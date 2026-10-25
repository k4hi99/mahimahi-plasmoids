import QtQuick
import QtCore
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import Qt.labs.folderlistmodel

PlasmoidItem {
    id: root
    
    width: 500
    height: 400
    
    // ========== ICÔNES PERSONNALISÉES ==========
    property string logoPath: Qt.resolvedUrl("../../logo.png")
    property string folderIconPath: Qt.resolvedUrl("../../foldermf.png")
    
    // Bureau uniquement, pas de vue de panneau : displayMode choisit entre FullMode et CompactMode
    fullRepresentation: Loader {
        source: {
            if (plasmoid.configuration.displayMode === "full") {
                return "FullMode.qml"
            } else {
                return "CompactMode.qml"
            }
        }
    }
    
    // ========== DONNÉES PARTAGÉES ==========
    property var allFolders: []
    property bool isScanning: false
    property int foldersCount: 0
    
    // Dossier de départ : vide = dossier personnel de l'utilisateur
    property string homeDir: plasmoid.configuration.homeDirectory
        || StandardPaths.writableLocation(StandardPaths.HomeLocation).toString().replace("file://", "")
    property int maxDepth: plasmoid.configuration.scanDepth
    property int maxResults: plasmoid.configuration.maxResults
    property bool autoScan: plasmoid.configuration.autoScan
    property int currentIndex: 0
    property var scanQueue: []
    
    // Couleurs MahiTheme (onglet "Couleurs", voir CLAUDE.md)
    property color primaryColor: plasmoid.configuration.primaryColor
    property color secondaryColor: plasmoid.configuration.secondaryColor
    property color accentColor: plasmoid.configuration.accentColor
    property color tertiaryColor: plasmoid.configuration.tertiaryColor
    property color bgColor: plasmoid.configuration.bgColor
    property color textColor: plasmoid.configuration.textColor
    property color secTextColor: plasmoid.configuration.secTextColor
    property color badgeTextColor: plasmoid.configuration.badgeTextColor
    property bool widgetBorderEnabled: plasmoid.configuration.widgetBorderEnabled
    
    // Tailles MahiTheme (onglet "Tailles", voir CLAUDE.md)
    property int titleFontSize: plasmoid.configuration.titleFontSize
    property int textFontSize: plasmoid.configuration.textFontSize
    property int smallFontSize: plasmoid.configuration.smallFontSize
    property int borderRadius: plasmoid.configuration.borderRadius
    property int widgetBorderWidth: plasmoid.configuration.widgetBorderWidth
    property int badgeFontSize: plasmoid.configuration.badgeFontSize
    property int resultIconSize: plasmoid.configuration.resultIconSize
    
    // Résultats partagés par FullMode et CompactMode
    property alias resultsModel: sharedResultsModel
    
    ListModel {
        id: sharedResultsModel
    }
    
    // ========== EXCLUSIONS ==========
    function shouldExclude(name) {
        var excludedString = plasmoid.configuration.excludedFolders
        var excluded = excludedString.split(',').map(function(s) { return s.trim() })
        
        return excluded.indexOf(name) !== -1
    }
    
    // ========== INITIALISATION ==========
    // Sans scan automatique, le scan se lance avec le bouton du widget
    Component.onCompleted: {
        if (autoScan) {
            startScan()
            startupTimer.start()
        }
    }

    // Relance le scan peu après le démarrage, pour contourner un problème d'ordre d'initialisation
    Timer {
        id: startupTimer
        interval: 100
        repeat: false
        onTriggered: startScan()
    }
    
    // ========== SCAN ==========
    function startScan() {
        isScanning = true
        allFolders = []
        foldersCount = 0
        scanQueue = []
        currentIndex = 0
        
        addToScanQueue(homeDir, 0)
        scanTimer.start()
    }
    
    function addToScanQueue(path, depth) {
        if (depth < maxDepth) {
            scanQueue.push({path: path, depth: depth})
        }
    }
    
    // Scan progressif, un dossier à la fois : chaque Ready traite le dossier puis passe au suivant
    FolderListModel {
        id: folderModel
        showDirs: true
        showFiles: false
        showDotAndDotDot: false
        showHidden: true
        
        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                processCurrentFolder()
            }
        }
    }
    
    function processCurrentFolder() {
        var currentItem = scanQueue[currentIndex]
        if (!currentItem) return
        
        for (var i = 0; i < folderModel.count; i++) {
            var fileName = folderModel.get(i, "fileName")
            var filePath = folderModel.get(i, "filePath").toString().replace("file://", "")
            
            if (shouldExclude(fileName)) {
                continue
            }
            
            allFolders.push({
                name: fileName,
                path: filePath
            })
            foldersCount++
            
            addToScanQueue(filePath, currentItem.depth + 1)
        }
        
        currentIndex++
        scanTimer.restart()
    }
    
    // Délai entre deux dossiers : rend la main à l'interface pendant le scan
    Timer {
        id: scanTimer
        interval: 5
        repeat: false
        
        onTriggered: {
            if (currentIndex >= scanQueue.length) {
                isScanning = false
                return
            }
            
            var nextItem = scanQueue[currentIndex]
            folderModel.folder = "file://" + nextItem.path
        }
    }
    
    // ========== ACTIONS ==========
    function openFolder(path) {
        Qt.openUrlExternally("file://" + path)
    }
    
    function filterFolders(searchText) {
        sharedResultsModel.clear()
        
        if (searchText === "") return
        
        var searchLower = searchText.toLowerCase()
        var matches = 0
        
        for (var i = 0; i < allFolders.length && matches < maxResults; i++) {
            var folder = allFolders[i]
            if (folder.name.toLowerCase().includes(searchLower)) {
                sharedResultsModel.append({
                    "name": folder.name,
                    "path": folder.path
                })
                matches++
            }
        }
    }
}