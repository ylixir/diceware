#!/usr/bin/env lua

--[[

Copyright © 2015 Jon Allen <ylixir@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

]]--

--[[
this package implements a base object
just a simple thing to allow inheritance
]]--

local P = {} --package
if nil == _REQUIREDNAME then
  object = P
else
  _G[_REQUIREDNAME] = P
end

function P:new()
  local o = {}
  for k,v in pairs(self) do o[k] = v end
  setmetatable(o,self)
  self.__index = self
  
  o.parent = self
  return o
end

return P