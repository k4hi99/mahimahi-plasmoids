import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Effects
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

// Mode compact : barre de recherche, résultats dans une liste déroulante
Item {
    id: compactMode
    
    implicitWidth: 400
    implicitHeight: 120
    
    Rectangle {
        id: mainRect
        anchors.fill: parent
        anchors.margins: -10  // Anti-cadre gris
        color: root.bgColor
        radius: Math.max(0, root.borderRadius - 2)
        border.color: root.tertiaryColor
        border.width: root.widgetBorderEnabled ? root.widgetBorderWidth : 0
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing
            
            // ========== EN-TÊTE ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: Qt.darker(root.bgColor, 1.1)
                radius: root.borderRadius + 2
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing
                    spacing: Kirigami.Units.smallSpacing
                    
                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        radius: 18
                        color: root.primaryColor
                        
                        Kirigami.Icon {
                            anchors.centerIn: parent
                            source: root.logoPath
                            width: 31
                            height: 31
                            color: root.bgColor
                        }
                    }
                    
                    QQC2.Label {
                        text: "MahiFind"
                        font.pixelSize: root.titleFontSize - 4
                        font.bold: true
                        color: root.textColor
                        Layout.fillWidth: true
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: statusLabel.width + 12
                        Layout.preferredHeight: 24
                        radius: 12
                        color: root.isScanning ? root.tertiaryColor : root.accentColor
                        
                        QQC2.Label {
                            id: statusLabel
                            anchors.centerIn: parent
                            text: root.isScanning ? "⏳ " + root.foldersCount : "✅ " + root.foldersCount
                            color: root.badgeTextColor
                            font.bold: true
                            font.pixelSize: root.badgeFontSize - 1
                        }
                    }
                    
                    // Bouton de rescan
                    Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        radius: 16
                        color: refreshMouse.containsMouse ? Qt.lighter(root.primaryColor, 1.2) : root.primaryColor
                        
                        Kirigami.Icon {
                            anchors.centerIn: parent
                            source: "view-refresh"
                            width: 18
                            height: 18
                            color: root.badgeTextColor
                        }
                        
                        MouseArea {
                            id: refreshMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.startScan()
                            
                            QQC2.ToolTip {
                                text: "Rescanner"
                                visible: refreshMouse.containsMouse
                            }
                        }
                    }
                }
            }
            
            // ========== BARRE DE RECHERCHE ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: root.borderRadius
                color: Qt.darker(root.bgColor, 1.1)
                border.color: searchField.activeFocus ? root.accentColor : root.primaryColor
                border.width: 2
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing
                    spacing: Kirigami.Units.smallSpacing
                    
                    Kirigami.Icon {
                        source: "search"
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        color: root.secTextColor
                    }
                    
                    QQC2.TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: root.isScanning ? "⏳ Scan..." : "🔎 Chercher"
                        
                        background: Rectangle {
                            color: "transparent"
                        }
                        
                        color: root.textColor
                        placeholderTextColor: root.secTextColor
                        
                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Escape) {
                                searchField.text = ""
                                dropdownPopup.close()
                                event.accepted = true
                            } else if (event.key === Qt.Key_Return) {
                                if (root.resultsModel.count > 0) {
                                    var firstItem = root.resultsModel.get(0)
                                    root.openFolder(firstItem.path)
                                    searchField.text = ""
                                    dropdownPopup.close()
                                    plasmoid.expanded = false
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Down) {
                                if (root.resultsModel.count > 0 && dropdownPopup.opened) {
                                    dropdownListView.forceActiveFocus()
                                    dropdownListView.currentIndex = 0
                                }
                                event.accepted = true
                            }
                        }
                        
                        onTextChanged: {
                            root.filterFolders(text)
                            if (text !== "" && root.resultsModel.count > 0) {
                                dropdownPopup.open()
                            } else {
                                dropdownPopup.close()
                            }
                        }
                        
                        Component.onCompleted: forceActiveFocus()
                    }
                    
                    // Bouton d'effacement de la recherche
