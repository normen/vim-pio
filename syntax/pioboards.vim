if exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn spell notoplevel

syn match pioboardsHeader /^Platform.*$/
syn match pioboardsSpecs /.*MHz.*/ 
syn match pioboardsBoard /^[^ ]*/ contained containedin=pioboardsSpecs
hi def link pioboardsHeader Label
hi def link pioboardsSpecs Text
hi def link pioboardsBoard Function

let b:current_syntax = "pioboards"
