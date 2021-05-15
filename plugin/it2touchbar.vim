" vim-it2-touchbar | Copyright (C) 2021 eth-p | MIT License
scriptencoding utf-8

" Only load once.
if exists('g:loaded_it2touchbar')
	finish
endif
let g:loaded_it2touchbar = 1
let g:it2touchbar_suspended = 0

"
if empty($ITERM_SESSION_ID)
	" We can't using iTerm.
	" There's no point continuing.
	finish
endif

" Hook exit and enter.
call it2touchbar#PushKeys("vim_before_".getpid())
autocmd ExitPre     * call it2touchbar#OnVimQuit()
autocmd VimResume   * call it2touchbar#OnVimResume()
autocmd VimSuspend  * call it2touchbar#OnVimSuspend()

" Hook events that will probably change the function keys.
autocmd BufEnter      * call it2touchbar#RegenKeys()
autocmd CmdlineEnter  * call it2touchbar#RegenKeys()
autocmd CmdlineLeave  * call it2touchbar#RegenKeys()
autocmd InsertEnter   * call it2touchbar#RegenKeys()
autocmd InsertLeave   * call it2touchbar#RegenKeys()

" Alias functions.
command! -nargs=1 TouchBarLabel call it2touchbar#SetTouchBarKey(split(<q-args>)[0], eval(join(split(<q-args>)[1:-1])))

