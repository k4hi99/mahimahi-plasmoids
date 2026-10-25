// Cheaty : cheatsheets à sections repliables, lues dans les sous-dossiers de refdocs.
//
// Adaptation pour KDE Plasma 6 de l'applet Cinnamon « Cheaty » de centurix
// (cheaty@centurix, https://cinnamon-spices.linuxmint.com/applets/view/285),
// réécrite en QML par MahiMahi99. Licence GPL-3.0, comme l'original.
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.folderlistmodel
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root
    
    // ========== PROPRIÉTÉS ==========
    property string cheatsheetFolder: Qt.resolvedUrl("../refdocs").toString().replace("file://", "")
    property var loadedSheets: []
    property string currentSheetName: "Sélectionnez un cheatsheet"
    property int currentSheetIndex: -1
    property string customIconPath: Qt.resolvedUrl("../../cheaty.MahiMahi99.png")
    
    // Contenu à plat : une ligne par en-tête de section, puis une par item
    property ListModel contentModel: ListModel {}
    property var expandedSections: ({})
    
    // Signal pour forcer le rafraîchissement de l'interface
    signal sectionsChanged()

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
    property int compactIconSize: plasmoid.configuration.compactIconSize
    property int borderRadius: plasmoid.configuration.borderRadius
    property int widgetBorderWidth: plasmoid.configuration.widgetBorderWidth
    property int sheetIconSize: plasmoid.configuration.sheetIconSize

    // Bouton aux couleurs de la palette (fond accent, texte badge)
    component ThemedButton: Button {
        id: themedButton
        property string iconName: ""

        hoverEnabled: true
        leftPadding: 10
        rightPadding: 10
        topPadding: 5
        bottomPadding: 5

        background: Rectangle {
            radius: root.borderRadius
            color: themedButton.down ? Qt.darker(root.accentColor, 1.2)
                 : themedButton.hovered ? Qt.lighter(root.accentColor, 1.15)
                 : root.accentColor
        }

        contentItem: RowLayout {
            spacing: 5

            Kirigami.Icon {
                source: themedButton.iconName
                visible: themedButton.iconName !== ""
                color: root.badgeTextColor
                isMask: true
                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                Layout.preferredHeight: Kirigami.Units.iconSizes.small
            }

            Label {
                font.pixelSize: root.textFontSize
                text: themedButton.text
                color: root.badgeTextColor
            }
        }
    }

    // Liste des sous-dossiers de refdocs (chargement asynchrone)
    FolderListModel {
        id: refdocsModel
        folder: "file://" + root.cheatsheetFolder
        showDirs: true
        showFiles: false
        showDotAndDotDot: false
        sortField: FolderListModel.Name
        caseSensitive: false

        // Charger dès que le contenu du dossier est disponible
        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                root.loadCheatsheets();
            }
        }
    }
    
    preferredRepresentation: compactRepresentation
    toolTipMainText: "Cheaty"
    toolTipSubText: loadedSheets.length + " cheatsheets disponibles"
    
    // ========== INITIALISATION ==========
    Component.onCompleted: {
        console.log("🚀 Cheaty démarré");
        // Le chargement est déclenché par refdocsModel une fois prêt
    }
    
    // ========== REPRÉSENTATION COMPACTE ==========
    compactRepresentation: MouseArea {
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        Layout.preferredWidth: root.compactIconSize
        Layout.preferredHeight: root.compactIconSize
        
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        
        Image {
            anchors.fill: parent
            source: root.customIconPath
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
            smooth: true
            
            onStatusChanged: {
                if (status === Image.Error) {
                    visible = false;
                    fallbackIcon.visible = true;
                } else if (status === Image.Ready) {
                    visible = true;
                    fallbackIcon.visible = false;
                }
            }
            
            scale: parent.containsMouse ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 150 } }
        }
        
        // Icône de secours si le logo ne se charge pas
        Kirigami.Icon {
            id: fallbackIcon
            anchors.fill: parent
            source: "accessories-text-editor"
            visible: false
            active: parent.containsMouse
            scale: parent.containsMouse ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 150 } }
        }
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                root.expanded = !root.expanded;
            } else if (mouse.button === Qt.MiddleButton) {
                loadCheatsheets();
            }
        }
    }
    
    // ========== REPRÉSENTATION COMPLÈTE ==========
    fullRepresentation: Rectangle {
        color: root.bgColor
        radius: root.borderRadius
        border.color: root.tertiaryColor
        border.width: root.widgetBorderEnabled ? root.widgetBorderWidth : 0
        Layout.minimumWidth: 700
        Layout.minimumHeight: 500
        Layout.preferredWidth: 900
        Layout.preferredHeight: 600
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            
            // ========== EN-TÊTE ==========
            RowLayout {
                Layout.fillWidth: true
                
                Kirigami.Icon {
                    source: root.customIconPath || "accessories-text-editor"
                    Layout.preferredWidth: root.sheetIconSize
                    Layout.preferredHeight: root.sheetIconSize
                }
                
                PlasmaComponents.Label {
                    text: "Cheaty"
                    font.pixelSize: root.titleFontSize
                    color: root.primaryColor
                    Layout.fillWidth: true
                }
                
                ThemedButton {
                    iconName: "view-refresh"
                    text: "Recharger"
                    onClicked: root.loadCheatsheets()
                }
            }
            
            Kirigami.Separator { Layout.fillWidth: true; color: root.tertiaryColor }
            
            // ========== ZONE PRINCIPALE : LISTE + CONTENU ==========
            SplitView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                orientation: Qt.Horizontal
                
                // ========== PANNEAU GAUCHE : LISTE DES CHEATSHEETS ==========
                Item {
                    SplitView.minimumWidth: 200
                    SplitView.preferredWidth: 250
                    SplitView.maximumWidth: 300
                    
                    ColumnLayout {
                        anchors.fill: parent
                        
                        PlasmaComponents.Label {
                            font.pixelSize: root.textFontSize
                            text: "Cheatsheets (" + root.loadedSheets.length + ")"
                            font.bold: true
                            color: root.textColor
                        }
                        
                        ScrollView {
                            clip: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ListView {
                                id: sheetsList
                                model: root.loadedSheets
                                currentIndex: root.currentSheetIndex
                                
                                delegate: ItemDelegate {
                                    id: sheetDelegate
                                    width: ListView.view.width
                                    height: 50
                                    highlighted: ListView.isCurrentItem
                                    hoverEnabled: true
                                    
                                    background: Rectangle {
                                        radius: root.borderRadius
                                        color: sheetDelegate.highlighted ? root.accentColor
                                             : sheetDelegate.hovered ? root.secondaryColor
                                             : "transparent"
                                    }
                                    
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 10
                                        
                                        Kirigami.Icon {
                                            Layout.preferredWidth: root.sheetIconSize
                                            Layout.preferredHeight: root.sheetIconSize
                                            source: modelData.iconPath ? "file://" + modelData.iconPath : "text-x-generic"
                                        }
                                        
                                        PlasmaComponents.Label {
                                            font.pixelSize: root.textFontSize
                                            text: modelData.name || "Sans nom"
                                            color: sheetDelegate.highlighted ? root.badgeTextColor : root.textColor
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }
                                    
                                    onClicked: {
                                        // Recliquer le cheatsheet sélectionné le referme
                                        if (sheetsList.currentIndex === index) {
                                            sheetsList.currentIndex = -1;
                                            root.currentSheetIndex = -1;
                                            root.currentSheetName = "Sélectionnez un cheatsheet";
                                            root.contentModel.clear();
                                        } else {
                                            sheetsList.currentIndex = index;
                                            root.currentSheetIndex = index;
                                            root.showSheetContent(modelData);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // ========== PANNEAU DROIT : CHEATSHEET SÉLECTIONNÉ ==========
                Item {
                    SplitView.fillWidth: true
                    
                    ColumnLayout {
                        anchors.fill: parent
                        
                        PlasmaComponents.Label {
                            text: root.currentSheetName
                            font.bold: true
                            color: root.primaryColor
                            font.pixelSize: root.titleFontSize - 2
                        }
                        
                        ScrollView {
                            clip: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ListView {
                                id: contentListView
                                model: root.contentModel
                                spacing: 0
                                
                                // Réassigner le modèle force les délégués à se redessiner
                                Connections {
                                    target: root
                                    function onSectionsChanged() {
                                        contentListView.model = null;
                                        contentListView.model = root.contentModel;
                                    }
                                }
                                
                                delegate: Column {
                                    width: contentListView.width
                                    
                                    // ========== EN-TÊTE DE SECTION ==========
                                    Rectangle {
                                        width: parent.width
                                        height: model.isSection ? 35 : 0
                                        visible: model.isSection
                                        color: root.primaryColor
                                        radius: root.borderRadius
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.toggleSection(model.sectionName)
                                        }
                                        
                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            
                                            PlasmaComponents.Label {
                                                font.pixelSize: root.textFontSize
                                                text: (root.isSectionExpanded(model.sectionName) ? "▼ " : "▶ ") + model.sectionName
                                                font.bold: true
                                                color: root.badgeTextColor
                                                Layout.fillWidth: true
                                            }
                                            
                                            PlasmaComponents.Label {
                                                text: "(" + model.itemCount + " items)"
                                                color: root.badgeTextColor
                                                opacity: 0.8
                                                font.pixelSize: root.smallFontSize + 2
                                            }
                                        }
                                    }
                                    
                                    // ========== ITEM (SECTION OUVERTE) ==========
                                    Rectangle {
                                        width: parent.width
                                        height: !model.isSection && root.isSectionExpanded(model.sectionName) ? 
                                               (itemColumn.implicitHeight + 20) : 0
                                        visible: !model.isSection && root.isSectionExpanded(model.sectionName)
                                        color: root.secondaryColor
                                        border.color: root.bgColor
                                        border.width: 2
                                        radius: root.borderRadius + 2
                                        clip: true
                                        
                                        ColumnLayout {
                                            id: itemColumn
                                            width: parent.width - 40
                                            anchors.left: parent.left
                                            anchors.leftMargin: 30
                                            anchors.top: parent.top
                                            anchors.topMargin: 10
                                            spacing: 5
                                            
                                            PlasmaComponents.Label {
                                                font.pixelSize: root.textFontSize
                                                text: model.itemName || ""
                                                font.bold: true
                                                color: root.textColor
                                                Layout.fillWidth: true
                                            }
                                            
                                            PlasmaComponents.Label {
                                                font.pixelSize: root.textFontSize
                                                text: model.description || ""
                                                color: root.secTextColor
                                                wrapMode: Text.WordWrap
                                                Layout.fillWidth: true
                                                visible: text !== ""
                                            }
                                            
                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: codeText.implicitHeight + 10
                                                color: root.tertiaryColor
                                                border.color: root.accentColor
                                                border.width: 1
                                                radius: Math.max(0, root.borderRadius - 1)
                                                visible: model.code !== ""
                                                
                                                PlasmaComponents.Label {
                                                    font.pixelSize: root.textFontSize
                                                    id: codeText
                                                    anchors.fill: parent
                                                    anchors.margins: 5
                                                    text: model.code || ""
                                                    font.family: "monospace"
                                                    color: root.textColor
                                                    wrapMode: Text.Wrap
                                                    textFormat: Text.PlainText
                                                }
                                            }
                                            
                                            ThemedButton {
                                                text: "📋 Copier"
                                                Layout.alignment: Qt.AlignRight
                                                visible: model.code !== ""
                                                
                                                onClicked: {
                                                    let textToCopy = model.code || "";
                                                    if (root.copyToClipboard(textToCopy)) {
                                                        text = "✅ Copié!";
                                                        copiedTimer.restart();
                                                    } else {
                                                        text = "❌ Erreur";
                                                        errorTimer.restart();
                                                    }
                                                }
                                                
                                                Timer {
                                                    id: copiedTimer
                                                    interval: 2000
                                                    onTriggered: parent.text = "📋 Copier"
                                                }
                                                
                                                Timer {
                                                    id: errorTimer
                                                    interval: 3000
                                                    onTriggered: parent.text = "📋 Copier"
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
            
            // ========== BARRE DE STATUT ==========
            Kirigami.Separator { Layout.fillWidth: true; color: root.tertiaryColor }
            
            RowLayout {
                Layout.fillWidth: true
                
                PlasmaComponents.Label {
                    font.pixelSize: root.textFontSize
                    text: "📋 " + root.loadedSheets.length + " cheatsheets chargés"
                    color: root.secTextColor
                }
                
                Item { Layout.fillWidth: true }
                
                PlasmaComponents.Label {
                    text: "Clic-milieu sur l'icône pour recharger | Cliquez sur les sections pour les replier/déplier"
                    color: root.secTextColor
                    opacity: 0.7
                    font.pixelSize: root.smallFontSize
                }
            }
        }
    }
    
    // ========== FONCTIONS ==========
    
    // Remplit contentModel à plat, toutes sections fermées
    function showSheetContent(sheet) {
        console.log("📄 Affichage de:", sheet.name);
        
        root.currentSheetName = sheet.name;
        root.contentModel.clear();
        root.expandedSections = {};
        
        if (!sheet.sections) {
            console.log("❌ Pas de sections dans", sheet.name);
            return;
        }
        
        let allSections = Object.keys(sheet.sections);
        
        for (let i = 0; i < allSections.length; i++) {
            let sectionName = allSections[i];
            let section = sheet.sections[sectionName];
            let items = Object.keys(section);
            
            root.expandedSections[sectionName] = false;
            
            root.contentModel.append({
                isSection: true,
                sectionName: sectionName,
                itemCount: items.length,
                itemName: "",
                description: "",
                code: ""
            });
            
            for (let j = 0; j < items.length; j++) {
                let itemName = items[j];
                let item = section[itemName];
                
                root.contentModel.append({
                    isSection: false,
                    sectionName: sectionName,
                    itemCount: 0,
                    itemName: itemName,
                    description: item.description || "",
                    code: item.code || ""
                });
            }
        }
        
        console.log("✅ Total entrées ajoutées:", root.contentModel.count);
    }
    
    function toggleSection(sectionName) {
        // Nouvel objet : modifier expandedSections sur place ne notifierait pas les liaisons
        let newExpandedSections = Object.assign({}, root.expandedSections);
        newExpandedSections[sectionName] = !newExpandedSections[sectionName];
        root.expandedSections = newExpandedSections;
        root.sectionsChanged();
    }
    
    function isSectionExpanded(sectionName) {
        return root.expandedSections[sectionName] === true;
    }
    
    // Ne retient que les sous-dossiers de refdocs qui ont un sheet.json valide
    function loadCheatsheets() {
        console.log("🔄 Rechargement des cheatsheets...");
        loadedSheets = [];

        for (let i = 0; i < refdocsModel.count; i++) {
            let folderName = refdocsModel.get(i, "fileName");
            let folderPath = cheatsheetFolder + "/" + folderName;
            let sheetData = loadSheetFromFolder(folderPath);
            if (sheetData) {
                loadedSheets.push(sheetData);
            }
        }
        
        console.log("✅ Chargé:", loadedSheets.length, "cheatsheets");
        loadedSheetsChanged();
    }
    
    function loadSheetFromFolder(folderPath) {
        try {
            let sheetJsonPath = folderPath + "/sheet.json";
            let iconPath = folderPath + "/icon.svg";
            
            let xhr = new XMLHttpRequest();
            xhr.open("GET", "file://" + sheetJsonPath, false);
            xhr.send();
            
            // Avec file://, un fichier absent peut donner status 0 et une réponse vide
            if ((xhr.status === 200 || xhr.status === 0) && xhr.responseText) {
                let sheetData = JSON.parse(xhr.responseText);
                sheetData.iconPath = iconPath;
                sheetData.folderPath = folderPath;
                return sheetData;
            }
        } catch (e) {
            console.log("❌ Erreur chargement:", folderPath, e.toString());
        }
        return null;
    }
    
    // Essaie trois méthodes, de la plus fiable sous Plasma au dernier recours
    function copyToClipboard(text) {
        let textString = String(text || "");
        
        if (!textString || textString.trim() === "") {
            console.log("❌ Texte vide");
            return false;
        }
        
        // Méthode 1 : PlasmaCore.DataSource
        try {
            let clipboardSource = Qt.createQmlObject(`
                import QtQuick
                import org.kde.plasma.core as PlasmaCore
                
                PlasmaCore.DataSource {
                    engine: "clipboard"
                    connectedSources: ["clipboard"]
                    
                    function setClipboardText(text) {
                        var service = serviceForSource("clipboard");
                        var operation = service.operationDescription("copy");
                        operation.text = text;
                        service.startOperationCall(operation);
                    }
                }
            `, root, "clipboardDataSource");
            
            clipboardSource.setClipboardText(textString);
            clipboardSource.destroy();
            console.log("✅ Copie réussie via PlasmaCore");
            return true;
        } catch (e) {
            console.log("⚠️ PlasmaCore erreur:", e.toString());
        }
        
        // Méthode 2 : Qt.application.clipboard
        try {
            if (typeof Qt !== 'undefined' && Qt.application && Qt.application.clipboard) {
                Qt.application.clipboard.text = textString;
                console.log("✅ Copie réussie via Qt.application");
                return true;
            }
        } catch (e) {
            console.log("⚠️ Qt.application erreur:", e.toString());
        }
        
        // Méthode 3 : TextArea temporaire
        try {
            let textArea = Qt.createQmlObject(`
                import QtQuick
                import QtQuick.Controls
                
                TextArea {
                    visible: false
                    width: 1
                    height: 1
                    text: ""
                }
            `, root, "tempTextArea");
            
            textArea.text = textString;
            textArea.selectAll();
            textArea.copy();
            textArea.destroy();
            console.log("✅ Copie réussie via TextArea");
            return true;
        } catch (e) {
            console.log("⚠️ TextArea erreur:", e.toString());
        }
        
        console.log("❌ Toutes les méthodes de copie ont échoué");
        return false;
    }
}
