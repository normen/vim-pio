if exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn spell notoplevel

syn match piolibrariesHeader /^#ID.*/ contained containedin=piolibrariesInfo
syn match piolibrariesInfo /.*\n===.*\n.*/ 
syn match piolibrariesId /^[^#:=]*$/ contained containedin=piolibrariesInfo
hi def link piolibrariesHeader Label
hi def link piolibrariesId Function
hi def link piolibrariesInfo Macro

let b:current_syntax = "piolibraries"
