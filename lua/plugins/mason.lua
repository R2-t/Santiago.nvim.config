return {
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local masonLspconfig = require("mason-lspconfig")
            masonLspconfig.setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "astro", "pyright", "gopls", "jsonls", "eslint" }
            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            local masonNvimDap = require("mason-nvim-dap")
            masonNvimDap.setup({
                ensure_installed = { "delve" }
            })
        end
    },
}
