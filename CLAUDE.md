# Plasmoids MahiMahi

Plasmoids KDE Plasma 6 (QML), une par dossier `<nom>.MahiMahi99` : `mahifind`, `mahify`, `weathermahi`, `cheaty`,
`mahistats`, `mahitheme`. Le script `mahitheme` et ses fichiers sont dans `mahitheme-cli/`.
L'interface et les commentaires sont en français.

Ce dossier est aussi l'installation active (`~/.local/share/plasma/plasmoids`) : il contient des plasmoids tierces
installées (`com.github.idityage.spacerdivider`, `luisbocanegra.panelspacer.extended`, `org.kde.latte.spacer`)
qui ne sont pas les nôtres. Ne pas les modifier ni les appliquer aux standards ci-dessous.

Pour tester après une modification de `main.xml` ou `config.qml`, il faut redémarrer plasmashell :
`systemctl --user restart plasma-plasmashell`. Pour vérifier qu'il n'y a pas d'erreur QML :
`plasmoidviewer -a <dossier>`.

Sous KDE, les logs de plasmoidviewer partent dans le journal systemd et les `console.log`/`console.warn` sont
filtrés. Pour les voir dans le terminal :

```bash
QT_FORCE_STDERR_LOGGING=1 QT_LOGGING_RULES="qml.debug=true" plasmoidviewer -a <dossier>
```

Pour tester un réglage précis (ex. une case décochée), changer temporairement son `<default>` dans `main.xml`,
puis le remettre.

## Standard des couleurs (MahiTheme)

Toutes les plasmoids partagent le même système de couleurs : mêmes clés, même onglet, mêmes presets.

### Fichiers

| Fichier | Rôle |
|---|---|
| `contents/config/config.qml` | déclare l'onglet `Couleurs` (icône `preferences-desktop-color`), juste après `General` s'il existe, avant `Tailles` |
| `contents/config/main.xml` | groupe `Colors` avec les 8 clés standard (+ couleurs spéciales éventuelles) |
| `contents/ui/configColors.qml` | la page de l'onglet, **identique partout** sauf les blocs `SPÉCIFIQUE` |
| `contents/ui/main.qml` | expose les 8 propriétés sur `root` |

Les couleurs ne vont jamais dans `configGeneral.qml` ni dans un autre onglet.

### Les 8 rôles

| Rôle (preset) | Clé kcfg / propriété | Usage type |
|---|---|---|
| `primary` | `primaryColor` | titres, en-têtes de section, icônes principales |
| `secondary` | `secondaryColor` | fonds de cartes, survol |
| `accent` | `accentColor` | sélection, boutons, éléments actifs |
| `tertiary` | `tertiaryColor` | séparateurs, blocs de code, fonds secondaires, états (scan…) |
| `bg` | `bgColor` | fond principal du widget |
| `text` | `textColor` | texte principal |
| `secText` | `secTextColor` | descriptions, texte secondaire, barre de statut |
| `badgeText` | `badgeTextColor` | texte posé sur `accent`/`primary` (boutons, badges, sélection) |

Les noms sont exactement ceux-ci, sans préfixe (`custom…`) ni variante (`backgroundColor`, `secondaryTextColor`).
Valeurs par défaut : la palette **Sweet Bun**.

```xml
<group name="Colors">
    <entry name="primaryColor" type="String"><default>#836A8A</default></entry>
    <entry name="secondaryColor" type="String"><default>#455973</default></entry>
    <entry name="accentColor" type="String"><default>#587891</default></entry>
    <entry name="tertiaryColor" type="String"><default>#47455D</default></entry>
    <entry name="bgColor" type="String"><default>#1E3D51</default></entry>
    <entry name="textColor" type="String"><default>#E3DCE5</default></entry>
    <entry name="secTextColor" type="String"><default>#EDE8EE</default></entry>
    <entry name="badgeTextColor" type="String"><default>#F6F3F6</default></entry>
</group>
```

