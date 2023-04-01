" vim-pio - helpers for the PlatformIO command line tool
" Author: Normen Hansen <normen667@gmail.com>
" Home: https://github.com/normen/vim-pio

if (exists("g:loaded_vim_pio") && g:loaded_vim_pio) || &cp
  finish
endif
let g:loaded_vim_pio = 1

" get a list of PlatformIO commands
function! pio#PIOCommandList(args,L,P)
  let commands = {
        \ 'access':["grant","list","private","public","revoke", "-h"],
        \ 'account':["destroy","forgot","login","logout","password","register","show","token","update","-h"],
        \ 'boards':["--installed","--json-output","-h"],
        \ 'check':["--environment","--project-dir","--project-conf","--pattern","--flags","--severity","--silent","--json-output","--fail-on-defect","--skip-packages","-h"],
        \ 'ci':["--lib","--exclude","--board","--build-dir","--keep-build-dir","--project-conf","project-option","--verbose","--help"],
        \ 'debug':["--project-dir","--project-conf","--environment","--load-mode","--verbose","--interface", "-h"],
        \ 'device':["list", "monitor","-h"],
        \ 'home':["--port","--host","--no-open","--shutdown-timeout","--session-id","-h"],
        \ 'lib':["builtin","install","list","register","search","show","stats","uninstall","update"],
        \ 'pkg':["exec","install","list","outdated","pack","publish","search","show","stats","uninstall","unpublish","update"],
        \ 'org':["add","create","destroy","list","remove","update","-h"],
        \ 'package':["pack","publish","unpublish","-h"],
        \ 'platform':["frameworks","install","list","search","show","uninstall","update","-h"],
        \ 'project':["config","data","init","-h"],
        \ 'remote':["agent","device","run","test","update","-h"],
        \ 'run':["--environment","--target","--upload-port","--project-dir","--project-conf","--jobs","--silent","--verbose","--disable-auto-clean","--list-targets","-h"],
        \ 'settings':["get","reset","set","-h"],
        \ 'team':["add","create","destroy","list","remove","update","-h"],
        \ 'test':["-e","-f","-i","--upload-port","-d","-c","--without-building","--without-uploading","--without-testing","--no-reset","--monitor-rts","--monitor-dtr","-v","-h"],
        \ 'update':["--core-packages","--only-check","--dry-run","-h"],
        \ 'upgrade':[],
        \ }
  if a:L=~'^PIO *[^ ]*$'
    return join(keys(commands),"\n")
  elseif a:L=~'^PIO *[^ ]* *.*$'
    let line_info=matchlist(a:L,'^PIO *\([^ ]*\) *.*$')
    if !empty(line_info)
      let name = get(line_info,1)
      return join(get(commands,name,[]),"\n")
    endif
  endif
  return ""
endfunction

" get a list of search keywords
function! pio#PIOKeywordList(args,L,P)
  let commands =[
        \ 'keyword:',
        \ 'header:',
        \ 'framework:',
        \ 'platform:',
        \ 'author:',
        \ 'id:',
        \ ]
  let commands += pio#PIOGetIniKeywords()
  return join(commands,"\n")
endfunction

" read the keywords from platformio.ini
" returns a list of strings like
" ["platform:espressif8266","framework:arduino"]
function! pio#PIOGetIniKeywords()
  let commands=[]
  try
    let pio_ini = readfile('platformio.ini')
    if !empty(pio_ini)
      for line in pio_ini
        if line =~ '^platform[\t ]*=.*'
          let pltf = substitute(line,"=",":","g")
          let pltf = substitute(pltf,"[\t ]","","g")
          let commands = commands + [pltf]
        endif
        if line =~ '^framework[\t ]*=.*'
          let pltf = substitute(line,"=",":","g")
          let pltf = substitute(pltf,"[\t ]","","g")
          let commands = commands + [pltf]
        endif
      endfor
    endif
  catch
  endtry
  return commands
endfunction

" get a list of PlatformIO boards
function! pio#PIOBoardList(args,L,P)
  let raw_boards=systemlist("platformio boards ".a:args)
  let boards=[]
  for boardline in raw_boards
    let board_info=matchlist(boardline,'^\([^ ]*\) .*Hz.*')
    if !empty(board_info)
      let name = get(board_info,1)
      if index(boards,name) == -1
        let boards = boards + [name]
      endif
    endif
  endfor
  return join(boards,"\n")
endfunction

" get a list of installed libraries
function! pio#PIOInstalledList(args,L,P)
  let all_libs = system('platformio pkg list --only-libraries')
  let idx=0
  let libnames=[]
  while idx!=-1
    let hit=matchlist(all_libs,'─[^)]*(required: \([^ ]*\)[^)]*)',0,idx)
    if !empty(hit)
      let myhit = get(hit,1)
      if index(libnames,myhit) == -1
        let libnames=libnames + [myhit]
      endif
      let idx=idx+1
    else
      let idx=-1
    endif
  endwhile
  return join(libnames,"\n")
endfunction

