# Cheaty

**English** · [Français](README.fr.md)

Your cheat sheets one click away from the panel: HTML, CSS, JavaScript, Bootstrap 5.3, Markdown, HTTP status codes, Claude Code… Each snippet copies to the clipboard in one click.

![Cheaty](../screenshots/cheaty.png)

## Usage

- Qt 6 only lets it read its sheets with `QML_XHR_ALLOW_FILE_READ=1`; set it once, then log out and back in:
  ```bash
  mkdir -p ~/.config/environment.d
  echo 'QML_XHR_ALLOW_FILE_READ=1' > ~/.config/environment.d/cheaty.conf
  ```
- Add your own sheet: a folder in `contents/refdocs/<Name>/` with a `sheet.json` (and an `icon.svg`), then **Recharger** or middle-click the icon.

## Settings

**Couleurs** (Colors) and **Tailles** (Sizes) tabs: the shared MahiTheme standard, 10 palettes included, see the [main README](../README.md#the-idea-one-shared-standard). Extra size: sheet icons.

## Install

From the repository root:

```bash
kpackagetool6 -t Plasma/Applet -i cheaty.MahiMahi99
```

## Credits

Adapted from the Cinnamon applet [Cheaty](https://cinnamon-spices.linuxmint.com/applets/view/285) by **centurix** (GPL-3.0); the **Markdown** and **HTTP Status Codes** sheets come from the original. License: GPL-3.0-only.

---

Imagined, designed and tested by MahiMahi99, developed with the help of Claude: see [Transparency](../README.md#transparency).
