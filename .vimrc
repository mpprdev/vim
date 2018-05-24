" http://amix.dk/vim/vimrc.html"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" F10 toggles paste mode so that pasted text comes in w/o autoindent. Press
" F10 before and after pasting
set pastetoggle=<F10>

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/3rdparty/*,*/target/*,*/log/*

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" disable netrw generation
let g:netrw_dirhistmax = 0

" execute pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" list needed plugins
"
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'nathanaelkane/vim-indent-guides'
" Plugin 'lokikl/vim-ctrlp-ag'
Plugin 'kshenoy/vim-signature'
Plugin 'airblade/vim-gitgutter'

" all of your plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

function! CommandCabbr(abbreviation, expansion)
      execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
" Use it on itself to define a simpler abbreviation for itself.
" CommandCabbr ccab CommandCabbr

syntax enable
set background=dark
colorscheme solarized

" enable indent guides 
let g:indent_guides_enable_on_vim_startup = 1

" Shortcut to rapidly toggle `set list`  - show whitespace
nmap <leader>l :set list!<CR>

set encoding=utf-8
set fileencoding=utf-8
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=space:˽,eol:¬

"Ack.vim settings
map <leader>a :ag 
let g:ack_use_dispatch = 1
let g:ack_use_cword_for_empty_search = 1

"" Use ag
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap <leader>f :Ag<SPACE>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=space:˽,tab:▸\ ,eol:¬



