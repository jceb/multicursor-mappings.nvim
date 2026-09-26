# multicursor-mappings.nvim

This plugin provides convenient key mappings and helper functions built on top
of Neovim's native multicursor engine.

For details on the underlying built-in multicursor architecture, refer to the
[Neovim Multicursor Documentation](https://neovim.io/doc/user/repeat/#_multiple-cursors)
(or `:help multicursor` inside Neovim).

## Installation

With Lazy, add this configuration to nvim:

```lua
{
  -- https://github.com/jceb/multicursor-mappings.nvim
  "jceb/multicursor-mappings.nvim",
}
```

With vim.pack add this configuration to nvim:

```lua
vim.pack.add({ "https://github.com/jceb/multicursor-mappings.nvim" })
```

## Keymaps

| Mode           | Keymap           | Description                                                                                                               |
| :------------- | :--------------- | :------------------------------------------------------------------------------------------------------------------------ |
| Normal         | `<Esc>`, `<M-i>` | Clear all multicursors                                                                                                    |
| Normal         | `<M-j>`          | Place cursor at the current position and move down                                                                        |
| Normal         | `<M-k>`          | Place cursor at the current position and move up                                                                          |
| Normal, Visual | `<M-a>`          | Place cursors at all occurrences of the word under the cursor / selection                                                 |
| Normal, Visual | `<M-n>`          | Set the initial search pattern, place cursor and move to the next occurrence of the word under the cursor / selection     |
| Normal, Visual | `<M-S-n>`        | Set the initial search pattern, place cursor and move to the previous occurrence of the word under the cursor / selection |
| Normal, Visual | `<M-C-n>`        | Reset the search pattern, place cursor and advance to the next occurrence of the word under the cursor / selection        |
| Normal, Visual | `<M-C-S-n>`      | Reset the search pattern, place cursor and advance to the previous occurrence of the word under the cursor / selection    |
| Normal         | `<M-=>`          | Toggle multicursor follow mode (`q=`)                                                                                     |
| Normal         | `<M-m>`          | Move back to previous cursor and remove it (`[CQ`)                                                                        |

## Requirements

- Neovim 0.13.0 or later with built-in multicursor support (`nvim.multicursor`
  namespace).
