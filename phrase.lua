#!/usr/bin/env lua

--[[

Copyright © 2015 Jon Allen <ylixir@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

]]--

--[[ these are the functions that we will be using ]]--
local main, menu, download, load, generate, show

--[[ these are the 'classes' we will use ]]--
local object = require 'object'
local protodice = require 'dice'
local protolist = require 'list'

--[[ the defaults are stored in these variables ]]--
local phrase_length, list, random_letter

--[[ the word lists and supporting data are stored here ]]--
local lists, letter_list

--[[ and these are the actual lists available ]]--
lists = {}

lists.beale = protolist:new()
lists.beale.file = 'beale.wordlist.asc'
lists.beale.dice.sides = 6
lists.beale.dice.throws = 5
lists.beale.skip = 2
lists.beale.padding = 7

lists.diceware = protolist:new()
lists.diceware.file = 'diceware.wordlist.asc'
lists.diceware.dice.sides = 6
lists.diceware.dice.throws = 5
lists.diceware.skip = 2
lists.diceware.padding = 7

lists.diceware8k = protolist:new()
lists.diceware8k.file = 'diceware8k.txt'
lists.diceware8k.dice.sides = 2
lists.diceware8k.dice.throws = 13

-- !"#$%&'()*+,-./0123456789:;<=>?@
letter_list = {}
for i=1,32 do letter_list[i] = string.char(0x20 + i) end

--everything starts here
function main()
  phrase_length = 7
  list = lists.diceware8k
  random_letter = true --insert a random letter into the phrase?

  while true do
    menu
    ({
      ['Update the word lists']=function() dofile('update.lua') end,
      ['Generate a pass phrase']=function() show(generate()) end,
      ['Quit']=os.exit
    })
  end
end

--the menu function just prints a numbered menu and has the user select a choice
--choices is table where the keys are the menu items, the values are functions
function menu(choices)
  local indexes = {}
  for item,func in pairs(choices) do
    indexes[#indexes+1] = func
    print(#indexes..' '..item)
  end
  io.write('Enter your choice: ')
  indexes[io.read('*n')]()
end

--[[
--download the word lists using wget
function download()
  for k,v in pairs(lists) do
    --if you are super paranoid then this command probably routes through two
    --external programs. namely the shell and wget.
    os.execute('/bin/env wget -O '..v.file..' '..v.source..v.file)
    v.loaded = false
  end
end

function load()
  local flist=assert(io.open(list.file,'r'))
  --just dump any trash at the beginning of the file
  if list.skip > 0 then for i=1,list.skip do flist:read('*l') end end
  --read in the word list
  for i=1,list.dice.sides^list.dice.throws do
    list.words[i]=flist:read('*l'):sub(list.padding)
  end
  flist:close()
  list.loaded = true
end
]]--
function generate()
  --first read the diceware list into memory
  if false == list.loaded then load() end
  
  local phrase = {}
  for i = 1,phrase_length do phrase[i] = list.words[list.dice:roll()] end
  
  if true == random_letter then
    local dice, letter, word, place
    dice = protodice:new()
    dice.throws = 1
    
    dice.sides = #letter_list
    letter = letter_list[dice:roll()]
    
    dice.sides = phrase_length
    word = dice:roll()
    
    dice.sides  = string.len(phrase[word])+1
    place = dice:roll()
    
    if 1 == place then
      phrase[word] = letter..phrase[word]
    elseif #phrase[word]+1 == place then
      phrase[word] = phrase[word]..letter
    else
      phrase[word] = string.sub(phrase[word],1,place-1)
                     ..letter ..string.sub(phrase[word],place,-1)
    end
  end
  return phrase
end

function show(phrase)
  for i,v in ipairs(phrase) do
    if i > 1 then io.write(' ') end
    io.write(v)
  end
  io.write('\n')
end

--lets do this thing
main()
