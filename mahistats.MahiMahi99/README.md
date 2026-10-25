# MahiStats

**English** · [Français](README.fr.md)

CPU load, temperature, memory and battery at a glance: compact mini-bars in a panel, gauges or bars on the desktop, with a 5-minute history.

![MahiStats in a panel](../screenshots/mahistats-taskbar.png)

![MahiStats on the desktop](../screenshots/mahistats-desktop.png)

## Usage

- Uses Plasma's system sensors (`org.kde.ksysguard`, installed with System Monitor).
- A value past its alert threshold turns to the accent color.

## Settings

**General** tab:

- **Full view**: gauges or bars, history shown or hidden
- **Compact view**: bars or text only, RAM in % or GB
- **Alert thresholds**: CPU temperature, RAM, low battery

**Couleurs** (Colors) and **Tailles** (Sizes) tabs: the shared MahiTheme standard, 10 palettes included, see the [main README](../README.md#the-idea-one-shared-standard). Extra sizes: gauges, history graph, bars, compact bars.

## Install

From the repository root:

```bash
kpackagetool6 -t Plasma/Applet -i mahistats.MahiMahi99
```

---

Imagined, designed and tested by MahiMahi99, developed with the help of Claude: see [Transparency](../README.md#transparency).
