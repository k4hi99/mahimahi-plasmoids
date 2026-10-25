import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    
    // ========== DONNÉES MÉTÉO ==========
    property var weatherData: null
    property var forecastData: null
    property bool loading: false
    property string errorMessage: ""
    
    // Réglages (onglet "General")
    property string apiKey: plasmoid.configuration.apiKey || ""
    property string city: plasmoid.configuration.city || "Lyon"
    property string units: plasmoid.configuration.units || "metric"
    
    // Couleurs MahiTheme (onglet "Couleurs", voir CLAUDE.md)
    property string primaryColor: plasmoid.configuration.primaryColor
    property string secondaryColor: plasmoid.configuration.secondaryColor
    property string accentColor: plasmoid.configuration.accentColor
    property string tertiaryColor: plasmoid.configuration.tertiaryColor
    property string bgColor: plasmoid.configuration.bgColor
    property string textColor: plasmoid.configuration.textColor
    property string secTextColor: plasmoid.configuration.secTextColor
    property string badgeTextColor: plasmoid.configuration.badgeTextColor
    property bool widgetBorderEnabled: plasmoid.configuration.widgetBorderEnabled
    property string unitIndicatorColor: plasmoid.configuration.unitIndicatorColor
    
    // Tailles MahiTheme (onglet "Tailles", voir CLAUDE.md)
    property int titleFontSize: plasmoid.configuration.titleFontSize
    property int textFontSize: plasmoid.configuration.textFontSize
    property int smallFontSize: plasmoid.configuration.smallFontSize
    property int compactIconSize: plasmoid.configuration.compactIconSize
    property int borderRadius: plasmoid.configuration.borderRadius
    property int widgetBorderWidth: plasmoid.configuration.widgetBorderWidth
    
    // Tailles spéciales
    property int compactTempSize: plasmoid.configuration.compactTempSize
    property int compactCitySize: plasmoid.configuration.compactCitySize
    property int fullTempSize: plasmoid.configuration.fullTempSize
    property int detailValueSize: plasmoid.configuration.detailValueSize
    property int forecastDaySize: plasmoid.configuration.forecastDaySize
    property int forecastTempSize: plasmoid.configuration.forecastTempSize
    property int fullMainIconSize: plasmoid.configuration.fullMainIconSize
    property int detailIconSize: plasmoid.configuration.detailIconSize
    property int forecastIconSize: plasmoid.configuration.forecastIconSize
    
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
    preferredRepresentation: compactRepresentation
    
    // ========== API OPENWEATHERMAP ==========
    Timer {
        id: refreshTimer
        interval: 1800000
        running: true
        repeat: true
        onTriggered: fetchWeather()
    }
    
    function fetchWeather() {
        if (!apiKey) {
            errorMessage = "Aucune clé API configurée"
            return
        }
        
        loading = true
        errorMessage = ""
        
        var currentUrl = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=${units}&lang=fr`
        
        var xhr = new XMLHttpRequest()
        xhr.open("GET", currentUrl)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    weatherData = JSON.parse(xhr.responseText)
                    fetchForecast()
                } else {
                    loading = false
                    errorMessage = "Erreur API: " + xhr.status
                    console.log("Erreur météo:", xhr.responseText)
                }
            }
        }
        xhr.send()
    }
    
    function fetchForecast() {
        var forecastUrl = `https://api.openweathermap.org/data/2.5/forecast?q=${city}&appid=${apiKey}&units=${units}&lang=fr`
        
        var xhr = new XMLHttpRequest()
        xhr.open("GET", forecastUrl)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                loading = false
                if (xhr.status === 200) {
                    forecastData = JSON.parse(xhr.responseText)
                } else {
                    errorMessage = "Erreur prévisions: " + xhr.status
                }
            }
        }
        xhr.send()
    }
    
    // ========== ICÔNES MÉTÉO ==========
    // Code d'icône OpenWeatherMap → SVG ; currentColor est remplacé à l'affichage.
    // Même fonction dans FullRepresentation.qml : les garder identiques.
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
    
    // ========== REPRÉSENTATION COMPACTE ==========
    compactRepresentation: Item {
        Layout.minimumWidth: 120
        Layout.minimumHeight: 40
        Layout.preferredWidth: 150
        Layout.preferredHeight: 50
        
        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: root.bgColor
            radius: root.borderRadius
            border.color: root.tertiaryColor
            border.width: root.widgetBorderEnabled ? root.widgetBorderWidth : 0
            
            MouseArea {
                anchors.fill: parent
                onClicked: root.expanded = !root.expanded
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 0
                
                // SVG maison plutôt qu'une icône du thème : colorisable avec primaryColor
                Item {
                    Layout.preferredWidth: root.compactIconSize
                    Layout.preferredHeight: root.compactIconSize
                    Layout.alignment: Qt.AlignVCenter
                    
                    Rectangle {
                        id: iconContainer
                        anchors.centerIn: parent
                        width: root.compactIconSize
                        height: root.compactIconSize
                        color: "transparent"
                        
                        Image {
                            id: weatherIcon
                            anchors.fill: parent
                            sourceSize.width: root.compactIconSize
                            sourceSize.height: root.compactIconSize
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            
                            source: {
                                if (!weatherData) return ""
                                var svg = getWeatherIconSvg(weatherData.weather[0].icon)
                                return "data:image/svg+xml;utf8," + svg.replace(/currentColor/g, root.primaryColor)
                            }
                        }
                    }
                }
                
                // Les Item extensibles répartissent l'espace entre icône, température, séparateur et ville
                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                }
                
                RowLayout {
                    spacing: 2
                    Layout.alignment: Qt.AlignVCenter
                    
                    Text {
                        text: weatherData ? Math.round(weatherData.main.temp) : "--"
                        font.pixelSize: root.compactTempSize
                        font.bold: true
                        color: root.textColor
                    }
                    
                    Text {
                        text: "°"
                        font.pixelSize: root.compactTempSize
                        font.bold: true
                        color: root.unitIndicatorColor
                    }
                }
                
                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                }
                
                Text {
                    text: "|"
                    font.pixelSize: root.compactTempSize
                    color: root.accentColor
                    opacity: 0.5
                    Layout.alignment: Qt.AlignVCenter
                }
                
                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                }
                
                Text {
                    text: city
                    font.pixelSize: root.compactCitySize
                    color: root.secTextColor
                    Layout.alignment: Qt.AlignVCenter
                }
                
                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                }
            }
            
            // Liseré accentColor tant qu'une erreur est affichée
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: root.accentColor
                border.width: 2
                radius: root.borderRadius
                visible: errorMessage !== ""
            }
        }
    }
    
    // ========== REPRÉSENTATION COMPLÈTE ==========
    fullRepresentation: FullRepresentation {
        Layout.minimumWidth: 380
        Layout.maximumWidth: 380
        Layout.preferredWidth: 380
        Layout.minimumHeight: 450
        Layout.maximumHeight: 450
        Layout.preferredHeight: 450
        
        weatherData: root.weatherData
        forecastData: root.forecastData
        loading: root.loading
        errorMessage: root.errorMessage
        city: root.city
        units: root.units
        
        // Couleurs
        primaryColor: root.primaryColor
        secondaryColor: root.secondaryColor
        accentColor: root.accentColor
        tertiaryColor: root.tertiaryColor
        bgColor: root.bgColor
        textColor: root.textColor
        secTextColor: root.secTextColor
        badgeTextColor: root.badgeTextColor
        unitIndicatorColor: root.unitIndicatorColor
        
        // Tailles de police
        titleFontSize: root.titleFontSize
        textFontSize: root.textFontSize
        smallFontSize: root.smallFontSize
        fullTempSize: root.fullTempSize
        detailValueSize: root.detailValueSize
        forecastDaySize: root.forecastDaySize
        forecastTempSize: root.forecastTempSize
        
        // Tailles d'icônes
        fullMainIconSize: root.fullMainIconSize
        detailIconSize: root.detailIconSize
        forecastIconSize: root.forecastIconSize
        
        // Autres
        anchors.margins: -10
        borderRadius: root.borderRadius
        widgetBorderEnabled: root.widgetBorderEnabled
        widgetBorderWidth: root.widgetBorderWidth
        
    }
    
    // ========== INITIALISATION ==========
    Component.onCompleted: {
        if (apiKey) {
            fetchWeather()
        }
    }
    
    Connections {
        target: plasmoid.configuration
        function onApiKeyChanged() { 
            apiKey = plasmoid.configuration.apiKey
            fetchWeather() 
        }
        function onCityChanged() { 
            city = plasmoid.configuration.city
            fetchWeather() 
        }
        function onUnitsChanged() { 
            units = plasmoid.configuration.units
            fetchWeather() 
        }
        
        // Couleurs
        function onPrimaryColorChanged() { primaryColor = plasmoid.configuration.primaryColor }
        function onSecondaryColorChanged() { secondaryColor = plasmoid.configuration.secondaryColor }
        function onAccentColorChanged() { accentColor = plasmoid.configuration.accentColor }
        function onTertiaryColorChanged() { tertiaryColor = plasmoid.configuration.tertiaryColor }
        function onBgColorChanged() { bgColor = plasmoid.configuration.bgColor }
        function onTextColorChanged() { textColor = plasmoid.configuration.textColor }
        function onSecTextColorChanged() { secTextColor = plasmoid.configuration.secTextColor }
        function onBadgeTextColorChanged() { badgeTextColor = plasmoid.configuration.badgeTextColor }
        function onUnitIndicatorColorChanged() { unitIndicatorColor = plasmoid.configuration.unitIndicatorColor }
    }
}