```qml
// main.qml
property color primaryColor: plasmoid.configuration.primaryColor
property color secondaryColor: plasmoid.configuration.secondaryColor
property color accentColor: plasmoid.configuration.accentColor
property color tertiaryColor: plasmoid.configuration.tertiaryColor
property color bgColor: plasmoid.configuration.bgColor
property color textColor: plasmoid.configuration.textColor
property color secTextColor: plasmoid.configuration.secTextColor
property color badgeTextColor: plasmoid.configuration.badgeTextColor
```

Utiliser `property string` à la place si la couleur est concaténée dans du texte
(ex. weathermahi injecte `primaryColor` dans des SVG via `svg.replace(/currentColor/g, …)`).

Dans l'interface, utiliser `root.xxxColor` plutôt que `Kirigami.Theme.*`, pour que le widget suive la palette.

### Mise en page de l'onglet `configColors.qml`

1. **🎨 Palette de couleurs** : grille de 3 colonnes, un bouton par preset (nom + 4 bandes primary/secondary/accent/tertiary). Un clic appelle `applyTheme(index)`, qui remplit les 8 rôles puis `applySpecialColors(colors)`.
2. **Couleurs personnalisées** : un `ColorPicker` par rôle (aperçu cliquable → dialogue avec nuancier de 36 couleurs, code hex, champ de saisie), chacun lié à un `QQC2.TextField` invisible porteur du `cfg_`.
3. **Contour** : case « Contour du widget » (`widgetBorderEnabled`), voir ci-dessous.
4. **Couleurs spéciales** (facultatif) : couleurs propres à la plasmoid.

Les 10 presets (Rengoku, Sorbet, Ken & Barbie, Sailor Moon, Sailor Mars, Summer Time, Sweet Bun, One Punch, Marimo, La Haine) sont les mêmes partout. Pour ajouter ou modifier un preset, le faire dans **toutes** les plasmoids **et** dans
`mahitheme-cli/themes.json` (lu par le script `mahitheme` et la plasmoid mahitheme ; installé en lien dans
`~/.config/mahitheme/themes.json`).

### Couleurs spéciales

Une couleur propre à une plasmoid (ex. bouton pause de mahify) :

- garde un nom de clé explicite (`pauseButtonColor`, `progressBarColor`, `unitIndicatorColor`), dans le groupe `Colors` ;
- est déclarée uniquement dans les deux blocs `// ========== SPÉCIFIQUE : couleurs spéciales ==========` de `configColors.qml` : le `cfg_` + `applySpecialColors()` en haut, la section « Couleurs spéciales » dans le `FormLayout` ;
- prend la couleur `accent` (ou un autre rôle) quand on clique sur un preset, via `applySpecialColors(colors)`.

Sans couleur spéciale, le bloc du haut contient `// (aucune couleur spéciale)` et un `applySpecialColors` vide, et la section de l'interface est supprimée (cf. mahifind, cheaty).

| Plasmoid | Couleurs spéciales |
|---|---|
| mahify | `pauseButtonColor`, `progressBarColor` |
| weathermahi | `unitIndicatorColor` |
| mahifind, cheaty, mahistats, mahitheme | aucune |

### Contour du widget

Le fond principal a un contour couleur `tertiaryColor`, réglé par deux clés :

| Clé | Groupe `main.xml` | Type / défaut | Onglet |
|---|---|---|---|
| `widgetBorderEnabled` | `Colors` (après les 8 rôles, avant les couleurs spéciales) | `Bool` / `true` | Couleurs, section « Contour » |
| `widgetBorderWidth` | `Sizes` (après `borderRadius`) | `Int` / `1` | Tailles, section ⚙️ Autres |

```qml
// main.qml
property bool widgetBorderEnabled: plasmoid.configuration.widgetBorderEnabled
property int widgetBorderWidth: plasmoid.configuration.widgetBorderWidth

// sur chaque fond principal (popup, et vue compacte si elle a son propre fond sur le bureau)
border.color: root.tertiaryColor
border.width: root.widgetBorderEnabled ? root.widgetBorderWidth : 0
```

