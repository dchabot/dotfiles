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
map <leader>j :bnext<CR>
map <leader>k :bprevious<CR>

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
set smartcase

" from stackoverflow.com/questions/11404800
if $TMUX == ''
    set clipboard=unnamed             " use the system clipboard
endif

" set wildmenu                      " enable bash style tab completion
" set wildmode=list:longest,full

" set window navigation commands. Add <C-W>_ to maximize active window (removed).
" from - http://vim.wikia.com/wiki/Switch_between_Vim_window_splits_easily
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" remap arrow keys to open up quickfix
" map <Left> :copen<cr>
" map <Right> :cclose<cr>
" map <Up> :cp<cr>
" map <Down> :cn<cr>

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
" let g:jedi#auto_initialization = 0
let g:jedi#usages_command = "<Leader>z"
let g:jedi#goto_assignments_command = "<Leader>g"
let g:jedi#goto_definitions_command = "<Leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<Leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<Leader>r"
" let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0
" let g:jedi#popup_select_first = 0
" let g:jedi#show_call_sigatures = 0
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
