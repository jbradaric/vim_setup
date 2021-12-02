local api = vim.api
local json = require 'json'

local function read_compile_commands(buf)
  local f = io.open(api.nvim_buf_get_var(buf, 'compile_commands_path'), 'rb')
  if f == nil then
    return nil
  end
  local contents = f:read '*a'
  f:close()
  return json.decode(contents)
end

local function init_ale()
  local buf = api.nvim_get_current_buf()
  if pcall(api.nvim_buf_get_var, buf, 'ale_cpp_clang_options') or
    pcall(api.nvim_buf_get_var, buf, 'ale_c_clang_options') then
    return
  end
  if not pcall(api.nvim_buf_get_var, buf, 'compile_commands_path') then
    local project_root = vim.fn.FindRootDirectory()
    if project_root == '' then
      return
    end
    local path = project_root .. '/compile_commands.json'
    api.nvim_buf_set_var(buf, 'compile_commands_path', path)
  end

  if not vim.fn.filereadable(api.nvim_buf_get_var(buf, 'compile_commands_path')) then
    return
  end

  local t = read_compile_commands(buf)
  if t == nil then
    return
  end
  local buf_name = api.nvim_buf_get_name(buf)
  for _, v in pairs(t) do
    if (v['directory'] .. '/' .. v['file']) == buf_name then
      local arr = {}
      local skip_count = 1
      for _, arg in pairs(v['arguments']) do
        if skip_count > 0 then
          skip_count = skip_count - 1
          goto continue
        end
        if arg == v['file'] then
          goto continue
        end
        if arg == v['file']:sub(v['directory']:len() + 2) then
          goto continue
        end
        if arg == '-c' then
          goto continue
        end
        if arg == '-o' then
          skip_count = 1
          goto continue
        end
        table.insert(arr, arg)
        ::continue::
      end
      table.insert(arr, '-Wno-tautological-constant-out-of-range-compare')
      table.insert(arr, '-Wno-unsupported-friend')
      local options = table.concat(arr, ' ')
      if api.nvim_buf_get_option(buf, 'filetype') == 'c' then
        api.nvim_buf_set_var(buf, 'ale_c_clang_options', options)
      else
        api.nvim_buf_set_var(buf, 'ale_cpp_clang_options', options)
      end
    end
  end
end

local nvim_lsp = require 'lspconfig'

local function setup_lsp()
  local function on_attach(client, bufnr)

    api.nvim_command('setlocal signcolumn=yes:1')
    api.nvim_buf_set_var(bufnr, 'show_signs', true)

    local opts = { noremap = true, silent = true }
    api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    api.nvim_buf_set_keymap(bufnr, 'x', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Sort diagnostics by severity
      severity_sort = true,
    }
  )

  nvim_lsp.ccls.setup{
    on_attach=on_attach,
    settings = {
      completion = {
        enableSnippetInsertion = false,
      },
    },
  }

  nvim_lsp.rls.setup{
    on_attach=on_attach,
  }

  nvim_lsp.jedi_language_server.setup{
    on_attach=on_attach,
    cmd = {
      "/home/jurica/.virtualenvs/local-py3.9/bin/python",
      "/home/jurica/.virtualenvs/local-py3.9/bin/jedi-language-server",
    },
    init_options = {
      jediSettings = {
        autoImportModules = {"act", "age", "gtk", "gio", "glib", "gobject", "numpy"},
      },
      completion = {
        disableSnippets = true,
      },
      diagnostics = {
        enable = false,
      },
      workspace = {
        extraPaths = {"/home/jurica/src/local/act-py3/src/python", "/home/jurica/src/stfw/src"},
        symbols = {
          ignoreFolders = {"doc", "__pycache__", ".ccls-cache", ".mypy_cache", ".pytest_cache"},
        }
      }
    }
  }

  nvim_lsp.diagnosticls.setup{
    filetypes = {"python"},
    init_options = {
      linters = {
        flake8 = {
          command = "flake8",
          debounce = 100,
          args = { "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s", "-" },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = "flake8",
          formatLines = 1,
          formatPattern = {
            "(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
            {
              line = 1,
              column = 2,
              security = 3,
              message = 4
            }
          },
          securities = {
            W = "info",
            E = "warning",
            F = "error",
            C = "info",
            N = "hint"
          }
        }
      },
      filetypes = {
        python = "flake8",
      }
    }
  }

  -- nvim_lsp.rust_analyzer.setup {
  --   on_attach=on_attach,
  -- }

end

local function setup_treesitter()
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
      use_languagetree = true,
      disable = { "cpp" },
    },
    refactor = {
      highlight_definitions = { enable = false },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition_lsp_fallback = '<C-]>',
          list_definitions = "gnD",
          list_definitions_toc = "gO",
        },
      },
    },
    textobjects = {
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ["gdf"] = "@function.outer",
          ["gdF"] = "@class.outer",
        },
      },
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ib"] = "@block.inner",
          ["ab"] = "@block.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  }
end

local function setup_nvim_compe()
  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    allow_prefix_unmatch = false;

    source = {
      path = true;
      buffer = true;
      calc = true;
      vsnip = true;
      nvim_lsp = true;
      nvim_lua = false;
      spell = false;
      tags = false;
      snippets_nvim = false;
    }
  };
end

-- local function setup_lsp_icons()
--   require('lspkind').init({
--     with_text = true,
--     symbol_map = {
--       Function = '',
--       Method = '',
--       Class = '',
--       Constructor = '襁',
--       Constant = '',
--       Module = '亮',
--       Keyword = 'ﱃ',
--       Variable = '勇',
--       File = '',
--       Folder = '',
--       Struct = 'פּ',
--     },
--   })
-- end

local function setup_lsp_icons()
  require('lspkind').init({
    with_text = false,
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
  })
end

function setup_neogit()
  local neogit = require('neogit')
  neogit.setup({
    disable_commit_confirmation = true,
    sections = {
      stashes = false,
    },
  })
end

return {
  init_ale = init_ale,
  setup_lsp = setup_lsp,
  setup_treesitter = setup_treesitter,
  setup_nvim_compe = setup_nvim_compe,
  setup_lsp_icons = setup_lsp_icons,
  setup_neogit = setup_neogit,
}
