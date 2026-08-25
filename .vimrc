set nocp enc=utf-8 noml noswf nobk title hid re=2 ar
set ts=4 sw=0 et autoindent showmatch sb spr
set incsearch hlsearch ignorecase smartcase smarttab
set list lcs=tab:>\ ,trail:-,nbsp:+ pt=<F2>
set wildoptions=pum,tagfile,fuzzy wcm=<C-z>
let &showbreak = '+++ '
set mouse=a mousem=popup_setpos ruler nu rnu
filetype plugin indent on
syntax enable

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
	let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
	if v:shell_error != 0 | return [] | endif
	return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
endfunc
set findfunc=s:findfiles
nmap <Space>f :find 

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" extend vim grep abilities with ripgrep
set grepprg=grep\ -HIrn\ $*
if executable('rg')
	set grepprg=rg\ --vimgrep\ --hidden\ -n\ $*
endif " use [--no-ignore] for wildcard
nmap <Space>g :grep! -i ''<Left>
vmap <Space>g "1y:grep! '<C-r>1'<Left>

" background tags generation
func! s:gentags() abort
	let l:job = job_start(['ctags', '-R', '.'], {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
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

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
au FileType vim setl ts=8 noet
nmap <C-l> <Cmd>noh<Bar>dif!<Bar>redr!<CR>

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" load useful optional packs
packadd comment
packadd hlyank
let g:hlyank_duration = 128
packadd! editorconfig

" better man :)
runtime ftplugin/man.vim
set keywordprg=:Man

" c/cpp
augroup CcppConfig
	au!
	if has('mac')
		au FileType c,cpp setl path=.,/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include,,
	endif

	if !empty(findfile('CMakeLists.txt', '.;'))
		au FileType c,cpp setl makeprg=cmake\ -S\ .\ -B\ build\ &&\ cmake\ --build\ build
	endif
augroup END

" java
augroup JavaConfig
	au!
	func! s:fqcn() abort
		let l:class = matchstr(expand('%'), '\v(^|.*/)src/([^/]+/java/)?\zs.+\ze\.java$')
		if empty(l:class)
			throw 'could not derive fully qualified class name from path'
		endif
		let l:name = substitute(l:class, '/', '.', 'g')
		let @+=l:name | echo l:name
	endfunc
	au FileType java command! -buffer -nargs=0 Fqcn call <SID>fqcn()

	if !empty(findfile('pom.xml', '.;'))
		au FileType java setl makeprg=mvn\ package\ -DskipTests\ -T\ 1C\ -am
		au FileType java setl errorformat=[ERROR]\ %f:[%l\\,%c]\ %m
	endif
augroup END
