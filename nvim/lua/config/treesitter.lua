local M = {}

local function setup_highlights()
  vim.api.nvim_command('hi link TSFuncBuiltin Function')
  vim.api.nvim_command('hi link TSConstBuiltin MyConstant')
  vim.api.nvim_command('hi link TSBoolean MyConstant')
  vim.api.nvim_command('hi link TSOperator MyConstant')
  vim.api.nvim_command('hi link TSInclude MyConditional')
  vim.api.nvim_command('hi link TSConditional TSInclude')
  vim.api.nvim_command('hi link TSRepeat TSInclude')
  vim.api.nvim_command('hi link TSParameter FunctionParameter')
end

local function setup_utils()
  vim.cmd([[
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
  ]])
end

M.setup = function()
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

  setup_highlights()
  setup_utils()
end

return M
