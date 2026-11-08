return {
    "telescope.nvim",
    cmd = "Telescope",

    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>", desc = "Buffers" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
        { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Word under cursor" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
    },

    before = function()
        vim.cmd.packadd("plenary.nvim")
        pcall(vim.cmd.packadd, "nvim-web-devicons")
    end,

    after = function()
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                vimgrep_arguments = {
                    "rg", "--color=never", "--no-heading", "--with-filename",
                    "--line-number", "--column", "--smart-case",
                    "--hidden", "--glob", "!**/.git/*",
                },
                file_ignore_patterns = {
                    "^node_modules/", "^%.git/", "^%.direnv/", "^%.devenv/",
                    "^target/", "^dist/", "^build/", "^result/", "%.lock$",
                },
                sorting_strategy = "ascending",
                layout_config = { prompt_position = "top" },
                path_display = { "truncate" },
                dynamic_preview_title = false,
                results_title = false,
                cache_picker = false,
                preview = {
                    filesize_limit = 1, -- МБ
                    timeout = 150,
                    treesitter = false,
                },
            },
            pickers = {
                find_files = {
                    find_command = {
                        "fd", "--type", "f", "--hidden", "--follow",
                        "--exclude", ".git", "--strip-cwd-prefix",
                    },
                },
                buffers = { ignore_current_buffer = true },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        pcall(vim.cmd.packadd, "telescope-fzf-native.nvim")
        pcall(telescope.load_extension, "fzf")
    end,
}
