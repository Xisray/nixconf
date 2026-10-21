return {
    "mini.icons",
    lazy = false,
    after = function()
        require("mini.icons").setup()
        MiniIcons.mock_nvim_web_devicons()
    end,
}
