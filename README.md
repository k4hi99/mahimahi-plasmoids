# MahiMahi plasmoids

**English** · [Français](README.fr.md)

A collection of plasmoids for **KDE Plasma 6**, designed as a set: they all speak the same visual language,
and a single click dresses them all in the same palette.

![The MahiMahi plasmoids on a desktop](screenshots/collection.png)

> The plasmoids' interface is in French.

## The idea: one shared standard

Every plasmoid follows the same standard, **MahiTheme**:

- **the same "Couleurs" (Colors) tab everywhere**, with 8 color roles (primary, secondary, accent, background,
  text…) and the same **10 ready-made palettes**: Rengoku, Sorbet, Ken & Barbie, Sailor Moon, Sailor Mars,
  Summer Time, Sweet Bun, One Punch, Marimo and La Haine;
- **the same "Tailles" (Sizes) tab everywhere**, to set the title, text, small text, icon sizes and corner
  radius in pixels;
- **MahiTheme**, a plasmoid and a script that apply a palette to **all of KDE at once**: window color scheme,
  a matching wallpaper, and every plasmoid of the collection repainted live.

![The Colors tab and its 10 palettes](screenshots/onglet-couleurs.png)

## The plasmoids

| | Plasmoid | What it does |
|---|---|---|
| ![](screenshots/mahifind.png) | **[MahiFind](mahifind.MahiMahi99/)** | Mini-finder: type a few letters to find a folder and open it |
| ![](screenshots/mahify.png) | **[MahiFy](mahify.MahiMahi99/)** | The track playing on Spotify, with cover art, progress and playback controls |
| ![](screenshots/weathermahi.png) | **[Weather Mahi](weathermahi.MahiMahi99/)** | Current weather and forecast for your city (OpenWeatherMap) |
| ![](screenshots/mahistats-taskbar.png) | **[MahiStats](mahistats.MahiMahi99/)** | CPU, temperature, memory and battery: mini-bars in the panel, gauges or bars on the desktop |
| ![](screenshots/cheaty.png) | **[Cheaty](cheaty.MahiMahi99/)** | Cheat sheets (HTML, CSS, JavaScript, Bootstrap, Markdown, HTTP status codes…) with one-click code copy |
| ![](screenshots/mahitheme.png) | **[MahiTheme](mahitheme.MahiMahi99/)** | Switch themes in one click, for all of KDE and the whole collection |

## Installation

Requires KDE Plasma 6.

```bash
git clone https://github.com/k4hi99/mahimahi-plasmoids.git
cd mahimahi-plasmoids
```

### One plasmoid

```bash
kpackagetool6 -t Plasma/Applet -i mahifind.MahiMahi99      # install
kpackagetool6 -t Plasma/Applet -u mahifind.MahiMahi99      # upgrade
kpackagetool6 -t Plasma/Applet -r mahifind.MahiMahi99      # remove
```

It then shows up in *Add Widgets…* (run `systemctl --user restart plasma-plasmashell` if it doesn't appear
right away).

### Everything at once

```bash
./install.sh
```

Installs every plasmoid, their logos and the `mahitheme` script. Options: `--plasmoids` or `--cli` for one part
only, `--link` for symlinks to the repository instead of copies (handy to hack on the plasmoids).

### The mahitheme script (for MahiTheme)

The MahiTheme plasmoid is only a front end: the work is done by the `mahitheme` script.

```bash
./install.sh --cli
mahitheme "Sweet Bun"          # apply a palette to all of KDE
mahitheme --rotation on        # change the wallpaper every 15 minutes
```

It installs `~/.local/bin/mahitheme`, the palettes in `~/.config/mahitheme/themes.json` and a systemd user timer.
Wallpapers go in one folder per theme: `~/Pictures/Themes/<Theme name>/`.
All the details are in [mahitheme-cli/README.md](mahitheme-cli/README.md) (in French).

### Specific settings

- **Weather Mahi** needs a free [OpenWeatherMap](https://openweathermap.org/api) API key.
- **MahiFy** follows Spotify through MPRIS: the Spotify app must be running.
- **Cheaty** reads its sheets from disk, which Qt 6 only allows with `QML_XHR_ALLOW_FILE_READ=1`:
  ```bash
  mkdir -p ~/.config/environment.d
  echo 'QML_XHR_ALLOW_FILE_READ=1' > ~/.config/environment.d/cheaty.conf
  ```
  then log out and back in.

## Transparency

These plasmoids were imagined, designed and tested by me, and developed with the help of **Claude**
(Anthropic), through [Claude Code](https://claude.com/claude-code) and [claude.ai](https://claude.ai).
The ideas, the design, the choices and the testing are mine; Claude wrote a large part of the code
under my direction.

The repository's [CLAUDE.md](CLAUDE.md) shows how we worked together: it is the specification Claude Code reads
before every change (color and size standards, conventions, new-plasmoid checklist).

## Credits

**Cheaty** is a KDE Plasma 6 adaptation of the Cinnamon applet
[Cheaty](https://cinnamon-spices.linuxmint.com/applets/view/285) (`cheaty@centurix`) by **centurix**,
released under GPL-3.0 in [cinnamon-spices-applets](https://github.com/linuxmint/cinnamon-spices-applets).
The **Markdown** and **HTTP Status Codes** sheets come from the original. The interface was rewritten in QML;
the other sheets, including **Bootstrap 5.3** (the original covered Twitter Bootstrap), are new.

## License

[GPL-3.0](LICENSE): **GPL-3.0-or-later** for the plasmoids and the `mahitheme` script,
**GPL-3.0-only** for Cheaty, like the original applet.

Author: **MahiMahi99** · mahicala@gmail.com
