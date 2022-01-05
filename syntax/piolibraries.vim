if exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn spell notoplevel

syn match piolibrariesInfo /.*\n===.*\n.*/ 
syn match piolibrariesHeader /^[^#:=\.]*$/ contained containedin=piolibrariesInfo
syn match piolibrariesId /^#ID.*/ contained containedin=piolibrariesInfo
syn match piolibrariesKeywords /^Version:\|^Keywords:\|^Compatible frameworks:\|^Compatible platforms:\|^Authors:/
syn match piolibrariesStorage /^Library Storage:/
syn match piolibrariesFound /^Found [0-9]* libraries:/
hi def link piolibrariesInfo Text
hi def link piolibrariesHeader Function
hi def link piolibrariesId Number
hi def link piolibrariesKeywords Tag
hi def link piolibrariesStorage Label
hi def link piolibrariesFound Label

let b:current_syntax = "piolibraries"
