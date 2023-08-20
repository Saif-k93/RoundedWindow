import QtQuick

Rectangle {
    id: main_Rect

    antialiasing: true

    property string curveSide

    function setAnchors(_parent) {
        if(curveSide === "leftCurved") {
            _parent.anchors.top = _parent.parent.top
            _parent.anchors.right = _parent.parent.right
            _parent.anchors.bottom = _parent.parent.bottom
        }
        if(curveSide === "rightCurved") {
            _parent.anchors.top = _parent.parent.top
            _parent.anchors.left = _parent.parent.left
            _parent.anchors.bottom = _parent.parent.bottom
        }
        if(curveSide === "topCurved") {
            _parent.anchors.right = _parent.parent.right
            _parent.anchors.left = _parent.parent.left
            _parent.anchors.bottom = _parent.parent.bottom
        }
        if(curveSide === "bottomCurved") {
            _parent.anchors.right = _parent.parent.right
            _parent.anchors.left = _parent.parent.left
            _parent.anchors.top = _parent.parent.top
        }
        if(curveSide === "allSideCurved") {
            _parent.width = 0
            _parent.height = 0
        }

    }

    function setInnerAnchors(_parent) {
        if(curveSide === "leftCurved") {
            _parent.anchors.fill = _parent.parent
            _parent.anchors.topMargin = 1
            _parent.anchors.rightMargin = 1
            _parent.anchors.bottomMargin = 1
        }
        if(curveSide === "rightCurved") {
            _parent.anchors.fill = _parent.parent
            _parent.anchors.topMargin = 1
            _parent.anchors.leftMargin = 1
            _parent.anchors.bottomMargin = 1
        }
        if(curveSide === "topCurved") {
            _parent.anchors.fill = _parent.parent
            _parent.anchors.rightMargin = 1
            _parent.anchors.leftMargin = 1
            _parent.anchors.bottomMargin = 1
        }
        if(curveSide === "bottomCurved") {
            _parent.anchors.fill = _parent.parent
            _parent.anchors.rightMargin = 1
            _parent.anchors.leftMargin = 1
            _parent.anchors.topMargin = 1
        }

    }


    function setSelectedSize() {
        snapHandler.getScreenWidth_Height()

        if(main_Rect.objectName === "leftCurved") {
            root.x = 0
            root.y = 0
            root.setWidth(actualScreenWidth / 2)
            root.setHeight(actualScreenHeight)
        }
        if(main_Rect.objectName === "rightCurved") {
            root.setWidth(actualScreenWidth / 2)
            root.x = (actualScreenWidth - root.width)
            root.setHeight(actualScreenHeight)
            root.y = 0
        }
        if(main_Rect.objectName === "topCurved") {
            root.setWidth(actualScreenWidth)
            root.setHeight(actualScreenHeight / 2)
            root.x = 0
            root.y = 0
        }
        if(main_Rect.objectName === "bottomCurved") {
            root.setWidth(actualScreenWidth)
            root.setHeight(actualScreenHeight / 2)
            root.x = 0
            root.y = (actualScreenHeight - root.height)
        }
        if(main_Rect.objectName === "allSideCurved") {
            root.setWidth(actualScreenWidth - actualScreenHeight)
            root.setHeight(actualScreenHeight)
            root.x = ((actualScreenWidth - root.width) / 2)
            root.y = 0
        }
        if(main_Rect.objectName === "leftTopCurved") {
            root.setWidth(actualScreenWidth / 2)
            root.setHeight(actualScreenHeight / 2)
            root.x = 0
            root.y = 0
        }
        if(main_Rect.objectName === "rightTopCurved") {
            root.setWidth(actualScreenWidth / 2)
            root.setHeight(actualScreenHeight / 2)
            root.x = (actualScreenWidth / 2)
            root.y = 0
        }
        if(main_Rect.objectName === "leftBottomCurved") {
            root.setWidth(actualScreenWidth / 2)
            root.setHeight(actualScreenHeight / 2)
            root.x = 0
            root.y = (actualScreenHeight - root.height)
        }
        if(main_Rect.objectName === "rightBottomCurved") {
            root.setWidth(actualScreenWidth / 2)
            root.setHeight(actualScreenHeight / 2)
            root.x = (actualScreenWidth - root.width)
            root.y = (actualScreenHeight - root.height)
        }
        if(main_Rect.objectName === "fullCurved") {
            showMaximized()
        }
    }

    Timer {
        id: topBarHider

        interval: 1
        repeat: false
        onTriggered: {
            __topSnap.hide()
        }
    }

    width: 50
    height: 80

    color: hover_handler.hovered ?
               mouse_area.pressed ?
                   Qt.lighter("#0067c0") : "#0067c0" : "#d6d6d6"
    border.color: hover_handler.hovered ? "black" : Qt.darker("#717171")
    border.width: 0.5
    radius: 15


    Rectangle {
        color: parent.border.color
        width: parent.radius
        height: parent.radius
        Component.onCompleted: parent.setAnchors(this)

        Rectangle {
            anchors.fill: parent
            Component.onCompleted: parent.parent.setInnerAnchors(this)
            color: parent.parent.color
        }
    }

    HoverHandler {
        id: hover_handler

        acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus

    }

    MouseArea {
        id: mouse_area

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onReleased: {
            __SnapBarMaximize.visible = false
            topBarHider.start()
            setSelectedSize()
        }

    }

    PropertyAnimation {
        id: scaleAnimator

        target: main_Rect
        property: "scale"
        from: 0.8
        to: 1
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: scale = 1
        loops: 1
    }
    onColorChanged: {
        if(color.toString() === "#0067c0") {
                            scaleAnimator.start()
                        }
    }
}
