# Custom VIM configuration

## Requirements
- Neovim 8+
- Plugin manager: Plug
- Linux based operation system / environment


## Install config 

Create nvim startup lua configuration to load all files from this repository

```lua

local dir = "path/to/config"
for file in io.popen('find "'..dir..'" -maxdepth 1 -type f | sort | grep -v init.lua$ | grep .lua$'):lines() do
  dofile(file)       
end

```

## Local workspace config
This configuration tries to load the `.vim/init.lua` file from the current working directory.
These configurations can be generated with `:InitWorkspace {lang}` command.
(see 98_workspace_initializer.lua to available templates)

