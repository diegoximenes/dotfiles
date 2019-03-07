""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'brooth/far.vim'
Plug 'junegunn/fzf.vim'
Plug 'gregsexton/gitv'
Plug 'sjl/gundo.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'scrooloose/nerdtree'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/Tabmerge'
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'leafgarland/typescript-vim'
Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jparise/vim-graphql'
Plug 'farmergreg/vim-lastplace'
Plug 'plasticboy/vim-markdown'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'terryma/vim-multiple-cursors'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'diepm/vim-rest-console'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe', {'do': ':!~/.local/share/nvim/plugged/YouCompleteMe/install.py --clang-completer'}
Plug 'osyo-manga/vim-anzu'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let max_line_length=80
let use_space_instead_of_tabs=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! RemoveTrailingWhitespace()
    if exists('b:noRemoveWhitespace')
        return
    endif
    %s/\s\+$//e
endfun

function RemoveEndBlankLines()
    let save_cursor = getpos('.')
    :silent! %s#\($\n\s*\)\+\%$##
    call setpos('.', l:save_cursor)
endfunction

function SetLineLength()
    let g:use_max_line_length=1
    execute 'set textwidth='.(g:max_line_length - 1)
    let w:m2=matchadd('ErrorMsg', '\%>'.g:max_line_length.'v.\+', -1)
endfunction

function UnsetLineLength()
    let g:use_max_line_length=0
    execute 'set textwidth=0'
    call matchdelete(w:m2)
endfunction

function HandleLineLength()
    if g:use_max_line_length == 0
        call SetLineLength()
    else
        call UnsetLineLength()
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufNewFile,BufRead *.md set filetype=markdown

" remove trailing spaces of all files before saving except markdown
autocmd BufWritePre * call RemoveTrailingWhitespace()
autocmd FileType markdown let b:noRemoveWhitespace=1

" remove blank end lines before saving files
autocmd BufWritePre * call RemoveEndBlankLines()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if max_line_length > 0
    call SetLineLength()
endif

if use_space_instead_of_tabs
    set expandtab
endif

filetype plugin indent on

" colors
syntax on
set t_Co=256
colorscheme molokai

set mouse=a
set showcmd
set smartindent
set tabstop=4 shiftwidth=4
set cursorline
set incsearch
set number
set encoding=utf-8 fileencoding=utf-8
set ruler " show current row and col
set completeopt=longest,menuone " change rules in autocomplete
set backspace=indent,eol,start " enable backspace eraser
set scrolloff=5 sidescrolloff=5 " scroll when necessary
set nowritebackup nobackup noswapfile
set cinoptions+=(0 " indent with opened parentheses
set foldlevelstart=50
set list listchars=tab:>-,trail:- " show trailing spaces and tabs
set nowrap " don't 'break' long lines
set timeout timeoutlen=1500
set updatetime=100
set nomodeline

let mapleader=','

" disable arrows
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <C-*> mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"copy/paste outsize vim
vmap <C-c> "+y
nmap <C-v> "+p
imap <C-v> <C-r>+

" visual-block mode
noremap <C-a> <C-v>

" show full file path
nmap <C-e> :echo expand('%:p')<CR>

" fzf.vim
nmap <C-s> :Files<CR>

" gitv
nmap <C-g> :Gitv<CR>

" ale
nmap <C-b> :ALEHover<CR>
nmap <C-t> :ALEFindReferences<CR>
nmap <C-f> :ALEFix<CR>
nmap <C-y> :ALEGoToDefinitionInTab<CR>
nmap <silent> <C-z> <Plug>(ale_detail)

" UltiSnips
let g:UltiSnipsExpandTrigger='<C-i>'
let g:UltiSnipsJumpForwardTrigger='<C-i>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <F*> mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-markdown-preview
let vim_markdown_preview_hotkey='<F2>'
let vim_markdown_preview_use_xdg_open=1

" vim-rest-console
let g:vrc_trigger = '<F3>'

" reload file
nmap <F5> :edit<CR>

set pastetoggle=<F4>
nmap <F7> :GundoToggle<CR>
nmap <F8> :TagbarToggle<CR>
nmap <F9> :NERDTreeToggle<CR>
nmap <F12> :call HandleLineLength()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugins configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-gitgutter
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" vim-fugitive
set diffopt+=vertical

" vim-rest-console
let g:vrc_curl_opts = {
    \ '-i': '',
\}

" nerdtree
let NERDTreeShowHidden=1

" eclim
let g:EclimCompletionMethod = 'omnifunc'

" fzf.vim
set runtimepath+=~/.fzf

" airline
set laststatus=2
let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_symbols = {}
let g:airline_symbols.branch = ''
let g:airline_section_c='%<%{expand("%:p")}'
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z='L:%4l/%{line("$")} | C:%3v/%3{col("$")}'

" editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']

" ale
let b:ale_fixers = {'typescript': ['tslint'], 'json': ['prettier'], 'python': ['black']}
let b:ale_linters = {'python': ['pyls', 'pycodestyle'], 'json': ['jsonlint']}
let g:ale_python_black_options='--line-length 80'

" semshi
let g:semshi#mark_selected_nodes=0

" YouCompleteMe
let g:ycm_register_as_syntastic_checker = 0
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'

" incsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)))))))

" UltiSnips
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/mysnippets']
let g:UltiSnipsEditSplit='vertical'

" auto-pairs
let g:AutoPairs={'{':'}'}

" easy motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" integration of incsearch with easymotion
map / <Plug>(incsearch-easymotion-stay)

" tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" nvim
set termguicolors
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175
