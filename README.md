# Vim-PlatformIO
## Introduction
This is a collection of helper commands for VIM to ease the use of PlatformIO with VIM.

Its very much a WIP, its literally just parts of my vimrc outsourced into a plugin.

[![asciicast](https://asciinema.org/a/4r0GnvuQo2dFCzTisdnqk7RX1.svg)](https://asciinema.org/a/4r0GnvuQo2dFCzTisdnqk7RX1)

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
To have code completion you'll need the [ccls](https://github.com/MaskRay/ccls) language server installed as well as a plugin for vim to use it, for example [coc.nvim](https://github.com/neoclide/coc.nvim) or `vim-lsp`.

The following is an example for MacOS with [Homebrew](https://brew.sh) installed.

##### MacOS using coc.nvim
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

### Background Make
I suggest also installing the awesome [vim-dispatch](https://github.com/tpope/vim-dispatch) plugin by tpope to be able to use `:Make` instead of `:make` to run compilations in the background.

### Further Info
This plugin is based on the built-in VIM and ccls support of PlatformIO, check out the information [here](https://docs.platformio.org/en/latest/integration/ide/vim.html)

