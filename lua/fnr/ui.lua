local Popup = require("nui.popup")

local M = {}

local BaseBox = Popup:extend("BaseBox")
function BaseBox:init (popup_options)
  local options = vim.tbl_deep_extend("force", popup_options or {}, {
    border = {
      style = "single",
      text = {
        top = "",
        top_align = "center"
      },
      buf_options = {
        modifiable = true,
        readonly = false,
      },
    }
  })

  BaseBox.super.init(self, options)
end

local findBox = Popup({
  enter = true,
})

M.FindBox = BaseBox:extend("FindBox")
function M.FindBox:init()
  M.FindBox.super.init(self, {
    enter = true,
    text = { top = "Find" }
  })
end


M.ReplaceBox = BaseBox:extend("ReplaceBox")
function M.ReplaceBox:init()
  M.ReplaceBox.super.init(self, {
    text = { top = "Replace" }
  })
end


M.ResultsBox = BaseBox:extend("ResultsBox")
function M.ResultsBox:init()
  M.ResultsBox.super.init(self, {
    text = { top = "Results" }
  })
end

return M
