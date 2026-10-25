# MahiFind

[English](README.md) · **Français**

Un mini-finder ultra rapide pour le bureau : il indexe tes dossiers une fois, puis tu tapes quelques lettres pour en retrouver un et l'ouvrir dans le gestionnaire de fichiers.

![MahiFind](../screenshots/mahifind.png)

## Utilisation

- Sur le bureau uniquement (pas dans un panneau).
- Le badge indique le nombre de dossiers indexés ; le bouton ⟳ relance un scan.

## Réglages

Onglet **General** :

- **Mode** : fenêtre complète ou interface réduite
- **Dossier de départ** : vide = ton dossier personnel
- **Profondeur de scan** : nombre de niveaux de sous-dossiers indexés
- **Auto-scan** : scanner automatiquement au démarrage (sinon, bouton ⟳)
- **Résultats max**
- **Dossiers exclus** : noms exacts, séparés par des virgules (`.git`, `.cache`, `node_modules`…)

Onglets **Couleurs** et **Tailles** : le standard MahiTheme commun, avec ses 10 palettes, voir le [README général](../README.fr.md#lidée--un-standard-commun). Tailles en plus : texte du badge, icônes des résultats.

## Installation

Depuis la racine du dépôt :

```bash
kpackagetool6 -t Plasma/Applet -i mahifind.MahiMahi99
```

---

Imaginée, conçue et testée par MahiMahi99, développée avec l'aide de Claude : voir [Transparence](../README.fr.md#transparence).
