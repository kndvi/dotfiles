set nocp enc=utf-8 noml noswf nobk title hid re=2
set shiftwidth=0 autoindent showmatch splitright ruler
set incsearch hlsearch ignorecase smartcase
set wildoptions=pum,tagfile,fuzzy wildcharm=<C-z>
let &showbreak = '+++ '
filetype plugin indent on
syntax enable

" extend vim grep abilities with git-grep
call system('git rev-parse --is-inside-work-tree &>/dev/null')
let s:findcmd='find . -type f'
set grepprg=grep\ -HIrn\ $*
if v:shell_error == 0
	let s:findcmd='git ls-files -c -o --exclude-standard'
	set grepformat^=%f:%l:%c:%m
	set grepprg=git\ grep\ --column\ -n\ $*
endif
" use [--untracked --no-exclude-standard] for wildcard
nmap <Space>g :grep! -i ''<Left>
xmap <Space>g "0y:grep! '<C-r>0'<Left>
nmap <Space>G :grep! '<C-r><C-w>'<CR>

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
	let l:out = systemlist(s:findcmd . ' 2>/dev/null')
	if v:shell_error != 0 | return [] | endif
	return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
endfunc
set findfunc=s:findfiles
nmap <Space>f :find 
nmap <Space>F :find <C-r><C-w><C-z>

" browse git modified/untracked files
func! s:gitfiles(arglead, _cmdline, _cursorpos) abort
	let l:out = systemlist('git ls-files -m -o --exclude-standard 2>/dev/null')
	if v:shell_error != 0 || empty(l:out) | return [] | endif
	return empty(a:arglead) ? l:out : matchfuzzy(l:out, a:arglead)
endfunc
command! -nargs=1 -complete=customlist,<SID>gitfiles GFiles exe 'edit ' . fnameescape(<q-args>)
nmap <Space>s :GFiles <C-z>

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nmap <Space>y "+y
xmap <Space>y "+y
nmap <Space>p "+p
xmap <Space>p "+p
nmap <Space>P "+P

func! s:gentags() abort
	let l:job = job_start(['ctags', '-R', '.'], {
				\ 'in_io': 'null',
				\ 'out_io': 'null',
				\ 'err_io': 'null'
				\ })
	echo 'generating tags, job: ' . l:job
endfunc
command! -nargs=0 Ctags call <SID>gentags()

" copy file name/path
nmap <Space>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>
nmap <Space>n <Cmd>let @+=expand('%')<Bar>echo 'filename yanked'<CR>

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
nmap <C-l> <Cmd>noh<Bar>dif!<Bar>redr!<CR>

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

augroup JavaConfig
	au!
	au FileType java setl tabstop=4 et
	func! s:fqcn() abort
		let l:class = matchstr(expand('%'), '\v(^|.*/)src/([^/]+/java/)?\zs.+\ze\.java$')
		if empty(l:class)
			throw 'could not derive fully qualified class name from path'
		endif
		let l:name = substitute(l:class, '/', '.', 'g')
		let @+=l:name | echo l:name
	endfunc
	au FileType java command! -buffer -nargs=0 Fqcn call <SID>fqcn()
augroup END

" load useful optional packs
packadd comment
packadd hlyank
packadd! editorconfig
