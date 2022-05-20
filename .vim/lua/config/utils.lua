local nvim_lsp = require 'lspconfig'
local nvim_lsp_status = require 'lsp-status'

local M = {}

M.setup_lsp = function()

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities = vim.tbl_extend('keep', capabilities or {}, nvim_lsp_status.capabilities)
    
  local function on_attach(client, bufnr)

    vim.api.nvim_command('setlocal signcolumn=yes:1')
    vim.api.nvim_buf_set_var(bufnr, 'show_signs', true)

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

    nvim_lsp_status.on_attach(client)

    if client.server_capabilities.document_symbol then
      vim.cmd([[augroup lsp_status]])
      vim.cmd([[  autocmd CursorHold,BufEnter <buffer> lua require('lsp-status').update_current_function()]])
      vim.cmd([[augroup END]])
    end
  end

  vim.diagnostic.config({severity_sort = true})

  nvim_lsp.ccls.setup{
    capabilities=capabilities,
    on_attach=on_attach,
    init_options = {
      compilationDatabaseDirectory = 'build',
      completion = {
        enableSnippetInsertion = false,
      },
    },
  }

  nvim_lsp.rls.setup{
    capabilities=capabilities,
    on_attach=on_attach,
  }

  nvim_lsp.jedi_language_server.setup{
    capabilities=capabilities,
    on_attach=on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    cmd = {
      "/home/jurica/.virtualenvs/local-py3.9/bin/python",
      "/home/jurica/.virtualenvs/local-py3.9/bin/jedi-language-server",
    },
    init_options = {
      -- jediSettings = {
      --   autoImportModules = {"act", "age", "gtk", "gio", "glib", "gobject", "numpy"},
      -- },
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
    capabilities=capabilities,
    filetypes = {"python"},
    init_options = {
      linters = {
        flake8 = {
          command = "flake8",
          debounce = 100,
          args = {
            "--append-config",
            "/home/jurica/.config/flake8",
            "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s",
            "-"
          },
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

M.setup_treesitter = function()
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

M.setup_nvim_compe = function()
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

M.setup_lsp_icons = function()
  require('lspkind').init({
    -- with_text = false,
    mode = 'symbol_text',
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

M.setup_neogit = function()
  local neogit = require('neogit')
  neogit.setup({
    disable_commit_confirmation = true,
    sections = {
      stashes = false,
    },
  })
end

return M
