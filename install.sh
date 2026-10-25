#!/usr/bin/env bash
# Installation des plasmoids MahiMahi et du script mahitheme, pour l'utilisateur courant.
#
#   ./install.sh               tout installer (plasmoids + mahitheme)
#   ./install.sh --plasmoids   seulement les plasmoids (+ leurs logos)
#   ./install.sh --cli         seulement le script mahitheme (+ thèmes et timer systemd)
#   ./install.sh --link        liens symboliques vers le dépôt au lieu de copies
#                              (pour développer : une modification du dépôt est prise en compte tout de suite)

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
PLASMOIDS_DIR="$DATA_HOME/plasma/plasmoids"
ICONS_DIR="$DATA_HOME/icons/hicolor"
BIN_DIR="$HOME/.local/bin"
SYSTEMD_DIR="$CONFIG_HOME/systemd/user"

do_plasmoids=0
do_cli=0
link=0
for arg in "$@"; do
    case "$arg" in
        --plasmoids) do_plasmoids=1 ;;
        --cli) do_cli=1 ;;
        --link) link=1 ;;
        -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "install.sh : option inconnue $arg" >&2; exit 1 ;;
    esac
done
if (( !do_plasmoids && !do_cli )); then
    do_plasmoids=1
    do_cli=1
fi

# Copie ou lien symbolique, selon --link
put() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if (( link )); then
        ln -sfn "$src" "$dest"
    else
        rm -rf "$dest"
        cp -r "$src" "$dest"
    fi
}

install_plasmoids() {
    echo "== Plasmoids"
    local dir id
    for dir in "$REPO"/*.MahiMahi99; do
        [[ -f "$dir/metadata.json" ]] || continue
        id="$(basename "$dir")"
        # Dépôt cloné directement dans le dossier des plasmoids : rien à copier
        if [[ "$(realpath "$dir")" == "$(realpath -m "$PLASMOIDS_DIR/$id")" ]]; then
            echo "   $id (déjà en place)"
            continue
        fi
        put "$dir" "$PLASMOIDS_DIR/$id"
        echo "   $id"
    done
}

# Logo de chaque plasmoid : <Id>.svg ou <Id>.png à la racine du paquet, nom d'icône = Id (cf. metadata.json)
install_icons() {
    echo "== Icônes"
    local dir id
    for dir in "$REPO"/*.MahiMahi99; do
        id="$(basename "$dir")"
        if [[ -f "$dir/$id.svg" ]]; then
            put "$dir/$id.svg" "$ICONS_DIR/scalable/apps/$id.svg"
            echo "   scalable/apps/$id.svg"
        elif [[ -f "$dir/$id.png" ]]; then
            put "$dir/$id.png" "$ICONS_DIR/256x256/apps/$id.png"
            echo "   256x256/apps/$id.png"
        fi
    done
}

install_cli() {
    echo "== mahitheme"
    chmod +x "$REPO/mahitheme-cli/mahitheme"
    put "$REPO/mahitheme-cli/mahitheme" "$BIN_DIR/mahitheme"
    echo "   $BIN_DIR/mahitheme"

    # Les palettes ne sont jamais écrasées : elles peuvent avoir été personnalisées
    local themes="$CONFIG_HOME/mahitheme/themes.json"
    if [[ -e "$themes" || -L "$themes" ]]; then
        echo "   $themes (existant, conservé)"
    else
        put "$REPO/mahitheme-cli/themes.json" "$themes"
        echo "   $themes"
    fi

    # Unités systemd toujours copiées : systemd gère mal les unités en lien symbolique
    local unit
    mkdir -p "$SYSTEMD_DIR"
    for unit in mahitheme-wallpaper.service mahitheme-wallpaper.timer; do
        install -m 644 "$REPO/mahitheme-cli/systemd/$unit" "$SYSTEMD_DIR/$unit"
        echo "   $SYSTEMD_DIR/$unit"
    done
    systemctl --user daemon-reload || true

    case ":$PATH:" in
        *":$BIN_DIR:"*) ;;
        *) echo "   ! $BIN_DIR n'est pas dans le PATH : appeler le script par son chemin complet" ;;
    esac
    echo "   Rotation du fond d'écran : mahitheme --rotation on"
}

if (( do_plasmoids )); then
    install_plasmoids
    install_icons
fi
(( do_cli )) && install_cli

echo
echo "Terminé. Pour que Plasma voie les nouveautés : systemctl --user restart plasma-plasmashell"
