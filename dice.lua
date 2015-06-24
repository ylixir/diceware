#!/usr/bin/env lua

--[[

Copyright © 2015 Jon Allen <ylixir@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

]]--

--[[
this package implements a dice object
just what you think it is
]]--

local object = require 'object'

local P = object:new() --package
if nil == _REQUIREDNAME then
  dice = P
else
  _G[_REQUIREDNAME] = P
end

--[[
we can't do anything without some entropy

please note that this function will block if there is not enough entropy

if the program locks up, just wiggle the mouse or surf the internet or
something until it has enough randomness to move on
]]--
local function get_random_byte()
  local frand=assert(io.open('/dev/random','rb'))
  local r = frand:read(1):byte(1)
  frand:close()
  return r
end

--default to a normal six sided die
P.sides  = 6
P.throws = 1

function P:roll()
  --r is the random number we are making
  local r         = 0
  --max_roll is the biggest number we can roll
  local max_roll  = self.sides^self.throws
  --bytes is the number of bytes required to store our roll
  local bytes     = math.ceil(math.log(max_roll,256))
  --bits is the number of bits required to store our roll
  local bits      = math.ceil(math.log(max_roll,2))
  
  for i=1,bytes do
    --put each byte in it's proper place in the number
    --this is like how 256=2*10^2+5*10^1+6*10^0
    r = r + get_random_byte()*256^(i-1)
  end
  
  --[[
  We assume that all digits have equal entropy, so arbitrarily
  removing digits will not affect the quality of our random numbers.
  
  Trim off extra bits and add one to map r from [0,2^bytes) to [1,2^bits]
  ]]--
  r = bit32.extract(r,0,bits-1) + 1
  
  --[[
  Mapping from [1,2^bits] to [1,max_roll] with multiplication could cause
  certain integers to be more likely. All numbers have equal probability, so
  tossing bad numbers should not affect the quality of our randomness. Instead
  of complicating the logic of the function, we will just recurse if we fail to
  get a number in range.
  ]]--
  if r > max_roll then
    return self:roll() --try again
  else
    return r --yay we win
  end
end

return P