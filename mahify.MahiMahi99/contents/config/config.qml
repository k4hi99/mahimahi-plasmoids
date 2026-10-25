import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Couleurs")
        icon: "preferences-desktop-color"
        source: "configColors.qml"
    }
    ConfigCategory {
        name: i18n("Tailles")
        icon: "transform-scale"
        source: "configSizes.qml"
    }
}
