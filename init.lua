require("santiago.remap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.opt.guicursor = ""

        vim.opt.nu = true
        vim.opt.relativenumber = true

        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true

        vim.opt.smartindent = true

        vim.opt.wrap = false

        vim.opt.termguicolors = true

        vim.opt.scrolloff = 8
        vim.opt.signcolumn = "yes"
        vim.opt.isfname:append("@-@")

        vim.opt.updatetime = 50

        vim.opt.colorcolumn = "80"
    end
})

-- Define a function to set up key mappings on LSP attach
local function on_lsp_attach(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }

    local keymap = vim.keymap.set
    local buf = vim.lsp.buf
    local diagnostic = vim.diagnostic

    keymap("n", "gd", buf.definition, opts)
    keymap("n", "K", buf.hover, opts)
    keymap("n", "<leader>vws", buf.workspace_symbol, opts)
    keymap("n", "<leader>vd", diagnostic.open_float, opts)
    keymap("n", "[d", diagnostic.goto_next, opts)
    keymap("n", "<leader>vrr", buf.references, opts)
    keymap("n", "<leader>vrn", buf.rename, opts)
    keymap("i", "<C-h>", buf.signature_help, opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = ev.buf,
            callback = function()
                vim.lsp.buf.format()
            end
        })
    end

    if client.supports_method("textDocumnet/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

    if client.name == "rust_analyzer" then
        keymap("n", "<leader>vca", function() vim.cmd.RustLsp("codeAction") end, opts)
        keymap("n", "[e", function() vim.cmd.RustLsp("explainError") end, opts)
        keymap("n", "]d", function() vim.cmd.RustLsp("renderDiagnostic") end, opts)
    else
        keymap("n", "<leader>vca", buf.code_action, opts)
    end
end

-- Define a function to clean up on LSP detach
local function on_lsp_detach(ev)
    -- Optionally clear key mappings set during attach
    local opts = { buffer = ev.buf }

    local keymap = vim.keymap.del

    keymap("n", "gd", opts)
    keymap("n", "K", opts)
    keymap("n", "<leader>vws", opts)
    keymap("n", "<leader>vd", opts)
    keymap("n", "[d", opts)
    keymap("n", "]d", opts)
    keymap("n", "<leader>vca", opts)
    keymap("n", "<leader>vrr", opts)
    keymap("n", "<leader>vrn", opts)
    keymap("i", "<C-h>", opts)

    -- Other cleanup tasks can be added here if necessary
end

-- Create autocmd group and autocmds
local lsp_group = vim.api.nvim_create_augroup('UserLspConfig', {})
vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_group,
    callback = on_lsp_attach,
})
--vim.api.nvim_create_autocmd('LspDetach', {
--    group = lsp_group,
--    callback = on_lsp_detach,
--})
