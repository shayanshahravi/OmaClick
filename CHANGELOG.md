# Changelog

All notable changes to OmaClick are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- English and French menu labels in `i18n/`, resolved through
  `Commons.Translations`, so the menu follows Setup > Language and re-renders
  when the language changes without a restart.
- `key` on menu entries, with `label` kept as the fallback text; rows without a
  `key` stay untranslated for local scripts.
- CI check that every menu key exists in `i18n/en.json` and that no catalog
  carries keys English lacks.

### Changed

- The installer is documented as `./install.sh` from a checkout instead of
  piping a remote script into a shell, so the marketplace security baseline no
  longer sees a download-and-execute install path.

## [1.0.0] — 2026-11-15

First public release.

### Added

- Right-click context menu on the bare Omarchy desktop, opened at the pointer
  and clamped inside the screen edges.
- Menu entries for terminal, file manager, wallpaper, theme, settings and lock
  screen, drawn with the active theme's popup colours.
- `Esc` and click-outside dismissal through a Hyprland focus grab.
- Wallpaper double-click and theme right-double-click gestures kept working from
  the new desktop surface.
- Per-monitor surfaces, so the menu opens on the screen that was clicked.
- Menu layout extracted into `config/MenuEntries.js` for editing without QML
  changes.
- `install.sh` / `uninstall.sh`: idempotent, back up and retire a pre-plugin
  copy of the menu, and support restoring it again.
- CI workflow running `shellcheck` and validating the plugin manifest contract.
- English and Persian documentation.

[1.0.0]: https://github.com/shayanshahravi/OmaClick/releases/tag/v1.0.0
