import QtQuick

MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    enabled: visibility !== 4

    property int edges: 0
    property int edgeOffest: 5
    property bool resizeActive: false
    property real screenSizeW
    property real screenSizeH
    property real lastWindowX
    property real lastWindowW
    property real lastWindowH
    property real lastWindowY
    property real wflag: 0
    property real hflag: 0

    function setEdges(x, y) {
        edges = 0;
        if(x < edgeOffest) edges |= Qt.LeftEdge;
        if(x > (width - edgeOffest)) edges |= Qt.RightEdge;
        if(y < edgeOffest) edges |= Qt.TopEdge;
        if(y > (height - edgeOffest)) edges |= Qt.BottomEdge;

    }

    function getScreenSize() {
        screenSizeW = (ScreenHandler.getScreenWidth(root.width) + root.width)
        screenSizeH = (ScreenHandler.getScreenHeight())
    }

    cursorShape: {
        return !containsMouse ? Qt.ArrowCursor:
                                edges == 3 || edges == 12 ? Qt.SizeFDiagCursor :
                                                            edges == 5 || edges == 10 ? Qt.SizeBDiagCursor :
                                                                                        edges & 9 ? Qt.SizeVerCursor :
                                                                                                    edges & 6 ? Qt.SizeHorCursor : Qt.ArrowCursor;
    }


    onPositionChanged: {
        setEdges(mouseX, mouseY)
    }
    onPressed: {
        resizeActive = true
        setEdges(mouseX, mouseY);
        if(edges && containsMouse) {
            startSystemResize(edges);
        }
    }
    onDoubleClicked: {

        getScreenSize()

        if(containsMouse && (cursorShape === Qt.SizeHorCursor)) {
            if(lastWindowW !== screenSizeW
                    && wflag === 0) {
                lastWindowX = root.x
                lastWindowW = root.width
                root.setX(0)
                root.setWidth(screenSizeW)
                wflag++
            }
            else {
                if(lastWindowX < 0)
                    root.setX(0)
                else
                    root.setX(lastWindowX)

                if((root.x + root.width) > screenSizeW) {
                    root.setWidth(lastWindowW)
                    root.setX(0)
                }
                else
                    root.setWidth(lastWindowW)
                wflag = 0
            }
        }

        if(containsMouse && (cursorShape === Qt.SizeVerCursor)) {
            if(lastWindowH !== screenSizeH
                    && hflag === 0) {
                lastWindowY = root.y
                lastWindowH = root.height
                root.setY(0)
                root.setHeight(screenSizeH)
                hflag++
            }
            else {
                root.setY(lastWindowY)
                root.setHeight(lastWindowH)
                hflag = 0
            }
        }
    }

    onReleased: resizeActive = false
    onExited: resizeActive = false


}

