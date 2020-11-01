set nocompatible

" Load up pathogen, using an alternative folder.
source ~/ivim/pathogen/autoload/pathogen.vim
execute pathogen#infect('~/ivim/{}')

syntax on
filetype plugin indent on

" Some basic options
set completeopt=noinsert,menuone,noselect
set history=500
set showcmd
set smartcase
set ignorecase
set showmatch
set incsearch
set nostartofline
set fileencoding=utf-8
set nowrap
set linebreak
set listchars=tab:\ \ ,trail:·
set list
set lazyredraw
set background=dark
set hidden
set conceallevel=2 concealcursor=
set splitright
set splitbelow
set path+=**
set fillchars+=vert:\│
set synmaxcol=5000

" Copy from spf
scriptencoding utf-8


    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode

" set exrc
" set secure

" Recommended for vim-stay
set sessionoptions-=cursor,folds,slash,unix

" No swap files, but undo files
set noswapfile
set nobackup
set nowritebackup
set undodir=~/backups
"set undofile

" Some of my favourites
" colorscheme PaperColor
colorscheme seoul256
" colorscheme abstract
" colorscheme afterglow
set background=dark
" colorscheme scheakur
ifont iosevka-fixed-ss04-extended 18

let mapleader=","
let maplocalleader=","

" Vimtex ------------------------------
let g:vimtex_compiler_enabled=0
set conceallevel=2

let g:vimtex_toc_config = { 'show_help' : 0, 'refresh_always' : 1, 'todo_sorted' : 0 }

augroup vimtex
  autocmd!
  autocmd BufWritePost *.tex call vimtex#toc#refresh()
augroup END

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

function! Prose()
  " call pencil#init()
  call pencil#init({'wrap': 'soft'})
  call lexical#init()
  " call litecorrect#init()
  call textobj#quote#init()
  call textobj#sentence#init()

  " manual reformatting shortcuts
  nnoremap <buffer> <silent> Q gqap
  xnoremap <buffer> <silent> Q gq
  nnoremap <buffer> <silent> <leader>Q vapJgqap

  " force top correction on most recent misspelling
  " nnoremap <buffer> <c-s> [s1z=<c-o>
  " inoremap <buffer> <c-s> <c-g>u<Esc>[s1z=`]A<c-g>u

  " replace common punctuation
  " iabbrev <buffer> -- –
  " iabbrev <buffer> --- —
  " iabbrev <buffer> << «
  " iabbrev <buffer> >> »

  " open most folds
  " setlocal foldlevel=6

  " replace typographical quotes (reedes/vim-textobj-quote)
  map <silent> <buffer> <leader>qc <Plug>ReplaceWithCurly
  map <silent> <buffer> <leader>qs <Plug>ReplaceWithStraight

  " highlight words (reedes/vim-wordy)
  " noremap <silent> <buffer> <F8> :<C-u>NextWordy<cr>
  " xnoremap <silent> <buffer> <F8> :<C-u>NextWordy<cr>
  " inoremap <silent> <buffer> <F8> <C-o>:NextWordy<cr>
  "
  set conceallevel=2 concealcursor=i

endfunction "

" File Types ------------------
" automatically initialize buffer by file type
autocmd FileType markdown,mkd call Prose()

autocmd FileType tex hi link texItalStyle Underlined
autocmd FileType tex call Prose()
autocmd FileType tex set conceallevel=2 concealcursor=

set foldmethod=expr
set foldexpr=vimtex#fold#level(v:lnum)
set foldtext=vimtex#fold#text()

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()

" Mappings ------------------------------
"
let g:ctrlp_working_path_mode = 'ra'
map <leader>f :CtrlP<cr>
map <leader>F :CtrlPCurFile<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>m :CtrlPBookmark<cr>


" In insert or command mode, move normally by using Ctrl
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" Font sizes
nnoremap <c-0> :ifont +<cr>
nnoremap <c-9> :ifont -<cr>

let g:goyo_width = 80
let g:goyo_height = "100%"
nnoremap <c-8> :Goyo<cr>
nnoremap <c-1> :call SynGroup()<cr>

" I'm so used to doing this...
nmap <c-s> :w<cr>


" vim: fdm=marker
