local home = os.getenv("HOME")
local brew = vim.fn.trim(vim.fn.system(["brew --prefix"]))
local eclipse_path = home .. "/.local/share/eclipse/"

-- File types that signify a Java project's root directory. This will be
-- -- used by eclipse to determine what constitutes a workspace
local root_markers = {'gradlew', 'mvnw', '.git'}
local root_dir = require('jdtls.setup').find_root(root_markers)

local workspace_folder = eclipse_path .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local google_stype = eclipse_path .. "eclipse-java-google-style.xml"

local base_path = home .. ".java/amazon-correto-%s.jdk"
local java_21_path = string.format(base_path, "21")
local java_17_path = string.format(base_path, "17")

local config = {
    flags = {
        debounce_text_changes = 80,
    },
    root_dir = root_dir,
    settings = {
        java = {
            format = {
                settings = {
                    url = google_stype,
                    profile = "GoogleStyle",
                },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*"
                }
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                }
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = java_21_path,
                    },
                    {
                        name = "JavaSE-17",
                        path = java_17_path,
                    },
                }
            }
    },
    },
    cmd = {
        java_17_path .. "/Contents/Home/bin/java",
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        'add-opens', 'java.base/java.util=ALL-UNNAMED',
        'add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob(brew .. '/Cellar/jdtls/1.40.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', brew .. 'Cellar/jdtls/1.40.0/libexec/config_mac',
        '-data', workspace_folder,
    }
}

require('jdtls').start_or_attach(config)
