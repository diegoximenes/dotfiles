--------------------------------------------------------------------------------
-- plugins manager: lazy.nvim
--------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "jiangmiao/auto-pairs",
    "editorconfig/editorconfig-vim",
    "tpope/vim-sleuth",
    "tpope/vim-commentary",
    "vim-airline/vim-airline",
    "airblade/vim-gitgutter",
    "farmergreg/vim-lastplace",
    {"fatih/vim-go", build = ":GoUpdateBinaries" },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "leafgarland/typescript-vim",
    "jparise/vim-graphql",
    "plasticboy/vim-markdown",
    "Vimjas/vim-python-pep8-indent",
    "tpope/vim-fugitive",
    "mbbill/undotree",
    "luochen1990/rainbow",
    "ryanoasis/vim-devicons",
    "dstein64/nvim-scrollview",
    "andymass/vim-matchup",
    "tomlion/vim-solidity",
    "kamykn/spelunker.vim",
    "hashivim/vim-terraform",
    "kevinhwang91/nvim-bqf",
    "tanvirtin/monokai.nvim",
    "github/copilot.vim",
    "mfussenegger/nvim-lint",
    "ellisonleao/glow.nvim",

    -- nvim-lspconfig related
    "ray-x/lsp_signature.nvim",
    "neovim/nvim-lspconfig",
    "wbthomason/packer.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
})

--------------------------------------------------------------------------------
-- general
--------------------------------------------------------------------------------

vim.g.mapleader = ","

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = false -- don"t "break" long lines
vim.opt.clipboard = "unnamedplus" -- yank and paste also goes to clipboard
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- blinking cursor
vim.opt.showmode = false -- don"t show the current mode, status line takes cares of it
vim.opt.completeopt="longest,menuone" -- change rules in autocomplete
-- scroll
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
-- show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars="tab:>-,trail:-"
-- indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
-- disable tmp files
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false

-- disable arrows
vim.keymap.set({"n", "v"}, "<Up>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "<Down>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "<Left>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "<Right>", "<NOP>", { noremap = true, silent = true })


--------------------------------------------------------------------------------
-- autocmd
--------------------------------------------------------------------------------

-- set filetypes
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.en_us"},
    callback = function()
       vim.opt.filetype = "en_us"
    end,
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.pt_br"},
    callback = function()
       vim.opt.filetype = "pt_br"
    end,
})

-- template for new .sh files
vim.api.nvim_create_autocmd({"BufNewFile"}, {
    pattern = {"*.sh", "*.bash"},
    command = "0r ~/.config/nvim/templates/skeleton.sh",
})


-- remove trailing spaces
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*"},
    callback = function()
        if vim.bo.filetype == "markdown" then
            return
        end
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[silent! %s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- remove end blank lines
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*"},
    callback = function()
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[silent! %s#\($\n\s*\)\+\%$##]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- spell config
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"gitcommit", "markdown", "plaintext", "tex", "en_us"},
    callback = function()
        vim.opt.spell = true
        vim.opt.spelllang = "en_us"
    end,
})
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"pt_br"},
    callback = function()
        vim.opt.spell = true
        vim.opt.spelllang = "pt_br"
    end,
})

--------------------------------------------------------------------------------
-- mappings
--------------------------------------------------------------------------------

-- previous tag
vim.api.nvim_set_keymap("n", "<C-m>", ":pop<CR>", { noremap = true })

-- previous location, to be used when tags are not applied to file navigation
vim.api.nvim_set_keymap("n", "<C-z>", "<C-o>", { noremap = true })

-- visual-block mode
vim.api.nvim_set_keymap("n", "<C-a>", "<C-v>", { noremap = true })

-- show full file path
vim.api.nvim_set_keymap("n", "<C-e>", ":echo expand('%:p')<CR>", { noremap = true })

-- reload file
vim.api.nvim_set_keymap("n", "<F5>", ":edit<CR>", { noremap = true })

-- undo
vim.api.nvim_set_keymap("n", "<F7>", ":UndotreeToggle<CR>", { noremap = true })

-- change letter case
vim.api.nvim_set_keymap("n", "U", "~", { noremap = true })

