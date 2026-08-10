if has('mac')
	au FileType c,cpp setl path=.,/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include,,
endif

if !empty(findfile('CMakeLists.txt', '.;'))
	setl makeprg=cmake\ -S\ .\ -B\ build\ &&\ cmake\ --build\ build
endif
