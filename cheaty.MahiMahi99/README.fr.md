# Cheaty

[English](README.md) · **Français**

Tes antisèches à un clic du panneau : HTML, CSS, JavaScript, Bootstrap 5.3, Markdown, codes HTTP, Claude Code… Chaque extrait se copie dans le presse-papiers en un clic.

![Cheaty](../screenshots/cheaty.png)

## Utilisation

- Qt 6 ne la laisse lire ses fiches qu'avec `QML_XHR_ALLOW_FILE_READ=1` ; à faire une fois, puis se déconnecter et se reconnecter :
  ```bash
  mkdir -p ~/.config/environment.d
  echo 'QML_XHR_ALLOW_FILE_READ=1' > ~/.config/environment.d/cheaty.conf
  ```
- Ajouter ta fiche : un dossier `contents/refdocs/<Nom>/` avec un `sheet.json` (et un `icon.svg`), puis **Recharger** ou clic du milieu sur l'icône.

## Réglages

Onglets **Couleurs** et **Tailles** : le standard MahiTheme commun, avec ses 10 palettes, voir le [README général](../README.fr.md#lidée--un-standard-commun). Taille en plus : icônes des fiches.

## Installation

Depuis la racine du dépôt :

```bash
kpackagetool6 -t Plasma/Applet -i cheaty.MahiMahi99
```

## Crédits

Adaptation de l'applet Cinnamon [Cheaty](https://cinnamon-spices.linuxmint.com/applets/view/285) de **centurix** (GPL-3.0) ; les fiches **Markdown** et **HTTP Status Codes** viennent de l'original. Licence : GPL-3.0-only.

---

Imaginée, conçue et testée par MahiMahi99, développée avec l'aide de Claude : voir [Transparence](../README.fr.md#transparence).
