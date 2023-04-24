local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
  -- Deps
  Plug('nvim-telescope/telescope.nvim', { ['tag']= '0.1.0' })
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug('nvim-treesitter/nvim-treesitter', {['do']= ':TSUpdate'})
  Plug 'nvim-lua/plenary.nvim'
  Plug 'akinsho/toggleterm.nvim'
  Plug 'smiteshp/nvim-navic'

  -- Editor plugins    
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'michaeljsmith/vim-indent-object'
  -- Plug 'sbdchd/neoformat'
  Plug 'ThePrimeagen/harpoon'
  Plug 'jedrzejboczar/toggletasks.nvim'
  Plug 'mbbill/undotree'
  Plug 'TimUntersberger/neogit'
  Plug 'rest-nvim/rest.nvim'
  Plug 'utilyre/barbecue.nvim'
  Plug 'm4xshen/autoclose.nvim'
  Plug 'aca/emmet-ls'
  Plug 'airblade/vim-gitgutter'
  Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
  Plug 'junegunn/fzf.vim'
  Plug 'nvim-tree/nvim-web-devicons' 
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-lualine/lualine.nvim'
  Plug('akinsho/bufferline.nvim', { branch = 'v3.7.0' })
  Plug 'folke/trouble.nvim'

  -- Theme
  Plug('folke/tokyonight.nvim', { branch = 'main' })
  Plug 'Mofiqul/vscode.nvim'
  Plug 'navarasu/onedark.nvim'
  Plug 'Everblush/nvim'
  -- Plug "olimorris/onedarkpro.nvim"
  

  -- LSP plugins
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'mfussenegger/nvim-dap'
  Plug "jay-babu/mason-nvim-dap.nvim"
  Plug 'mfussenegger/nvim-lint'
  Plug 'mhartington/formatter.nvim'

  Plug 'ray-x/lsp_signature.nvim'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'rcarriga/nvim-dap-ui'
  -- Plug('mxsdev/nvim-dap-vscode-js')
  -- Plug('microsoft/vscode-js-debug', {['do'] = "npm install --legacy-peer-deps && npm run compile"})

  -- Scala lang plugin
  Plug 'scalameta/nvim-metals'

  -- Csharp plugins
  Plug "Hoffs/omnisharp-extended-lsp.nvim"

  -- Org language plugins
  Plug 'jceb/vim-orgmode'
vim.call('plug#end')

