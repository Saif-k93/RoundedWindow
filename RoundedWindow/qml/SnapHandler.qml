import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: mainItem

    property real screenWidth
    property real screenHeight
    property real __SnapBarWidth
    property real __SnapBarHeight
    property real windowX
    property real windowY
    property alias snapItem: __SnapBar
    property alias snapItemBottom: __SnapBarBottom
    property alias snapItemMaximize: __SnapBarMaximize
    property alias snapItemTop: __topSnap
    readonly property real _snapWidth: __SnapBar.snapWidth
    readonly property real _snapHeight: __SnapBar.snapHeight
    readonly property real _snapX: __SnapBar.snapX
    readonly property real _lastSnapWidth: __SnapBar.lastSnapWidth
    readonly property real _lastSnapHeight: __SnapBar.lastSnapHeight
    property real actualScreenWidth
    property real actualScreenHeight
    property real cursorX
    property real cursorY
    property real topSnapBarBeginX
    property real topSnapBarEndX

    Connections {
        id: mouseMoveDetector

        target: ScreenHandler
        function onMouseXChanged() {
            cursorX = ScreenHandler.mouseX
            topSnapBarBeginX = (actualScreenWidth - __topSnap.width) / 2
            topSnapBarEndX = actualScreenWidth - __topSnap.x
        }
        function onMouseYChanged() {
            cursorY = ScreenHandler.mouseY

            if(cursorY <= 5
                    && (cursorX >= topSnapBarBeginX & cursorX <= topSnapBarEndX)) {
                __topSnap.height = 100
            }
            else if(cursorY > 100
                    || cursorX <= (actualScreenWidth - __topSnap.width) / 2
                    || cursorX >= actualScreenWidth - __topSnap.x) {
                  __topSnap.height = 25
            }
        }
    }

    ////////////////////////////////////  Not Used Functions  ////////////////////////////////////////////////////
    function rightSnapHandler() {
        if(root.width >= 1300)
        {
            __SnapBarWidth = (screenWidth + root.width /2)
            __SnapBar.setWidth(__SnapBarWidth)
        }
        else if(root.width >= 800 && root.width <= 1299) {
            __SnapBarWidth = (windowX / 1.15)
            __SnapBar.setWidth(__SnapBarWidth)
        }
        else {
            __SnapBarWidth = (windowX / 2)
            __SnapBar.setWidth(__SnapBarWidth)
        }
    }
    function leftSnapHandler() {
        if(root.width >= 1300)
        {
            __SnapBarWidth = (root.width / 1.35)
            __SnapBar.setWidth(__SnapBarWidth)
        }
        else if(root.width >= 800 && root.width <= 1299) {
            __SnapBarWidth = ((-windowX + (screenWidth - screenWidth / 3.25)) * 1.15)
            __SnapBar.setWidth(__SnapBarWidth)
        }
        else {
            __SnapBarWidth = ((-windowX + (screenWidth - screenWidth / 1.58)) * 1.15)
            __SnapBar.setWidth(__SnapBarWidth)
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function getScreenWidth_Height() {
        actualScreenWidth = (ScreenHandler.getScreenWidth(root.width) + root.width)
        actualScreenHeight = (ScreenHandler.getScreenHeight())
    }
    function setSnapBarX() {
        if((screenWidth - windowX) < 0) __SnapBar.x = ScreenHandler.getScreenWidth(__SnapBar.width)
        if((screenWidth - windowX) > 0) __SnapBar.x = 0
    }

    SnapBar {
        id: __SnapBar

        visible: false

    }
    SnapBar {
        id: __SnapBarBottom

        visible: false

    }

    Connections {
        id: detectDragging

        target: root
        function onXChanged() {
            if(windowHandler.__dragAreaPressed) {
                screenWidth = ScreenHandler.getScreenWidth(root.width)
                screenHeight = ScreenHandler.getScreenHeight()
                __SnapBarWidth = ScreenHandler.getScreenWidth(root.width)
                __SnapBarHeight = ScreenHandler.getScreenHeight()
                windowX = root.x
                windowY = root.y
            }
        }
    }

    onWindowXChanged: {
        if(!__SnapBarBottom.visible && root.y > __topSnap.height) {
            getScreenWidth_Height()
            if(root.width <= (actualScreenWidth -400) && !__resizeActive) {

                if((screenWidth - windowX) < 0) {
                    root.setWidth(root.minimumWidth)
                    __SnapBar.visible = true
                    __SnapBarWidth = ((windowX + root.width) / 2.25)

                    if(__SnapBarWidth < root.minimumWidth)
                        __SnapBarWidth = root.minimumWidth

                    __SnapBar.setWidth(__SnapBarWidth)
                    __SnapBar.setHeight(__SnapBarHeight)
                    setSnapBarX()
                    __SnapBar.setY(0)

                    //           rightSnapHandler()   // another algorithm to handle snaping
                }

                else if(screenWidth - windowX > screenWidth + 3) {
                    root.setWidth(root.minimumWidth)
                    __SnapBar.visible = true
                    __SnapBarWidth = ((-windowX + (screenWidth - screenWidth / 1.58)) * 1.15)

                    if(__SnapBarWidth < root.minimumWidth)
                        __SnapBarWidth = root.minimumWidth
                    __SnapBar.setWidth(__SnapBarWidth)
                    __SnapBar.setHeight(__SnapBarHeight)
                    setSnapBarX()
                    __SnapBar.setY(0)

                    //            leftSnapHandler()  // another algorithm to handle snaping
                }
                else
                    __SnapBar.visible = false
            }
        }
    }


    onWindowYChanged: {
        if(!__SnapBar.visible) {
            getScreenWidth_Height()
            if((root.y + (root.height / 2)) > actualScreenHeight) {
                __SnapBarBottom.visible = true
                __SnapBarBottom.setWidth(actualScreenWidth)
                __SnapBarBottom.setHeight(windowY / 1.3)
                __SnapBarBottom.setY(actualScreenHeight - __SnapBarBottom.height)
                __SnapBarBottom.setX(0)
            }
            else
                __SnapBarBottom.visible = false

        }
        if(root.y <= 250
                && windowHandler.__dragAreaPressed
                && !__SnapBar.visible
                && !__SnapBarBottom.visible) {
            __topSnap.visible = true
        }
        else
            __topSnap.visible = false
        dragArea.cursorShape = Qt.ClosedHandCursor
    }

    SnapBar {
        id: __SnapBarMaximize

        visible: false
        subround: 3

        objectName: qsTr("__SnapBarMaximize")

        SnapLayers {
            id: snapLayers

        }
    }

    SnapBar {
        id: __topSnap

        objectName: "__topSnap"

        width: 548
        x: (actualScreenWidth - width) / 2

        Component.onCompleted: height = 25

        visible: false

        Behavior on height {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutBack
            }
        }
        onFocusObjectChanged:  {
            visible = false
        }

        SnapTopLayers {
            id: snapTopLayers

        }
    }

    Connections {
        target: windowHandler.maximizeButton
        function onEntered() {
            windowHandler.maximizeButton.pressAndHoldInterval = 300
        }
        function onPressAndHold(mouse) {
            if(mouse.button === Qt.LeftButton) {
                getScreenWidth_Height()

                __SnapBarMaximize.width = 300
                __SnapBarMaximize.height = 200
                __SnapBarMaximize.x = root.x + (root.width - (__SnapBarMaximize.width + 50))
                __SnapBarMaximize.y = (root.y + windowHandler.maximizeButton.height * 2)
                __SnapBarMaximize.visible = true
            }
        }
    }


}

