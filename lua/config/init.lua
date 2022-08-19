local options = require "config.options"

---  SETTINGS  ---
vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append "I" -- don't show the default intro message
vim.opt.whichwrap:append "<,>,[,],h,l"

for k, v in pairs(options) do
    vim.opt[k] = v
end

require "config.plugins"
require "config.keymaps"
require "config.autocommands"

