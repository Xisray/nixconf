{
  flake.wrappers.neovim = {
    lib,
    wlib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.neovim];
    options.mode = lib.mkOption {
      type = lib.types.enum [
        "dynamic"
        "static"
      ];
      default = "static";
    };
    config = let
      dynamic = config.mode == "dynamic";
    in {
      runtimePkgs = [pkgs.wl-clipboard pkgs.ripgrep pkgs.fd];
      settings.config_directory = lib.mkIf dynamic (
        lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/nixconf/modules/wrappers/neovim'"
      );
      settings.compile_generated_lua = false;
      specs.init = lib.mkIf dynamic {
        data = null;
        before = ["MAIN_INIT"];
        config = "pcall(require, 'init')";
      };
      lazyPlugins = {
        "which-key.nvim" = {
          package = pkgs.vimPlugins.which-key-nvim;
          event = "DeferredUIEnter";
          keys = [
            {
              key = "<leader>?";
              action = "<cmd>lua require('which-key').show({ global = false })<cr>";
              description = "Buffer keymaps";
            }
          ];
          after = {
            setup = null;
            "which-key".setup = let
              inherit (lib.generators) mkLuaInline;
              group = key: name: mkLuaInline ''{ "${key}", group = "${name}" }'';
            in {
              preset = "helix";
              delay = 300;
              notify = false;
              plugins = {
                marks = false;
                registers = false;
                spelling.enabled = false;
              };
              icons.mappings = false;
              spec = [
                (group "<leader>f" "find")
                (group "<leader>g" "git")
                (group "<leader>c" "code")
              ];
            };
          };
        };
        "telescope.nvim" = {
          package = [
            pkgs.vimPlugins.telescope-nvim
            pkgs.vimPlugins.telescope-fzf-native-nvim
            pkgs.vimPlugins.plenary-nvim
          ];
          cmd = "Telescope";
          keys = [
            {
              key = "<leader>ff";
              action = "<cmd>Telescope find_files<cr>";
              description = "Files";
            }
            {
              key = "<leader>fg";
              action = "<cmd>Telescope live_grep<cr>";
              description = "Grep";
            }
            {
              key = "<leader>fb";
              action = "<cmd>Telescope buffers sort_mru=true<cr>";
              description = "Buffers";
            }
            {
              key = "<leader>fr";
              action = "<cmd>Telescope oldfiles<cr>";
              description = "Recent files";
            }
            {
              key = "<leader>fh";
              action = "<cmd>Telescope help_tags<cr>";
              description = "Help";
            }
            {
              key = "<leader>fd";
              action = "<cmd>Telescope diagnostics<cr>";
              description = "Diagnostics";
            }
            {
              key = "<leader>fs";
              action = "<cmd>Telescope lsp_document_symbols<cr>";
              description = "Symbols";
            }
            {
              key = "<leader>fw";
              action = "<cmd>Telescope grep_string<cr>";
              description = "Word under cursor";
            }
            {
              key = "<leader>fk";
              action = "<cmd>Telescope keymaps<cr>";
              description = "Keymaps";
            }
            {
              key = "<leader>/";
              action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
              description = "Search in buffer";
            }
          ];
          before.extraConfig = ''
            vim.cmd.packadd("plenary.nvim")
            pcall(vim.cmd.packadd, "nvim-web-devicons")
          '';
          after = {
            setup = null;
            "telescope".setup = {
              defaults = {
                vimgrep_arguments = [
                  "rg"
                  "--color=never"
                  "--no-heading"
                  "--with-filename"
                  "--line-number"
                  "--column"
                  "--smart-case"
                  "--hidden"
                  "--glob"
                  "!**/.git/*"
                ];
                file_ignore_patterns = [
                  "^node_modules/"
                  "^%.git/"
                  "^%.direnv/"
                  "^%.devenv/"
                  "^target/"
                  "^dist/"
                  "^build/"
                  "^result/"
                  "%.lock$"
                ];
                sorting_strategy = "ascending";
                layout_config.prompt_position = "top";
                path_display = ["truncate"];
                dynamic_preview_title = false;
                results_title = false;
                cache_picker = false;
                preview = {
                  filesize_limit = 1;
                  timeout = 150;
                  treesitter = false;
                };
              };
              pickers = {
                find_files.find_command = [
                  "fd"
                  "--type"
                  "f"
                  "--hidden"
                  "--follow"
                  "--exclude"
                  ".git"
                  "--strip-cwd-prefix"
                ];
                buffers.ignore_current_buffer = true;
              };
              extensions.fzf = {
                fuzzy = true;
                override_generic_sorter = true;
                override_file_sorter = true;
                case_mode = "smart_case";
              };
            };
            extraConfig = ''
              pcall(vim.cmd.packadd, "telescope-fzf-native.nvim")
              pcall(require("telescope").load_extension, "fzf")
            '';
          };
        };
      };
      plugins = {
        "blink.cmp" = {
          package = pkgs.vimPlugins.blink-cmp;
          lazy = false;
          after.setup = {
            snippets.preset = "luasnip";
            keymap = {
              preset = "enter";
              "<Tab>" = [
                "select_and_accept"
                "snippet_forward"
                "fallback"
              ];
              "<S-Tab>" = [
                "snippet_backward"
                "fallback"
              ];
              "<CR>" = [
                "accept"
                "fallback"
              ];
            };
          };
        };
        "rachartier/tiny-inline-diagnostic.nvim".package = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
        "luasnip".package = pkgs.vimPlugins.luasnip;
        "mini.ai".package = pkgs.vimPlugins.mini-ai;
        "mini.icons" = {
          package = pkgs.vimPlugins.mini-icons;
          lazy = false;
          after.extraConfig = "MiniIcons.mock_nvim_web_devicons()";
        };
        "mini.jump".package = pkgs.vimPlugins.mini-jump;
        "mini.pairs".package = pkgs.vimPlugins.mini-pairs;
        "mini.surround".package = pkgs.vimPlugins.mini-surround;
        "mini.indentscope".package = pkgs.vimPlugins.mini-indentscope;
        "oil.nvim" = {
          package = pkgs.vimPlugins.oil-nvim;
          lazy = false;
          after.setup = null;
          after."oil".setup = {
            skip_confirm_for_simple_edits = true;
            float = {
              padding = 2;
              max_width = 0.8;
              max_height = 0.8;
            };
          };
          keys = [
            {
              key = "<leader>e";
              action = ":Oil .<cr>";
              mode = "n";
            }
          ];
        };
      };
      languages = {
        nixd = {
          cmd = "nixd";
          formatter_filetypes = "nix";
          formatters = "alejandra";
          treesitter = "nix";
          settings.nixd.nixpkgs.expr = "import <nixpkgs> { }";
        };

        pyright = {
          cmd = ["pyright-langserver" "--stdio"];
          filetypes = ["python"];
          root_markers = [
            "pyproject.toml"
            "setup.py"
            "setup.cfg"
            "requirements.txt"
            "Pipfile"
            "pyrightconfig.json"
            ".git"
          ];
          treesitter = "python";
        };

        ruff = {
          cmd = ["ruff" "server"];
          filetypes = ["python"];
          root_markers = ["pyproject.toml" "ruff.toml" ".ruff.toml" ".git"];
          formatters = ["ruff_fix" "ruff_format" "ruff_organize_imports"];
          extra_config = ''
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "ruff" then
                  client.server_capabilities.hoverProvider = false
                end
              end,
            })
          '';
        };

        bashls = {
          cmd = ["bash-language-server" "start"];
          packages = [
            pkgs.bash-language-server
            pkgs.shellcheck
            pkgs.shfmt
          ];
          filetypes = ["sh" "bash"];
          root_markers = [".git"];
          formatters = "shfmt";
          treesitter = "bash";
          settings.bashIde.shfmt.path = lib.getExe pkgs.shfmt;
        };

        jsonls = {
          cmd = ["vscode-json-language-server" "--stdio"];
          packages = pkgs.vscode-langservers-extracted;
          filetypes = ["json" "jsonc"];
          root_markers = [".git" "package.json"];
          # treesitter = "json";
          settings.json = {
            validate.enable = true;
            format.enable = false;
          };
        };

        yamlls = {
          cmd = ["yaml-language-server" "--stdio"];
          packages = pkgs.yaml-language-server;
          filetypes = ["yaml"];
          root_markers = [".git"];
          # treesitter = "yaml";
          settings.yaml = {
            schemaStore = {
              enable = true;
              url = "https://www.schemastore.org/api/json/catalog.json";
            };
            validate = true;
            format.enable = false;
            hover = true;
            completion = true;
          };
        };

        clangd = {
          cmd = ["clangd" "--background-index" "--clang-tidy" "--header-insertion=iwyu"];
          filetypes = ["c" "cpp"];
          root_markers = [
            ".clangd"
            ".clang-tidy"
            ".clang-format"
            "compile_commands.json"
            "compile_flags.txt"
            "CMakeLists.txt"
            "meson.build"
            ".git"
          ];
          formatters = "clang-format";
          treesitter = ["c" "cpp"];
          # packages = pkgs.clang-tools;
        };

        omnisharp = {
          treesitter = "c_sharp";
          # packages = pkgs.omnisharp-roslyn;
          settings.FormattingOptions.EnableEditorConfigSupport = true;
        };
        ts_ls = {
          cmd = ["typescript-language-server" "--stdio"];
          packages = pkgs.typescript-language-server;
          filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact"];
          root_markers = ["tsconfig.json" "jsconfig.json" "package.json" ".git"];
          settings = {
            typescript.inlayHints = {
              includeInlayParameterNameHints = "literals";
              includeInlayFunctionLikeReturnTypeHints = true;
            };
          };
        };
        html = {
          cmd = ["vscode-html-language-server" "--stdio"];
          packages = pkgs.vscode-langservers-extracted;
          filetypes = ["html"];
          root_markers = ["package.json" ".git"];
          init_options = {
            provideFormatter = false;
            embeddedLanguages = {
              css = true;
              javascript = true;
            };
          };
        };
        cssls = {
          cmd = ["vscode-css-language-server" "--stdio"];
          packages = pkgs.vscode-langservers-extracted;
          filetypes = ["css" "scss" "less"];
          root_markers = ["package.json" ".git"];
          settings = let
            # tailwind-директивы (@apply, @theme и т.д.) иначе подсвечиваются как ошибки
            lint.unknownAtRules = "ignore";
          in {
            css = {inherit lint;};
            scss = {inherit lint;};
            less = {inherit lint;};
          };
        };

        tailwindcss = {
          cmd = ["tailwindcss-language-server" "--stdio"];
          packages = pkgs.tailwindcss-language-server;
          filetypes = [
            "html"
            "css"
            "scss"
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
          root_markers = [
            "tailwind.config.js"
            "tailwind.config.ts"
            "tailwind.config.cjs"
            "postcss.config.js"
            "package.json"
            ".git"
          ];
        };

        emmet_language_server = {
          cmd = ["emmet-language-server" "--stdio"];
          packages = pkgs.emmet-language-server;
          filetypes = [
            "html"
            "css"
            "scss"
            "javascriptreact"
            "typescriptreact"
          ];
          root_markers = [".git"];
        };

        eslint = {
          cmd = ["vscode-eslint-language-server" "--stdio"];
          packages = pkgs.vscode-langservers-extracted;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
          root_markers = [
            "eslint.config.js"
            "eslint.config.mjs"
            "eslint.config.ts"
            ".eslintrc.json"
            ".eslintrc.js"
            "package.json"
          ];
          settings = {
            workingDirectory.mode = "auto";
            format = false;
          };
          extra_config = ''
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "eslint" then
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = args.buf,
                    callback = function()
                      pcall(vim.cmd, "LspEslintFixAll")
                    end,
                  })
                end
              end,
            })
          '';
        };

        web_formatting = {
          lsp = false;
          packages = pkgs.prettierd;
          formatters = "prettierd";
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
            "html"
            "css"
            "scss"
            "less"
            "json"
            "jsonc"
            "yaml"
            "markdown"
          ];
          treesitter = [
            "javascript"
            "typescript"
            "tsx"
            "html"
            "css"
            "scss"
            "json"
            "markdown"
            "markdown_inline"
          ];
        };
      };
    };
  };
}
