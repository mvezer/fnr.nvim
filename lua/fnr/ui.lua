local Layout = require("nui.layout")
local Popup = require("nui.popup")

local M = {}
M._boxes = {}
M._focused_box_index = 1
M.close = nil
M.open = nil

M._focused_box = function()
  return M._boxes[M._focused_box_index]
end

M._register = function(base_box)
  if base_box.win_config.focusable or true then
    table.insert(M._boxes, base_box)
  end
end

M._focus_next = function()
  M._focused_box_index = M._focused_box_index + 1
  if M._focused_box_index > #M._boxes then
    M._focused_box_index = 1
  end
  M._focused_box():focus()
end

M._focus_prev = function()
  M._focused_box_index = M._focused_box_index - 1
  if M._focused_box_index < 1 then
    M._focused_box_index = #M._boxes
  end
  M._focused_box():focus()
end

local BaseBox = Popup:extend("BaseBox")
function BaseBox:init(popup_options)
  local options = vim.tbl_deep_extend("force", popup_options or {}, {
    focusable = true,
    border = {
      style = "double",
      text = {
        top = "",
        top_align = "center"
      },
      buf_options = {
        modifiable = true,
        readonly = false,
      }
    }
  })

  BaseBox.super.init(self, options)
  M._register(self)
end

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

M.initLayout = function()
  return Layout(
    {
      position = "50%",
      size = {
        width = "80%",
        height = "80%"
      }
    },
    Layout.Box({
      Layout.Box(M.FindBox(), { size = "20%" }),
      Layout.Box(M.ReplaceBox(), { size = "20%" }),
      Layout.Box(M.ResultsBox(), { size = "60%" })
    }, { dir = "col" })
  )
end

M.open = function()
  M._boxes = {}
  M._focused_box_index = 1
  M._layout = M.initLayout()
  M._layout:mount()
  for _, box in ipairs(M._boxes) do
    box:map("n", "<Tab>", M._focus_next)
    box:map("n", "<S-Tab>", M._focus_prev)
    box:map("n", { "q", "<Esc>" }, M.close)
  end
end

M.close = function()
  for _, box in ipairs(M._boxes) do
    box:unmap("n", "<Tab>")
    box:unmap("n", "<S-Tab>")
    box:unmap("n",{ "q", "<Esc>" })
  end
  M._layout:unmount()
  M._layout = nil
end


return M
