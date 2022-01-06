" vim-pio - helpers for the PlatformIO command line tool
" Author: Normen Hansen <normen667@gmail.com>
" Home: https://github.com/normen/vim-pio

if (exists("g:loaded_vim_pio") && g:loaded_vim_pio) || &cp
  finish
endif
let g:loaded_vim_pio = 1

command! -nargs=+ -complete=custom,<SID>PIOCommandList PIO call s:OpenTermOnce('platformio ' . <q-args>, "Platform IO")
"command! PIOCreateMakefile call <SID>PIOCreateMakefile()
"command! PIOCreateMain call <SID>PIOCreateMain()
command! PIORefresh call <SID>PIORefresh()
command! -nargs=* -complete=custom,<SID>PIOBoardList PIONewProject call <SID>PIOBoardSelection(<q-args>)
command! -nargs=1 -complete=custom,<SID>PIOKeywordList PIOAddLibrary call <SID>PIOInstallSelection(<q-args>)
command! PIORemoveLibrary call <SID>PIOUninstallSelection()

command! -nargs=1 -complete=custom,<SID>PIOBoardList PIOInit call <SID>PIOInit(<q-args>)
command! -nargs=1 -complete=custom,<SID>PIOLibraryList PIOInstall call <SID>PIOInstall(<q-args>)
command! -nargs=1 -complete=custom,<SID>PIOInstalledList PIOUninstall call <SID>PIOUninstall(<q-args>)

" get a list of PlatformIO commands
function! s:PIOCommandList(args,L,P)
  if a:L=~'^PIO [^ ]*$'
  else
    return ""
  endif
  let commands = [
        \ 'access',
        \ 'account',
        \ 'boards',
        \ 'check',
        \ 'ci',
        \ 'debug',
        \ 'device',
        \ 'home',
        \ 'lib',
        \ 'org',
        \ 'package',
        \ 'platform',
        \ 'project',
        \ 'remote',
        \ 'run',
        \ 'settings',
        \ 'team',
        \ 'test',
        \ 'update',
        \ 'upgrade',
        \ 'access',
        \ ]
  return join(commands,"\n")
endfunction

" get a list of search keywords
function! s:PIOKeywordList(args,L,P)
  let commands = [
        \ 'id:',
        \ 'keyword:',
        \ 'header:',
        \ 'framework:',
        \ 'platform:',
        \ 'author:',
        \ ]
  let pio_ini = readfile('platformio.ini')
  if !empty(pio_ini)
    for line in pio_ini
      if line =~ '^platform *=.*'
        let pltf = substitute(line,"=",":","g")
        let pltf = substitute(pltf," ","","g")
        let commands = commands + [pltf]
      endif
      if line =~ '^framework *=.*'
        let pltf = substitute(line,"=",":","g")
        let pltf = substitute(pltf," ","","g")
        let commands = commands + [pltf]
      endif
    endfor
  endif
  return join(commands,"\n")
endfunction

" get a list of PlatformIO boards
function! s:PIOBoardList(args,L,P)
  let raw_boards=systemlist("pio boards ".a:args)
  let boards=[]
  for boardline in raw_boards
    let board_info=matchlist(boardline,'^\([^\s\t ]*\) .*Hz.*')
    if !empty(board_info)
      let name = get(board_info,1)
      let boards = boards + [name]
    endif
  endfor
  return join(boards,"\n")
endfunction

" get a list of PlatformIO boards
function! s:PIOInstalledList(args,L,P)
  let all_libs = system('pio lib list')
  let idx=0
  let libnames=[]
  while idx!=-1
    let hit=matchlist(all_libs,'\n\([^\n]*\)\n===*',0,idx)
    if !empty(hit)
      let libnames=libnames + [get(hit,1)]
      let idx=idx+1
    else
      let idx=-1
    endif
  endwhile
  return join(libnames,"\n")
endfunction

" get a list of PlatformIO boards
function! s:PIOLibraryList(args,L,P)
  let all_libs = system('pio lib search "'.a:args.'"')
  let idx=0
  let libnames=[]
  while idx!=-1
    " match 3 lib info lines:
    " Library Name
    " ============
    " #ID: 999
    let hit=matchlist(all_libs,'\n\([^\n]*\)\n===*\n#ID: \([0-9]*\)\n',0,idx)
    if !empty(hit)
      let libnames=libnames + [get(hit,1)]
      let idx=idx+1
    else
      let idx=-1
    endif
  endwhile
  return join(libnames,"\n")
