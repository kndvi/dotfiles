set nocp enc=utf-8 noml noswf nobk title hid re=2 ar
set autoindent showmatch sb spr ts=4 sw=0 et
set incsearch hlsearch ignorecase smartcase smarttab
set lcs=tab:>\ ,trail:-,nbsp:+ list wop=pum,tagfile,fuzzy
let &showbreak = '+++ '
set mouse=a mousem=popup_setpos pt=<F2> ruler nu rnu
filetype plugin indent on
syntax enable

" better man :D
runtime ftplugin/man.vim
set keywordprg=:Man

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
	let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
	if v:shell_error != 0 | return [] | endif
	return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
endfunc
set findfunc=s:findfiles
nmap <Space>f :find 

" extend vim grep abilities with ripgrep
set grepprg=grep\ -HIrn\ $*
if executable('rg')
	set grepprg=rg\ --vimgrep\ --hidden\ -n\ $*
	set grepformat^=%f:%l:%c:%m
endif " use [--no-ignore] for wildcard
nmap <Space>g :grep! -i ''<Left>
vmap <Space>g "0y:grep! '<C-r>0'<Left>

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nmap <Space>y "+y
xmap <Space>y "+y
nmap <Space>p "+p
xmap <Space>p "+p
nmap <Space>P "+P

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
au FileType vim setl ts=8 noet
nmap <C-l> <Cmd>noh<Bar>dif!<Bar>redr!<CR>

" load useful optional packs
packadd comment
packadd hlyank
let g:hlyank_duration = 128
packadd! editorconfig

" background tags generation
func! s:gentags() abort
	let l:job = job_start(['ctags', '-R', '.'], {
				\ 'in_io': 'null',
				\ 'out_io': 'null', 'err_io': 'null'})
	echo 'generating tags, job: ' . l:job
endfunc
command! -nargs=0 Ctags call <SID>gentags()
