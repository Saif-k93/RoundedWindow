import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.platform
import QtQuick.Layouts


ApplicationWindow {

    visible: true
    minimumWidth: 540
    minimumHeight: 400
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window

    opacity: windowHandler.__snapBottomVisible.visible ? 0.2
                                                       : windowHandler.__snapVisible.visible ? 0.2 : 1

    property real round: 10
    property real lastRound: round
    property real checker:0
    property real lastVisibility: visibility
    property alias __resizeActive: resizeHandler.resizeActive

    SystemTrayIcon {
        id: systemTrayIcon

        visible: true
        icon.mask: true
        icon.source: "qrc:/img/icons/tray/SystemTray.png"

        tooltip: qsTr("MyApp\nDouble Click To Restore / Right Click For Options")

        onActivated: (activated) => {
                         if(activated === SystemTrayIcon.DoubleClick) {
                             if(root.visibility === 0) {
                                 root.show()
                                 root.raise()
                                 root.requestActivate()
                                 root.visibility = windowHandler.__lastvisibility
                             }
                         }
                     }

        menu: OptionsMenu {
            __roundItem.visible: false
            onRestoreClicked: root.visibility = windowHandler.__lastvisibility
            __restoreItem.visible: root.visibility === 0
        }
    }

    onVisibilityChanged: focusTimer.start()

    Timer {
        id: timer

        interval: 10
        repeat: false
        running: false
        onTriggered: {
            windowHandler.__closeRect.anchors.rightMargin = round + 5
        }
    }
    Timer {
        id: focusTimer

        repeat: false
        running: false
        interval: 1
        onTriggered: windowHandler.forceActiveFocus()
    }

    onRoundChanged: {
        if(round > 194) {
            round = 194
            WindowShape.applyRadius(this, round)
        }else if(round < 0) {
            round = 0
            WindowShape.applyRadius(this, round)
        }else {
            WindowShape.applyRadius(this, round)
        }
        timer.start()
    }

    Connections {
        target: root
        function onVisibilityChanged() {
            if(root.visibility === 4){
                lastVisibility = root.visibility
                lastRound = round
                round = 0
                windowHandler.__roundRect.visible = false
            }

            else if(root.visibility === 0 && lastVisibility !== 4) {
                lastRound = round
            }
            else if(root.visibility === 2 && lastVisibility === 4) {
                round = lastRound
                windowHandler.__roundRect.visible = true
            }
            else {
                round = lastRound
                windowHandler.__roundRect.visible = true
            }
        }
    }


    onWidthChanged: {
        WindowShape.applyRadius(this, round)
        if(root.width < root.minimumWidth) root.setWidth(root.minimumWidth)
    }
    onHeightChanged:{
        WindowShape.applyRadius(this, round)
        if(root.height < root.minimumHeight) root.setHeight(root.minimumHeight)
    }

    Component.onCompleted: {
        WindowShape.applyRadius(this, round)

    }

    NumberAnimation {
        target: root

        running: true
        loops: 1
        property: "opacity"
        from: 0
        to: 1
        easing.type: Easing.OutQuad
        duration: 500
    }

    ResizeHandler {
        id: resizeHandler

    }


}
