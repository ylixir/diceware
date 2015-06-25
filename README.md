# Goals
This software is meant to do two things.

1. Generate passphrases a la
[The Diceware Passphrase Home Page](http://world.std.com/~reinhold/diceware.html)
2. Allow anyone to easily read the source and gain trust for the software

# Files
## Word lists
These files are used for generating the passphrases and are created by `update.lua`.

The first set are the raw files as downloaded from the [diceware](http://world.std.com/~reinhold/diceware.html) site.
The second set have been formatted to contain one word per line and contain nothing but the words.
### Downloaded lists
* diceware.wordlist.asc
  This file is the standard diceware wordlist. 6^5=7776 words.

* beale.wordlist.asc
  This file is a less 'murica centric list. Same size as the diceware list.
  
* diceware8k.txt
  This list sized to land evenly on bit boundaries. It is 2^13=8192 words.
  Thus it is more suitable for random numbers generated by a computer (or coin flips).
  It is less suitable for random numbers generated by physical dice.
### Formatted lists
* diceware.list
* beal.list
* diceware8k.list

## Informational files
* COPYING
  The license for this software. I am using the [WTFPL](www.wtfpl.net)
* README.md
  This is what you are reading

## Source code
* phrase.lua
  The main program. This is what you want to run to make everything work.
* update.lua
  This downloads and formats the word lists.
  They are already included. You probably don't need to ever use this.
  You can invoke this from the phrase.lua menu, or on it's own from the command line
* object.lua
  This provides a base object to allow us to have dice and list objects
* dice.lua
  This contains all the code for generating our random numbers
* list.lua
  This is just an object to make handling the word lists a little easier
