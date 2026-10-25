# Weather Mahi

**English** · [Français](README.fr.md)

Current weather for your city in a small tile; click it for details and the forecast. Data from OpenWeatherMap.

![Weather Mahi](../screenshots/weathermahi.png)

## Usage

- Needs a free [OpenWeatherMap API key](https://openweathermap.org/api) (a new key can take up to 2 hours to activate).
- Data refreshes every 30 minutes.

## Settings

**General** tab:

- **OpenWeatherMap API key**
- **City**: `Paris`, or `Paris,FR` to be more precise
- **Units**: Celsius or Fahrenheit

**Couleurs** (Colors) and **Tailles** (Sizes) tabs: the shared MahiTheme standard, 10 palettes included, see the [main README](../README.md#the-idea-one-shared-standard). Extra color: unit indicator. Extra sizes: temperatures, city, details, forecast, weather icons.

## Install

From the repository root:

```bash
kpackagetool6 -t Plasma/Applet -i weathermahi.MahiMahi99
```

---

Imagined, designed and tested by MahiMahi99, developed with the help of Claude: see [Transparency](../README.md#transparency).
