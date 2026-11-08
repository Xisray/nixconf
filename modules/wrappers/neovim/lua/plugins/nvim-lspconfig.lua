return {
    "nvim-lspconfig",
    lazy = false,

    before = function()
        local ok, blink = pcall(require, "blink.cmp")
        local capabilities = ok
            and blink.get_lsp_capabilities()
            or vim.lsp.protocol.make_client_capabilities()

        vim.lsp.config("*", { capabilities = capabilities })

        -- LspAttach вместо on_attach: не перезаписывается серверами со своим on_attach
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local opts = { silent = true, buffer = args.buf }
                vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
            end,
        })
    end,
}
