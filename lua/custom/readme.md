# HAMMERNET NVIM

## Missing features

- Collapse expand code block / parentheses / multi line quotes...

- [x] Auto save upon switching buffers

- Run telescope from within selected nvim-tree folder
partially solved through spectre

- [x] Git Features , Diff, Merge ...
--> ? https://github.com/NeogitOrg/neogit

- Debugging features, integration with neotest

- [x] Close other buffers, in telescope, or all except selected buffers in windows

- Scratch file with file extension & formatting

- Markdown preview

- OpenAPI preview

- [x] Git rollback fixed via neogit discard

- Return to previous page

- [x] Git checkout branch

- Overseer run pnpm in sub package / adjust npm template

- [x] Replace text across project with reged (Spectre?)

- Optimize imports LSP?

- Create LUA function to collapse all functions at the current level

- Neogit, local branch delete with parameter -D instead of -d

- Git, annotate lines in window

## Implementation

### Autosave

https://github.com/Pocco81/auto-save.nvim

=> does not work atm

### Git file Diff

Used the diffview plugin
It has a very nice file history view
It can also visualize all the current active changes

Or it can visualize the changes between two branches.

#### TODO
Check how to combine diffview together with telescope branches.

First step should be to add keymap to print all the selcted branches with tab

### Close other buffers

Fixed with telescope close action for buffers and C-b.

### Git

Used packages:
- neogit
- diffview

### Installing vue lsp

Installing vue language server globally
```bash
npm i -g vls
```

added 'vuels' to the lspconfig.lua

Installed Treesitter vue `:TSInstall vue`

### Spectre
Spectre installed with default settings, this allows for searching in specific folders
Flow: press 'Y' in the nvim-tree and copy the relative path, paste it into the spectre windows
=> Search and replace at will through default linux sed functionality

NOTE there is also the possibility to work with rust-oxi instead of sed, to research
