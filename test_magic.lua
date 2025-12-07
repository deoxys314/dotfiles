local magic = require 'magic'
local pp = require'pprint'.print

local v = magic.cycle{12, 15}
    :take(8)

pp(tostring(v))
pp(v:collect())
