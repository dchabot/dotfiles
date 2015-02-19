" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2000 Oct 14
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off

" no annoying beeps
set visualbell

" Automatic reloading of .vimrc
"augroup reload_vimrc " {
"    autocmd!
"    autocmd BufWritePost $MYVIMRC source $MYVIMRC
"augroup END " }
autocmd! bufwritepost .vimrc source %

" Rebind <Leader> key
" " I like to have it here becuase it is easier to reach than the default and
" " it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","

" easier moving between buffers
map <C-]> :bnext<CR>
map <C-[> :bprevious<CR>

" Showing line numbers and length
highlight LineNr ctermfg=grey ctermbg=233
" set number  " show line numbers
" set tw=79   " width of document (used by gd)
" set nowrap  " don't automatically wrap on load
" set fo-=t   " don't automatically wrap text when typing
" set colorcolumn=80
" highlight ColorColumn ctermbg=233

set bs=2		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
set ruler
set incsearch
set ignorecase
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full

" set window navigation commands. Add <C-W>_ to maximize active window (removed).
" from - http://vim.wikia.com/wiki/Switch_between_Vim_window_splits_easily
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" easier moving of code blocks
" " Try to go into visual mode (v), thenselect several lines of code here and
" " then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" open vsplits to the right
set splitright

"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 autocmd BufRead *.txt set tw=78

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  " use "gzip -d", gunzip isn't always available
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gzip -d")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bzip2 -d")
  autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre			*.gz call GZIP_appre("gzip -d")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bzip2 -d")
  autocmd FileAppendPost		*.gz call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    " set 'cmdheight' to two, to avoid the hit-return prompt
    let ch_save = &ch
    set ch=3
    " when filtering the whole buffer, it will become empty
    let empty = line("'[") == 1 && line("']") == line("$")
    let tmp = tempname()
    let tmpe = tmp . "." . expand("<afile>:e")
    " write the just read lines to a temp file "'[,']w tmp.gz"
    execute "'[,']w " . tmpe
    " uncompress the temp file: call system("gzip -d tmp.gz")
    call system(a:cmd . " " . tmpe)
    " delete the compressed lines
    '[,']d
    " read in the uncompressed lines "'[-1r tmp"
    set nobin
    execute "'[-1r " . tmp
    " if buffer became empty, delete trailing blank line
    if empty
      normal Gdd''
    endif
    " delete the temp file
    call delete(tmp)
    let &ch = ch_save
    " When uncompressed the whole buffer, do autocommands
    if empty
      execute ":doautocmd BufReadPost " . expand("%:r")
    endif
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      call system(a:cmd . " " . expand("<afile>:r"))
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    call system(a:cmd . " " . expand("<afile>"))
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

endif " has("autocmd")

" appended for Vundle usage
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
 
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'christoomey/vim-tmux-navigator'
" Plugin 'klen/python-mode'
Plugin 'bling/vim-airline'
Plugin 'edkolev/tmuxline.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'yssl/QFEnter'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax enable
set background=dark
colorscheme ir_black
set number
set cursorline
hi CursorLine ctermbg=234
 
" Ctrl-P setup:
" -> r = nearest ancestor with repo directory
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
 
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ 'link': 'some_bad_symbolic_links',
\ }

" make QFEnter behavior map to the same keys as Ctrl-P
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_topen_map = ['<C-t>']

" airline plugin config
set t_Co=256                    " 256-color terminal
set encoding=utf-8
let g:airline_powerline_fonts=0 " if funny symbols show in the status line, set this to 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_inactive_collapse = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
let g:tmuxline_powerline_separators = 0
set laststatus=2

"""""""""""""""""""""
"  tmuxline config  "
"""""""""""""""""""""
let g:tmuxline_theme = 'airline_insert'
" let g:tmuxline_preset = {
"     \ 'a': '#S',
"     \ 'b': '#F',
"     \ 'c': '#W',
"     \ 'win': ['#I', '#W'],
"     \ 'cwin': ['#I', '#W'],
"     \ 'x': '%a',
"     \ 'y': ['%b %d', '%R'],
"     \ 'z': '#h'}

" -- python mode
" E501 = line too long, C901 = too complex
" let g:pymode_indent = 0 " use python-indent not from python-mode
" autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"let g:pymode_lint_ignore = "E501,C901"

" disable the 80char vertical line
" let g:pymode_options_colorcolumn = 0
" disable code completion
" let g:pymode_rope_completion = 0
" highlight LineNr ctermfg=red
" highlight LineNr guifg=#FF0000
" let NERDTreeIgnore = ['\.pyc$']
" let g:netrw_list_hide='.git,'
" let g:netrw_list_hide.='\.svn,'
" let g:netrw_list_hide.='\.hg,'
" let g:netrw_list_hide.='\.py[co],'
" let g:netrw_list_hide.='\.sw[op],'
" let g:pyflakes_use_quickfix = 0
" let g:pep8_map='<leader>8'

" Settings for jedi-vim
" " cd ~/.vim/bundle
" " git clone git://github.com/davidhalter/jedi-vim.git
let g:jedi#usages_command = "<Leader>z"
let g:jedi#goto_assignments_command = "<Leader>g"
let g:jedi#goto_definitions_command = "<Leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<Leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<Leader>r"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" " Better navigating through omnicomplete option list
" " See
" http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable
