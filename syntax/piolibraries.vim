if exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn spell notoplevel

syn match piolibrariesInfo /\n\n.*\n.*•.*\n/ 
syn match piolibrariesHeader /^[^#:=\.•]*$/ contained containedin=piolibrariesInfo
syn match piolibrariesId /^#ID: [0-9]*$/
syn match piolibrariesKeywords /^Verified Library\|^Library/ contained containedin=piolibrariesInfo
syn match piolibrariesStorage /^Library Storage:/
syn match piolibrariesHelp /^Help:/
syn match piolibrariesFound /^Found [0-9]* packages/
hi def link piolibrariesInfo Text
hi def link piolibrariesHeader Function
hi def link piolibrariesId Number
hi def link piolibrariesKeywords Include
hi def link piolibrariesStorage Label
hi def link piolibrariesFound Label
hi def link piolibrariesHelp Tag

let b:current_syntax = "piolibraries"
