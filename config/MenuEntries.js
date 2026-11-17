.pragma library

// OmaClick menu layout.
//
// Edit this file to change what the right-click menu shows; no QML changes are
// needed. Each entry is either a row or a separator ({ separator: true }).
//
//   key     optional catalog key in i18n/<language>.json, resolved at draw
//           time so the row follows the Omarchy language without a restart
//   label   text shown in the menu, and the fallback when a catalog has no
//           entry for `key`, so plain entries can skip `key` entirely
//   command shell command run with Util.execDetached when the row is clicked
//
// After editing, reload the shell:
//   omarchy-shell shell rescanPlugins

var wallpaperCommand = 'background=$(omarchy-theme-bg-switcher); [[ -n $background ]] && omarchy-theme-bg-set "$background"'
var themeCommand = 'theme=$(omarchy-theme-switcher); [[ -n $theme ]] && omarchy-theme-set "$theme" >/dev/null 2>&1 &'

var entries = [
  { key: "menu.terminal", label: "Open Terminal", command: "omarchy-launch-terminal" },
  { key: "menu.files", label: "Open Files", command: "nautilus" },
  { separator: true },
  { key: "menu.wallpaper", label: "Change Wallpaper…", command: wallpaperCommand },
  { key: "menu.theme", label: "Change Theme…", command: themeCommand },
  { separator: true },
  { key: "menu.settings", label: "Settings…", command: "omarchy-shell omasettings toggle" },
  { key: "menu.lock", label: "Lock Screen", command: "omarchy-system-lock" }
]
