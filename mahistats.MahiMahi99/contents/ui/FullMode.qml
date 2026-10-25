// Vue complète (popup ou bureau) : jauges ou barres + courbes des 5 dernières minutes
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents

Item {
    Layout.preferredWidth: content.implicitWidth + 40
    Layout.preferredHeight: content.implicitHeight + 40
    Layout.minimumWidth: content.implicitWidth + 40
    Layout.minimumHeight: content.implicitHeight + 40

    Rectangle {
        anchors.fill: parent
        anchors.margins: -10
        color: root.bgColor
        radius: root.borderRadius
        border.color: root.tertiaryColor
        border.width: root.widgetBorderEnabled ? root.widgetBorderWidth : 0
    }

    // Contenu centré verticalement, sur toute la largeur moins les marges
    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 20
        spacing: 12

        PlasmaComponents.Label {
            text: "MahiStats"
            font.pixelSize: root.titleFontSize
            font.bold: true
            color: root.primaryColor
        }

        // ========== JAUGES OU BARRES ==========
        Loader {
            Layout.fillWidth: true
            source: root.fullLayout === "bars" ? "BarsView.qml" : "GaugesView.qml"
        }

        // ========== HISTORIQUE ==========
        // Masqué : le widget rétrécit, mais l'échantillonnage continue (main.qml)
        ColumnLayout {
            visible: root.showHistory
            Layout.fillWidth: true
            spacing: 12

            PlasmaComponents.Label {
                text: "📈 Historique (5 min)"
                font.pixelSize: root.textFontSize
                font.bold: true
                color: root.primaryColor
            }

            HistoryGraph {
                Layout.fillWidth: true
                label: "CPU"
                values: root.cpuHistory
                valueText: root.cpuText
            }
            HistoryGraph {
                Layout.fillWidth: true
                label: "Température"
                values: root.tempHistory
                threshold: root.tempThreshold
                valueText: root.tempText
                alert: root.tempAlert
            }
            HistoryGraph {
                Layout.fillWidth: true
                label: "RAM"
                values: root.ramHistory
                threshold: root.ramThreshold
                valueText: Math.round(root.ramPercent) + " %"
                alert: root.ramAlert
            }
        }
    }
}
