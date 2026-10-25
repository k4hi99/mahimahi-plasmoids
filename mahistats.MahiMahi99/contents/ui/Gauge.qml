// Jauge circulaire : arc de 270°, valeur au centre, nom dans l'ouverture du bas
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: gauge

    property real value: 0
    property real maximum: 100
    property string valueText: ""
    property string label: ""
    property string detail: ""
    property bool alert: false

    spacing: 4
    // Jauges alignées en haut, même si certaines ont une ligne de détail
    Layout.alignment: Qt.AlignTop

    Item {
        Layout.preferredWidth: root.gaugeSize
        Layout.preferredHeight: root.gaugeSize
        Layout.alignment: Qt.AlignHCenter

        Canvas {
            id: canvas
            anchors.fill: parent
            antialiasing: true

            property real ratio: Math.max(0, Math.min(1, gauge.value / gauge.maximum))
            property color arcColor: gauge.alert ? root.accentColor : root.primaryColor
            property color trackColor: root.tertiaryColor

            onRatioChanged: requestPaint()
            onArcColorChanged: requestPaint()
            onTrackColorChanged: requestPaint()
            onWidthChanged: requestPaint()

            onPaint: {
                const ctx = getContext("2d")
                ctx.reset()

                const lineWidth = Math.max(4, width / 11)
                const radius = (Math.min(width, height) - lineWidth) / 2
                const start = 0.75 * Math.PI
                const span = 1.5 * Math.PI

                ctx.lineCap = "round"
                ctx.lineWidth = lineWidth

                ctx.strokeStyle = String(trackColor)
                ctx.beginPath()
                ctx.arc(width / 2, height / 2, radius, start, start + span)
                ctx.stroke()

                if (ratio > 0) {
                    ctx.strokeStyle = String(arcColor)
                    ctx.beginPath()
                    ctx.arc(width / 2, height / 2, radius, start, start + span * ratio)
                    ctx.stroke()
                }
            }
        }

        PlasmaComponents.Label {
            anchors.centerIn: parent
            text: gauge.valueText
            font.pixelSize: root.titleFontSize
            font.bold: true
            color: gauge.alert ? root.accentColor : root.textColor
        }

        PlasmaComponents.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            text: gauge.label
            font.pixelSize: root.smallFontSize
            color: root.secTextColor
        }
    }

    PlasmaComponents.Label {
        visible: gauge.detail !== ""
        text: gauge.detail
        font.pixelSize: root.smallFontSize
        color: root.secTextColor
        horizontalAlignment: Text.AlignHCenter
        Layout.alignment: Qt.AlignHCenter
    }
}
