require("opts")
require("keymap")
require("lz.n").load("plugins")
local ok, matugen = pcall(require, "matugen")
if ok then
  matugen.setup()
end
