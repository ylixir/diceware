#!/usr/bin/env lua

--[[

Copyright © 2015 Jon Allen <ylixir@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

]]--

--[[ This file downloads and formats the word lists ]]--

local function get_line_iterator(skip_lines,get_lines)
  local i = 0
  
  return function(file)
    return function()
      while i<skip_lines do
        file:read('*l')
        i=i+1
      end
      
      if i<get_lines+skip_lines then
        i=i+1
        return file:read('*l')
      else
        return nil
      end
    end
  end
end

local diceware_server = 'http://world.std.com/~reinhold/'
local diceware_files =
{
  beale =
  {
    file = 'beale.wordlist.asc',
    server = diceware_server,
    line_iter = get_line_iterator(2,6^5),
    line_filter = function(s) return s:sub(7) end
  },
  diceware =
  {
    file = 'diceware.wordlist.asc',
    server = diceware_server,
    line_iter = get_line_iterator(2,6^5),
    line_filter = function(s) return s:sub(7) end
  },
  diceware8k =
  {
    file = 'diceware8k.txt',
    server = diceware_server,
    line_iter = get_line_iterator(0,2^13),
    line_filter = function(s) return s end
  }
}

for k,v in pairs(diceware_files) do
  --first download the files
  --if you are super paranoid then this command probably routes through two
  --external programs. namely the shell and wget.
  os.execute('/bin/env wget -O '..v.file..' '..v.server..v.file)
  
  
  --after the file is downloaded, format it to be super easy to parse
  local fin = assert(io.open(v.file,'r'))
  local fout = assert(io.open(k..'.list','w'))
  print(v.line_iter(fin))
  for line in v.line_iter(fin) do
    fout:write(v.line_filter(line)..'\n')
  end
  fin:close()
  fout:close()
end

