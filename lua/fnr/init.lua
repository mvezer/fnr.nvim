local ui = require("fnr.ui")

local M = {}

M.findBox = {}
M.replaceBox = {}
M.resultsBox = {}

M.layout = {}
function M.replaceInFiles()
  ui.open()
end

function M.hide()
  ui.close()
end

return M

