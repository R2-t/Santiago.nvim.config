local M = {}

local function get_pipenv_venv_path()
    local pipenv_venv = vim.fn.trim(vim.fn.system("pipenv --venv"))
    if pipenv_venv == "" then
        return nil
    end
    local split = vim.split(pipenv_venv, "\n")
    for _, line in ipairs(split) do
        if string.match(line, "^/") ~= nil and vim.fn.isdirectory(line) then
                return line
        end
    end

    return nil
end

function M.get_python_path() 
    local venv_path = get_pipenv_venv_path()
    if venv_path then
        local python_bin = venv_path .. "/bin/python"
        return python_bin
    else
        return vim.fn.trim(vim.fn.system("python -c 'import sys; print(sys.executable)'"))
    end
end

return M
