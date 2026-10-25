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

    // ========== VUE COMPACTE ==========
    property alias cfg_compactIconSize: compactIconSpin.value
    // ========== FIN VUE COMPACTE ==========

    // ========== SPÉCIFIQUE : tailles spéciales ==========
    property alias cfg_compactTempSize: compactTempSpin.value
    property alias cfg_compactCitySize: compactCitySpin.value
    property alias cfg_fullTempSize: fullTempSpin.value
    property alias cfg_detailValueSize: detailValueSpin.value
    property alias cfg_forecastDaySize: forecastDaySpin.value
    property alias cfg_forecastTempSize: forecastTempSpin.value
    property alias cfg_fullMainIconSize: fullMainIconSpin.value
    property alias cfg_detailIconSize: detailIconSpin.value
    property alias cfg_forecastIconSize: forecastIconSpin.value
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
            id: compactTempSpin
            Kirigami.FormData.label: "Vue compacte - Température:"
            from: 8
            to: 48
        }

        SizeSpinBox {
            id: compactCitySpin
            Kirigami.FormData.label: "Vue compacte - Ville:"
            from: 6
            to: 24
        }

        SizeSpinBox {
            id: fullTempSpin
            Kirigami.FormData.label: "Vue complète - Température:"
            from: 16
            to: 64
        }

        SizeSpinBox {
            id: detailValueSpin
            Kirigami.FormData.label: "Détails - Valeurs:"
            from: 8
            to: 24
        }

        SizeSpinBox {
            id: forecastDaySpin
            Kirigami.FormData.label: "Prévisions - Jours:"
            from: 6
            to: 18
        }

        SizeSpinBox {
            id: forecastTempSpin
            Kirigami.FormData.label: "Prévisions - Températures:"
            from: 8
            to: 24
        }
        // ========== FIN SPÉCIFIQUE ==========

        // ========== ICÔNES ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "🎯 Icônes"
        }

        // ========== VUE COMPACTE ==========
        SizeSpinBox {
            id: compactIconSpin
            Kirigami.FormData.label: "Vue compacte:"
            from: 16
            to: 64
        }
        // ========== FIN VUE COMPACTE ==========

        // ========== SPÉCIFIQUE : icônes ==========
        SizeSpinBox {
            id: fullMainIconSpin
            Kirigami.FormData.label: "Vue complète - Principale:"
            from: 32
            to: 128
        }

        SizeSpinBox {
            id: detailIconSpin
            Kirigami.FormData.label: "Détails:"
            from: 16
            to: 48
        }

        SizeSpinBox {
            id: forecastIconSpin
            Kirigami.FormData.label: "Prévisions:"
            from: 16
            to: 64
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
