vim.filetype.add({
  extension = {
    h = function(_path, _bufnr)
      if vim.fn.search('\\C^#include <[^>.]\\+>$', 'nw') >= 1 then
        return 'cpp'
      end
      return 'c'
    end,
  },
  proj = 'zip',
  elem = 'zip',
  icons = 'zip',
  debug = 'zip',
  datapool = 'zip',
})
