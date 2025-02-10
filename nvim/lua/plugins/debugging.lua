return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            {
                "microsoft/vscode-js-debug",
                version = "1.x",
                build = "npm i && npm run compile dapDebugServer"
            }
        },
        "theHamsta/nvim-dap-virtual-text"
    },
    config = function()
        local dap = require("dap")
        local ui = require("dapui")
        local virtual_text = require("nvim-dap-virtual-text")

        -- Open UI automatically (if everything initialized correctly)
        dap.listeners.before.launch.dapui_config = function() ui.open() end

        --- LLDB-DAP (C++ and Rust) ---
        dap.adapters.lldb = {
            type = "executable",
            command = "/usr/bin/lldb-dap",
            name = "lldb"
        }

        dap.configurations.cpp = {
            {
                name = "Debug - Compile Automatically",
                type = "lldb",
                request = "launch",
                program = function()
                    local notify = require("mini.notify").make_notify({ ERORR = { duration = 2000 }, INFO = { duration = 2000 } })
                    local source = vim.fn.expand("%:p")
                    local output = vim.fn.expand("%:r")
                    local cmd = string.format("g++ -std=c++20 -g %s -o %s", source, output)
                    notify("Compiling with: " .. cmd, vim.log.levels.INFO)

                    local ret = os.execute(cmd)
                    if ret ~= 0 then
                        notify("Compilation failed", vim.log.levels.ERROR)
                        return dap.ABORT
                    end

                    return output
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {}
            },
            {
                name = "Debug - Manually Select",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {}
            }
        }

        dap.configurations.rust = {
            {
                name = "Debug - Compile Automatically",
                type = "lldb",
                request = "launch",
                program = function()
                    local notify = require("mini.notify").make_notify({ ERROR = { duration = 2000 }, INFO = { duration = 2000 } })
                    -- Cargo build (with debug by default)
                    local cmd = "cargo build -q"
                    notify("Compiling with: " .. cmd, vim.log.levels.INFO)

                    local ret = os.execute(cmd)
                    if ret ~= 0 then
                        notify("Compilation failed")
                        return dap.ABORT
                    end

                    -- Extract the name from Cargo.toml
                    local cargo_toml = io.open("Cargo.toml", "r")
                    if not cargo_toml then
                        notify("Could not locate Cargo.toml file", vim.log.levels.ERROR)
                        return dap.ABORT
                    end

                    local package_name = nil
                    for line in cargo_toml:lines() do
                        local match = line:match('^name%s*=%s*"(.-)"')
                        if match then
                            package_name = match
                            break
                        end
                    end
                    cargo_toml:close()

                    if not package_name then
                        notify("Package name not found in Cargo.toml", vim.log.levels.ERROR)
                        return dap.ABORT
                    end

                    local executable = "target/debug/" .. package_name
                    return executable
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                initCommands = function()
                    -- Find out where to look for the pretty printer Python module
                    local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

                    local script_import = 'command script import "' ..
                        rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                    local commands = {}
                    local file = io.open(commands_file, "r")
                    if file then
                        for line in file:lines() do
                            table.insert(commands, line)
                        end
                        file:close()
                    end
                    table.insert(commands, 1, script_import)

                    return commands
                end
            },
            {
                name = "Debug - Manually Select",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                initCommands = function()
                    -- Find out where to look for the pretty printer Python module
                    local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

                    local script_import = 'command script import "' ..
                        rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                    local commands = {}
                    local file = io.open(commands_file, "r")
                    if file then
                        for line in file:lines() do
                            table.insert(commands, line)
                        end
                        file:close()
                    end
                    table.insert(commands, 1, script_import)

                    return commands
                end
            }
        }

        --- NETCOREDBG (C#) ---
        dap.adapters.coreclr = {
            type = "executable",
            command = "/usr/bin/netcoredbg",
            args = { "--interpreter=vscode" }
        }

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Launch",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/debug", "file")
                end
            }
        }

        --- JS-DEBUG (JavaScript) ---
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = { vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js", "${port}" }
            }
        }

        for _, lang in ipairs({ "javascript", "typescript", "svelte" }) do
            dap.configurations[lang] = {
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach to Vite Dev server",
                    sourceMaps = true,
                    resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
                    cwd = "${workspaceFolder}/src",
                    skipFiles = { "${workspaceFolder}/node_modules/**/*.js" }
                }
            }
        end

        --- DEBUGPY (Python) ---
        dap.adapters.python = function(cb, config)
            if config.request == "attach" then
                ---@diagnostic disable-next-line: undefined-field
                local port = (config.connect or config).port
                ---@diagnostic disable-next-line: undefined-field
                local host = (config.connect or config).host or "127.0.0.1"
                cb({
                    type = "server",
                    port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                    host = host,
                    options = {
                        source_filetype = "python",
                    },
                })
            else
                cb({
                    type = "executable",
                    command = "/home/ashley/.virtualenvs/debugpy/bin/python",
                    args = { "-m", "debugpy.adapter" },
                    options = {
                        source_filetype = "python",
                    },
                })
            end
        end

        dap.configurations.python = {
            {
                -- The first three options are required by nvim-dap
                type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = "launch",
                name = "Launch file",

                -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                program = "${file}", -- This configuration will launch the current file if used.
                pythonPath = function()
                    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                        return cwd .. "/venv/bin/python"
                    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                        return cwd .. "/.venv/bin/python"
                    else
                        return "/usr/bin/python"
                    end
                end
            }
        }

        --- Godot (gdscript) ---
        dap.adapters.godot = {
            type = "server",
            host = "127.0.0.1",
            port = "6006"
        }

        dap.configurations.gdscript = {
            {
                type = "godot",
                request = "launch",
                name = "Launch scene",
                project = "${workspaceFolder}"
            }
        }

        vim.keymap.set("n", "<space>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#cdd6f4", bg = "#45475a" })
        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "DapBreakpoint" })

        ---@diagnostic disable-next-line: missing-fields
        ui.setup({
            controls = {
                enabled = false
            },
            layouts = {
                {
                    elements = {
                        {
                            id = "repl",
                            size = 0.25
                        },
                        {
                            id = "stacks",
                            size = 0.25
                        },
                        {
                            id = "breakpoints",
                            size = 0.25
                        },
                        {
                            id = "scopes",
                            size = 0.25
                        }
                    },
                    position = "left",
                    size = 40
                },
                {
                    elements = {
                        {
                            id = "console",
                            size = 1
                        }
                    },
                    position = "bottom",
                    size = 10
                }
            }
        })
        ---@diagnostic disable-next-line: missing-parameter
        virtual_text.setup()
    end
}
