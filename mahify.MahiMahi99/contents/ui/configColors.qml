import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

// Onglet "Couleurs" standard MahiTheme — voir CLAUDE.md à la racine des plasmoids.
// Ce fichier est identique dans toutes les plasmoids, sauf les blocs marqués SPÉCIFIQUE.
KCM.SimpleKCM {
    id: configRoot

    // ========== 8 RÔLES STANDARD ==========
    property alias cfg_primaryColor: primaryColorField.text
    property alias cfg_secondaryColor: secondaryColorField.text
    property alias cfg_accentColor: accentColorField.text
    property alias cfg_tertiaryColor: tertiaryColorField.text
    property alias cfg_bgColor: bgColorField.text
    property alias cfg_textColor: textColorField.text
    property alias cfg_secTextColor: secTextColorField.text
    property alias cfg_badgeTextColor: badgeTextColorField.text

    // ========== CONTOUR DU WIDGET ==========
    property alias cfg_widgetBorderEnabled: widgetBorderCheck.checked

    // ========== SPÉCIFIQUE : couleurs spéciales ==========
    property alias cfg_pauseButtonColor: pauseColorField.text
    property alias cfg_progressBarColor: progressColorField.text

    function applySpecialColors(colors) {
        pauseColorField.text = colors.accent
        progressColorField.text = colors.accent
    }
    // ========== FIN SPÉCIFIQUE ==========

    property var themes: [
        {
            name: "Rengoku",
            colors: {
                primary: "#A3122A",
                secondary: "#FFB347",
                accent: "#FF7A1A",
                tertiary: "#D7263D",
                bg: "#FFF4E6",
                text: "#2B0A0E",
                secText: "#7A3B2E",
                badgeText: "#FFFFFF"
            }
        },
        {
            name: "Sorbet",
            colors: {
                primary: "#C8154C",
                secondary: "#FFD15C",
                accent: "#3FAE8C",
                tertiary: "#F7A8B8",
                bg: "#FFEEDD",
                text: "#3A0A18",
                secText: "#7A4A52",
                badgeText: "#FFFFFF"
            }
        },
        {
            name: "Ken & Barbie",
            colors: {
                primary: "#036D7A",
                secondary: "#FFBACF",
                accent: "#F2729A",
                tertiary: "#024B54",
                bg: "#F4FAFB",
                text: "#0B2226",
                secText: "#41676C",
                badgeText: "#FFFFFF"
            }
        },
        {
            name: "Sailor Moon",
            colors: {
                primary: "#8F93C0",
                secondary: "#3A3E66",
                accent: "#FFD166",
                tertiary: "#5C608A",
                bg: "#282B4A",
                text: "#F0F1FA",
                secText: "#A0A4C8",
                badgeText: "#282B4A"
            }
        },
        {
            name: "Sailor Mars",
            colors: {
                primary: "#C4142A",
                secondary: "#5B2A6E",
                accent: "#FF8C1A",
                tertiary: "#8E1C2C",
                bg: "#1A0F1F",
                text: "#FBE9EC",
                secText: "#D8B4C4",
                badgeText: "#FFFFFF"
            }
        },
        {
            name: "Summer Time",
            colors: {
                primary: "#8AACCF",
                secondary: "#FEDF85",
                accent: "#F5BC52",
                tertiary: "#A7C6E3",
                bg: "#FEF1CD",
                text: "#1F3144",
                secText: "#576D85",
                badgeText: "#4A3400"
            }
        },
        {
            name: "Sweet Bun",
            colors: {
                primary: "#836A8A",
                secondary: "#455973",
                accent: "#587891",
                tertiary: "#47455D",
                bg: "#1E3D51",
                text: "#E3DCE5",
                secText: "#EDE8EE",
                badgeText: "#F6F3F6"
            }
        },
        {
            name: "One Punch",
            colors: {
                primary: "#E60019",
                secondary: "#B63E2A",
                accent: "#A6843D",
                tertiary: "#69251F",
                bg: "#F9C75F",
                text: "#7E2D26",
                secText: "#7E2D26",
                badgeText: "#DFE2E2"
            }
        },
        {
            name: "Marimo",
            colors: {
                primary: "#15675B",
                secondary: "#113A30",
                accent: "#D09427",
                tertiary: "#23A995",
                bg: "#0D2A29",
                text: "#FAFFDE",
                secText: "#F6FFC2",
                badgeText: "#FAFFDE"
            }
        },
        {
            name: "La Haine",
            colors: {
                primary: "#40403E",
                secondary: "#282929",
                accent: "#444542",
                tertiary: "#5B5C59",
                bg: "#131515",
                text: "#F0F0F3",
                secText: "#F0F0F3",
                badgeText: "#F6F6F9"
            }
        }
    ]

    function applyTheme(index) {
        const colors = themes[index].colors
        primaryColorField.text = colors.primary
        secondaryColorField.text = colors.secondary
        accentColorField.text = colors.accent
        tertiaryColorField.text = colors.tertiary
        bgColorField.text = colors.bg
        textColorField.text = colors.text
        secTextColorField.text = colors.secText
        badgeTextColorField.text = colors.badgeText
        applySpecialColors(colors)
    }

    Kirigami.FormLayout {

        // ========== PRESETS ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "🎨 Palette de couleurs"
        }

        GridLayout {
            Kirigami.FormData.label: "Presets:"
            columns: 3
            columnSpacing: Kirigami.Units.smallSpacing
            rowSpacing: Kirigami.Units.smallSpacing
            Layout.fillWidth: true

            Repeater {
                model: themes

                QQC2.Button {
                    text: ""
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    leftPadding: 12
                    rightPadding: 12
                    topPadding: 8
                    bottomPadding: 8

                    contentItem: RowLayout {
                        spacing: 12

                        QQC2.Label {
                            text: modelData.name
                            color: Kirigami.Theme.textColor
                            Layout.fillWidth: true
                        }

                        Row {
                            spacing: 3

                            Rectangle { width: 5; height: 22; color: modelData.colors.primary; radius: 2 }
                            Rectangle { width: 5; height: 22; color: modelData.colors.secondary; radius: 2 }
                            Rectangle { width: 5; height: 22; color: modelData.colors.accent; radius: 2 }
                            Rectangle { width: 5; height: 22; color: modelData.colors.tertiary; radius: 2 }
                        }
                    }

                    onClicked: applyTheme(index)
                }
            }
        }

        // ========== COULEURS PERSONNALISÉES ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Couleurs personnalisées"
        }

        ColorPicker {
            Kirigami.FormData.label: "Primaire:"
            colorField: primaryColorField
            colorName: "Couleur principale"
        }
        QQC2.TextField { id: primaryColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Secondaire:"
            colorField: secondaryColorField
            colorName: "Couleur secondaire"
        }
        QQC2.TextField { id: secondaryColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Accent:"
            colorField: accentColorField
            colorName: "Couleur accent"
        }
        QQC2.TextField { id: accentColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Tertiaire:"
            colorField: tertiaryColorField
            colorName: "Couleur tertiaire"
        }
        QQC2.TextField { id: tertiaryColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Fond:"
            colorField: bgColorField
            colorName: "Fond principal"
        }
        QQC2.TextField { id: bgColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Texte:"
            colorField: textColorField
            colorName: "Texte principal"
        }
        QQC2.TextField { id: textColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Texte sec.:"
            colorField: secTextColorField
            colorName: "Texte secondaire"
        }
        QQC2.TextField { id: secTextColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Texte badges:"
            colorField: badgeTextColorField
            colorName: "Texte des badges"
        }
        QQC2.TextField { id: badgeTextColorField; visible: false }

        // ========== CONTOUR ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Contour"
        }

        QQC2.CheckBox {
            id: widgetBorderCheck
            Kirigami.FormData.label: "Contour du widget:"
            text: "Couleur Tertiaire"
        }

        // ========== SPÉCIFIQUE : couleurs spéciales ==========
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Couleurs spéciales"
        }

        ColorPicker {
            Kirigami.FormData.label: "Bouton pause:"
            colorField: pauseColorField
            colorName: "Bouton pause"
        }
        QQC2.TextField { id: pauseColorField; visible: false }

        ColorPicker {
            Kirigami.FormData.label: "Progression:"
            colorField: progressColorField
            colorName: "Barre de progression"
        }
        QQC2.TextField { id: progressColorField; visible: false }
        // ========== FIN SPÉCIFIQUE ==========
    }

    // ========== COMPOSANT SÉLECTEUR DE COULEUR ==========
    component ColorPicker: RowLayout {
        required property var colorField
        required property string colorName

        spacing: Kirigami.Units.smallSpacing
        Layout.fillWidth: true
        Layout.maximumWidth: 400

        Rectangle {
            width: 50
            height: 30
            radius: 5
            border.color: "#ffffff"
            border.width: 1
            color: colorField.text

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: colorDialog.openForField(colorField, colorName)
            }
        }

        QQC2.Label {
            text: colorField.text
            opacity: 0.7
            Layout.preferredWidth: 80
        }

        QQC2.TextField {
            text: colorField.text
            placeholderText: "#000000"
            Layout.preferredWidth: 100

            onEditingFinished: {
                if (text.match(/^#[0-9A-Fa-f]{6}$/)) {
                    colorField.text = text
                }
            }
        }
    }

    // ========== DIALOGUE DE COULEUR ==========
    Kirigami.Dialog {
        id: colorDialog
        title: "Choisir une couleur"

        property var targetField: null
        property string targetName: ""

        function openForField(field, name) {
            targetField = field
            targetName = name
            customColorField.text = field.text
            open()
        }

        ColumnLayout {
            QQC2.Label {
                text: colorDialog.targetName
                font.bold: true
            }

            QQC2.Label {
                text: "Couleur (hex):"
            }

            QQC2.TextField {
                id: customColorField
                placeholderText: "#836A8A"
                Layout.fillWidth: true
            }

            GridLayout {
                columns: 8
                Layout.fillWidth: true

                Repeater {
                    model: [
                        "#836A8A", "#455973", "#587891", "#47455D",
                        "#E60019", "#B63E2A", "#A6843D", "#69251F",
                        "#15675B", "#113A30", "#D09427", "#23A995",
                        "#40403E", "#282929", "#444542", "#5B5C59",
                        "#EFA9AC", "#6C2B37", "#B3495A", "#E98A8E",
                        "#F1C864", "#93B8CD", "#EDDA96", "#F5ECC9",
                        "#E24F85", "#D4C2BE", "#EEAAB5", "#F2BDC6",
                        "#F08891", "#505253", "#80D991", "#ECDA69",
                        "#024578", "#B23614", "#024C84", "#0074B8"
                    ]

                    Rectangle {
                        width: 30
                        height: 30
                        radius: 4
                        color: modelData
                        border.color: "#ffffff"
                        border.width: 1

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: customColorField.text = modelData
                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight

                QQC2.Button {
                    text: "Annuler"
                    onClicked: colorDialog.close()
                }

                QQC2.Button {
                    text: "Appliquer"
                    onClicked: {
                        if (customColorField.text.match(/^#[0-9A-Fa-f]{6}$/)) {
                            colorDialog.targetField.text = customColorField.text
                            colorDialog.close()
                        }
                    }
                }
            }
        }
    }
}
