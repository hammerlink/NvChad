# HAMMERNET NVIM

## Missing features

- Collapse expand code block / parentheses / multi line quotes...

- [x] Auto save upon switching buffers

- Run telescope from within selected nvim-tree folder

- [x] Git Features , Diff, Merge ...
--> ? https://github.com/NeogitOrg/neogit

- Debugging features, integration with neotest

- [x] Close other buffers, in telescope, or all except selected buffers in windows

- Scratch file with file extension & formatting

- Markdown preview

- OpenAPI preview

- Git rollback

- Return to previous page

- Git checkout branch

- Overseer run pnpm in sub package / adjust npm template

- Replace text across project with reged (Spectre?)

- Optimize imports LSP?

- Create LUA function to collapse all functions at the current level

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
