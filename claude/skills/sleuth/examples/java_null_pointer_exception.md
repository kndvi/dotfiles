# Java: NullPointerException

## Scenario
`OrderService.applyDiscount()` throws intermittently in production, only for a subset of customers.

## Evidence
```
Exception in thread "main" java.lang.NullPointerException: Cannot invoke "Customer.getLoyaltyTier()" because "customer" is null
	at OrderService.applyDiscount(OrderService.java:42)
	at OrderService.checkout(OrderService.java:18)
```
The helpful NPE message (Java 14+) already names the null reference (`customer`) and the call site. Start there instead of guessing.

## Reproduction
Call `checkout()` with an order whose `customerId` doesn't resolve to a `Customer` row (e.g. a guest checkout). Fails every time under that condition, so it's reliably reproducible, not a race.

## Failing test
Before forming any hypotheses, wrote `OrderServiceTest.applyDiscount_guestOrder_throwsNpe()` against the exact repro: a guest order fed into `applyDiscount()`. It fails with the same `NullPointerException`, giving a concrete pass/fail signal to check hypotheses against instead of eyeballing output.

## Hypotheses (ranked)
1. `CustomerRepository.findById()` returns `null` for guest orders instead of throwing/`Optional.empty()`, and `applyDiscount` doesn't guard for it. *Prediction: guest orders have no row in the `customers` table.*
2. `Order.getCustomer()` is populated by a separate async enrichment step that hasn't run yet when `checkout()` executes. *Prediction: reordering the calls fixes it without touching `applyDiscount`.*
3. A caching layer evicted the customer record between lookup and use. *Prediction: repro fails against a fresh cache.*

## Isolation
Tagged the lookup: `System.out.println("[DEBUG-npe01] customer=" + customer + " orderId=" + order.getId());`
Output confirmed `customer=null` for every guest order, and the DB has genuinely no row for those IDs, confirming hypothesis 1 and ruling out 2 and 3 (no async gap, no cache involved).

## Root cause
`applyDiscount()` assumed every order has a registered customer; guest checkout is a legitimate flow that was never covered by that assumption.

## Check in with user
Reported the root cause and the proposed fix (return the order unmodified for guests) before touching any code, since there's a product question buried in it: should guests be silently skipped, or should discount eligibility be an explicit, visible rule? Got confirmation to go with "skip silently" before proceeding.

## Fix
```java
Customer customer = customerRepository.findById(order.getCustomerId());
if (customer == null) {
    return order; // guests aren't eligible for loyalty discounts
}
```

## Verification
Renamed the failing test to `applyDiscount_guestOrder_returnsUnmodifiedOrder()` and updated its assertion to expect the unmodified order instead of a thrown exception; it now passes. Confirmed `grep -r "DEBUG-npe01"` is empty before calling it done.
