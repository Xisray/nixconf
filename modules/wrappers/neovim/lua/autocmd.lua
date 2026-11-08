vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })  -- или "Visual"
  end,
})
