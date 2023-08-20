import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: snapBarRec

    visible: false
    color: "transparent"
    flags: Qt.FramelessWindowHint

    property real snapWidth
    property real snapHeight
    property real snapX
    property real lastSnapWidth
    property real lastSnapHeight
    property real flag: 0
    property real subround: root.round
    property alias snapRect: snapRect
    property alias snapBarArea: snapBarArea

    function checkRound() {
        if(subround > 10) {
            return subround
        }
        else
            return 10
    }

    Component {
        id: opacity_Animator

        OpacityAnimator {
            target: snapRect
            running: visible
            loops: 1
            from: .4
            to: 1
            duration: 400
        }
    }

    Component.onCompleted: {
        if(snapBarRec.objectName !== "__topSnap") WindowShape.applyRadius(this, checkRound())
        if(snapBarRec.objectName === "__SnapBarMaximize" || snapBarRec.objectName === "__topSnap") {
            opacity_Animator.createObject(snapRect)
        }
    }

    onWidthChanged: if(snapBarRec.objectName === "__topSnap")
                        WindowShape.applyRadius(snapBarRec, 5)
                    else
                        WindowShape.applyRadius(snapBarRec, checkRound())

    onHeightChanged: if(snapBarRec.objectName === "__topSnap")
                         WindowShape.applyRadius(this, 5)
                     else
                         WindowShape.applyRadius(this, checkRound())

    Rectangle {
        id: snapRect

        color: snapBarRec.objectName === "__SnapBarMaximize" ? "#E6eeeeee" : "#80d3d3d3"
        anchors.fill: parent
        antialiasing: true

        radius: {
            if(snapBarRec.objectName !== "__topSnap")
                return checkRound() + 15
            else
                return 5
        }
        border.color: snapBarRec.objectName === "__SnapBarMaximize" ? "gray" : "black"
        border.width: 1
        clip: true

        MouseArea {
            id: snapBarArea

            anchors.fill: parent
            hoverEnabled: true
        }

    }

    Connections {
        target: windowHandler
        function onActiveFocusChanged() {
            if(windowHandler.activeFocus && flag !== 0) {
                visible = false
            }

            flag++
            if(flag > 1) flag = 1
        }
    }

    onVisibleChanged: (visible) =>
                      {
                          if(!visible && windowHandler.activeFocus
                             && snapBarRec.objectName !== "__SnapBarMaximize"
                             && snapBarRec.objectName !== "__topSnap")
                          {
                              lastSnapWidth = root.width
                              root.setWidth(width)
                              snapWidth = root.width
                              root.setX(x)
                              snapX = root.x
                              lastSnapHeight = root.height
                              root.setHeight(height)
                              snapHeight = root.height
                              root.setY(y)
                          }
                      }
}
