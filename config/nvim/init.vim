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
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for': 'python'}
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
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'ellisonleao/glow.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'dstein64/nvim-scrollview'
Plug 'andymass/vim-matchup'
Plug 'tomlion/vim-solidity'

" nvim-lspconfig stuff.
Plug 'ray-x/lsp_signature.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'wbthomason/packer.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" unseful at the moment but can be in the future
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
nmap <C-z> <C-o>

"copy/paste outsize vim
vmap <C-c> "+y
nmap <C-v> "+p
imap <C-v> <C-r>+
cnoremap <C-v> <C-r>+

" visual-block mode
noremap <C-a> <C-v>

" show full file path
nmap <C-e> :echo expand('%:p')<CR>

" fzf.vim
nmap <C-s> :Files<CR>
let g:fzf_action = {
  \ 'enter': 'tab split',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <F*> mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" tab navigation
nmap O :tabp<CR>
nmap P :tabn<CR>

" window navigation
nmap J <C-w>j
nmap K <C-w>k
nmap H <C-w>h
nmap L <C-w>l

" move window into a new tab
nmap T <C-w>T

" vim-matchup, go to begin/end of pair
nmap M g%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugins configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-matchup
let g:matchup_matchparen_offscreen = {}

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'operators': '',
      \ 'guifgs': ['white', 'darkorange3', 'royalblue3', 'seagreen3', 'firebrick'],
      \ }

" vim-go
let g:go_doc_keywordprg_enabled=0

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

" vim-devicons
" this was blocking g:airline_section_y to be overriden
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0

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
" nvim-lspconfig
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua << EOF

local lsp_signature_config = {
  doc_lines = 0,
}
require'lsp_signature'.setup(lsp_signature_config)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<C-i>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-y>', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-g>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<C-t>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<C-b>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-n>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<C-[>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<C-f>', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local use = require('packer').use
require('packer').startup(function()
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local flags = {
  debounce_text_changes = 150,
}

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local lsps_with_default_config = {
  'gopls',
  'jsonls',
  'tsserver',
  'metals',
  'yamlls',
  'pyright',
  'clangd',
  'vimls',
  'dockerls',
  'solidity_ls',
}
for _, lsp in ipairs(lsps_with_default_config) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = flags,
    capabilities = capabilities,
  }
end
lspconfig['diagnosticls'].setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = capabilities,

  filetypes = {
    'sh',
    'markdown',
    'python',
  },
  init_options = {
    filetypes = {
      sh = 'shellcheck',
      markdown = 'markdownlint',
      python = {'flake8', 'pylint'},
    },
    formatFiletypes = {
      sh = 'shfmt',
      markdown = 'prettier',
    },
    linters = {
      pylint = {
        sourceName = 'pylint',
        command = 'pylint',
        args = {
          '--output-format',
          'text',
          '--score',
          "no",
          '--msg-template',
          "'{line}:{column}:{category}:{msg} ({msg_id}:{symbol})'",
          '%file',
        },
        formatPattern = {
          '^(\\d+?):(\\d+?):([a-z]+?):(.*)$',
          {
            line = 1,
            column = 2,
            security = 3,
            message = 4,
          }
        },
        securities ={
          informational = 'hint',
          refactor = 'info',
          convention = 'info',
          warning = 'warning',
          error = 'error',
          fatal = 'error',
        },
        offsetColumn = 1,
        formatLines = 1,
      },
      flake8 = {
        sourceName = 'flake8',
        command = 'flake8',
        debounce = 100,
        args = {
          '%file',
        },
        formatPattern = {
          '^(.+\\.py):(\\d+):(\\d+): (I|W|E|F)\\d+ (.+)$',
          {
            line = 2,
            column = 3,
            security = 4,
            message = 5,
          }
        },
        securities = {
          E = "error",
          W = "warning",
          I = "info",
          F = "error"
        },
        offsetColumn = 0,
        formatLines = 1,
      },
      markdownlint = {
        command = 'markdownlint',
        isStderr = true,
        debounce = 100,
        args = {
          '--stdin',
          '--disable',
          'MD013',
        },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'markdownlint',
        securities = {
          undefined = 'warning',
        },
        formatLines = 1,
        formatPattern = {
          '^stdin:(\\d+)(?:\\s|:(\\d+)\\s)(.*)$',
          {
            line = 1,
            column = 2,
            message = 3,
          },
        },
      },
      shellcheck = {
        command = 'shellcheck',
        debounce = 100,
        args = {
          '--format=gcc',
          '-',
        },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'shellcheck',
        formatLines = 1,
        formatPattern = {
          '^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$',
          {
            line = 1,
            column = 2,
            message = 4,
            security = 3,
          }
        },
        securities = {
          error = 'error',
          warning = 'warning',
          note = 'info',
        },
      },
    },
    formatters = {
      prettier = {
        command = 'prettier',
        args = {
          '--stdin-filepath',
          '%filepath',
        },
      },
      shfmt = {
        command = 'shfmt',
        args = {
          '-i',
          '2',
          '-bn',
          '-ci',
          '-sr',
        },
      },
    },
  },
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

EOF
