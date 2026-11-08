return {
    "tiny-inline-diagnostic.nvim",
    -- name = "tiny-inline-diagnostic.nvim",
    event = "BufReadPost",
    -- lazy = false,
    priority = 1000,
    after = function()
        require("tiny-inline-diagnostic").setup({
          options = {
            multilines = {
              enabled = true,
            },
          },
          preset = "classic",
        })
        vim.diagnostic.config({ virtual_text = false })
    end,
}
