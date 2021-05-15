# vim-it2-touchbar

Adds (experimental) iTerm2 Mac touchbar support to `vim` and `neovim`.

**This uses a feature exclusive to [iTerm2](https://iterm2.com/). It will not work with the Apple Terminal.app.**



## Installation

Just install this plugin with your favorite Vim plugin manager!

```
eth-p/vim-it2-touchbar
```



## Setup

Using the touch bar should be pretty simple.
Just add the following to your `.vimrc`/`init.vim`:

```vim
function TouchBar()
	TouchBarLabel F1 "label here"
	" Add remappings here if necessary.
endfunction
```

Whenever vim is opened/closed/suspended/resumed, it will set or restore the touch bar accordingly.



## It doesn't work/it's slow!

To be fair, it's experimental *and* a bit of a hack. Vim doesn't offer any streamlined way to write to the user's tty, and some tricks had to be utilized.

