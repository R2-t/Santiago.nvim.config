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
                ensure_installed = { "lua_ls", "rust_analyzer", "tsserver" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local servers = { "lua_ls", "rust_analyzer", "tsserver" }
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities
                })
            end
        end
    }
}