Rectangle {
    visible: searchField.text !== ""
    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    radius: 12
    color: clearMouse.containsMouse ? Qt.lighter(root.accentColor, 1.3) : root.accentColor
    
    QQC2.Label {
        anchors.centerIn: parent
        text: "×"
        color: root.badgeTextColor
        font.bold: true
        font.pixelSize: root.badgeFontSize
    }
                        
                        MouseArea {
                            id: clearMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                searchField.text = ""
                                dropdownPopup.close()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ========== LISTE DÉROULANTE ==========
    QQC2.Popup {
        id: dropdownPopup
        
        parent: compactMode
        y: compactMode.height + 4
        x: 0
        width: compactMode.width
        height: Math.min(400, dropdownListView.contentHeight + 20)
        
        modal: false
        dim: false
        closePolicy: QQC2.Popup.CloseOnEscape | QQC2.Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: root.bgColor
            radius: root.borderRadius
            border.color: root.primaryColor
            border.width: 2
            
            // Ombre via MultiEffect : ce Popup QQC2 n'est pas ombré par Plasma
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#80000000"
                shadowBlur: 0.3
                shadowVerticalOffset: 4
                shadowHorizontalOffset: 0
            }
        }
        
        contentItem: Item {
            anchors.fill: parent
            
            // ========== LISTE DES RÉSULTATS ==========
            QQC2.ScrollView {
                anchors.fill: parent
                anchors.margins: 4
                
                ListView {
                    id: dropdownListView
                    clip: true
                    spacing: 2
                    
                    model: root.resultsModel
                    
                    delegate: Rectangle {
                        width: dropdownListView.width
                        height: 60
                        color: itemMouse.containsMouse ? root.secondaryColor : "transparent"
                        radius: Math.max(0, root.borderRadius - 2)
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 8
                            
                            Rectangle {
                                Layout.preferredWidth: root.resultIconSize + 8
                                Layout.preferredHeight: root.resultIconSize + 8
                                radius: Math.max(0, root.borderRadius - 2)
                                color: root.primaryColor
                                
                                Kirigami.Icon {
                                    anchors.centerIn: parent
                                    source: root.folderIconPath
                                    width: root.resultIconSize - 4
                                    height: root.resultIconSize - 4
                                    color: root.bgColor
                                }
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                QQC2.Label {
                                    text: model.name
                                    font.bold: true
                                    font.pixelSize: root.textFontSize - 1
                                    color: root.textColor
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                
                                QQC2.Label {
                                    text: model.path
                                    font.pixelSize: root.smallFontSize - 1
                                    color: root.secTextColor
                                    elide: Text.ElideMiddle
                                    Layout.fillWidth: true
                                }
                            }
                            
                            Rectangle {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                radius: 12
                                color: root.accentColor
                                visible: itemMouse.containsMouse
                                
                                QQC2.Label {
                                    anchors.centerIn: parent
                                    text: "↗"
                                    color: root.bgColor
                                    font.bold: true
                                    font.pixelSize: root.badgeFontSize
                                }
                            }
                        }
                        
                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                root.openFolder(model.path)
                                searchField.text = ""
                                dropdownPopup.close()
                                plasmoid.expanded = false
                            }
                        }
                    }
                }
            }
            
            // ========== MESSAGE AUCUN RÉSULTAT ==========
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.smallSpacing
                visible: root.resultsModel.count === 0 && searchField.text !== ""
                
                Kirigami.Icon {
                    source: "edit-none"
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    Layout.alignment: Qt.AlignHCenter
                    color: root.secTextColor
                }
                
                QQC2.Label {
                    text: "Aucun résultat"
                    font.pixelSize: root.textFontSize
                    color: root.secTextColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
    
    Component.onCompleted: {
        searchField.forceActiveFocus()
    }
}