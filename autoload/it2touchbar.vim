" vim-it2-touchbar | Copyright (C) 2021 eth-p | MIT License
scriptencoding utf-8

" Wait for the plugin to load.
if !exists('g:loaded_it2touchbar')
	finish
endif

" Writes directly to the 'stdout' file descriptor.
" This is necessary to send ANSI escape sequence.
"
" Note: This may reset the mode to normal.
function! it2touchbar#WriteStdout(command, message)
	call writefile([ "]1337;".a:command."=".a:message."" ], '/dev/fd/1', "ba")
endfunction

" Functions for manipulating the touch bar.
let s:key_label_cache = {}
function! it2touchbar#SetTouchBarKey(key, value)
	if !has_key(s:key_label_cache, a:key) || s:key_label_cache[a:key] != a:value
		let s:key_label_cache[a:key] = a:value
		call it2touchbar#WriteStdout('SetKeyLabel', a:key."=".a:value)
	endif
endfunction

function! it2touchbar#PushKeys(label)
	call it2touchbar#WriteStdout('PushKeyLabels', a:label)
endfunction

function! it2touchbar#PopKeys(label)
	call it2touchbar#WriteStdout('PopKeyLabels', a:label)
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
		let s:key_label_cache = {} " clear the key cache to re-render the entire touchbar
		call it2touchbar#PushKeys("vim_before_".getpid())
		call it2touchbar#RegenKeys()
	endif
endfunction

function! it2touchbar#OnVimQuit()
	" FIXME: This calls unnecessarily when using :q on a modified buffer.
	call it2touchbar#PopKeys("vim_before_".getpid())

	" FIXME: Using this to allow a re-render in the above case.
	"        This still won't solve double-popping the previous keys, though.
	let s:key_label_cache = {}
endfunction

