" vim-it2-touchbar | Copyright (C) 2021 eth-p | MIT License
scriptencoding utf-8

" Wait for the plugin to load.
if !exists('g:loaded_it2touchbar')
	finish
endif

" Writes directly to the terminal.
" This is necessary to send ANSI escape sequence.
function! it2touchbar#WriteTTY(message)
	new
	setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
	setlocal noeol
	setlocal binary
	setlocal nofixendofline
	call setline(1, a:message)
	execute 'w >>' '/dev/tty'
	q
endfunction

" Functions for manipulating the touch bar.
function! it2touchbar#SetTouchBarKey(key, value)
	silent call it2touchbar#WriteTTY(']1337;SetKeyLabel='.a:key.'='.a:value.'')
endfunction

function! it2touchbar#PushKeys(label)
	silent call it2touchbar#WriteTTY(']1337;PushKeyLabels='.a:label.'')
endfunction

function! it2touchbar#PopKeys(label)
	silent call it2touchbar#WriteTTY(']1337;PopKeyLabels='.a:label.'')
endfunction

" Function to regenerate the touchbar keys.
function! it2touchbar#RegenKeys()
	if exists("*TouchBar")
    	call TouchBar()
	endif
endfunction

" Helpers for when vim shows and hides itself.
function! it2touchbar#OnVimSuspend()
	let g:it2touchbar_suspended = 1
	call it2touchbar#PopKeys("vim_before_".getpid())
endfunction

function! it2touchbar#OnVimResume()
	if g:it2touchbar_suspended == 1
		let g:it2touchbar_suspended = 0
		call it2touchbar#PushKeys("vim_before_".getpid())
		call it2touchbar#RegenKeys()
	endif
endfunction

function! it2touchbar#OnVimQuit()
	call it2touchbar#PopKeys("vim_before_".getpid())
endfunction

