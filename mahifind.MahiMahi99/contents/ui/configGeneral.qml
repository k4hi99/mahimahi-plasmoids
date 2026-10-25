import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: configRoot
    
    // ========== PROPRIÉTÉS ==========
    property alias cfg_homeDirectory: homeDirField.text
    property alias cfg_scanDepth: depthSpinBox.value
    property alias cfg_maxResults: maxResultsSpinBox.value
    property alias cfg_autoScan: autoScanCheckBox.checked
    property alias cfg_excludedFolders: excludedField.text
    
    // Pas d'alias : écrit par le ButtonGroup des boutons radio du mode
    property string cfg_displayMode: "full"
    
    Kirigami.FormLayout {
        
        // ========== MODE D'AFFICHAGE ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Mode d'affichage"
        }
        
        QQC2.ButtonGroup {
            id: displayModeGroup
            onCheckedButtonChanged: {
                if (checkedButton) {
                    cfg_displayMode = checkedButton.value
                }
            }
        }
        
        ColumnLayout {
            Kirigami.FormData.label: "Mode:"
            spacing: Kirigami.Units.smallSpacing
            
            QQC2.RadioButton {
                text: "Full (fenêtre complète)"
                property string value: "full"
                QQC2.ButtonGroup.group: displayModeGroup
                checked: cfg_displayMode === "full"
            }
            
            QQC2.RadioButton {
                text: "Compact (interface réduite)"
                property string value: "compact"
                QQC2.ButtonGroup.group: displayModeGroup
                checked: cfg_displayMode === "compact"
            }
        }
        
        QQC2.Label {
            text: "💡 Ce widget fonctionne uniquement sur le bureau, pas dans le panel"
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
        
        // ========== SCAN ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Configuration du scan"
        }
        
        QQC2.TextField {
            id: homeDirField
            Kirigami.FormData.label: "Dossier de départ:"
            placeholderText: "Dossier personnel"
            Layout.fillWidth: true
        }
        
        QQC2.SpinBox {
            id: depthSpinBox
            Kirigami.FormData.label: "Profondeur de scan:"
            from: 1
            to: 20
            stepSize: 1
            
            QQC2.ToolTip {
                text: "Nombre de niveaux de sous-dossiers à scanner"
            }
        }
        
        RowLayout {
            Kirigami.FormData.label: "Profondeur actuelle:"
            
            QQC2.Label {
                text: depthSpinBox.value + " niveau(x)"
            }
            
            QQC2.Label {
                text: depthSpinBox.value > 15 ? "⚠️ Peut être lent !" : depthSpinBox.value > 10 ? "💪 Beast mode" : "✅ Normal"
                opacity: 0.7
            }
        }
        
        QQC2.CheckBox {
            id: autoScanCheckBox
            text: "Scanner automatiquement au démarrage"
            Kirigami.FormData.label: "Auto-scan:"
        }
        
        // ========== RÉSULTATS ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Affichage des résultats"
        }
        
        QQC2.SpinBox {
            id: maxResultsSpinBox
            Kirigami.FormData.label: "Résultats max:"
            from: 10
            to: 200
            stepSize: 10
        }
        
        // ========== EXCLUSIONS ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "🚫 Dossiers exclus"
        }
        
        QQC2.TextArea {
            id: excludedField
            Kirigami.FormData.label: "Dossiers à ignorer:"
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            placeholderText: "Séparez les noms par des virgules"
            wrapMode: TextEdit.Wrap
        }
        
        QQC2.Label {
            text: "💡 Seuls les dossiers listés ici sont ignorés (noms exacts, dossiers cachés compris : .git, .cache…)"
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
        
        // ========== INFORMATIONS ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "ℹ️ Informations"
        }
        
        QQC2.Label {
            text: "⚠️ Après modification, clique sur le bouton refresh dans le plasmoid pour appliquer"
           font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }
}
