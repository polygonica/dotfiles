-- ~/.config/nvim/init.lua

-- Basic settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.mouse = 'a'           -- Enable mouse support
vim.opt.ignorecase = true     -- Case insensitive search
vim.opt.smartcase = true      -- But case sensitive when uppercase present
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.wrap = false          -- Don't wrap lines
vim.opt.breakindent = true    -- Preserve indentation in wrapped text
vim.opt.tabstop = 4           -- Tab width
vim.opt.shiftwidth = 4        -- Indentation width
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.termguicolors = true  -- Enable 24-bit RGB color
vim.opt.clipboard = "unnamedplus" -- Use system clipboard by default (e.g.: for yy yank)