Pas de clé de couleur : le contour suit les presets et le script `mahitheme` sans rien ajouter à
`applySpecialColors()`. Le contour se pose directement sur le fond, y compris avec `anchors.margins: -10`
(anti-cadre gris) : il reste entièrement visible. Pas d'ombre portée (Plasma ombre déjà ses popups).

Le contour concerne les plasmoids posées sur le bureau. Une plasmoid uniquement de panneau, déjà encadrée
par Plasma, peut s'en passer : elle n'a alors ni les clés, ni la section « Contour », ni la ligne
« Épaisseur du contour ».

| Plasmoid | Fonds avec contour |
|---|---|
| mahify, cheaty | `fullRepresentation` |
| mahistats | `FullMode.qml` (la vue compacte, sans fond, n'apparaît que dans un panneau) |
| weathermahi | `FullRepresentation.qml` + fond de la vue compacte |
| mahifind | `FullMode.qml` + `CompactMode.qml` |
| mahitheme | aucun (panneau uniquement) |

## Standard des tailles (MahiTheme)

Même principe que les couleurs : mêmes clés, même onglet, blocs `SPÉCIFIQUE` pour le reste.

### Fichiers

| Fichier | Rôle |
|---|---|
| `contents/config/config.qml` | déclare l'onglet `Tailles` (icône `transform-scale`), juste après `Couleurs` |
| `contents/config/main.xml` | groupe `Sizes` avec les clés standard (+ tailles spéciales), type `Int` |
| `contents/ui/configSizes.qml` | la page de l'onglet, **identique partout** sauf les blocs `SPÉCIFIQUE` et `VUE COMPACTE` |
| `contents/ui/main.qml` | expose les tailles sur `root` (`property int xxx: plasmoid.configuration.xxx`) |

Les tailles ne vont jamais dans `configGeneral.qml` ni dans un autre onglet. Toutes les valeurs sont en **px**
(`font.pixelSize`, jamais `font.pointSize`). Pas de valeur de secours `|| 6` dans `main.qml` :
`main.xml` fournit déjà le défaut, et `||` transformerait un 0 légitime (arrondi nul) en valeur de secours.

### Les clés standard

| Section | Clé | Usage |
|---|---|---|
| Textes | `titleFontSize` | titre principal |
| Textes | `textFontSize` | texte courant (noms, descriptions, libellés, code) |
| Textes | `smallFontSize` | petit texte (chemins, légendes, temps, pied de page) |
| Icônes | `compactIconSize` | icône du panneau — **seulement si la plasmoid a sa propre `compactRepresentation`** |
| Autres | `borderRadius` | arrondi des fonds, cartes, champs, boutons |
| Autres | `widgetBorderWidth` | épaisseur du contour du widget (cf. « Contour du widget ») — **sauf plasmoid uniquement de panneau** |

Valeurs par défaut : les tailles d'origine de chaque plasmoid (elles diffèrent d'une plasmoid à l'autre).

### Mise en page de l'onglet `configSizes.qml`

Un `Kirigami.FormLayout` en 3 sections, chacune avec les tailles standard puis un bloc `SPÉCIFIQUE` :

1. **📝 Textes** : titre, texte, petit texte + textes spécifiques.
2. **🎯 Icônes** : vue compacte (bloc `VUE COMPACTE`) + icônes spécifiques.
3. **⚙️ Autres** : arrondi des coins, épaisseur du contour + autres spécifiques.

Chaque valeur est un `SizeSpinBox` (composant du fichier : `QQC2.SpinBox` affichant « N px »).
Une unité différente reste possible pour une taille spéciale (ex. pochette de mahify en unités de grille).
Le bloc de propriétés `cfg_` en haut du fichier a aussi son bloc `SPÉCIFIQUE` et son bloc `VUE COMPACTE`.
Sans `compactRepresentation`, supprimer les deux blocs `VUE COMPACTE` (cf. mahify, mahifind).
Pas de message d'information dans l'onglet.

### Tailles dérivées

Une taille écrite en dur proche d'une taille standard s'exprime en écart par rapport à elle, pour que le
rendu par défaut reste identique au pixel et que tout suive quand on change la taille standard :

```qml
font.pixelSize: root.titleFontSize - 4              // titre du mode compact
font.pixelSize: root.smallFontSize + 1              // indication sous un message
radius: Math.max(0, root.borderRadius - 2)          // survol, plus arrondi que le fond
Layout.preferredWidth: root.resultIconSize + 16     // cadre autour d'une icône
```

Un écart négatif sur un arrondi passe toujours par `Math.max(0, …)`.

**Restent écrits en dur** : cercles et pilules (arrondi = moitié de la hauteur), dimensions du widget,
bordures, séparateurs, espacements et marges, tailles système (`Kirigami.Units.iconSizes.*`).
Ne pas utiliser `Kirigami.Heading` pour un titre réglable : il impose sa taille via `font.pointSize` ;
utiliser un `PlasmaComponents.Label` avec `font.pixelSize: root.titleFontSize`.

### Tailles spéciales

| Plasmoid | Textes | Icônes | Autres |
|---|---|---|---|
| weathermahi | `compactTempSize`, `compactCitySize`, `fullTempSize`, `detailValueSize`, `forecastDaySize`, `forecastTempSize` | `fullMainIconSize`, `detailIconSize`, `forecastIconSize` | — |
| mahify | — | `albumSize` (unités de grille), `buttonSize` | — |
| mahifind | `badgeFontSize` | `resultIconSize` | — |
| cheaty | — | `sheetIconSize` | — |
| mahistats | — | `gaugeSize` | `graphHeight`, `barHeight`, `compactBarWidth` |
| mahitheme | — | — | — |

`compactIconSize` : weathermahi, cheaty, mahistats et mahitheme uniquement.

## Convention des commentaires

- **Tout en français**, y compris les termes courants (« secours » et non « fallback », « survol » et non « hover »).
  Les noms de code (`primaryColor`, `MultiEffect`, `FolderListModel`…) restent tels quels.
- **Le pourquoi, pas le quoi** : un commentaire explique un choix, un piège ou une contrainte
  (« Nouvel objet : modifier expandedSections sur place ne notifierait pas les liaisons »). Pas de commentaire
  qui paraphrase le code (`// Bouton de copie` au-dessus du bouton « Copier »), ni de commentaire obsolète
  (`// ✨ FIXÉ ICI`, renvoi vers un ancien emplacement). Un libellé reste permis quand le code ne dit pas ce qu'il
  est (un `Rectangle` qui sert de bouton, un code d'icône OpenWeatherMap).
- **Titres de section** : une seule ligne, en majuscules, sur le modèle des marqueurs du standard. Une précision
  éventuelle va sur la ligne suivante, en commentaire normal. Pas de bannière de trois lignes.
  ```qml
  // ========== HISTORIQUE ==========
  // 5 min, un point toutes les 2 s
  ```
  Dans `main.xml` : `<!-- ========== TAILLES STANDARD ========== -->` (même forme, précision éventuelle en minuscules
  après « : », comme `<!-- ========== TAILLES SPÉCIALES : icônes ========== -->`).
- **Noms de section récurrents** : `REPRÉSENTATION COMPACTE` / `REPRÉSENTATION COMPLÈTE` pour
  `compactRepresentation` / `fullRepresentation` (ne pas écrire `VUE COMPACTE`, réservé au marqueur de
  `configSizes.qml`), `PROPRIÉTÉS`, `INITIALISATION`, `EN-TÊTE`, `FONCTIONS`.
- **En-tête de fichier** (facultatif) : commentaire simple de une à trois lignes, sans bannière,
  `// Nom : rôle du fichier` (+ crédits et licence s'il s'agit d'une adaptation, cf. cheaty).
- **Uniquement `//`** en QML/JS : pas de `/* */` ni de `/** */`.
- **Marqueurs du standard intouchables** : `// ========== SPÉCIFIQUE… ==========`, `// ========== FIN SPÉCIFIQUE ==========`,
  `// ========== VUE COMPACTE ==========`, `// ========== FIN VUE COMPACTE ==========` restent exactement tels quels.
- Une passe sur les commentaires ne change aucune ligne de code : vérifier avec `git diff` que seules des lignes
  de commentaires (ou des commentaires de fin de ligne) ont changé.

## Nouvelle plasmoid : checklist

**Couleurs**

1. Copier `mahifind.MahiMahi99/contents/ui/configColors.qml` (version sans couleur spéciale) dans `contents/ui/`.
2. Ajouter le groupe `Colors` ci-dessus dans `contents/config/main.xml`.
3. Déclarer les 8 propriétés dans `main.qml` et colorer l'interface avec (fond principal = `Rectangle { color: root.bgColor }` en `fullRepresentation`).
4. Couleurs spéciales éventuelles : clé dans `Colors` + blocs `SPÉCIFIQUE` de `configColors.qml`, puis mettre à jour le tableau des couleurs spéciales.

**Tailles**

5. Copier `cheaty.MahiMahi99/contents/ui/configSizes.qml` dans `contents/ui/`, vider ses blocs `SPÉCIFIQUE`
   (retirer `sheetIconSize`) et supprimer les blocs `VUE COMPACTE` si la plasmoid n'a pas de `compactRepresentation`.
6. Ajouter un groupe `Sizes` dans `main.xml` : `titleFontSize`, `textFontSize`, `smallFontSize`, `borderRadius`
   (+ `compactIconSize`), avec les tailles réelles de la plasmoid comme défauts.
7. Déclarer ces propriétés `int` dans `main.qml` et les utiliser partout (`font.pixelSize`, `radius`, tailles d'icônes),
   avec des écarts pour les tailles dérivées.
8. Tailles spéciales éventuelles : clé dans `Sizes` + blocs `SPÉCIFIQUE` de `configSizes.qml`, puis mettre à jour le tableau des tailles spéciales.

**Contour** (plasmoid posée sur le bureau)

9. `widgetBorderEnabled` dans `Colors` et `widgetBorderWidth` dans `Sizes` (les `configColors.qml` et
   `configSizes.qml` copiés ont déjà la case et le réglage ; pour une plasmoid uniquement de panneau, les retirer).
10. Déclarer les deux propriétés dans `main.qml` et poser `border.color`/`border.width` sur chaque fond principal,
    puis mettre à jour le tableau des fonds avec contour.

**Onglets**

11. Déclarer les onglets dans `contents/config/config.qml`, dans cet ordre (`General` seulement s'il a du contenu) :
   ```qml
   ConfigCategory {
       name: i18n("General")
       icon: "configure"
       source: "configGeneral.qml"
   }
   ConfigCategory {
       name: i18n("Couleurs")
       icon: "preferences-desktop-color"
       source: "configColors.qml"
   }
   ConfigCategory {
       name: i18n("Tailles")
       icon: "transform-scale"
       source: "configSizes.qml"
   }
   ```
12. Vérifier : `xmllint --noout contents/config/main.xml`, `plasmoidviewer -a <dossier>`, puis redémarrer plasmashell
    et ouvrir le popup et chaque onglet de configuration.

**Publication**

13. Dossier et Id `<nom>.MahiMahi99`, `metadata.json` selon « Metadata » ci-dessous.
14. Logo `<Id>.svg` (ou `.png`) à la racine du paquet, `"Icon": "<Id>"`, puis `./install.sh --plasmoids --link`
    pour l'installer dans `~/.local/share/icons/hicolor/`.
15. Capture `screenshots/<nom>.png` (`<nom>-desktop.png` / `<nom>-taskbar.png` si les deux vues diffèrent),
    à vérifier avant publication : aucun chemin, nom d'utilisateur ou dossier personnel visible.
16. `README.md` (anglais) + `README.fr.md` (français) dans le dossier de la plasmoid, sur le modèle des autres :
    lien entre les deux langues, présentation, capture, Utilisation, Réglages, Installation, ligne Transparence.
    Ajouter la plasmoid au tableau des deux README généraux (`README.md` et `README.fr.md`).

Renommer ou déplacer une clé (couleur ou taille) fait revenir la valeur à sa valeur par défaut (pas de migration) :
pour les couleurs, il suffit de recliquer le preset.

## Script MahiTheme (thème global)

Source dans `mahitheme-cli/` (script, `themes.json`, unités `systemd/`, `README.md`), installée par
`./install.sh --cli` : `~/.local/bin/mahitheme`, `~/.config/mahitheme/themes.json` (jamais écrasé),
`~/.config/systemd/user/mahitheme-wallpaper.{service,timer}` (toujours copiés, jamais en lien).
Ici, `install.sh --cli --link` : le script et `themes.json` installés sont des liens vers le dépôt, on modifie donc
toujours `mahitheme-cli/`. Aucun chemin personnel en dur : `Path.home()`, dossiers XDG, et les variables
`MAHITHEME_THEMES` / `MAHITHEME_WALLPAPERS` (à déclarer dans `~/.config/environment.d/` pour la plasmoid et le timer).
La plasmoid appelle `$HOME/.local/bin/mahitheme`.

`mahitheme <nom>` applique un thème à tout KDE : schéma de couleurs généré dans
`~/.local/share/color-schemes/`, fond d'écran au hasard dans `<dossier Images>/Themes/<Nom>/`, et repeint en direct
toutes les plasmoids dont le `main.xml` a les 8 clés du groupe `Colors` (via `evaluateScript` de plasmashell).
Les couleurs spéciales y prennent `accent`, comme `applySpecialColors()`.
Un timer systemd utilisateur (`mahitheme-wallpaper.timer`) change le fond d'écran toutes les 15 minutes.

Rotation du fond d'écran, pilotée par le script (le widget mahitheme passe par lui pour tout) :

| Commande | Effet |
|---|---|
| `mahitheme --rotation on\|off` | `systemctl --user enable\|disable --now` du timer |
| `mahitheme --interval N` | écrit le drop-in `~/.config/systemd/user/mahitheme-wallpaper.timer.d/interval.conf` (1 à 1440 min) puis `daemon-reload` |
| `mahitheme --status [--json]` | état réel lu dans systemd : `{"rotation", "enabled", "interval", "next"}` |

Le drop-in redéclare `OnActiveSec=1min` : la ligne vide `OnUnitActiveSec=` efface tous les déclencheurs
monotones, et sans `OnActiveSec` le timer reste bloqué en `elapsed` après un `enable`. Pas de `restart` du
timer après un changement d'intervalle : il relancerait le service tout de suite si l'échéance est dépassée.
Rotation désactivée, changer de thème choisit quand même un fond au hasard dans le dossier du thème.

## Publication GitHub

Dépôt public : https://github.com/k4hi99/mahimahi-plasmoids (compte `k4hi99`, nom public **MahiMahi99**).

### Branches

| Branche | Rôle |
|---|---|
| `main`, `prep-github` | historique complet, **local uniquement** (jamais poussé) |
| `public` | ce qui est publié : historique à part, né d'un seul commit « Première publication » |

Le dossier de travail est l'installation active : un `git switch` ajoute ou retire des widgets en direct.
Ne jamais faire de checkout de `public`. Elle est construite depuis la branche courante sans toucher au disque,
sur un index temporaire, en retirant ce qui ne se publie pas :

```bash
export GIT_INDEX_FILE="$(mktemp -u)"
git read-tree HEAD
git rm -r --cached -q com.github.idityage.spacerdivider luisbocanegra.panelspacer.extended org.kde.latte.spacer \
    "cheaty.MahiMahi99/contents/refdocs/Situations" "cheaty.MahiMahi99/contents/refdocs/Fedora KDE"
tree="$(git write-tree)"
rm -f "$GIT_INDEX_FILE"; unset GIT_INDEX_FILE
git diff --stat public "$tree"     # vérifier ce qui part
git branch -f public "$(git -c user.name=MahiMahi99 commit-tree "$tree" -p public -m "Description courte")"
git push origin public:main
```

**Exclus du public** : les 3 plasmoids tierces, et les fiches Cheaty personnelles `Situations` et `Fedora KDE`
(elles restent en local, dans le dépôt privé). Toute nouvelle exclusion s'ajoute à la commande ci-dessus.

### Avant chaque publication (audit)

Rien de personnel dans les fichiers publiés : pas de clé API ni de jeton (les clés restent dans la configuration
de l'utilisateur, défaut vide dans `main.xml`), pas de chemin `/home/<utilisateur>` (utiliser `~`, `$HOME`,
`StandardPaths` ou un défaut vide), pas de nom d'utilisateur ou de machine, pas d'autre e-mail que
mahicala@gmail.com (sauf exemples factices).

```bash
git grep -nIE "/home/|$(whoami)|$(hostname -s)" "$tree"
```

### Metadata

Tous les `metadata.json` suivent le même modèle (clés triées comme ci-dessous, indentation 4) :

```json
{
    "KPackageStructure": "Plasma/Applet",
    "KPlugin": {
        "Authors": [{ "Email": "mahicala@gmail.com", "Name": "MahiMahi99" }],
        "Category": "Utilities",
        "Description": "Phrase complète en français : ce que fait la plasmoid, et ce qu'il lui faut.",
        "Icon": "<Id>",
        "Id": "<nom>.MahiMahi99",
        "License": "GPL-3.0-or-later",
        "Name": "MahiXxx",
        "Version": "1.0.0",
        "Website": "https://github.com/k4hi99/mahimahi-plasmoids"
    },
    "X-Plasma-API-Minimum-Version": "6.0"
}
```

Version en `MAJEUR.MINEUR.CORRECTIF`. Pas de `X-Plasma-Provides` ni de `X-Plasma-ConfigPlugins`.

### Logos

Nom d'icône = **Id du plugin**. Le fichier `<Id>.svg` (ou `<Id>.png` à défaut de SVG) est à la racine du paquet,
`"Icon": "<Id>"` dans `metadata.json`, et `install.sh` l'installe dans `~/.local/share/icons/hicolor/scalable/apps/`
(PNG : `256x256/apps/`). Ici, ce sont des liens vers le dépôt.

| Plasmoid | Logo |
|---|---|
| mahifind, mahify, weathermahi, mahistats | `<Id>.svg` |
| cheaty | `cheaty.MahiMahi99.png` (aussi affiché dans le widget) |
| mahitheme | aucun : icône système `kcolorchooser` |

Les autres images d'un paquet (ex. `logo.png`, `foldermf.png` de mahifind) sont des éléments d'interface,
hors convention.

### Licence et crédits

`LICENSE` = texte de la GPL-3.0. Plasmoids et script : `GPL-3.0-or-later`. **Cheaty** : `GPL-3.0-only`, car c'est
une adaptation de l'applet Cinnamon « Cheaty » de centurix (`cheaty@centurix`,
https://cinnamon-spices.linuxmint.com/applets/view/285, dépôt `linuxmint/cinnamon-spices-applets` sous GPL-3.0).
Le crédit à centurix reste dans son `metadata.json` (2ᵉ auteur), l'en-tête de son `main.qml`, le `README.md`, et
le champ `author` des fiches reprises de l'original (`Markdown`, `HTTP Status Codes`). Les autres fiches, dont
`Bootstrap5` (l'original couvrait Twitter Bootstrap), ont `"author": "MahiMahi99"`.
