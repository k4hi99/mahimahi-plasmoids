import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    id: configRoot
    
    property alias cfg_apiKey: apiKeyField.text
    property alias cfg_city: cityField.text
    property alias cfg_units: unitsCombo.currentValue
    
    Kirigami.FormLayout {
        
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Configuration API"
        }
        
        RowLayout {
            Kirigami.FormData.label: "Clé API OpenWeatherMap:"
            spacing: 10
            
            QQC2.TextField {
                id: apiKeyField
                Layout.fillWidth: true
                placeholderText: "Entrez votre clé API"
                echoMode: QQC2.TextField.Password
            }
            
            QQC2.Button {
                icon.name: apiKeyField.echoMode === QQC2.TextField.Password ? "visibility" : "hint"
                onClicked: {
                    apiKeyField.echoMode = apiKeyField.echoMode === QQC2.TextField.Password 
                        ? QQC2.TextField.Normal 
                        : QQC2.TextField.Password
                }
                QQC2.ToolTip.text: "Afficher/Masquer"
                QQC2.ToolTip.visible: hovered
            }
        }
        
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: infoColumn.height
            
            ColumnLayout {
                id: infoColumn
                width: parent.width
                spacing: 5
                
                Text {
                    Layout.fillWidth: true
                    text: "Obtenez gratuitement une clé API sur:"
                    color: Kirigami.Theme.disabledTextColor
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                }
                
                QQC2.Label {
                    Layout.fillWidth: true
                    text: '<a href="https://openweathermap.org/api">https://openweathermap.org/api</a>'
                    onLinkActivated: (link) => Qt.openUrlExternally(link)
                    font.pixelSize: 11
                    color: Kirigami.Theme.linkColor
                    wrapMode: Text.WordWrap
                    
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
                
                Kirigami.InlineMessage {
                    Layout.fillWidth: true
                    type: Kirigami.MessageType.Information
                    text: "⚠️ Les nouvelles clés API peuvent prendre 10min à 2h pour s'activer!"
                    visible: true
                }
            }
        }
        
        Item {
            Kirigami.FormData.isSection: true
        }
        
        QQC2.TextField {
            id: cityField
            Kirigami.FormData.label: "Ville:"
            placeholderText: "Lyon, FR"
            Layout.fillWidth: true
        }
        
        QQC2.ComboBox {
            id: unitsCombo
            Kirigami.FormData.label: "Unités:"
            model: [
                { text: "Celsius (°C)", value: "metric" },
                { text: "Fahrenheit (°F)", value: "imperial" }
            ]
            textRole: "text"
            valueRole: "value"
            
            Component.onCompleted: {
                currentIndex = indexOfValue(cfg_units)
            }
        }
        
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Astuces"
        }
        
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: tipsColumn.height
            
            ColumnLayout {
                id: tipsColumn
                width: parent.width
                spacing: 10
                
                Kirigami.InlineMessage {
                    Layout.fillWidth: true
                    type: Kirigami.MessageType.Information
                    text: "Format ville: 'Paris' ou 'Paris,FR' pour plus de précision"
                    visible: true
                }
                
                Kirigami.InlineMessage {
                    Layout.fillWidth: true
                    type: Kirigami.MessageType.Information
                    text: "Les données sont rafraîchies automatiquement toutes les 30 minutes"
                    visible: true
                }
            }
        }
    }
}