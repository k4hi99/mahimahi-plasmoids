// Courbe d'historique : les 5 dernières minutes, la plus récente à droite
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: graph

    property var values: []
    property real minimum: 0
    property real maximum: 100
    property real threshold: -1      // ligne de seuil (aucune si < 0)
    property string label: ""
    property string valueText: ""
    property bool alert: false

    spacing: 2

    RowLayout {
        Layout.fillWidth: true

        PlasmaComponents.Label {
            text: graph.label
            font.pixelSize: root.textFontSize
            color: root.textColor
        }
        Item { Layout.fillWidth: true }
        PlasmaComponents.Label {
            text: graph.valueText
            font.pixelSize: root.textFontSize
            font.bold: true
            color: graph.alert ? root.accentColor : root.textColor
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: root.graphHeight
        color: Qt.rgba(root.tertiaryColor.r, root.tertiaryColor.g, root.tertiaryColor.b, 0.35)
        radius: Math.max(0, root.borderRadius - 2)

        Canvas {
            id: canvas
            anchors.fill: parent
            anchors.margins: 4
            antialiasing: true

            property color lineColor: root.primaryColor
            property color thresholdColor: root.accentColor

            onLineColorChanged: requestPaint()
            onThresholdColorChanged: requestPaint()
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()

            Connections {
                target: root
                function onHistoryUpdated() { canvas.requestPaint() }
            }

            function yFor(v) {
                const ratio = (v - graph.minimum) / (graph.maximum - graph.minimum)
                return height - Math.max(0, Math.min(1, ratio)) * height
            }

            function rgba(c, alpha) {
                return "rgba(" + Math.round(c.r * 255) + "," + Math.round(c.g * 255) + ","
                    + Math.round(c.b * 255) + "," + alpha + ")"
            }

            onPaint: {
                const ctx = getContext("2d")
                ctx.reset()

                if (graph.threshold >= 0) {
                    ctx.strokeStyle = rgba(thresholdColor, 0.7)
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(0, yFor(graph.threshold))
                    ctx.lineTo(width, yFor(graph.threshold))
                    ctx.stroke()
                }

                const values = graph.values
                if (values.length < 2)
                    return

                // Échelle fixe sur 5 min : la courbe se remplit de droite à gauche
                const step = width / (root.historySize - 1)
                const x0 = width - (values.length - 1) * step

                ctx.beginPath()
                ctx.moveTo(x0, yFor(values[0]))
                for (let i = 1; i < values.length; i++)
                    ctx.lineTo(x0 + i * step, yFor(values[i]))

                ctx.strokeStyle = String(lineColor)
                ctx.lineWidth = 2.5
                ctx.lineJoin = "round"
                ctx.lineCap = "round"
                ctx.stroke()

                // Zone sous la courbe : primaryColor transparent, en fondu vers le bas
                ctx.lineTo(width, height)
                ctx.lineTo(x0, height)
                ctx.closePath()
                const gradient = ctx.createLinearGradient(0, 0, 0, height)
                gradient.addColorStop(0, rgba(lineColor, 0.35))
                gradient.addColorStop(1, rgba(lineColor, 0.05))
                ctx.fillStyle = gradient
                ctx.fill()
            }
        }
    }
}
