# Vim-PlatformIO (with clangd support)
## Introduction
This is a collection of helper commands for VIM to ease the use of PlatformIO with VIM.

Its very much a WIP, its literally just parts of my vimrc outsourced into a plugin.

[![asciicast](https://asciinema.org/a/dNEbhAzg7SqH2z6RTHYdprFyR.svg)](https://asciinema.org/a/dNEbhAzg7SqH2z6RTHYdprFyR)

## Features

- Select board from a list
- Create project incl. Makefile
- Search and install libararies from a list
- Errors and warnings with jumpmarks to relevant code files
- Supports code completion (needs language server plugin, see below)

## Installation
### PlatformIO Core
Make sure you have the [PlatformIO command line tools](https://docs.platformio.org/en/latest/core/installation.html#piocore-install-shell-commands) installed.

On MacOS with [Homebrew](https://brew.sh) installed just do:
```
brew install platformio
```

### Plugin
With [vim-plug](https://github.com/junegunn/vim-plug) installed, add this to your `vimrc`:
```
Plug 'normen/vim-pio'
```
## Documentation

Use `:h pio` in vim for documentation of all commands and options.

### Basic Commands
- `:PIO`
  - Mirrors the command line command and opens a term window. Note theres always only one PIO window.
- `:PIONewProject <search>`
  - Shows a list of boards, press enter on a board name to create a new project in the current folder based on that board.
- `:PIOAddLibrary <search>`
  - Shows a list of libraries, press enter on a library name to add it to the project.
- `:PIORemoveLibrary`
  - Shows a list of installed libraries, press enter on a library name to remove it from the project.

### Makefile
The plugin creates a `Makefile`, this way you can use a simple `:make` to compile or a `:make upload` to compile and upload your code to your microcontroller.

## Other things
### Code completion
To have code completion you'll need the [ccls](https://github.com/MaskRay/ccls) or [clangd](https://clangd.llvm.org/) language server installed as well as a plugin for vim to use it, for example [coc.nvim](https://github.com/neoclide/coc.nvim) or [vim-lsp](https://github.com/prabirshrestha/vim-lsp).

##### AstroNvim
This should work with [AstroNvim](https://github.com/AstroNvim/AstroNvim) out of the box, as long as you installed `clangd` using the included LSP Installer plugin ([`mason.nvim`](github.com/williamboman/mason.nvim)).

##### MacOS using coc.nvim
The following is an example for MacOS with [Homebrew](https://brew.sh) installed:
- Install ccls (`brew install ccls`)
- Install Node.js (`brew install node`)
- Follow the installation directions for [coc.nvim](https://github.com/neoclide/coc.nvim)
- Add this to your `coc-settings.json` (no other coc.nvim plugins needed)
```
{
  "languageserver": {
    "ccls": {
      "command": "ccls",
      "filetypes": [ "c", "cpp", "objc", "objcpp" ],
      "rootPatterns": [ ".ccls", "compile_commands.json" ],
      "initializationOptions": {
        "cache": {
          "directory": "/tmp/ccls"
        },
        "client": {
          "snippetSupport": true
        }
      }
    }
  }
}
```

##### MacOS using vim-lsp
- Install ccls (`brew install ccls`)
- Follow the installation directions for [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
- Add this to your `vimrc`
```
if executable('ccls')
  " disable clangd (pre-installed on MacOS)
  let g:lsp_settings = {
    \  'clangd': {'disabled': v:true}
    \}
  au User lsp_setup call lsp#register_server({
    \ 'name': 'ccls',
    \ 'cmd': {server_info->['ccls']},
    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.ccls'))},
    \ 'initialization_options': {'cache': {'directory': expand('/tmp/ccls') }},
    \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
    \ })
endif
```

### Background Make
I suggest also installing the awesome [vim-dispatch](https://github.com/tpope/vim-dispatch) plugin by tpope to be able to use `:Make` instead of `:make` to run compilations in the background.

### Further Info
This plugin is based on the built-in VIM and ccls support of PlatformIO, check out the information [here](https://docs.platformio.org/en/latest/integration/ide/vim.html)
