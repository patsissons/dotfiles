set nocompatible        " required for map's
set showmode            " display the current mode
set showmatch           " show matching braces
set expandtab           " use spaces instead of tab character
set tabstop=4           " # of spaces for tab
set softtabstop=4       " make ${tabstop} spaces like tabs (delete 4 spaces with one stroke)
set shiftwidth=4        " # of spaces for indentation
set autoindent          " auto indent on newline
set smartindent         " move the caret automatically after parsing words
filetype indent on      " turn indenting on based on filetype
set number              " line numbering
set ruler               " display cursor location at the bottom right
" set sm                  " shortcut for showmatch
set bs=indent,eol,start " fixes backspace issues
" set gfn=Courier\ 10\ Pitch\ 12
" set bg=dark

syntax on               " syntax highlighting

" return to previous line on open
set viminfo='20,\"50

if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
   \ if line("'\"") > 0 && line ("'\"") <= line("$") |
   \   exe "normal! g'\"" |
   \ endif
endif

" uncomment the line below if you use gvim in windows
" and want to use ctrl-v instead of ctrl-q to invoke
" visual block mode

"unmap <C-V>

ab teh the
ab fro for


" press gi followed by a character will insert that character at cursor
map gi i<space><esc>r


" these two maps enable you to press space to move cursor down a screen,
" and press backspace up a screen.
" map <space> <c-f>
" map <backspace> <c-b>

" You can use - to jump between windows
map <c-pageup> <esc>:tabprev<return>
map <c-pagedown> <esc>:tabnext<return>
map - <c-w>w

" fix for gateone home/end escape codes
" ^[[H = <Esc>[H = HOME
" ^[[F = <Esc>[F = END
" NOTE: map! applies mapping to other modes
map <Esc>[H <Home>
map! <Esc>[H <Home>
map <Esc>[F <End>
map! <Esc>[F <End>
