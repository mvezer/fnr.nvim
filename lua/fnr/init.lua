local Layout = require("nui.layout")
local ui = require("fnr.ui")

local M = {}

M.findBox = {}
M.replaceBox = {}
M.resultsBox = {}

M.layout = {}
function M.replaceInFiles()
  M.findBox = ui.FindBox()
  M.replaceBox = ui.ReplaceBox()
  M.resultsBox = ui.ResultsBox()

  M.layout = Layout(
    {
      position = "50%",
      size = {
        width = "80%",
        height = "80%"
      }
    },
    Layout.Box({
      Layout.Box(M.findBox, { size = "20%" }),
      Layout.Box(M.replaceBox, { size = "20%" }),
      Layout.Box(M.resultsBox, { size = "60%" })
    }, { dir = "col" })
  )

  M.layout:mount()
  print(M.findBox.bufnr)
end

function M.hide()
  M.layout:unmount()
end

return M

