""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sleuth'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'easymotion/vim-easymotion'
Plug 'markonm/traces.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'farmergreg/vim-lastplace'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'leafgarland/typescript-vim'
Plug 'jparise/vim-graphql'
Plug 'plasticboy/vim-markdown'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'terryma/vim-multiple-cursors'
Plug 'osyo-manga/vim-anzu'
Plug 'scrooloose/nerdtree'
Plug 'francoiscabrol/ranger.vim'
Plug 'sjl/gundo.vim'
Plug 'brooth/far.vim'
Plug 'junegunn/fzf.vim'
" Plug 'tpope/vim-surround'
" Plug 'gregsexton/gitv'
" Plug 'tmhedberg/SimpylFold'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! RemoveTrailingWhitespace()
    if exists('b:noRemoveWhitespace')
        return
    endif
    let save_cursor = getpos('.')
    :silent! %s/\s\+$//e
    call setpos('.', l:save_cursor)
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

" set markdown filetype
autocmd BufNewFile,BufRead *.md set filetype=markdown

" remove trailing spaces of all files before saving except markdown
autocmd BufWritePre * call RemoveTrailingWhitespace()
autocmd FileType markdown let b:noRemoveWhitespace=1

" remove blank end lines before saving files
autocmd BufWritePre * call RemoveEndBlankLines()

" template for new .sh files
autocmd BufNewFile *.sh 0r ~/.config/nvim/templates/skeleton.sh

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" line length
let max_line_length=80
let use_max_line_length=0

filetype plugin indent on

" colors
syntax on
set t_Co=256
colorscheme molokai

set mouse=a
set showcmd
set smartindent
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
set noshowmode " don't show the current mode (vim-airline.vim takes care of it)
set autoread " set to auto read when a file is changed from the outside
set clipboard=unnamedplus " yank and paste also goes to clipboard
set nojoinspaces " only one space when joining lines
set formatoptions=troqj " format comment leader when joining/creating line
" default indent options, can be overrided by vim-sleuth
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175
execute 'set colorcolumn='.max_line_length

let mapleader=','

" disable arrows
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <C-*> mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" previous tag
nmap <C-m> :pop<CR>

" previous location, to be used when tags are not applied to file navigation
nmap <C-]> <C-o>

"copy/paste outsize vim
vmap <C-c> "+y
nmap <C-v> "+p
imap <C-v> <C-r>+
cnoremap <C-v> <C-r>"

" visual-block mode
noremap <C-a> <C-v>

" show full file path
nmap <C-e> :echo expand('%:p')<CR>

" fzf.vim
nmap <C-s> :Files<CR>

" go to definition, can be used with tags
nnoremap <C-i> <C-]>

" coc
nmap <silent> <C-y> <Plug>(coc-implementation)
nmap <silent> <C-t> <Plug>(coc-references)
nmap <silent> <C-g> <Plug>(coc-type-definition)
nmap <silent> <C-f> <Plug>(coc-format)
nmap <silent> <C-r> <Plug>(coc-rename)
nmap <silent> <C-q> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-w> <Plug>(coc-diagnostic-next)
nmap <silent> <C-b> :call <SID>show_coc_documentation()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <F*> mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let vim_markdown_preview_hotkey='<F2>'

" reload file
nmap <F5> :edit<CR>

set pastetoggle=<F4>
nmap <F7> :GundoToggle<CR>
nmap <F8> :TagbarToggle<CR>
nmap <F9> :NERDTreeToggle<CR>
nmap <F10> :Ranger<CR>
nmap <F12> :call HandleLineLength()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" other mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" change letter case
nmap U ~

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugins configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-markdown-preview
let vim_markdown_preview_use_xdg_open=1
let vim_markdown_preview_pandoc=1

" vim-gitgutter
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" nerdtree
let NERDTreeShowHidden=1

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

" semshi
let g:semshi#mark_selected_nodes=0

" incsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)))))))

" auto-pairs
let g:AutoPairs={'{':'}'}

" easy motion
let g:EasyMotion_do_mapping = 0 " disable default mappings
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" integration of incsearch with easymotion
map / <Plug>(incsearch-easymotion-stay)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set tagfunc=CocTagFunc

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" set python path based on 'which python'. Useful when working with virtualenv
call coc#config('python', {
      \   'pythonPath': split(execute('!which python'), '\n')[-1]
      \ })

function! s:show_coc_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" to uninstall remove an element of this array and :CocUninstall coc-extension
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-yaml',
      \ 'coc-python',
      \ 'coc-marketplace',
      \ 'coc-sh',
      \ 'coc-metals',
      \ 'coc-markdownlint',
      \ ]
