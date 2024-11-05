--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.termguicolors = true

-- Options for NVimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Ballerina
vim.filetype.add({
  extension = {
    bal = 'ballerina',
    hurl = 'hurl',
  }
})


-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- Presenting
  {
    "sotte/presenting.nvim",
    opts = {},
    cmd = { "Presenting" },
  },

  -- visualize whitespace
  'mcauley-penney/visual-whitespace.nvim',

  -- images
  'edluffy/hologram.nvim',
  -- coverage
  'ruanyl/coverage.vim',
  -- Hurl (http testing)
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    ft = "hurl",
    opts = {
      -- Show debugging info
      debug = false,
      -- Show notification on run
      show_notification = false,
      -- Show response in popup or split
      mode = "split",
      -- Default formatter
      formatters = {
        json = { 'jq' }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
          'prettier',    -- Make sure you have install prettier in your system, e.g: npm install -g prettier
          '--parser',
          'html',
        },
      },
    },
    keys = {
      -- Run API request
      { "<leader>hA", "<cmd>HurlRunner<CR>",        desc = "Run All requests" },
      { "<leader>ha", "<cmd>HurlRunnerAt<CR>",      desc = "Run Api request" },
      { "<leader>he", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>hm", "<cmd>HurlToggleMode<CR>",    desc = "Hurl Toggle Mode" },
      { "<leader>hv", "<cmd>HurlVerbose<CR>",       desc = "Run Api in verbose mode" },
      -- Run Hurl request in visual mode
      { "<leader>hh", ":HurlRunner<CR>",            desc = "Hurl Runner",             mode = "v" },
    },
  },

  -- Go
  'ray-x/go.nvim',

  -- Elixir,
  'elixir-editors/vim-elixir',

  -- Screen Key
  {
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    version = "*",
    config = function()
      require('screenkey').setup({
        disable = {
          filetypes = { 'toggleterm' },
          buftypes = { 'terminal' }
        },
        clear_after = 2,
      })
    end,
  },

  -- Database UI
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- NOTE: First, some plugins that don't require any configuration
  --
  -- Clojure
  'Olical/conjure',
  {
    "dundalek/parpar.nvim",
    dependencies = { "gpanders/nvim-parinfer", "julienvincent/nvim-paredit" },
    config = function()
      local paredit = require("nvim-paredit")
      require("parpar").setup {
        paredit = {
          indent = { enabled = true },
          -- pass any nvim-paredit options here
          keys = {
            -- custom bindings are automatically wrapped
            [">)"] = { paredit.api.slurp_forwards, "Slurp forwards" },
            [">("] = { paredit.api.barf_backwards, "Barf backwards" },

            ["<)"] = { paredit.api.barf_forwards, "Barf forwards" },
            ["<("] = { paredit.api.slurp_backwards, "Slurp backwards" },

            [">e"] = { paredit.api.drag_element_forwards, "Drag element right" },
            ["<e"] = { paredit.api.drag_element_backwards, "Drag element left" },

            [">f"] = { paredit.api.drag_form_forwards, "Drag form right" },
            ["<f"] = { paredit.api.drag_form_backwards, "Drag form left" },

            ["<localleader>o"] = { paredit.api.raise_form, "Raise form" },
            ["<localleader>O"] = { paredit.api.raise_element, "Raise element" },

            ["E"] = {
              paredit.api.move_to_next_element_tail,
              "Jump to next element tail",
              -- by default all keybindings are dot repeatable
              repeatable = false,
              mode = { "n", "x", "o", "v" },
            },
            ["W"] = {
              paredit.api.move_to_next_element_head,
              "Jump to next element head",
              repeatable = false,
              mode = { "n", "x", "o", "v" },
            },

            ["B"] = {
              paredit.api.move_to_prev_element_head,
              "Jump to previous element head",
              repeatable = false,
              mode = { "n", "x", "o", "v" },
            },
            ["gE"] = {
              paredit.api.move_to_prev_element_tail,
              "Jump to previous element tail",
              repeatable = false,
              mode = { "n", "x", "o", "v" },
            },

            ["("] = {
              paredit.api.move_to_parent_form_start,
              "Jump to parent form's head",
              repeatable = false,
              mode = { "n", "x", "v" },
            },
            [")"] = {
              paredit.api.move_to_parent_form_end,
              "Jump to parent form's tail",
              repeatable = false,
              mode = { "n", "x", "v" },
            },
          }
        }
      }
    end
  },
  --'guns/vim-sexp',
  --'tpope/vim-sexp-mappings-for-regular-people',
  --'tpope/vim-repeat',
  'tpope/vim-surround',
  'PaterJason/cmp-conjure',

  -- Testing
  'vim-test/vim-test',

  -- File search
  { 'junegunn/fzf.vim',     dependencies = { 'junegunn/fzf' } },
  -- Janet
  'bakpakin/janet.vim',

  -- Odin
  'Tetralux/odin.vim',

  -- Debugger
  'mfussenegger/nvim-dap',
  'jay-babu/mason-nvim-dap.nvim',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup()
    end
  },
  'chrisbra/vim-xml-runtime',

  -- Undo tree
  'mbbill/undotree',

  -- Guard for formatting
  "clang-format",
  {
    "nvimdev/guard.nvim",
    dependencies = {
      "nvimdev/guard-collection"
    },
    event = "VeryLazy",
    config = function()
      local ft = require("guard.filetype")
      ft("c,cpp"):fmt("clang-format")

      require("guard").setup({
        fmt_on_save = true,
        lsp_as_default_formatter = fals,
      })
    end,
  },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- For Qalc (calculator CLI app)
  'Apeiros-46B/qalc.nvim',

  -- For AceJump equivalent
  'smoka7/hop.nvim',
  'rmagatti/auto-session',

  -- BUffer managment
  'Asheq/close-buffers.vim',

  -- File management
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Tree explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      sort = { sorter = "case_sensitive", },
      view = { width = 30, },
      filters = { dotfiles = true, },
    },
  },


  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',

      -- Zig
      'ziglang/zig.vim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  -- Bookmarks
  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    opts = {
      show_icons = true,
      always_show_path = true,
      leader_key = '<leader>m',
      buffer_leader_key = '<localleader>b',
      separate_save_and_remove = true,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`

    config = function()
      require('lualine').setup({
        options = {
          theme = 'onedark',
          component_separators = '|',
        },
        extensions = {'quickfix', 'nvim-tree', 'mason', 'lazy', 'nvim-dap-ui'},
        sections = {
          lualine_c = {
            'filename',
            function()
              local buff = require('arrow.buffer_persist').get_bookmarks_by()
              if #buff > 0 then
                return "≣ " .. #buff
              else
                return ""
              end
            end,
            function()
              return require('arrow.statusline').text_for_statusline_with_icons(nil)
            end,
          },
          lualine_x = { {'encoding', show_bomb = true}, 'fileformat',  },
        },
        tabline = {
          lualine_b = {{'filename', path = 3, newfile_status = true, shorting_target = 60}, },
          lualine_c = {{'filetype', icon = {align = 'right'}}, quickfix},
          lualine_y = {{'datetime', style='%H:%M:%S'}},
        }
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'HiPhish/rainbow-delimiters.nvim',
      'elixir-lang/tree-sitter-elixir',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'tree-sitter/tree-sitter-python',
    },
    build = ':TSUpdate',
  },

  {
    "matthewtolman/column-width.nvim",
    opts = {
      enabled = true,
      widths = {
      },
    }
  },

  "jeffkreeftmeijer/vim-numbertoggle",

  'mfussenegger/nvim-dap-python',

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- arrow bookmarks
vim.keymap.set('n', '[b', require('arrow.commands').commands.prev_buffer_bookmark,
  { desc = 'Previous [b]uffer bookmark' })
vim.keymap.set('n', ']b', require('arrow.commands').commands.next_buffer_bookmark, { desc = 'Next [b]uffer bookmark' })
vim.keymap.set('n', '[B', require('arrow.persist').next, { desc = 'Previous File [B]ookmark' })
vim.keymap.set('n', ']B', require('arrow.persist').previous, { desc = 'Next File [B]ookmak' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Remap for paste/delete without yank
vim.keymap.set('v', '<leader>p', '"_dP', { remap = true, desc = '[P]aste (no yank)' })
vim.keymap.set('v', '<leader>d', '"_d', { remap = true, desc = '[D]elete (no yank)' })

-- Undo tree keymaps
vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = 'Toggle undo tree' })

-- ParInfer keymaps
vim.keymap.set('n', '<leader>pt', vim.cmd.ParinferToggle, { desc = 'Toggle ParInfer' })
vim.keymap.set({ 'n', 'v' }, '<leader>sk', vim.cmd.Screenkey, { desc = 'Toggle Screen Key' })

-- quickfix list and vimgrep

vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })
vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Prev quickfix' })
vim.keymap.set('n', ']Q', vim.cmd.cfirst, { desc = 'First quickfix' })
vim.keymap.set('n', '[Q', vim.cmd.clast, { desc = 'Last quickfix' })
vim.keymap.set('n', ']l', vim.cmd.copen, { desc = 'Open quickfix list' })
vim.keymap.set('n', '[l', vim.cmd.cclose, { desc = 'Close quickfix list' })
vim.keymap.set('n', ']f', vim.cmd.cnfile, { desc = 'Next file' })
vim.keymap.set('n', '[f', vim.cmd.cpfile, { desc = 'Prev file' })
vim.keymap.set('n', ']L', vim.cmd.cnewer, { desc = 'Next quickfix list' })
vim.keymap.set('n', '[L', vim.cmd.colder, { desc = 'Prev quickfix list' })

-- Diagnostic keymap
vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = 'Goto next error' })
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, { desc = 'Goto previous error' })

-- [[Configure Hop]]
require('hop').setup {
  uppercase_labels = true,
  multi_windows = true,
}

local hop = require('hop')

vim.keymap.set('', ';', function()
  hop.hint_patterns()
end, { desc = 'Hop pattern' })
vim.keymap.set('', '<leader>;', function()
  hop.hint_words()
end, { desc = 'Hop words' })

-- [[Configure Session Manager]]
require("auto-session").setup {
  auto_session_suppress_dirs = { "~/", "~/dev", "~/Downloads", "/" },
  options = {
    theme = 'tokyonight',
  },
  sections = { lualine_c = { require('auto-session.lib').current_session_name } },
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_use_git_branch = true,
}

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'c',
      'cpp',
      'clojure',
      'go',
      'lua',
      'python',
      'rust',
      'tsx',
      'javascript',
      'json',
      'typescript',
      'vimdoc',
      'vim',
      'bash',
      'hurl',
      'elixir',
      'erlang'
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    additional_vim_regex_highlighting = true,
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    rainbow = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>Lt', require('telescope.builtin').lsp_type_definitions, '[T]ype Definition')
  nmap('<leader>Ld', require('telescope.builtin').lsp_document_symbols, '[D]ocument Symbols')
  nmap('<leader>Lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- [ Automatically Configure Dap ]
require("mason-nvim-dap").setup({
  ensure_installed = { "cppdbg", "codelldb" },
  automatic_installation = true,
  handlers = {
    function(config)
      require('mason-nvim-dap').default_setup(config)
    end,
    python = function(config)
      config.adapters = {
        type = "executable",
        command = "python3",
        args = {
          "-m",
          "debugpy.adapter",
        },
      }
      require('mason-nvim-dap').default_setup(config)
    end,
  },
})

-- [manual dapaters]

local dap = require('dap')
dap.adapters.debugpy = {
  type = "executable",
  command = "python3",
  args = {
    "-m",
    "debugpy.adapter",
  },
}

-- [ dap commands ]

local setup_dap = function()
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { desc = desc })
  end

  nmap('<leader>db', function() require('dap').toggle_breakpoint() end, '[b]reakpoint')
  nmap('<leader>dB', function() require('dap').list_breakpoints() end, 'List [B]reakpoints')
  nmap('<leader>dC', function() require('dap').clear_breakpoints() end, '[C]lear Breakpoints')
  nmap('<leader>dl', function() require('dap').continue() end, '[l]aunch')
  nmap('<leader>dL', function() require('dap').run_last() end, 'Run [L]ast')
  nmap('<leader>di', function() require('dap').step_into() end, 'Step [i]nto')
  nmap('<leader>do', function() require('dap').step_over() end, 'Step [o]ver')
  nmap('<leader>dO', function() require('dap').step_out() end, 'Step [O]out')
  nmap('<leader>dR', function() require('dap').restart() end, '[R]estart')
  nmap('<leader>dT', function() require('dap').terminate() end, '[T]erminate Session')
  nmap('<leader>dL', function()
    require('dap.ext.vscode').load_launchjs(nil, {
      debugpy = { 'python' },
      cppdbg = { 'c', 'cpp' }
    })
  end, '[L]oad .vscode/launch.json')
  nmap('<leader>dP', function() require('dap').pause() end, '[P]ause')
  nmap('<leader>du', function() require('dap').up() end, '[u]p callstack')
  nmap('<leader>dd', function() require('dap').down() end, '[d]own callstack')
  nmap('<leader>dc', function() require('dap').run_to_cursor() end, 'run to [c]ursor')
  nmap('<leader>d<space>', function() require('dap').status() end, 'Status')

  nmap('<leader>dt', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.threads)
  end, '[t]hreads')

  nmap('<leader>de', function()
    local widgets = require('dap.ui.widgets')
    widgets.cursor_float(widgets.expression)
  end, '[e]xpression')

  nmap('<leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.sessions)
  end, '[s]essions')

  nmap('<leader>dS', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
  end, '[S]copes')

  nmap('<leader>dfl', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
  end, '[l]ist frames')

  nmap('<leader>dff', function() require('dap').focus_frame() end, '[f]ocus frame')
  nmap('<leader>dfr', function() require('dap').restart_frame() end, 'Restart [F]rame')

  nmap('<leader>dtb', function() require('dap').step_out() end, 'step [b]ack')
  nmap('<leader>dtc', function() require('dap').step_out() end, 'reverse [c]ontinue')
  nmap('<leader>drt', function() require('dap').repl.toggle() end, 'REPL [t]oggle')
  nmap('<leader>dro', function() require('dap').repl.open() end, 'REPL [o]pen')
  nmap('<leader>dre', function() require('dap').repl.exit() end, 'REPL [e]xit')
  nmap('<leader>drc', function() require('dap').repl.continue() end, 'REPL [c]ontinue')
  nmap('<leader>drn', function() require('dap').repl.next() end, 'REPL [n]ext')
  nmap('<leader>dri', function() require('dap').repl.into() end, 'REPL [i]nto')
  nmap('<leader>dro', function() require('dap').repl.out() end, 'REPL [o]ut')
  nmap('<leader>dru', function() require('dap').repl.up() end, 'REPL [u]p')
  nmap('<leader>drd', function() require('dap').repl.down() end, 'REPL [d]own')
  nmap('<leader>drs', function() require('dap').repl.scopes() end, 'REPL [s]copes')
  nmap('<leader>drt', function() require('dap').repl.threads() end, 'REPL [t]hreads')
  nmap('<leader>drf', function() require('dap').repl.frames() end, 'REPL [f]rames')
end
setup_dap()

vim.keymap.set('n', "<leader><leader>vw", require('visual-whitespace').toggle, { desc = "[V]iew [W]hitespace toggle" })

-- document existing key chains
-- [KEYMAP DOCS]
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode/[C]olumn', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[d]ebug', _ = 'which_key_ignore' },
  ['<leader>dt'] = { name = '[d]ebug [t]imetravel', _ = 'which_key_ignore' },
  ['<leader>dr'] = { name = '[d]ebug [r]repl', _ = 'which_key_ignore' },
  ['<leader>df'] = { name = '[d]ebug [f]rames', _ = 'which_key_ignore' },
  ['<leader>L'] = { name = '[L]SP', _ = 'which_key_ignore' },
  ['<leader>b'] = { name = '[b]ookmark', _ = 'which_key_ignore' },
  ['<leader>m'] = { name = 'File book[m]ark', _ = 'which_key_ignore' },
  ['<leader>e'] = { name = '[E]valuate', _ = 'which_key_ignore' },
  ['<leader>l'] = { name = '[L]ogs', _ = 'which_key_ignore' },
  ['<leader>p'] = { name = '[P]arInfer', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]esting', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch/REPL [S]ession/[S]creen', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = '[H]url/[H]ttp', _ = 'which_key_ignore' },
  ['<leader><leader>'] = { name = 'More', _ = 'which_key_ignore' },

  ['v['] = { name = 'Select Previous', _ = 'which_key_ignore' },
  ['v[%'] = { name = 'Smart Select Previous', _ = 'which_key_ignore' },
  ['v]'] = { name = 'Select Next', _ = 'which_key_ignore' },
  ['v]%'] = { name = 'Smart Select Next', _ = 'which_key_ignore' },
  ['v<leader>'] = { name = 'Hop Select', _ = 'which_key_ignore' },
  ['vg'] = { name = 'File Select', _ = 'which_key_ignore' },

  ['d['] = { name = 'Delete Previous', _ = 'which_key_ignore' },
  ['d[%'] = { name = 'Smart Delete Previous', _ = 'which_key_ignore' },
  ['d]'] = { name = 'Delete Next', _ = 'which_key_ignore' },
  ['d]%'] = { name = 'Smart Delete Next', _ = 'which_key_ignore' },
  ['d<leader>'] = { name = 'Hop Delete', _ = 'which_key_ignore' },
  ['dg'] = { name = 'File Delete', _ = 'which_key_ignore' },

  ['y['] = { name = 'Yank Previous', _ = 'which_key_ignore' },
  ['y[%'] = { name = 'Smart Yank Previous', _ = 'which_key_ignore' },
  ['y]'] = { name = 'Yank Next', _ = 'which_key_ignore' },
  ['y]%'] = { name = 'Smart Yank Next', _ = 'which_key_ignore' },
  ['y<leader>'] = { name = 'Hop Yank', _ = 'which_key_ignore' },
  ['yg'] = { name = 'File Yank', _ = 'which_key_ignore' },

  ['c['] = { name = 'Change Previous', _ = 'which_key_ignore' },
  ['c[%'] = { name = 'Smart Change Previous', _ = 'which_key_ignore' },
  ['c]'] = { name = 'Change Next', _ = 'which_key_ignore' },
  ['c]%'] = { name = 'Smart Change Next', _ = 'which_key_ignore' },
  ['c<leader>'] = { name = 'Hop Change', _ = 'which_key_ignore' },
  ['cg'] = { name = 'File Change', _ = 'which_key_ignore' },

  ['>['] = { name = 'Indent Previous', _ = 'which_key_ignore' },
  ['>[%'] = { name = 'Smart Indent Previous', _ = 'which_key_ignore' },
  ['>]'] = { name = 'Indent Next', _ = 'which_key_ignore' },
  ['>]%'] = { name = 'Smart Indent Next', _ = 'which_key_ignore' },
  ['><leader>'] = { name = 'Hop Indent', _ = 'which_key_ignore' },
  ['>g'] = { name = 'File Indent', _ = 'which_key_ignore' },

  ['<['] = { name = 'DeIndent Previous', _ = 'which_key_ignore' },
  ['<[%'] = { name = 'Smart DeIndent Previous', _ = 'which_key_ignore' },
  ['<]'] = { name = 'DeIndent Next', _ = 'which_key_ignore' },
  ['<]%'] = { name = 'Smart DeIndent Next', _ = 'which_key_ignore' },
  ['<<leader>'] = { name = 'Hop DeIndent', _ = 'which_key_ignore' },
  ['<g'] = { name = 'File DeIndent', _ = 'which_key_ignore' },

  ['[o'] = { name = 'Soft wrap', _ = 'which_key_ignore' },
  [']o'] = { name = 'Hard wrap', _ = 'which_key_ignore' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs', 'heex' } },
  elixirls = {

  },
  gopls = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  zls = {},
  emmet_language_server = {},
  ols = { filetypes = { 'odin' } },
  -- elp = {},

  cmake = {},
  -- CLOJURE
  clojure_lsp = {},
}

-- Setup oil.nvim
require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime"
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

--

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
require('snippets')
local luasnip = require 'luasnip'

vim.keymap.set({ "i" }, "<C-K>", function() luasnip.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-o>'] = cmp.mapping.open_docs(),
    ['<Tab>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'conjure' },
  },
}

-- Search counter in status bar
if vim.v.hlsearch == 1 then
  local sinfo = vim.fn.searchcount { maxcount = 0 }
  local search_stat = sinfo.incomplete > 0 and '[?/?]'
      or sinfo.total > 0 and ('[%s/%s]'):format(sinfo.current, sinfo.total)
      or nil

  if search_stat ~= nil then
    -- add search_stat to statusline/winbar
  end
end

cmp.setup.filetype('markdown', { sources = {} })

-- folding

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("set nofoldenable")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
