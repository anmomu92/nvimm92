<h1 align="center">Nvimm92</h1>

<div align="center">

[![GPL-3.0 license](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](LICENSE)
[![State](https://img.shields.io/badge/State-active-brightgreen?style=flat-square)]()

</div>

This is my personal configuration for Neovim. After being a Nvchad user for some time, I decided to set up my own Neovim configuration from scratch. It includes the plugins I find more useful for my personal use, so it may not fit your needs in every way. Also, I am not neither a Neovim nor a Lua expert, so there may be some mistakes that I have not noticed so far. Any help is more than welcome. 

## Dashboard
> [!NOTE]
> [goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)

> [!IMPORTANT]
> I have included a task section that lists pending tasks added through a plugin I have not finished yet.

![Dashboard](assets/alpha-nvim.png)

## 🧭 Basic keybindings
| Commands | Keybinding |
| -------- | :--------: |
| Exit | Esc |
| Save | Ctrl+s |

| Navigation | Keybinding |
| ---------- | :----------: |
| Cycle through tabs | Tab |
| Focus left window | Ctrl+h | 
| Focus right window | Ctrl+l | 
| Focus above window | Ctrl+k | 
| Focus below window | Ctrl+j | 

| Panels | Kybindings |
| ------ | :----------: |
| File explorer | Alt+n |
| Vertical terminal | Alt+l |
| Horizontal terminal | Alt+j |
| Lazygit | Alt+g |



## ⚡ Main features

### Autopairing
> [!NOTE]
> [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

> [!IMPORTANT]
> To move the character outside the enclosing characters without exiting INSERT mode, use `Ctrl+{h,l}` keybinding.

Common enclosing characters are automatically closed when the opening character is typed.

### Top Bar
> [!NOTE]
> [romgrk/barbar.nvim](https://github.com/romgrk/barbar.nvim)

This top bar shows the opened buffers in the current session.

### Status Line
> [!NOTE]
> [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

A visually pleasant and informative status line. It shows information such as git status, encoding or filetype among other. It follows the gruvbox theme.

### Colorscheme
> [!NOTE]
> [ellisonleao/gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)

It supports both light and dark themes. My favorite colorscheme is gruvbox as it is neither too bright in light mode nor too obscure in dark mode.


## 🛠️ Installation

> [!WARNING]
> Before installing this repo, make a backup of your current config files in case you want it back.

To install this Neovim configuration, just clone this repository to the default Neovim's dotfiles location.

```bash
git clone https://github.com/anmomu92/nvimm92.git ~/.config/nvim && nvim
```

## 🤝 Contributions

Any kind of suggestion or improvement is suggested. Please, open an issue or merge request to discuss changes.

## 📜 License

GPL-3.0 license.
