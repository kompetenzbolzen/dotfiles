local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

vim.env.REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt"
vim.g.python3_host_prog = "/usr/bin/python"

require("lazy").setup("plugins")

-- load vim config
vim.cmd("source " .. vim.fn.stdpath("config") .. "/vimscript/*")
