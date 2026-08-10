set nocp enc=utf-8 noml noswf nobk title hid
set incsearch hlsearch ignorecase smartcase
set showmatch splitright ruler sw=0
set ut=256 wildoptions+=fuzzy nu rnu list
let &showbreak = '+++ '

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
	let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
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

" extend vim grep abilities with ripgrep
set grepprg=grep\ -HIrn\ $*
if executable('rg')
	set grepprg=rg\ --vimgrep\ --hidden\ -n\ $*
endif " use [--no-ignore] for wildcard
nmap <Space>g :grep! -i ''<Left>
xmap <Space>g "0y:grep! '<C-r>0'<Left>
nmap <Space>G :grep! '<C-r><C-w>'<CR>

" background tags generation
func! s:gentags() abort
	let l:job = jobstart(['ctags', '-R', '.'], {
				\ 'in_io': 'null',
				\ 'out_io': 'null', 'err_io': 'null'})
	echo 'generating tags, job: ' . l:job
endfunc
command! -nargs=0 Ctags call <SID>gentags()

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nmap <Space>y "+y
xmap <Space>y "+y
nmap <Space>p "+p
xmap <Space>p "+p
nmap <Space>P "+P

" copy file name/path
nmap <Space>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>
nmap <Space>n <Cmd>let @+=expand('%')<Bar>echo 'filename yanked'<CR>

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
au FileType bash,sh,lua setl ts=4 et

if has('nvim')
	au TextYankPost * silent! lua vim.hl.on_yank()
	lua vim.filetype.add{pattern={['.*%.log.*']='messages'}, extension={psql='sql'}}

	" unload redundant providers
	let g:loaded_node_provider = 0
	let g:loaded_perl_provider = 0
	let g:loaded_python3_provider = 0
	let g:loaded_ruby_provider = 0
	let g:loaded_matchit = 1
	set completeopt+=menuone,noselect
	set undofile inccommand=split

	" load lua stuff
	lua require'lsconf'
	lua require'diffsign'
endif
