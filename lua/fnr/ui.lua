local UI = {}

UI.LEFT = "left"
UI.RIGHT = "right"
UI.CENTER = "center"
UI.TOP = "top"
UI.BOTTOM = "bottom"

UI.parent_window = nil
UI.parent_window_props = {
  width = 0,
  height = 0
}

local Box = {}

Box.new = function(col, row, width, height)
  local self = {}

  local function create_buffer()
    return vim.api.nvim_create_buf(false, true)
  end

  local function create_window(buffer)
    return vim.api.nvim_open_win(buffer, true, {
      relative = 'win',
      width = width,
      height = height,
      col = col,
      row = row,
      border = "rounded"
    })
  end

  self.buffer = create_buffer()
  self.window = create_window(self.buffer)
  vim.api.nvim_buf_set_lines(self.buffer, 0, 0, false, { "fuck yea" })

  return self
end

UI.get_x = function (width, align, parent_window_props)
  assert(align == UI.LEFT or align == UI.RIGHT or align == UI.CENTER, "align is not a valid alignment!")
  if width >= parent_window_props.width or align == UI.LEFT then
    return 0
  end
  if align == UI.RIGHT then
    return parent_window_props.width - width
  end

  return math.floor((parent_window_props.width - width) / 2)
end

UI.open_floating_window = function(width, height, h_align, v_align)
  UI.parent_window = vim.api.nvim_get_current_win()
  UI.parent_window_props = {
    width = vim.api.nvim_win_get_width(UI.parent_window),
    height = vim.api.nvim_win_get_height(UI.parent_window)
  }
  local box = Box.new(
    UI.get_x(width, h_align or UI.LEFT, UI.parent_window_props), 10, width, height
  )
end

UI.open_floating_window(80, 6, UI.CENTER)

return UI

