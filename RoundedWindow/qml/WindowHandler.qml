import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import QtQuick.Controls.Material
import "../js/Alpha.js" as Alpha


Rectangle {
    id: mainRec

    anchors.fill: parent
    antialiasing: true

    scale: snapHandler.snapItemTop.height >= 100
           && snapHandler.snapItemTop.visible
           && root.visibility !== 4
           && !windowHandler.activeFocus ? 0.2 : 1

    onActiveFocusChanged: {
        if(activeFocus) {
            ScreenHandler.cursorTimerStop();
            __dragAreaPressed = false
        }
    }

    OptionsMenu {
        id: optionsMenu

    }

    SnapHandler {
        id: snapHandler

    }

    property string topColor: "f9f9f9"
    property string alpha: Alpha.get(alphaValue)
    property string subAlpha: {
        if(alpha === "00"
                || "1A"
                || "33"
                || "4D") return "66"
        else
            return alpha
    }
    property real __lastvisibility: 2
    property real alphaValue: 100
    property bool __dragAreaPressed: false
    property alias __snapVisible: snapHandler.snapItem
    property alias __snapBottomVisible: snapHandler.snapItemBottom
    property alias maximizeButton: area2

    Component {
        id: __gradient

        Gradient {
            GradientStop {position: 0.0; color: "#" + alpha + topColor}
            GradientStop {position: 0.5; color: "#" + alpha + "f9f9f9"}
            GradientStop {position: 1.0; color: "#" + alpha + "f4f1f1"}
        }
    }

    Component {
        id: rec_gradient

        Gradient {
            GradientStop {position: 0.0; color: "#" + subAlpha + topColor}
            GradientStop {position: 0.5; color: "#" + subAlpha + topColor}
            GradientStop {position: 1.0; color: "#" + subAlpha + topColor}
        }
    }

    function getGradient(parent, currentColor) {
        if(parent.color.toString() === currentColor) {
            return rec_gradient.createObject(parent)
        }
        else return null
    }

    gradient: __gradient.createObject(mainRec)


    radius: root.round + 15
    border.color: activeFocus ? "#0078d4" : "#bfbfbf"
    border.width: 1
    clip: true
    focus: true

    property var __closeRect: closeRect
    property alias __roundRect: roundRect
    property real h_Min: snapHandler._snapHeight + 7
    property real h_Max: snapHandler._snapHeight - 1

    DragHandler {
        id: dragHandler

        enabled: dragArea.pressed
        onActiveChanged:{
            if(!activeFocus)
                forceActiveFocus()
            if(active){
                if(root.height >=  h_Max && root.height <= h_Min)
                {
                    root.setWidth(snapHandler._lastSnapWidth)
                    root.setHeight(snapHandler._lastSnapHeight)
                    if(root.x === snapHandler.screenWidth)
                        ScreenHandler.setCursorPos(((snapHandler.screenWidth + root.width) - (root.width / 2)), 15)
                    if(root.x === 0)
                        ScreenHandler.setCursorPos(root.width / 2, 15)
                }
                startSystemMove()
            }
        }
    }

    MouseArea {
        id:dragArea

        height: 80
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            leftMargin: 10
            topMargin: 10
            rightMargin: 70
        }

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
                       if(mouse.button === Qt.RightButton){
                           optionsMenu.open()
                       }
                       parent.forceActiveFocus()
                   }

        onDoubleClicked: (mouse) => {
                             if(mouse.button === Qt.LeftButton) {
                                 if(visibility !== 4){
                                     showMaximized()
                                 }else {
                                     showNormal()
                                 }
                                 ScreenHandler.cursorTimerStop();
                             }
                         }

        onPressed: {
            __dragAreaPressed = true
            ScreenHandler.cursorTimerStart()
        }

        onReleased: {
            __dragAreaPressed = false
            ScreenHandler.cursorTimerStop();
        }

        onMouseXChanged: {
            if(cursorShape !== Qt.ArrowCursor)
                cursorShape = Qt.ArrowCursor
        }

        onMouseYChanged: if(cursorShape !== Qt.ArrowCursor) cursorShape = Qt.ArrowCursor
        onEntered: if(cursorShape !== Qt.ArrowCursor) cursorShape = Qt.ArrowCursor
        onExited: if(cursorShape !== Qt.ArrowCursor) cursorShape = Qt.ArrowCursor
    }

    MouseArea {
        id: focusArea

        anchors {
            top: dragArea.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            rightMargin: 4
            leftMargin: 4
            bottomMargin: 4
        }
        onClicked: parent.forceActiveFocus()
    }

    Rectangle {
        id: closeRect

        width: 32
        height: 32
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: __closeRect
            topMargin: 20
        }
        radius: 8
        color: hover1.hovered ? area1.pressed ? "#99f95c5c" : "#c42b1c" : "#f3f3f3"
        gradient: getGradient(closeRect, "#f3f3f3")

        BorderImage {
            id: img1
            source: "qrc:/img/icons/topbar/Close.png"
            width: 32; height: 32
            border.left: 1; border.top: 1
            border.right: 1; border.bottom: 1
            anchors {
                fill: parent
                margins: 7
            }
            RotationAnimator {
                target: img1
                duration: 200
                from: 0
                to: 100
                running: hover1.hovered
                onStopped: img1.rotation = 180
                loops: 1
            }
            OpacityAnimator {
                target: closeRect
                from: 0
                to: 1
                duration: 500
                loops: 1
                running: hover1.hovered
                onStopped: closeRect.opacity = 1
            }
        }
        HoverHandler {
            id: hover1

            acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        }
        MouseArea {
            id: area1

            hoverEnabled: true
            onEntered: hover1.enabled = true
            onExited: hover1.enabled = false
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onReleased: hover1.hovered ? Qt.quit() : hover1.enabled = true
        }
    }

    Rectangle {
        id: maximizeRect

        width: 32
        height: 32
        anchors {
            top: parent.top
            right: closeRect.left
            rightMargin: 2
            topMargin: 20

        }
        radius: 8
        color: hover2.hovered ? area2.pressed ? "#490f7fd6" : "#0f7fd6" : "#f3f3f3"
        gradient: getGradient(maximizeRect, "#f3f3f3")

        BorderImage {
            id: img2
            source: root.visibility === 4 ? "qrc:/img/icons/topbar/Restore.png" : "qrc:/img/icons/topbar/Maximize.png"
            width: 32; height: 32
            border.left: 1; border.top: 1
            border.right: 1; border.bottom: 1
            anchors {
                fill: parent
                margins: 7
            }
            RotationAnimator {
                target: img2
                duration: 200
                from: 0
                to: 100
                running: hover2.hovered
                onStopped: img2.rotation = 180
                loops: 1
            }
            OpacityAnimator {
                target: maximizeRect
                from: 0
                to: 1
                duration: 500
                loops: 1
                running: hover2.hovered
                onStopped: maximizeRect.opacity = 1
            }
        }
        HoverHandler {
            id: hover2

            acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        }
        MouseArea {
            id: area2

            hoverEnabled: true
            onEntered: hover2.enabled = true
            onExited: hover2.enabled = false
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onReleased: hover2.hovered ? visibility === 4 ? root.showNormal() : root.showMaximized() : hover2.enabled = true
        }
    }

    Rectangle {
        id: minimizeRect

        width: 32
        height: 32
        anchors {
            top: parent.top
            right: maximizeRect.left
            rightMargin: 2
            topMargin: 20

        }
        radius: 8
        color: hover3.hovered ? area3.pressed ? "#490f7fd6" : "#0f7fd6" : "#f3f3f3"
        gradient: getGradient(minimizeRect, "#f3f3f3")

        BorderImage {
            id: img3
            source: "qrc:/img/icons/topbar/Minimize.png"
            width: 32; height: 32
            border.left: 1; border.top: 1
            border.right: 1; border.bottom: 1
            anchors {
                fill: parent
                margins: 7
            }
            RotationAnimator {
                target: img3
                duration: 200
                from: 0
                to: 100
                running: hover3.hovered
                onStopped: img3.rotation = 180
                loops: 1
            }
            OpacityAnimator {
                target: minimizeRect
                from: 0
                to: 1
                duration: 500
                loops: 1
                running: hover3.hovered
                onStopped: minimizeRect.opacity = 1
            }
        }
        HoverHandler {
            id: hover3

            acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        }
        MouseArea {
            id: area3

            hoverEnabled: true
            onEntered: hover3.enabled = true
            onExited: hover3.enabled = false
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onReleased: {
                __lastvisibility = visibility; hover3.hovered ? root.hide() : hover3.enabled = true
                snapHandler.snapItemTop.visible = false
            }
        }
    }

    Rectangle {
        id: roundRect

        width: 32
        height: 32
        anchors {
            top: parent.top
            right: minimizeRect.left
            rightMargin: 2
            topMargin: 20

        }

        radius: 8
        color: hover4.hovered ? area4.pressed ? "#79f9c7ed" : "#f9c7ed"
        : roundSlider.activeFocus | activeFocus ? "#f9c7ed" : "#f3f3f3"
        gradient: getGradient(roundRect, "#f3f3f3")

        BorderImage {
            id: img4

            source: "qrc:/img/icons/topbar/Round.png"
            width: 32; height: 32
            border.left: 1; border.top: 1
            border.right: 1; border.bottom: 1
            anchors {
                fill: parent
                margins: 7
            }
            RotationAnimator {
                target: img4
                duration: 200
                from: 0
                to: 100
                running: hover4.hovered & (!roundRect.activeFocus && !roundSlider.activeFocus)
                onStopped: img4.rotation = 180
                loops: 1
            }
            OpacityAnimator {
                target: roundRect
                from: 0
                to: 1
                duration: 500
                loops: 1
                running: hover4.hovered & (!roundRect.activeFocus && !roundSlider.activeFocus)
                onStopped: roundRect.opacity = 1
            }
        }
        HoverHandler {
            id: hover4

            acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        }
        MouseArea {
            id: area4

            hoverEnabled: true
            onEntered: hover4.enabled = true
            onExited: hover4.enabled = false
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onReleased: {
                if(hover4.hovered) {
                    roundRect.focus = !roundRect.focus
                }
            }
        }

        Slider {
            id: roundSlider

            height: 20
            width: 60
            from: 0
            value: root.round
            to: 194
            visible: roundRect.activeFocus | roundSlider.activeFocus | mouseArea.activeFocus
            anchors {
                top: roundRect.bottom
                right: roundRect.horizontalCenter
                topMargin: 2
            }
            transform: Rotation {origin.x: 20; origin.y: -8; angle: -90}

            handle: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0; color: "#ffffff" }
                    GradientStop { position: 1; color: "#c1bbf9" }
                }
            }

            background: Rectangle {
                id: innerRect

                width: roundSlider.width
                height: hoverHandler.hovered ? 11 : 8
                radius: 8
                color: "#d5d5d5"

                Rectangle {
                    id:outerRect

                    width:  roundSlider.position*parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "gray"
                }
                HoverHandler {
                    id: hoverHandler

                    acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
                }
                MouseArea {
                    id: mouseArea

                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                }
                Behavior on height {
                    SmoothedAnimation {velocity: 20}
                }
            }

            property int counter: 0
            onValueChanged: {
                if(round !== Math.round(value)) {
                    round = Math.round(value)
                }
                if(counter > 0) roundRect.forceActiveFocus()
                counter++
                if(counter > 1) counter = 1
            }
        }
        Slider {
            id: alphaSlider

            height: 20
            width: 125
            from: 0
            value: 100
            to: 100
            stepSize: 10
            visible: roundRect.activeFocus | alphaSlider.activeFocus | mouseArea2.activeFocus
            anchors {
                top: parent.bottom
                topMargin: 5
            }

            handle: Rectangle {}

            background: Rectangle {
                id: __innerRect

                width: alphaSlider.width
                height: hoverHandler2.hovered ? 12 : 8
                radius: 8
                color: "#d5d5d5"

                Rectangle {
                    id:__outerRect

                    width:  alphaSlider.position*parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "gray"
                }
                HoverHandler {
                    id: hoverHandler2

                    acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
                }

                MouseArea {
                    id: mouseArea2

                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                }
                Behavior on height {
                    SmoothedAnimation {velocity: 20}
                }
            }
            property int counter: 0
            onValueChanged: {
                if(alphaValue !== Math.round(value)) {
                    alphaValue = Math.round(value)
                }
                if(counter > 0) roundRect.forceActiveFocus()
                counter++
                if(counter > 1) counter = 1
            }
        }
    }


}
