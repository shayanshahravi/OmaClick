# OmaClick

[فارسی (Persian)](README.fa.md) · English

**A Windows-style right-click context menu for the Omarchy desktop.**

Right-clicking the bare desktop on most Linux desktops does nothing. OmaClick
puts a real context menu there — terminal, file manager, wallpaper, theme,
settings and lock screen — drawn in Omarchy's own popup styling, so it looks
like part of the shell rather than a bolt-on.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Lint](https://github.com/shayanshahravi/OmaClick/actions/workflows/lint.yml/badge.svg)](https://github.com/shayanshahravi/OmaClick/actions/workflows/lint.yml)
[![Omarchy compatible](https://img.shields.io/badge/Omarchy-Quattro-1f6feb.svg)](https://omarchy.org)
[![Release](https://img.shields.io/github/v/release/shayanshahravi/OmaClick?color=green)](https://github.com/shayanshahravi/OmaClick/releases)

![The OmaClick context menu open on an empty desktop](preview.png)

## Features

- **Right-click anywhere on the desktop** to open a context menu at the pointer.
- **Clamped to the screen**: the card flips above the cursor when there is not
  enough room below, and never runs off the edge.
- **Omarchy-native look**: the card uses the active theme's popup colours,
  border and corner radius, and follows theme switches live.
- **Follows the Omarchy font**: rows are drawn in `Style.font.menuFamily` —
  whatever `omarchy font set` configured, or `OMARCHY_MENU_FONT` when that is
  set — and sized from `omarchy display text size`. Row, separator and card
  metrics scale with the text size, so a larger font does not clip.
- **Keyboard friendly**: `Esc` closes it; clicking anywhere else does too, via a
  Hyprland focus grab.
- **Desktop gestures preserved**: double-clicking the wallpaper still changes
  the wallpaper, and right-double-clicking still changes the theme.
- **Multi-monitor aware**: every screen gets its own surface, and the menu opens
  on the screen you clicked.
- **One file to customise**: menu entries live in
  [`config/MenuEntries.js`](config/MenuEntries.js).

Default entries:

| Entry               | Action                                        |
| ------------------- | --------------------------------------------- |
| Open Terminal       | `omarchy-launch-terminal`                     |
| Open Files          | `nautilus`                                    |
| Change Wallpaper…   | `omarchy-theme-bg-switcher` + `omarchy-theme-bg-set` |
| Change Theme…       | `omarchy-theme-switcher` + `omarchy-theme-set` |
| Settings…           | `omarchy-shell omasettings toggle`            |
| Lock Screen         | `omarchy-system-lock`                         |

## Requirements

- **Omarchy** (Quattro shell, `schemaVersion: 1` plugin manifests).
- `nautilus` for the *Open Files* row — edit the entry if you use another file
  manager.
- No extra packages, no background daemon, no Hyprland keybinding.

## Install

With the Omarchy plugin manager:

```sh
omarchy plugin add https://github.com/shayanshahravi/OmaClick.git --enable
```

Or from a checkout, using the installer, which also retires an older
hand-installed copy of the menu (see below):

```sh
git clone https://github.com/shayanshahravi/OmaClick.git
cd OmaClick
./install.sh
```

Either way the plugin lands in
`~/.config/omarchy/plugins/io.github.shayanshahravi.omaclick/` and is enabled
immediately. No shell restart is needed; right-click the desktop.

## Usage

- **Right-click the desktop** → the menu opens at the pointer.
- **Left-click a row** → runs its command and closes the menu.
- **`Esc` / click elsewhere** → closes the menu.
- **Double-click the wallpaper** → next wallpaper.
- **Right-double-click the wallpaper** → next theme.

## Configuration

Edit `config/MenuEntries.js` inside the installed plugin:

```sh
$EDITOR ~/.config/omarchy/plugins/io.github.shayanshahravi.omaclick/config/MenuEntries.js
```

Each row is either a command or a separator:

```js
var entries = [
  { label: "Open Terminal", command: "omarchy-launch-terminal" },
  { separator: true },
  { label: "My Script", command: "~/bin/my-script" }
]
```

Then reload the shell:

```sh
omarchy-shell shell rescanPlugins
```

Commands run detached through `Util.execDetached`, i.e. as your user, with your
environment — the same as running them in a terminal.

## Uninstall

```sh
omarchy plugin remove io.github.shayanshahravi.omaclick
```

Or, to also put back an older hand-installed menu that `install.sh` retired:

```sh
./uninstall.sh --restore-legacy
```

Backups are kept in `~/.local/state/omaclick/backups/`; nothing outside the
plugin folder is modified, so removing it leaves your configuration untouched.

## How it works

OmaClick is a `service`-kind plugin: `Service.qml` is loaded into the running
`omarchy-shell` process (Quickshell).

- A transparent full-screen surface on the **bottom** layer, created after the
  wallpaper surface, receives pointer input on the bare desktop without covering
  windows or bottom-layer widgets.
- A second surface on the **overlay** layer draws the card itself, sized to the
  menu, and holds a focus grab so outside clicks dismiss it.
- Commands are launched with `Util.execDetached`, so the shell never blocks.

It does not start a second Quickshell process and does not patch Hyprland
configuration.

## License

[MIT](LICENSE) © Shayan Shahravi
