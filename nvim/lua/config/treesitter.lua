local link_highlight = require('config.utils').link_highlight

local M = {}

local function setup_highlights()
  link_highlight('TSFuncBuiltin', 'Function')
  link_highlight('TSConstBuiltin', 'MyConstant')
  link_highlight('TSBoolean', 'MyConstant')
  link_highlight('TSOperator', 'MyConstant')
  link_highlight('TSInclude', 'MyConditional')
  link_highlight('TSConditional', 'TSInclude')
  link_highlight('TSRepeat', 'TSInclude')
  link_highlight('TSParameter', 'FunctionParameter')

  require('paint').setup({
    highlights = {
      {
        filter = { filetype = 'python' },
        pattern = '%s*#[^@]*(@%w+)',
        hl = 'Constant',
      },
      {
        filter = { filetype = 'python' },
        pattern = '%s*#.*(TODO)',
        hl = 'Constant',
      },
      {
        filter = { filetype = 'python' },
        pattern = '%s*#.*(XXX)',
        hl = 'Constant',
      },
      {
        filter = { filetype = 'python' },
        pattern = '%s*#.*(NOTE)',
        hl = 'Constant',
      },
      {
        filter = { filetype = 'lua' },
        pattern = '%s*%-%-%-%s*(@%w+)',
        hl = 'Constant',
      },
    }
  })
end

local function setup_utils()
  vim.cmd([[
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
  ]])
end

local function setup_context()
  require('treesitter-context').setup({
    max_lines = 3,
  })
end

M.setup = function()
  local tm_fts = { 'python' }

  require('nvim-treesitter.configs').setup {
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
    yati = {
      enable = true,
      default_lazy = true,
      default_fallback = function(lnum, computed, bufnr)
        if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
          return require('tmindent').get_indent(lnum, bufnr) + computed
        end
        return require('nvim-yati.fallback').vim_auto(lnum, computed, bufnr)
      end,
    },
    indent = {
      enable = false,
    },
  }

  setup_highlights()
  setup_utils()
  -- setup_context()
end

return M
