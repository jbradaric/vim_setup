local M = {}

M.setup = function()
  local notify = require('notify')
  notify.setup({ stages = 'static', timeout = 1000 })
  vim.notify = notify
end

return M