-- tab navigation
vim.api.nvim_set_keymap("n", "O", ":tabp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "P", ":tabn<CR>", { noremap = true })

-- window navigation
vim.api.nvim_set_keymap("n", "J", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "K", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "H", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "L", "<C-w>l", { noremap = true })

-- move window into a new tab
vim.api.nvim_set_keymap("n", "T", "<C-w>T", { noremap = true })

-- vim-matchup, go to begin/end of pair
vim.api.nvim_set_keymap("n", "M", "g%", { noremap = true })

-- spell
vim.api.nvim_set_keymap("n", "fa", "zg", { noremap = true })
vim.api.nvim_set_keymap("n", "fr", "zug", { noremap = true })
vim.api.nvim_set_keymap("n", "fo", "[s", { noremap = true })
vim.api.nvim_set_keymap("n", "fp", "]s", { noremap = true })

--------------------------------------------------------------------------------
-- plugins
--------------------------------------------------------------------------------

-- vim-terraform
vim.g.terraform_fmt_on_save = 1
vim.g.terraform_align = 1

-- spelunker
vim.g.spelunker_check_type = 0
vim.g.enable_spelunker_vim_on_readonly = 1
vim.g.spelunker_target_min_char_len = 1
vim.g.spelunker_disable_account_name_checking = 0
vim.g.spelunker_disable_backquoted_checking = 0
vim.api.nvim_set_keymap("n", "ff", "<Plug>(spelunker-correct-from-list)", {})

-- vim-matchup
vim.g.matchup_matchparen_offscreen = {}

-- rainbow
vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
    operators = "",
    guifgs = {"white", "darkorange3", "royalblue3", "seagreen3", "firebrick"},
}

-- vim-go
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_fmt_command = "golines"
vim.g.go_fmt_options = {
    golines = "--base-formatter gofmt -m 120",
}

-- vim-gitgutter
vim.cmd("highlight GitGutterAdd guifg=#009900 ctermfg=2")
vim.cmd("highlight GitGutterChange guifg=#bbbb00 ctermfg=3")
vim.cmd("highlight GitGutterDelete guifg=#ff2222 ctermfg=1")

-- airline
vim.opt.laststatus = 2
vim.g.airline_powerline_fonts = 0
vim.g.airline_left_sep = ""
vim.g.airline_right_sep = ""
-- TODO: not working, arline will be replaced soon
-- let g:airline_symbols = {}
-- let g:airline_symbols.branch = ''
vim.g.airline_section_c = "%<%{expand('%:p')}"
vim.g.airline_section_x = ""
vim.g.airline_section_y = ""
vim.g.airline_section_z = "L:%4l/%{line('$')} | C:%3v/%3{col('$')}"

-- vim-devicons
-- this was blocking g:airline_section_y to be overriden
vim.g.webdevicons_enable_airline_statusline_fileformat_symbols = 0

-- editorconfig-vim
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
vim.g.EditorConfig_disable_rules = { "trim_trailing_whitespace" }

-- github/copilot.vim
vim.api.nvim_set_keymap("i", "<C-f>", "copilot#Accept('<CR>')", { noremap = true, expr = true, silent = true})
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-r>", "<Plug>(copilot-next)", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>(copilot-previous)", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-w>", "<Plug>(copilot-suggest)", { noremap = true })

-- glow.nvim
require("glow").setup()

-- monokai.nvim
require("monokai").setup{
    palette = {
        base2 = "#1c1c1c",
    },
}

-- nvim-bqf
require("bqf").setup({
    func_map = {
        open = "o",
        openc = "<CR>",
    }
})

-- nvim-lint
require("lint").linters_by_ft = {
    proto = {
        "buf_lint",
    }
}
vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- nvim-treesitter
require("nvim-treesitter.configs").setup {
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    disable = { "vim" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--------------------------------------------------------------------------------
-- nvim-lspconfig
--------------------------------------------------------------------------------

local lsp_signature_config = {
  doc_lines = 0,
}
require'lsp_signature'.setup(lsp_signature_config)

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<C-q>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.keymap.set('n', '[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.keymap.set('n', ']', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', '<C-i>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', '<C-y>', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', '<C-g>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<C-b>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', '<C-f>', '<cmd>lua vim.lsp.buf.format{ async = true }<CR>', opts)
  vim.keymap.set('n', '<C-n>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
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
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities['offsetEncoding'] = 'utf-16'

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
  'vimls',
  'dockerls',
  'solidity_ls',
  'terraformls',
  'tflint', -- it does not search for .tflint.hcl in parent directories
  'golangci_lint_ls',
  'sqlls',
  'bufls',
  'marksman',
}
for _, lsp in ipairs(lsps_with_default_config) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = flags,
    capabilities = capabilities,
  }
end

local function readDictionaryFile(file)
  local dict = {}
  for line in io.lines(file) do
    table.insert(dict, line)
  end
  return dict
end

lspconfig['clangd'].setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = capabilities,
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
}

lspconfig['ltex'].setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = capabilities,
  filetypes = {
    "gitcommit",
    "markdown",
    "plaintex",
    "tex",
    "en_us",
  },
  settings = {
    ltex = {
      language = "en-US",
      dictionary = {
        ["en-US"] = readDictionaryFile(vim.env.HOME .. "/.config/nvim/spell/en.utf-8.add"),
      },
    },
  },
}

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

local cmp = require 'cmp'

local next_item = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local prev_item = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

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
    ['<Tab>'] = next_item,
    ['<DOWN>'] = next_item,
    ['<S-Tab>'] = prev_item,
    ['<UP>'] = prev_item,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
