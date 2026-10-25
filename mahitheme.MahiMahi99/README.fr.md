# MahiTheme

[English](README.md) · **Français**

Change de thème en un clic : schéma de couleurs de KDE, fond d'écran assorti et toutes les plasmoids de la collection repeintes en direct. Elle pilote aussi la rotation du fond d'écran.

![MahiTheme](../screenshots/mahitheme.png)

## Utilisation

- Dans un panneau uniquement. **Nécessite le script `mahitheme`** : `./install.sh --cli` à la racine du dépôt, voir [mahitheme-cli](../mahitheme-cli/README.md).
- Clic du milieu sur l'icône : thème suivant.
- Fonds d'écran : un dossier par thème dans `~/Images/Themes/<Nom du thème>/`.

## Réglages

Onglets **Couleurs** et **Tailles** : le standard MahiTheme commun, avec ses 10 palettes, voir le [README général](../README.fr.md#lidée--un-standard-commun).

## Installation

Depuis la racine du dépôt :

```bash
kpackagetool6 -t Plasma/Applet -i mahitheme.MahiMahi99
```

---

Imaginée, conçue et testée par MahiMahi99, développée avec l'aide de Claude : voir [Transparence](../README.fr.md#transparence).
