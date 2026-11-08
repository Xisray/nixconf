return {
    "conform.nvim",
    lazy = false,

    after = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                -- nix
                nix = { "alejandra" },

                -- python: автофиксы -> импорты -> форматирование
                python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },

                -- shell
                sh = { "shfmt" },
                bash = { "shfmt" },

                -- C / C++
                c = { "clang-format" },
                cpp = { "clang-format" },

                -- C#: форматеров нет, на сохранении работает LSP (omnisharp).
                -- Для csharpier добавь cs = { "csharpier" } и установи его в devenv.

                -- web: prettierd, если нет, то обычный prettier из node_modules
                javascript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                scss = { "prettierd", "prettier", stop_after_first = true },
                less = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                jsonc = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },
            },

            -- для типов без форматера (или если он не найден) используем LSP
            default_format_opts = { lsp_format = "fallback" },

            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 1000, lsp_format = "fallback" }
            end,

            formatters = {
                shfmt = { prepend_args = { "-i", "4" } },
            },
        })

        -- ручное форматирование
        local function fmt()
            conform.format({ async = true, lsp_format = "fallback" })
        end
        vim.keymap.set({ "n", "v" }, "<leader>F", fmt, { desc = "Format buffer/range" })
        vim.keymap.set("v", "F", fmt, { desc = "Format range" })

        -- :FormatDisable / :FormatEnable (с ! только для текущего буфера)
        vim.api.nvim_create_user_command("FormatDisable", function(opts)
            if opts.bang then
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, { bang = true, desc = "Disable format on save" })

        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, { desc = "Enable format on save" })
    end,
}
