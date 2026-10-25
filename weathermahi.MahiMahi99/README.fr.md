# Weather Mahi

[English](README.md) · **Français**

La météo actuelle de ta ville dans une petite vignette ; un clic affiche le détail et les prévisions. Données OpenWeatherMap.

![Weather Mahi](../screenshots/weathermahi.png)

## Utilisation

- Il faut une [clé API OpenWeatherMap](https://openweathermap.org/api) gratuite (une nouvelle clé peut mettre jusqu'à 2 h à s'activer).
- Les données sont rafraîchies toutes les 30 minutes.

## Réglages

Onglet **General** :

- **Clé API OpenWeatherMap**
- **Ville** : `Paris`, ou `Paris,FR` pour plus de précision
- **Unités** : Celsius ou Fahrenheit

Onglets **Couleurs** et **Tailles** : le standard MahiTheme commun, avec ses 10 palettes, voir le [README général](../README.fr.md#lidée--un-standard-commun). Couleur en plus : indicateur d'unité. Tailles en plus : températures, ville, détails, prévisions, icônes météo.

## Installation

Depuis la racine du dépôt :

```bash
kpackagetool6 -t Plasma/Applet -i weathermahi.MahiMahi99
```

---

Imaginée, conçue et testée par MahiMahi99, développée avec l'aide de Claude : voir [Transparence](../README.fr.md#transparence).
