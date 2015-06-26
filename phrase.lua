#!/usr/bin/env lua

--[[

Copyright © 2015 Jon Allen <ylixir@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

]]--

--[[ these are the functions that we will be using ]]--
local main, menu, load_lists, generate, display_options
local change_list, settings

--[[ these are the 'classes' we will use ]]--
local object = require 'object'
local protodice = require 'dice'
local protolist = require 'list'

--[[ the defaults are stored in these variables ]]--
local phrase_length, use_list, random_letter

--[[ the word lists and supporting data are stored here ]]--
local lists, letter_list

--[[ and these are the actual lists available ]]--
lists = {}

lists['beale.list'] = protolist:new()
lists['diceware8k.list'] = protolist:new()
lists['diceware.list'] = protolist:new()

-- !"#$%&'()*+,-./0123456789:;<=>?@
letter_list = {}
for i=1,32 do letter_list[i] = string.char(0x20 + i) end

--everything starts here
function main()
  phrase_length = 7
  use_list = 'diceware8k.list'
  random_letter = true --insert a random letter into the phrase?

  load_lists()
  
  while true do
    display_options()
    menu
    ({
      ['Generate a pass phrase']=generate,
      ['Update the word lists from the interwebs']=function()
        dofile('update.lua')
        load_lists()
      end,
      ['Change settings']=settings,
      ['Quit']=os.exit
    })
  end
end

function settings()
  local done = false
  while not done do
    display_options()
    menu
    ({
      ['Use a different word list']=change_list,
      ['Toggle random character insertion']=function()
        random_letter = not random_letter
      end,
      ['Change the length of the phrase']=function()
        io.write('How many words do you want in your phrase? ')
        phrase_length = math.floor(io.read('*n'))
      end,
      ['Back']=function() done=true end
    })
  end
end

--the menu function just prints a numbered menu and has the user select a choice
--choices is table where the keys are the menu items, the values are functions
function menu(choices)
  local indexes = {}
  for item,func in pairs(choices) do
    table.insert(indexes,func)
    print(#indexes..' '..item)
  end
  io.write('Enter your choice: ')
  indexes[io.read('*n')]()
end

function display_options()
  io.write('\nUsing '..use_list)
  io.write(' to generate a phrase of length '..phrase_length)
  if random_letter then
    io.write(' which includes a random character.\n\n')
  else
    io.write(' which does not include a random character.\n\n')
  end
end

function change_list()
  menu_table = {}
  for k,v in pairs(lists )do
    menu_table[k] = function() use_list=k end
  end
  menu(menu_table)
end

function generate()
  print('This may take a moment if your computer needs more entropy.')
  print('You should be using your computer to make this go faster.')
  print('Go surf the internet or something.')
  local phrase =  ''
  local the_list = lists[use_list]
  for i = 1,phrase_length do
    phrase = phrase..the_list.words[the_list.dice:roll()]..' '
  end
  phrase = phrase:sub(1,-2)
  
  if random_letter then
    local dice, letter, place
    
    dice = protodice:new()
    dice.throws=1
    dice.sides=#letter_list
    
    letter = letter_list[dice:roll()]
    
    dice.sides = #phrase+1
    place = dice:roll()
    phrase = string.sub(phrase,1,place-1)
             ..letter
             ..string.sub(phrase,place,-1)
  end
  
  io.write('\n'..phrase..'\n\n')
  
  return phrase
end

--(re)load all lists from disk
function load_lists()
  for k,v in pairs(lists) do
    v:load(k) --we conveniently stored each word list under it's filename
  end
end

--lets do this thing
main()
