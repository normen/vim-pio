if exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn spell notoplevel

syn match pioboardsHeader /^Platform.*$/
syn match pioboardsSpecs /.*MHz.*/ 
syn match pioboardsBoard /^[^ ]*/ contained containedin=pioboardsSpecs
hi def link pioboardsHeader Label
hi def link pioboardsBoard Function
hi def link pioboardsSpecs Macro

let b:current_syntax = "pioboards"
