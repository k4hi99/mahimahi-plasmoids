# mahitheme (script)

Applique une palette MahiTheme à tout KDE Plasma en une commande :

- génère un schéma de couleurs KDE (`~/.local/share/color-schemes/MahiTheme<Nom>.colors`) et l'active ;
- choisit un fond d'écran au hasard dans le dossier du thème ;
- repeint en direct toutes les plasmoids qui suivent le standard des couleurs MahiTheme
  (les 8 clés `primaryColor`… du groupe `Colors` de leur `main.xml`).

La plasmoid **MahiTheme** (`mahitheme.MahiMahi99`) n'est qu'une interface pour ce script : elle en a besoin.

## Dépendances

Python 3, `plasma-apply-colorscheme`, `plasma-apply-wallpaperimage`, `kreadconfig6` (fournis par Plasma 6),
`gdbus` (GLib) et `xdg-user-dir` (facultatif, pour trouver le dossier Images).

## Installation

Depuis la racine du dépôt :

```bash
./install.sh --cli
```

| Fichier installé | Emplacement |
|---|---|
| `mahitheme` | `~/.local/bin/mahitheme` |
| `themes.json` | `~/.config/mahitheme/themes.json` (jamais écrasé s'il existe déjà) |
| `systemd/mahitheme-wallpaper.service` et `.timer` | `~/.config/systemd/user/` |

La plasmoid MahiTheme appelle `$HOME/.local/bin/mahitheme` : garder cet emplacement.

## Utilisation

```bash
mahitheme "Sweet Bun"          # applique un thème (espaces et majuscules ignorés)
mahitheme --list               # liste les thèmes (* = thème courant)
mahitheme --next-theme         # thème suivant
mahitheme --next-wallpaper     # autre fond d'écran du thème courant
mahitheme --rotation on|off    # changement automatique du fond d'écran
mahitheme --interval 30        # toutes les 30 minutes (1 à 1440)
mahitheme --status             # état de la rotation
```

## Fonds d'écran

Un sous-dossier par thème, au nom exact du thème, avec des images `.jpg`, `.jpeg`, `.png` ou `.webp` :

```
~/Images/Themes/          (ou ~/Pictures/Themes/, selon la langue du système)
├── Sweet Bun/
├── Ken & Barbie/
└── …
```

Sans image pour un thème, le fond d'écran reste inchangé.

## Réglages

| Variable | Rôle | Défaut |
|---|---|---|
| `MAHITHEME_THEMES` | fichier des palettes | `~/.config/mahitheme/themes.json` |
| `MAHITHEME_WALLPAPERS` | dossier des fonds d'écran | `<dossier Images>/Themes` |

Pour qu'elles valent aussi pour la plasmoid et le timer, les déclarer dans
`~/.config/environment.d/mahitheme.conf`, puis se déconnecter et se reconnecter :

```ini
MAHITHEME_WALLPAPERS=/chemin/vers/mes/fonds
```

L'état (thème courant, dernier fond) est rangé dans `~/.local/state/mahitheme/state.json`.

## Palettes

`themes.json` contient la liste des thèmes, chacun avec ses 8 rôles :

```json
{ "name": "Sweet Bun", "colors": { "primary": "#836A8A", "secondary": "#455973", "accent": "#587891",
  "tertiary": "#47455D", "bg": "#1E3D51", "text": "#E3DCE5", "secText": "#EDE8EE", "badgeText": "#F6F3F6" } }
```

Ajouter un thème ici le rend disponible dans le script et la plasmoid MahiTheme. Pour qu'il apparaisse
aussi dans l'onglet « Couleurs » des autres plasmoids, l'ajouter à la liste des presets de chaque `configColors.qml`.

## Rotation du fond d'écran

Le timer `mahitheme-wallpaper.timer` lance `mahitheme --next-wallpaper` toutes les 15 minutes une fois activé
(`mahitheme --rotation on`). `--interval` écrit un drop-in
`~/.config/systemd/user/mahitheme-wallpaper.timer.d/interval.conf` au lieu de modifier le timer.

## Désinstallation

```bash
mahitheme --rotation off
rm ~/.local/bin/mahitheme ~/.config/systemd/user/mahitheme-wallpaper.{service,timer}
rm -r ~/.config/mahitheme ~/.local/state/mahitheme ~/.config/systemd/user/mahitheme-wallpaper.timer.d
systemctl --user daemon-reload
```
