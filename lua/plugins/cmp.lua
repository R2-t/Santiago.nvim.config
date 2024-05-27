return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {"hrsh7th/cmp-nvim-lsp", after="nvim-cmp"},
            {"hrsh7th/cmp-buffer", after="nvim-cmp"},
            {"hrsh7th/cmp-path", after="nvim-cmp"},
            {"hrsh7th/cmp-cmdline", after="nvim-cmp"},
            {
                "L3MON4D3/LuaSnip",
                after = "nvim-cmp"
            },
            {"saadparwaiz1/cmp_luasnip", after = "LuaSnip"}
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" }
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-y>"] = cmp.mapping.confirm({select=true}),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
            })

            cmp.setup.cmdline("/", {
                sources = {
                    { name = "buffer" }
                }
            })

            cmp.setup.cmdline(":", {
                sources = cmp.config.sources({
                    { name = "buffer" }
                }, {
                    { name = "cmdline" }
                }
                )
            })
        end
    }
}