endfunction

function! s:PIOCreateMakefile()
  if filereadable('Makefile')
    echomsg 'Makefile exists!'
    return
  endif
  let data=[
    \ "# CREATED BY VIM-PIO",
    \ "all:",
    \ "	platformio -f -c vim run",
    \ "",
    \ "upload:",
    \ "	platformio -f -c vim run --target upload",
    \ "",
    \ "clean:",
    \ "	platformio -f -c vim run --target clean",
    \ "",
    \ "program:",
    \ "	platformio -f -c vim run --target program",
    \ "",
    \ "uploadfs:",
    \ "	platformio -f -c vim run --target uploadfs"]
  if writefile(data, 'Makefile')
    echomsg 'write error'
  endif
endfunction

function! s:PIOCreateMain()
  if filereadable('src/main.cpp')
    echomsg 'main.cpp exists!'
    return
  endif
  let data=[
    \ "#include <Arduino.h>",
    \ "",
    \ "void setup(){",
    \ "}",
    \ "",
    \ "void loop(){",
    \ "}",
    \ ""]
  if writefile(data, 'src/main.cpp')
    echomsg 'write error'
  endif
endfunction

" refresh (initialize) a project with the ide vim to recreate .ccls file
function! s:PIORefresh()
  execute 'silent !platformio project init --ide vim'
  execute 'redraw!'
endfunction

" initialitze a project with a board
function! s:PIOInit(board)
  execute 'silent !platformio project init --ide vim --board '.a:board
  call <SID>PIOCreateMakefile()
  call <SID>PIOCreateMain()
  execute 'redraw!'
endfunction

" install a library using pio
function! s:PIOInstall(library)
  let name=a:library
  if a:library=~'^#ID:.*'
    let name=a:library[5:]
  endif
  execute 'silent !platformio lib install "'.name.'"'
  call <SID>PIORefresh()
endfunction

" install a library using pio
function! s:PIOUninstall(library)
  execute 'silent !platformio lib uninstall "'.a:library.'"'
  call <SID>PIORefresh()
endfunction

" show a list of libraries for selection
function! s:PIOUninstallSelection()
  let winnr = bufwinnr('PIO Uninstall')
  if(winnr>0)
    execute winnr.'wincmd w'
    setlocal noro modifiable
    execute '%d'
  else
    bo new
    silent file 'PIO Uninstall'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile wrap
    setlocal filetype=piolibraries
    nnoremap <buffer> <CR> :call <SID>PIOUninstall(getline('.'))<CR>:call <SID>PIOUninstallSelection()<CR>
  endif
  echo 'Scanning PIO libraries..'
  execute 'silent $read !platformio lib list'
  execute append(0,"Help: Press [Enter] on a library name to uninstall")
  setlocal ro nomodifiable
  1
endfunction

" show a list of libraries for selection
function! s:PIOInstallSelection(args)
  let winnr = bufwinnr('PIO Install')
  if(winnr>0)
    execute winnr.'wincmd w'
    setlocal noro modifiable
    execute '%d'
  else
    bo new
    silent file 'PIO Install'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile wrap
    setlocal filetype=piolibraries
    nnoremap <buffer> <CR> :call <SID>PIOInstall(getline('.'))<CR>
  endif
  echo 'Searching PlatformIO libraries.. Press Ctrl-C to abort'
  execute 'silent $read !platformio lib search --noninteractive "'.a:args.'"'
  execute append(0,"Help: Press [Enter] on a library name or ID to install")
  setlocal ro nomodifiable
  1
endfunction

" show a list of boards for selection
function! s:PIOBoardSelection(args)
  let winnr = bufwinnr('PIO Boards')
  if(winnr>0)
    execute winnr.'wincmd w'
    setlocal noro modifiable
    execute '%d'
  else
    bo new
    silent file 'PIO Boards'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    setlocal filetype=pioboards
    nnoremap <buffer> <CR> :call <SID>PIOInit(expand('<cWORD>'))<CR>
  endif
  echo 'Scanning PlatformIO boards..'
  execute 'silent $read !platformio boards '.a:args
  execute append(0,"Help: Press [Enter] on a board name to create a new project")
  setlocal ro nomodifiable
  1
endfunction

" Open a named Term window only once (command tools)
function! s:OpenTermOnce(command, buffername)
  let winnr = bufwinnr(a:buffername)
  if(winnr>0)
    execute winnr.'wincmd c'
  endif
  call term_start(a:command,{'term_name':a:buffername})
endfunction

