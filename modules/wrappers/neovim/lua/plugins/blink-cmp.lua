return {
    "blink.cmp",
    lazy = false,

    after = function()
        require("blink.cmp").setup({
            snippets = { preset = 'luasnip' },

            keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" }
            },
        })
    end,
}
