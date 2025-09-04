-- Display symlink target in status bar if the hovered file is a symlink
Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return " -> " .. tostring(h.link_to)
  else
    return ""
  end
end, 3300, Status.LEFT)

-- Display user@host in header on Unix systems
Header:children_add(function()
  if ya.target_family() ~= "unix" then
    return ""
  end
  return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg "blue"
end, 500, Header.LEFT)

