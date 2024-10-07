return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local servers = { "lua_ls", "tsserver", "astro", "pyright", "gopls", "jsonls", "eslint", "rust_analyzer" }
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities
            })
        end

        lspconfig.pyright.setup({
            on_new_configs = function(new_config)
                local custom_config = require("santiago.lspconfig")
                local python_path = custom_config.get_python_path()
                if python_path then
                    new_config.settings.python.pythonPath = python_path
                end
            end
        })

        lspconfig.gopls.setup({
            settings = {
                gopls = {
                    hints = {
                        assigVariableTypes = true,
                        constantValues = true,
                        rangeVariableTypes = true
                    }
                }
            }
        })
    end
}
