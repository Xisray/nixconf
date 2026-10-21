return {
    "oil.nvim",
    lazy = false,
    after = function()
        require("oil").setup({
            skip_confirm_for_simple_edits = true,
            float = {
              padding = 2,
              max_width = 0.8,
              max_height = 0.8,
            },
        })
    end,
    keys = { { "<leader>e", ":Oil .<cr>", mode = "n" }, }, 
}
