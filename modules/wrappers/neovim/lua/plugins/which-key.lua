return {
    "which-key.nvim",
    event = "DeferredUIEnter",

    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer keymaps",
        },
    },

    after = function()
        require("which-key").setup({
            preset = "modern",
            delay = 300,
            notify = false,
            plugins = {
                marks = false,
                registers = false,
                spelling = { enabled = false },
            },
            icons = { mappings = false },
            spec = {
                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>c", group = "code" },
            },
        })
    end,
}
