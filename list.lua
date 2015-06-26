#!/usr/bin/env lua

--[[

Copyright © 2015 Jon Allen <ylixir@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

]]--

--[[
this package implements a word list object
each word list is inherited from this generic word list
]]--

local object = require 'object'
local protodice = require 'dice'

local P = object:new() --package
if nil == _REQUIREDNAME then
  list = P
else
  _G[_REQUIREDNAME] = P
end


P.dice = protodice:new()
P.words = {}
P.loaded = false --whether this list has been loaded from the disk

--[[ each list needs it's own set of dice ]]--
function P:new()
  local o = self.parent.new(self)
  o.dice = protodice:new()
  return o
end

function P:load(filename)
  self.words = {} --replace any list loaded, don't append more words
  for l in io.lines(filename) do
    table.insert(self.words, l)
  end
  self.dice.sides = #self.words
  self.dice.throws = 1
  self.loaded = true
end

return P