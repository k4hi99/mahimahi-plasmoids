import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: configRoot

    // ========== VUE COMPLÈTE ==========
    property string cfg_fullLayout: "gauges"
    property alias cfg_showHistory: showHistoryCheck.checked

    // ========== VUE COMPACTE ==========
    property string cfg_compactStyle: "bars"
    property alias cfg_ramShowPercent: ramPercentCheck.checked

    // ========== SEUILS D'ALERTE ==========
    property alias cfg_tempThreshold: tempThresholdSpin.value
    property alias cfg_ramThreshold: ramThresholdSpin.value
    property alias cfg_batteryLowThreshold: batteryThresholdSpin.value

    Kirigami.FormLayout {

        // ========== VUE COMPLÈTE ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "🖼️ Vue complète"
        }

        QQC2.RadioButton {
            Kirigami.FormData.label: "Disposition:"
            text: "Jauges"
            checked: configRoot.cfg_fullLayout === "gauges"
            onToggled: if (checked) configRoot.cfg_fullLayout = "gauges"
        }

        QQC2.RadioButton {
            text: "Barres"
            checked: configRoot.cfg_fullLayout === "bars"
            onToggled: if (checked) configRoot.cfg_fullLayout = "bars"
        }

        QQC2.CheckBox {
            id: showHistoryCheck
            Kirigami.FormData.label: "Historique:"
            text: "Afficher l'historique (5 min)"
        }

        // ========== VUE COMPACTE ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "📊 Vue compacte"
        }

        QQC2.RadioButton {
            Kirigami.FormData.label: "Style:"
            text: "Barres"
            checked: configRoot.cfg_compactStyle === "bars"
            onToggled: if (checked) configRoot.cfg_compactStyle = "bars"
        }

        QQC2.RadioButton {
            text: "Texte seul"
            checked: configRoot.cfg_compactStyle === "text"
            onToggled: if (checked) configRoot.cfg_compactStyle = "text"
        }

        QQC2.CheckBox {
            id: ramPercentCheck
            Kirigami.FormData.label: "RAM:"
            text: "Afficher en % (au lieu de Go)"
        }

        // ========== SEUILS D'ALERTE ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "⚠️ Seuils d'alerte (valeur en couleur accent)"
        }

        UnitSpinBox {
            id: tempThresholdSpin
            Kirigami.FormData.label: "Température CPU ≥"
            unit: " °C"
            from: 40
            to: 110
        }

        UnitSpinBox {
            id: ramThresholdSpin
            Kirigami.FormData.label: "RAM ≥"
            unit: " %"
            from: 10
            to: 100
        }

        UnitSpinBox {
            id: batteryThresholdSpin
            Kirigami.FormData.label: "Batterie faible ≤"
            unit: " %"
            from: 0
            to: 100
        }
    }

    // ========== COMPOSANT SPINBOX AVEC UNITÉ ==========
    component UnitSpinBox: QQC2.SpinBox {
        property string unit: ""
        stepSize: 1
        textFromValue: function(value) { return value + unit }
        valueFromText: function(text) { return parseInt(text) }
    }
}
