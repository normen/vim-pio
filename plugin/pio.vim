" vim-pio - helpers for the PlatformIO command line tool
" Author: Normen Hansen <normen667@gmail.com>
" Home: https://github.com/normen/vim-pio

if (exists("g:loaded_vim_pio_plugin") && g:loaded_vim_pio_plugin) || &cp
  finish
endif
let g:loaded_vim_pio_plugin = 1

command! -nargs=* -complete=custom,pio#PIOCommandList PIO call pio#OpenTermOnce('platformio ' . <q-args>, "Platform IO")
command! -nargs=* -complete=custom,pio#PIOCommandList PIOMonitor call pio#OpenTermOnce('platformio device monitor ' . <q-args>, "PIO Monitor")
command! -nargs=* -complete=custom,pio#PIOBoardList PIONewProject call pio#PIOBoardSelection(<q-args>)
command! -nargs=1 -complete=custom,pio#PIOKeywordList PIOAddLibrary call pio#PIOInstallSelection(<q-args>)
command! PIORemoveLibrary call pio#PIOUninstallSelection()

command! -nargs=* -complete=custom,pio#PIOBoardList PIOInit call pio#PIOInit(<q-args>)
command! -nargs=1 -complete=custom,pio#PIOLibraryList PIOInstall call pio#PIOInstall(<q-args>)
command! -nargs=1 -complete=custom,pio#PIOInstalledList PIOUninstall call pio#PIOUninstall(<q-args>)
