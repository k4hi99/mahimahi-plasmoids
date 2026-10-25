import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

// Mode complet : barre de recherche et liste des résultats intégrée
Rectangle {
    id: fullMode
    
    anchors.fill: parent
    anchors.margins: -10  // Anti-cadre gris
    color: root.bgColor
    border.color: root.tertiaryColor
    border.width: root.widgetBorderEnabled ? root.widgetBorderWidth : 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing
        
        // ========== EN-TÊTE ==========
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Qt.darker(root.bgColor, 1.1)
            radius: root.borderRadius
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.smallSpacing
                spacing: Kirigami.Units.smallSpacing
                
                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 20
                    color: root.primaryColor
                    
                    Kirigami.Icon {
                        anchors.centerIn: parent
                        source: root.logoPath
                        width: 24
                        height: 24
                        color: root.bgColor
                    }
                }
                
                QQC2.Label {
                    text: "MahiFind"
                    font.pixelSize: root.titleFontSize
                    font.bold: true
                    color: root.textColor
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    Layout.preferredWidth: statusLabel.width + 16
                    Layout.preferredHeight: 28
                    radius: 14
                    color: root.isScanning ? root.tertiaryColor : root.accentColor
                    
                    QQC2.Label {
                        id: statusLabel
                        anchors.centerIn: parent
                        text: root.isScanning ? "⏳ " + root.foldersCount : "✅ " + root.foldersCount
                        color: root.badgeTextColor
                        font.bold: true
                    }
                }
                
                // Bouton de rescan
                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: 18
                    color: refreshMouse.containsMouse ? Qt.lighter(root.primaryColor, 1.2) : root.primaryColor
                    
                    Kirigami.Icon {
                        anchors.centerIn: parent
                        source: "view-refresh"
                        width: 20
                        height: 20
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
            Layout.preferredHeight: 50
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
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    color: root.secTextColor
                }
                
                QQC2.TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: root.isScanning ? "⏳ Scan en cours..." : "🔎 Chercher parmi " + root.foldersCount + " dossiers"
                    
                    background: Rectangle {
                        color: "transparent"
                    }
                    
                    color: root.textColor
                    placeholderTextColor: root.secTextColor
                    
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape) {
                            searchField.text = ""
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return) {
                            if (resultsListView.count > 0) {
                                var firstItem = root.resultsModel.get(0)
                                root.openFolder(firstItem.path)
                                searchField.text = ""
                                plasmoid.expanded = false
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Down) {
                            if (resultsListView.count > 0) {
                                resultsListView.forceActiveFocus()
                                resultsListView.currentIndex = 0
                            }
                            event.accepted = true
                        }
                    }
                    
                    onTextChanged: root.filterFolders(text)
                    
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
                        onClicked: searchField.text = ""
                    }
                }
            }
        }
        
        // ========== LISTE DES RÉSULTATS ==========
        QQC2.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: resultsListView.count > 0
            
            background: Rectangle {
                color: Qt.darker(root.bgColor, 1.05)
                radius: root.borderRadius
            }
            
            ListView {
                id: resultsListView
                clip: true
                spacing: 2
                
                model: root.resultsModel
                
                delegate: Rectangle {
                    width: resultsListView.width
                    height: 70
                    color: itemMouse.containsMouse ? root.secondaryColor : "transparent"
                    radius: Math.max(0, root.borderRadius - 2)
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing
                        spacing: Kirigami.Units.smallSpacing
                        
                        Rectangle {
                            Layout.preferredWidth: root.resultIconSize + 16
                            Layout.preferredHeight: root.resultIconSize + 16
                            radius: root.borderRadius
                            color: root.primaryColor
                            
                            Kirigami.Icon {
                                anchors.centerIn: parent
                                source: root.folderIconPath
                                width: root.resultIconSize
                                height: root.resultIconSize
                                color: root.bgColor
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            QQC2.Label {
                                text: model.name
                                font.bold: true
                                font.pixelSize: root.textFontSize
                                color: root.textColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            
                            QQC2.Label {
                                text: model.path
                                font.pixelSize: root.smallFontSize
                                color: root.secTextColor
                                elide: Text.ElideMiddle
                                Layout.fillWidth: true
                            }
                        }
                        
                        Rectangle {
                            Layout.preferredWidth: 30
                            Layout.preferredHeight: 30
                            radius: 15
                            color: root.accentColor
                            visible: itemMouse.containsMouse
                            
                            QQC2.Label {
                                anchors.centerIn: parent
                                text: "↗"
                                color: root.bgColor
                                font.bold: true
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
                            plasmoid.expanded = false
                        }
                    }
                }
            }
        }
        
        // ========== MESSAGE AUCUN RÉSULTAT ==========
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: searchField.text !== "" && resultsListView.count === 0 && !root.isScanning
            color: Qt.darker(root.bgColor, 1.05)
            radius: root.borderRadius
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing
                
                Kirigami.Icon {
                    source: "edit-none"
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 64
                    Layout.alignment: Qt.AlignHCenter
                    color: root.secTextColor
                }
                
                QQC2.Label {
                    text: "Aucun dossier trouvé"
                    font.pixelSize: root.titleFontSize - 4
                    color: root.secTextColor
                    Layout.alignment: Qt.AlignHCenter
                }
                
                QQC2.Label {
                    text: "Essaye un autre terme de recherche"
                    font.pixelSize: root.smallFontSize + 1
                    color: root.secTextColor
                    opacity: 0.7
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        
        // ========== MESSAGE DE BIENVENUE ==========
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: searchField.text === ""
            color: Qt.darker(root.bgColor, 1.05)
            radius: root.borderRadius
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing
                
                Rectangle {
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    Layout.alignment: Qt.AlignHCenter
                    radius: 40
                    color: root.primaryColor
                    
                    Kirigami.Icon {
                        anchors.centerIn: parent
                        source: root.folderIconPath
                        width: 48
                        height: 48
                        color: root.bgColor
                    }
                }
                
                QQC2.Label {
                    text: root.isScanning ? "Scan en cours..." : "🔎 Tape pour chercher"
                    font.pixelSize: root.titleFontSize - 2
                    font.bold: true
                    color: root.textColor
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Rectangle {
                    Layout.preferredWidth: countLabel.width + 20
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignHCenter
                    radius: 16
                    color: root.isScanning ? root.tertiaryColor : root.accentColor
                    
                    QQC2.Label {
                        id: countLabel
                        anchors.centerIn: parent
                        text: root.foldersCount + " dossiers indexés"
                        color: root.badgeTextColor
                        font.bold: true
                    }
                }
                
                QQC2.Label {
                    text: root.isScanning ? "Patience, ça arrive... ☕" : "Prêt à explorer ! 🚀"
                    font.pixelSize: root.smallFontSize + 1
                    color: root.secTextColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}