" get a list of online libraries
" loads keywords from ini to narrow down completion search
function! pio#PIOLibraryList(args,L,P)
  let iniKeywords = [] " TODO pio#PIOGetIniKeywords()
  let all_libs = system('platformio pkg search "'.join(iniKeywords," ").' '.a:args.'*"')
  let idx=0
  let libnames=[]
  while idx!=-1
    " TODO: broken..
    let hit=matchlist(all_libs,'\n\([^\n]*\)\n[^•\n]*•',0,idx)
    if !empty(hit)
      let libnames=libnames + [get(hit,1)]
      let idx=idx+1
    else
      let idx=-1
    endif
  endwhile
  return join(libnames,"\n")
endfunction

function! pio#PIOCreateMakefile()
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

function! pio#PIOCreateMain()
  if !isdirectory('src') || len(readdir('src')) > 0
    " only create in empty source folder
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
function! pio#PIORefresh()
  execute 'silent !platformio project init --ide vim'
  execute 'silent !platformio run -t compiledb'
  execute 'redraw!'
endfunction

" initialitze a project with a board
function! pio#PIOInit(board)
  if empty(a:board)
    execute 'silent !platformio project init --ide vim'
    execute '!platformio run -t compiledb'
  else
    execute 'silent !platformio project init --ide vim --board '.a:board
    execute '!platformio run -t compiledb'
  endif
  call pio#PIOCreateMakefile()
  call pio#PIOCreateMain()
  execute 'redraw!'
endfunction

" install a library using pio
function! pio#PIOInstall(library)
  let name=a:library
  if a:library=~'^#ID:.*'
    let name=a:library[5:]
  endif
  execute '!platformio pkg install -l "'.name.'"'
  call pio#PIORefresh()
endfunction

" install a library using pio
function! pio#PIOUninstall(library)
  execute '!platformio pkg uninstall -l "'.a:library.'"'
  call pio#PIORefresh()
endfunction

" uninstall a library from a line in library list
function! pio#PIOUninstallLine()
  let line = getline('.')
  let hit=matchlist(line,'─[^)]*(required: \([^ ]*\)[^)]*)')
  if !empty(hit)
    let myhit = get(hit,1)
    call pio#PIOUninstall(myhit)
  endif
endfunction

" show a list of libraries for selection
function! pio#PIOUninstallSelection()
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
    nnoremap <buffer> <CR> :call pio#PIOUninstallLine()<CR>:call pio#PIOUninstallSelection()<CR>
  endif
  echo 'Scanning PIO libraries..'
  execute 'silent $read !platformio pkg list --only-libraries'
  execute append(0,"Help: Press [Enter] on a library name to uninstall")
  setlocal ro nomodifiable
  1
endfunction

" show a list of libraries for selection
function! pio#PIOInstallSelection(args)
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
    nnoremap <buffer> <CR> :call pio#PIOInstall(getline('.'))<CR>
  endif
  echo 'Searching PlatformIO libraries.. Press Ctrl-C to abort'
  let iniKeywords = [] " TODO pio#PIOGetIniKeywords()
  execute 'silent $read !platformio pkg search "'.join(iniKeywords," ").' '.a:args.'"'
  execute append(0,"Help: Press [Enter] on a library name or ID to install")
  setlocal ro nomodifiable
  1
endfunction

" show a list of boards for selection
function! pio#PIOBoardSelection(args)
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
    nnoremap <buffer> <CR> :call pio#PIOInit(expand('<cWORD>'))<CR>
  endif
  echo 'Scanning PlatformIO boards..'
  execute 'silent $read !platformio boards '.a:args
  execute append(0,"Help: Press [Enter] on a board name to create a new project")
  setlocal ro nomodifiable
  1
endfunction

" Open a named Term window only once (command tools)
function! pio#OpenTermOnce(command, buffername)
  let winnr = bufwinnr(a:buffername)
  if(winnr>0)
    execute 'bd! '.winbufnr(winnr)
    "execute winnr.'wincmd c'
  endif
  if has('nvim')
    call termopen(a:command,{'term_name':a:buffername})
  else
    call term_start(a:command,{'term_name':a:buffername})
  endif
  if a:command =~ '^platformio *pkg *search.*$'
    setlocal filetype=piolibraries
    nnoremap <buffer> <CR> :call pio#PIOInstall(getline('.'))<CR>
  elseif a:command =~ '^platformio *lib *search.*$'
    setlocal filetype=piolibraries
    nnoremap <buffer> <CR> :call pio#PIOInstall(getline('.'))<CR>
  elseif a:command =~ '^platformio *boards.*$'
    setlocal filetype=pioboards
    nnoremap <buffer> <CR> :call pio#PIOInit(expand('<cWORD>'))<CR>
  else
    setlocal filetype=
    silent! nunmap <buffer> <CR>
  endif
endfunction

if has('nvim')
  let s:TERM = 'botright split | terminal! '
elseif has('terminal')
  " In vim, doing terminal! will automatically open in a new split
  let s:TERM = 'terminal! '
else
  " Backwards compatible with old versions of vim
  let s:TERM = '!'
endif
