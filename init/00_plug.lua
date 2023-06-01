local Plug = vim.fn['plug#']
vim.call('plug#begin', (os.getenv('VIM_PLUGGED') or '~/.config/nvim') .. '/plugged')
  -- Deps
  Plug('nvim-telescope/telescope.nvim', { ['tag']= '0.1.0' })
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'prochri/telescope-all-recent.nvim'
  Plug('nvim-treesitter/nvim-treesitter', {['do']= ':TSUpdate'})
  Plug 'nvim-lua/plenary.nvim'
  Plug 'akinsho/toggleterm.nvim'
  Plug 'smiteshp/nvim-navic'
  Plug 'kkharji/sqlite.lua'

  -- Editor plugins    
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-commentary'
  -- Plug 'tpope/vim-fugitive'
  Plug 'akinsho/git-conflict.nvim'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'sindrets/diffview.nvim'
  Plug 'antoinemadec/FixCursorHold.nvim'                                                                                                                 
  Plug 'nvim-neotest/neotest'                                                                                                                            
  Plug 'Issafalcon/neotest-dotnet' 

  -- Plug 'sbdchd/neoformat'
  Plug 'ThePrimeagen/harpoon'
  Plug 'jedrzejboczar/toggletasks.nvim'
  Plug 'mbbill/undotree'
  Plug 'TimUntersberger/neogit'
  Plug 'rest-nvim/rest.nvim'
  Plug 'utilyre/barbecue.nvim'
  Plug 'm4xshen/autoclose.nvim'
  Plug 'aca/emmet-ls'
  -- Plug 'airblade/vim-gitgutter'
  Plug 'lewis6991/gitsigns.nvim'
  Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
  Plug 'junegunn/fzf.vim'
  Plug 'nvim-tree/nvim-web-devicons' 
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-lualine/lualine.nvim'
  Plug('akinsho/bufferline.nvim', { branch = 'v3.7.0' })
  Plug 'folke/trouble.nvim'
  Plug 'luukvbaal/statuscol.nvim'

  -- Theme
  Plug('folke/tokyonight.nvim', { branch = 'main' })
  Plug 'Mofiqul/vscode.nvim'
  Plug 'navarasu/onedark.nvim'
  Plug 'Everblush/nvim'
  -- Plug "olimorris/onedarkpro.nvim"
  

  -- LSP plugins
  Plug 'williamboman/mason.nvim'
  Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'mfussenegger/nvim-dap'
  Plug "jay-babu/mason-nvim-dap.nvim"
  Plug 'mfussenegger/nvim-lint'
  Plug 'mhartington/formatter.nvim'

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

  Plug 'rcarriga/nvim-dap-ui'
  -- Plug('mxsdev/nvim-dap-vscode-js')
  -- Plug('microsoft/vscode-js-debug', {['do'] = "npm install --legacy-peer-deps && npm run compile"})
  
  -- Neotest packages
  Plug 'antoinemadec/FixCursorHold.nvim'                                                                                                                 
  Plug 'nvim-neotest/neotest'                                                                                                                            
  Plug 'Issafalcon/neotest-dotnet' 
  Plug 'stevanmilic/neotest-scala'


  -- Scala lang plugin
  Plug 'scalameta/nvim-metals'

  -- Csharp plugins
  Plug "Hoffs/omnisharp-extended-lsp.nvim"
  -- Plug "Decodetalkers/csharpls-extended-lsp.nvim"

  -- Org language plugins
  Plug 'jceb/vim-orgmode'

  Plug 'whonore/Coqtail'
vim.call('plug#end')

