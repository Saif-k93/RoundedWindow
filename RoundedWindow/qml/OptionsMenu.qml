import QtQuick
import QtQuick.Controls
import Qt.labs.platform

Menu {

    property alias __roundItem: roundItem
    property alias __restoreItem: restoreItem
    signal restoreClicked()

    MenuItem {
        id: restoreItem

        text: qsTr("Restore")
        icon.mask: true
        icon.source: "qrc:/img/icons/topbar/Restore.png"
        shortcut: "Ctrl+N"
        enabled: root.visibility === 4 || root.visibility === 0
        onTriggered: {
            showNormal()
            restoreClicked()
        }

    }

    MenuItem {
        text: qsTr("Maximize")
        icon.mask: true
        icon.source: "qrc:/img/icons/topbar/Maximize.png"
        shortcut: "Ctrl+F"
        enabled: root.visibility === 2 || root.visibility === 0
        onTriggered: showMaximized()
    }

    MenuItem {
        text: qsTr("Minimize To SystemTray")
        icon.mask: true
        icon.source: "qrc:/img/icons/topbar/Minimize.png"
        shortcut: "Ctrl+M"
        enabled: root.visibility !== 0
        onTriggered:{
            windowHandler.__lastvisibility = visibility
            hide()
        }
    }
    MenuItem {
        id: roundItem

        text: qsTr("Round / Aplha")
        icon.mask: true
        icon.source: "qrc:/img/icons/topbar/Round.png"
        shortcut: "Ctrl+R"
        enabled: root.visibility !== 4
        visible: root.visibility !== 0
        onTriggered: roundRect.forceActiveFocus()
    }

    MenuSeparator {}

    MenuItem {
        text: qsTr("Close")
        icon.mask: true
        icon.source: "qrc:/img/icons/topbar/Close.png"
        onTriggered: Qt.quit()
    }

}


