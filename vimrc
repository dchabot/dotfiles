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
nmap <leader>. :b#<CR>

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

" let g:python3_host_prog = '/home/chabot/mc/bin/python'
let g:python_host_prog = '/usr/bin/python'

" appended for Vundle usage
" set the runtime path to include Vundle and initialize
" set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin()
 
" let Vundle manage Vundle, required
" Plugin 'gmarik/Vundle.vim'
Plug 'kien/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'klen/python-mode'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'davidhalter/jedi-vim'
Plug 'yssl/QFEnter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim',
Plug 'tpope/vim-fugitive'
Plug 'rodjek/vim-puppet'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'


" All of your Plugins must be added before the following line
call plug#end()            " required
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
hi CursorLine ctermbg=236

 
" Ctrl-P setup:
" -> r = nearest ancestor with repo directory
let g:ctrlp_working_path_mode = 'ra'
" use ctrl-z to select multiple files, ctrl-o to open all in 'hidden' buffers
let g:ctrlp_open_multiple_files = 'i'
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

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" airline plugin config
set t_Co=256                    " 256-color terminal
set encoding=utf-8
let g:airline_theme='term'
let g:airline_powerline_fonts=1 " if funny symbols show in the status line, set this to 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
" don't overwrite tmuxline status-line settings
let g:airline#extensions#tmuxline#enabled = 0
set laststatus=2

let g:tmuxline_theme = 'airline_insert'

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
nnoremap <leader>f :FZF<cr>

" Augmenting Ag command using fzf#vim#with_preview function
" "   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
" "     * For syntax-highlighting, Ruby and any of the following tools are
" required:
" "       - Highlight:
" http://www.andre-simon.de/doku/highlight/en/highlight.php
" "       - CodeRay: http://coderay.rubychan.de/
" "       - Rouge: https://github.com/jneen/rouge
" "
" "   :Ag  - Start fzf with hidden preview window that can be enabled with "?"
" key
" "   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
\ call fzf#vim#ag(<q-args>,
\                 <bang>0 ? fzf#vim#with_preview('up:60%')
\                         : fzf#vim#with_preview('right:50%:hidden','?'),
\                 <bang>0)

nnoremap <leader>g :Ag<cr>
nnoremap <silent> <Leader>b :Buffers<CR>
noremap <leader>c :History:<cr>

" Settings for jedi-vim
" " cd ~/.vim/bundle
" " git clone git://github.com/davidhalter/jedi-vim.git
" let g:jedi#auto_initialization = 0
" let g:jedi#force_py_version = 3
let g:jedi#goto_assignments_command = "<Leader>a"
let g:jedi#goto_definitions_command = "<Leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<Leader>u"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<Leader>r"
" let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0
" let g:jedi#popup_select_first = 0
" let g:jedi#show_call_sigatures = 0
" map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

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

" From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
" makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" recursively vimgrep for word under cursor or selection if you hit leader-star
nmap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>

"""""""""" NerdTree config
nnoremap <leader>t :NERDTreeToggle<CR>
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Exit Vim if NERDTree is the only window left.
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
"    \ quit | endif
"""""""""" end NerdTree cfg

" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable

" hide mode message since we're using Airline, or similar
set noshowmode
