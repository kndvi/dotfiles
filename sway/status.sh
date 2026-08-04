#!/bin/sh
# see: man 7 swaybar-protocol
set -eu

printf '{"version":1}\n[\n'

while true; do
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$muted" = "yes" ]; then
        vol_text="muted"
    else
        vol_text="vol $volume"
    fi

    if [ "$(nmcli -t -f STATE general status)" = "connected" ]; then
        net_text=$(nmcli -t -f NAME connection show --active | head -1)
    else
        net_text="offline"
    fi

    scratch_count=$(swaymsg -t get_tree | jq -r 'recurse(.nodes[]?) | select(.name=="__i3_scratch") | .floating_nodes | length')

    clock=$(date +'%d %b %Y %H:%M')

    jq -nc --arg net "$net_text" --arg vol "$vol_text" --arg clock "$clock" --argjson scratch "$scratch_count" \
        '(if $scratch > 0 then [{full_text: "scratchpad \($scratch)"}] else [] end)
         + [{full_text: $net}, {full_text: $vol}, {full_text: $clock}]'
    printf ',\n'

    sleep 1
done
