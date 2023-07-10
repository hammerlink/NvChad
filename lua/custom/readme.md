# HAMMERNET NVIM

## Missing features

- Collapse expand code block / parentheses / multi line quotes...

- [x] Auto save upon switching buffers

- Run telescope from within selected nvim-tree folder

- Git Features , Diff, Merge ...

- Debugging features, integration with neotest

- [x] Close other buffers, in telescope, or all except selected buffers in windows

- Scratch file with file extension & formatting

- Markdown preview

- OpenAPI preview

- Git rollback

- Return to previous page

- Git checkout branch

- Overseer run pnpm in sub package / adjust npm template

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

### Close other buffers

Fixed with telescope close action for buffers and C-b.
