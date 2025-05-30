-- ~/.config/nvim/init.lua

-- Basic settings
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

-- Clipboard settings
vim.opt.clipboard = "unnamedplus"   -- Use system clipboard by default (e.g.: for yy yank)
vim.keymap.set('n', 'Y', '0y$')     -- Shortcut: yank line without newline

-- Navigation settings
vim.opt.number = true                                       -- Show line numbers
vim.opt.relativenumber = true                               -- Show relative line numbers
vim.keymap.set('n', 'H', '^')                               -- H                            : Beginning of line (Custom Vim keybind style, like Home)
vim.keymap.set('n', 'L', '$')                               -- L                            : End of line (Custom Vim keybind style, like End)
vim.keymap.set({'n', 'v'}, '<M-b>', 'b')                    -- Alt + ←                      : word back (MacOS style)
vim.keymap.set({'n', 'v'}, '<M-f>', 'e')                    -- Alt + →                      : word forward (MacOS style)
vim.keymap.set({'n', 'v'}, '<M-BS>', 'db')                  -- Alt + Backspace              : delete word (MacOS style)
vim.keymap.set('n', '<C-f>', '/')                           -- Ctrl + f                     : Search (MacOS style)

-- File settings
vim.keymap.set('n', '<C-s>', ':w<CR>')  -- Ctrl + s     : Save (MacOS style)

