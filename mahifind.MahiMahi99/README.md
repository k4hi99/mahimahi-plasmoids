# MahiFind

**English** · [Français](README.fr.md)

A lightning-fast mini-finder for the desktop: it indexes your folders once, then you type a few letters to find one and open it in the file manager.

![MahiFind](../screenshots/mahifind.png)

## Usage

- Desktop only (not in a panel).
- The badge shows how many folders are indexed; the ⟳ button runs a new scan.

## Settings

**General** tab:

- **Mode**: full window or compact interface
- **Starting folder**: empty = your home folder
- **Scan depth**: how many levels of subfolders to index
- **Auto-scan**: scan automatically at startup (otherwise use the ⟳ button)
- **Max results**
- **Excluded folders**: exact names, comma-separated (`.git`, `.cache`, `node_modules`…)

**Couleurs** (Colors) and **Tailles** (Sizes) tabs: the shared MahiTheme standard, 10 palettes included, see the [main README](../README.md#the-idea-one-shared-standard). Extra sizes: badge text, result icons.

## Install

From the repository root:

```bash
kpackagetool6 -t Plasma/Applet -i mahifind.MahiMahi99
```

---

Imagined, designed and tested by MahiMahi99, developed with the help of Claude: see [Transparency](../README.md#transparency).
