import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

// Onglet "Tailles" standard MahiTheme — voir CLAUDE.md à la racine des plasmoids.
// Ce fichier est identique dans toutes les plasmoids, sauf les blocs marqués SPÉCIFIQUE
// et le bloc VUE COMPACTE (à supprimer si la plasmoid n'a pas de compactRepresentation).
KCM.SimpleKCM {
    id: configRoot

    // ========== TAILLES STANDARD ==========
    property alias cfg_titleFontSize: titleFontSpin.value
    property alias cfg_textFontSize: textFontSpin.value
    property alias cfg_smallFontSize: smallFontSpin.value
    property alias cfg_borderRadius: borderRadiusSpin.value
    property alias cfg_widgetBorderWidth: widgetBorderWidthSpin.value


    // ========== SPÉCIFIQUE : tailles spéciales ==========
    property alias cfg_badgeFontSize: badgeFontSpin.value
    property alias cfg_resultIconSize: resultIconSpin.value
    // ========== FIN SPÉCIFIQUE ==========

    Kirigami.FormLayout {

        // ========== TEXTES ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "📝 Textes"
        }

        SizeSpinBox {
            id: titleFontSpin
            Kirigami.FormData.label: "Titre:"
            from: 10
            to: 48
        }

        SizeSpinBox {
            id: textFontSpin
            Kirigami.FormData.label: "Texte:"
            from: 8
            to: 32
        }

        SizeSpinBox {
            id: smallFontSpin
            Kirigami.FormData.label: "Petit texte:"
            from: 6
            to: 24
        }

        // ========== SPÉCIFIQUE : textes ==========
        SizeSpinBox {
            id: badgeFontSpin
            Kirigami.FormData.label: "Badges:"
            from: 8
            to: 24
        }
        // ========== FIN SPÉCIFIQUE ==========

        // ========== ICÔNES ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "🎯 Icônes"
        }


        // ========== SPÉCIFIQUE : icônes ==========
        SizeSpinBox {
            id: resultIconSpin
            Kirigami.FormData.label: "Résultats:"
            from: 16
            to: 48
        }
        // ========== FIN SPÉCIFIQUE ==========

        // ========== AUTRES ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "⚙️ Autres"
        }

        SizeSpinBox {
            id: borderRadiusSpin
            Kirigami.FormData.label: "Arrondi des coins:"
            from: 0
            to: 20
        }

        SizeSpinBox {
            id: widgetBorderWidthSpin
            Kirigami.FormData.label: "Épaisseur du contour:"
            from: 0
            to: 10
        }

        // ========== SPÉCIFIQUE : autres ==========
        // ========== FIN SPÉCIFIQUE ==========
    }

    // ========== COMPOSANT SPINBOX EN PX ==========
    component SizeSpinBox: QQC2.SpinBox {
        stepSize: 1
        textFromValue: function(value) { return value + " px" }
        valueFromText: function(text) { return parseInt(text) }
    }
}
