import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Item {
    id: fullRep
    
    property var weatherData
    property var forecastData
    property bool loading
    property string errorMessage
    property string city
    property string units
    
    // Couleurs (transmises par main.qml)
    property string primaryColor
    property string secondaryColor
    property string accentColor
    property string tertiaryColor
    property string bgColor
    property string textColor
    property string secTextColor
    property string badgeTextColor
    property string unitIndicatorColor
    
    // Tailles de police
    property int titleFontSize
    property int textFontSize
    property int smallFontSize
    property int fullTempSize
    property int detailValueSize
    property int forecastDaySize
    property int forecastTempSize
    
    // Tailles d'icônes
    property int fullMainIconSize
    property int detailIconSize
    property int forecastIconSize
    
    // Autres
    property int borderRadius
    property bool widgetBorderEnabled
    property int widgetBorderWidth
    
    
    function formatDay(timestamp) {
        var date = new Date(timestamp * 1000)
        var days = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"]
        return days[date.getDay()]
    }
    
    // ========== ICÔNES MÉTÉO ==========
    // Copie de getWeatherIconSvg de main.qml : les garder identiques
   function getWeatherIconSvg(iconCode) {
    var svgMap = {
        // Soleil (jour)
        "01d": '<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="12" r="5"/><path d="M12 1v3m0 16v3M3.22 3.22l2.12 2.12m13.44 13.44l2.12 2.12M1 12h3m16 0h3M3.22 20.78l2.12-2.12m13.44-13.44l2.12-2.12"/></svg>',
        // Lune (nuit)
        "01n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>',
        // Peu nuageux (jour)
        "02d": '<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="7" r="3"/><path d="M12 1v2m6 2.5l-1.5 1.5M21 7h-2m-2 7c-2.2 0-4-1.8-4-4H9c-2.2 0-4 1.8-4 4h10zm0 0h4c1.1 0 2 .9 2 2s-.9 2-2 2H6c-1.7 0-3-1.3-3-3s1.3-3 3-3h2"/></svg>',
        // Peu nuageux (nuit)
        "02n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 10a7 7 0 0 1-7-7 9 9 0 1 0 9.9 10.2A7 7 0 0 1 17 10z"/><path d="M15 14c-2.2 0-4-1.8-4-4H7c-2.2 0-4 1.8-4 4h12zm0 0h5c1.1 0 2 .9 2 2s-.9 2-2 2H5c-1.7 0-3-1.3-3-3s1.3-3 3-3h2"/></svg>',
        // Nuageux
        "03d": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/></svg>',
        "03n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/></svg>',
        // Très nuageux
        "04d": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 15.5c1.25 0 2.29-.86 2.57-2.01A8.97 8.97 0 0 0 18 8h-1.26A8 8 0 1 0 9 20h11c1.66 0 3-1.34 3-3 0-.35-.07-.69-.18-1-.1-.29-.25-.56-.44-.79A2.99 2.99 0 0 1 20 15.5z"/></svg>',
        "04n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 15.5c1.25 0 2.29-.86 2.57-2.01A8.97 8.97 0 0 0 18 8h-1.26A8 8 0 1 0 9 20h11c1.66 0 3-1.34 3-3 0-.35-.07-.69-.18-1-.1-.29-.25-.56-.44-.79A2.99 2.99 0 0 1 20 15.5z"/></svg>',
        // Pluie éparse
        "09d": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><circle cx="8" cy="21" r="1.5"/><circle cx="12" cy="21" r="1.5"/><circle cx="16" cy="21" r="1.5"/></svg>',
        "09n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><circle cx="8" cy="21" r="1.5"/><circle cx="12" cy="21" r="1.5"/><circle cx="16" cy="21" r="1.5"/></svg>',
        // Pluie
        "10d": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><path d="M16 16v6M12 16v6M8 16v6"/></svg>',
        "10n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><path d="M16 16v6M12 16v6M8 16v6"/></svg>',
        // Orage
        "11d": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><path d="M13 13l-3 5 3-1.5L12 20l4-5-3 1.5L14 13z"/></svg>',
        "11n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><path d="M13 13l-3 5 3-1.5L12 20l4-5-3 1.5L14 13z"/></svg>',
        // Neige
        "13d": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><circle cx="8" cy="18" r="1"/><circle cx="8" cy="21" r="1"/><circle cx="12" cy="18" r="1"/><circle cx="12" cy="21" r="1"/><circle cx="16" cy="18" r="1"/><circle cx="16" cy="21" r="1"/></svg>',
        "13n": '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"/><circle cx="8" cy="18" r="1"/><circle cx="8" cy="21" r="1"/><circle cx="12" cy="18" r="1"/><circle cx="12" cy="21" r="1"/><circle cx="16" cy="18" r="1"/><circle cx="16" cy="21" r="1"/></svg>',
        // Brume
        "50d": '<svg viewBox="0 0 24 24" fill="currentColor"><rect x="3" y="9" width="18" height="2" rx="1"/><rect x="3" y="13" width="14" height="2" rx="1"/><rect x="3" y="17" width="16" height="2" rx="1"/></svg>',
        "50n": '<svg viewBox="0 0 24 24" fill="currentColor"><rect x="3" y="9" width="18" height="2" rx="1"/><rect x="3" y="13" width="14" height="2" rx="1"/><rect x="3" y="17" width="16" height="2" rx="1"/></svg>'
    }
    return svgMap[iconCode] || '<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="12" r="10"/></svg>'
}
    
    Rectangle {
        anchors.fill: parent
        anchors.topMargin : -10
        color: bgColor
        radius: borderRadius
        border.color: tertiaryColor
        border.width: widgetBorderEnabled ? widgetBorderWidth : 0
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            anchors.topMargin: -30
            spacing: 15
            
            // ========== MESSAGE D'ERREUR ==========
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                visible: !weatherData || errorMessage !== ""
                
                ColumnLayout {
                    anchors.centerIn: parent
                    width: parent.width * 0.9
                    spacing: 10
                    
                    Kirigami.Icon {
                        source: errorMessage ? "dialog-warning" : "configure"
                        Layout.preferredWidth: fullMainIconSize
                        Layout.preferredHeight: fullMainIconSize
                        Layout.alignment: Qt.AlignHCenter
                        color: primaryColor
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: errorMessage || "Configurez votre clé API OpenWeatherMap"
                        color: textColor
                        font.pixelSize: textFontSize
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    
                    QQC2.Button {
                        text: "Configurer"
                        icon.name: "configure"
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: plasmoid.internalAction("configure").trigger()
                        
                        background: Rectangle {
                            color: primaryColor
                            radius: borderRadius
                        }
                        
                        contentItem: RowLayout {
                            spacing: 5
                            
                            Kirigami.Icon {
                                source: "configure"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                color: textColor
                            }
                            
                            Text {
                                text: "Configurer"
                                color: textColor
                                font.pixelSize: smallFontSize + 2
                            }
                        }
                    }
                }
            }
            
            // ========== CONTENU PRINCIPAL ==========
            ColumnLayout {
                visible: weatherData && errorMessage === ""
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15
                
                // ========== MÉTÉO ACTUELLE ==========
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 15
                    
                    Item {
                        Layout.preferredWidth: fullMainIconSize
                        Layout.preferredHeight: fullMainIconSize
                        
                        Image {
                            anchors.centerIn: parent
                            width: fullMainIconSize
                            height: fullMainIconSize
                            sourceSize.width: fullMainIconSize
                            sourceSize.height: fullMainIconSize
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            
                            source: {
                                if (!weatherData) return ""
                                var svg = getWeatherIconSvg(weatherData.weather[0].icon)
                                return "data:image/svg+xml;utf8," + svg.replace(/currentColor/g, primaryColor)
                            }
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 5
                        
                        Text {
                            text: city
                            font.pixelSize: titleFontSize
                            font.bold: true
                            color: textColor
                        }
                        
                        Text {
                            text: weatherData ? weatherData.weather[0].description : ""
                            font.pixelSize: textFontSize
                            color: secTextColor
                            Component.onCompleted: {
                                if (text) {
                                    text = text.charAt(0).toUpperCase() + text.slice(1)
                                }
                            }
                        }
                        
                        Row {
                            spacing: 2
                            
                            Text {
                                text: weatherData ? Math.round(weatherData.main.temp) : ""
                                font.pixelSize: fullTempSize
                                font.bold: true
                                color: textColor
                            }
                            
                            Text {
                                text: "°C"
                                font.pixelSize: fullTempSize
                                font.bold: true
                                color: unitIndicatorColor
                            }
                        }
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: accentColor
                    opacity: 0.3
                }
                
                // ========== DÉTAILS DU JOUR ==========
                GridLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    columns: 3
                    rowSpacing: 10
                    columnSpacing: 15
                    
                    // Ressenti
                    RowLayout {
                        spacing: 8
                        Kirigami.Icon {
                            source: "temperature-warm"
                            Layout.preferredWidth: detailIconSize
                            Layout.preferredHeight: detailIconSize
                            color: accentColor
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Ressenti"
                                font.pixelSize: smallFontSize
                                color: secTextColor
                            }
                            Row {
                                spacing: 1
                                Text {
                                    text: weatherData ? Math.round(weatherData.main.feels_like) : ""
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: textColor
                                }
                                Text {
                                    text: "°C"
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: unitIndicatorColor
                                }
                            }
                        }
                    }
                    
                    // Vent
                    RowLayout {
                        spacing: 8
                        Kirigami.Icon {
                            source: "weather-windy"
                            Layout.preferredWidth: detailIconSize
                            Layout.preferredHeight: detailIconSize
                            color: accentColor
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Vent"
                                font.pixelSize: smallFontSize
                                color: secTextColor
                            }
                            Row {
                                spacing: 1
                                Text {
                                    text: weatherData ? Math.round(weatherData.wind.speed * 3.6) : ""
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: textColor
                                }
                                Text {
                                    text: " km/h"
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: unitIndicatorColor
                                }
                            }
                        }
                    }
                    
                    // Humidité
                    RowLayout {
                        spacing: 8
                        Kirigami.Icon {
                            source: "humidity"
                            Layout.preferredWidth: detailIconSize
                            Layout.preferredHeight: detailIconSize
                            color: accentColor
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Humidité"
                                font.pixelSize: smallFontSize
                                color: secTextColor
                            }
                            Row {
                                spacing: 1
                                Text {
                                    text: weatherData ? weatherData.main.humidity : ""
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: textColor
                                }
                                Text {
                                    text: "%"
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: unitIndicatorColor
                                }
                            }
                        }
                    }
                    
                    // Pression
                    RowLayout {
                        spacing: 8
                        Kirigami.Icon {
                            source: "pressure-barometer"
                            Layout.preferredWidth: detailIconSize
                            Layout.preferredHeight: detailIconSize
                            color: accentColor
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Pression"
                                font.pixelSize: smallFontSize
                                color: secTextColor
                            }
                            Row {
                                spacing: 1
                                Text {
                                    text: weatherData ? weatherData.main.pressure : ""
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: textColor
                                }
                                Text {
                                    text: " hPa"
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: unitIndicatorColor
                                }
                            }
                        }
                    }
                    
                    // Visibilité
                    RowLayout {
                        spacing: 8
                        Kirigami.Icon {
                            source: "visibility"
                            Layout.preferredWidth: detailIconSize
                            Layout.preferredHeight: detailIconSize
                            color: accentColor
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Visibilité"
                                font.pixelSize: smallFontSize
                                color: secTextColor
                            }
                            Row {
                                spacing: 1
                                Text {
                                    text: weatherData ? (weatherData.visibility / 1000).toFixed(1) : ""
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: textColor
                                }
                                Text {
                                    text: " km"
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: unitIndicatorColor
                                }
                            }
                        }
                    }
                    
                    // Couverture nuageuse
                    RowLayout {
                        spacing: 8
                        Kirigami.Icon {
                            source: "weather-clouds"
                            Layout.preferredWidth: detailIconSize
                            Layout.preferredHeight: detailIconSize
                            color: accentColor
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Nuages"
                                font.pixelSize: smallFontSize
                                color: secTextColor
                            }
                            Row {
                                spacing: 1
                                Text {
                                    text: weatherData ? weatherData.clouds.all : ""
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: textColor
                                }
                                Text {
                                    text: "%"
                                    font.pixelSize: detailValueSize
                                    font.bold: true
                                    color: unitIndicatorColor
                                }
                            }
                        }
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: accentColor
                    opacity: 0.3
                }
                
                // ========== PRÉVISIONS ==========
                Text {
                    text: "Prévisions"
                    font.pixelSize: textFontSize
                    font.bold: true
                    color: textColor
                    Layout.alignment: Qt.AlignHCenter
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5
                    
                    Repeater {
                        model: forecastData ? 5 : 0
                        
                        delegate: Rectangle {
                            Layout.preferredWidth: 65
                            Layout.preferredHeight: 90
                            color: secondaryColor
                            radius: borderRadius
                            
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 5
                                
                                Text {
                                    text: {
                                        var idx = index * 8 + 4
                                        if (forecastData && forecastData.list && idx < forecastData.list.length) {
                                            return formatDay(forecastData.list[idx].dt)
                                        }
                                        return ""
                                    }
                                    font.pixelSize: forecastDaySize
                                    color: secTextColor
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                
                                Item {
                                    Layout.preferredWidth: forecastIconSize
                                    Layout.preferredHeight: forecastIconSize
                                    Layout.alignment: Qt.AlignHCenter
                                    
                                    Image {
                                        anchors.centerIn: parent
                                        width: forecastIconSize
                                        height: forecastIconSize
                                        sourceSize.width: forecastIconSize
                                        sourceSize.height: forecastIconSize
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        
                                        source: {
                                            var idx = index * 8 + 4
                                            if (forecastData && forecastData.list && idx < forecastData.list.length) {
                                                var svg = getWeatherIconSvg(forecastData.list[idx].weather[0].icon)
                                                return "data:image/svg+xml;utf8," + svg.replace(/currentColor/g, primaryColor)
                                            }
                                            return ""
                                        }
                                    }
                                }
                                
                                Row {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 1
                                    
                                    Text {
                                        text: {
                                            var idx = index * 8 + 4
                                            if (forecastData && forecastData.list && idx < forecastData.list.length) {
                                                return Math.round(forecastData.list[idx].main.temp)
                                            }
                                            return ""
                                        }
                                        font.pixelSize: forecastTempSize
                                        font.bold: true
                                        color: textColor
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                    
                                    Text {
                                        text: "°"
                                        font.pixelSize: forecastTempSize
                                        font.bold: true
                                        color: unitIndicatorColor
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}