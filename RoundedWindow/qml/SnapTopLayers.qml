import QtQuick
import QtQuick.Layouts


RowLayout {
    id: mainRow

    anchors {
        fill: parent
        verticalCenter: parent.verticalCenter
        margins: 10
    }
    visible: parent.height >= 100
    layoutDirection: Qt.LeftToRight

    property bool isDropped
    property variant currentSnap

    function checkDrop() {
        if(!windowHandler.__dragAreaPressed)
            isDropped = true
        else
            isDropped = false
    }

    Timer {
        id: dropChecker

        interval: 1
        repeat: false
        running: false
        onTriggered: checkDrop()
    }

    Connections
    {
        target: windowHandler
        function on__DragAreaPressedChanged() {
            dropChecker.start()
        }
    }

    onIsDroppedChanged: {
        if(isDropped
                && snapHandler.snapItemTop.height >= 100
                && currentSnap.color.toString() === "#0067c0")
        {
            currentSnap.setSelectedSize()
        }
    }

    Row {

        spacing: 5
        Rect {
            id: leftCurved

            curveSide: "leftCurved"
            objectName: qsTr("leftCurved")
            width: 50
            height: 80
            color: snapHandler.cursorX >= snapHandler.topSnapBarBeginX
                   && snapHandler.cursorX <= (snapHandler.topSnapBarEndX - __topSnap.width) + width +9 ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }

        Rect {
            id: rightCurved

            curveSide: "rightCurved"
            objectName: "rightCurved"
            width: 50
            height: 80
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width) +10
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width) + width +17 ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }
    }

    Column {

        spacing: 5

        Rect {
            id: topCurved

            curveSide: "topCurved"
            objectName: "topCurved"
            width: 80
            height: 35
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width) +18
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width) + width +35
                   && snapHandler.cursorY <= (snapHandler.snapItemTop.height / 2) ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }

        Rect {
            id: bottomCurved

            curveSide: "bottomCurved"
            objectName: "bottomCurved"
            width: 80
            height: 35
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width) +18
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width) + width +35
                   && snapHandler.cursorY <= (snapHandler.snapItemTop.height)
                   && snapHandler.cursorY >= (snapHandler.snapItemTop.height / 2) +1 ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }
    }

    Rect {
        id: allSideCurved

        curveSide: "allSideCurved"
        objectName: "allSideCurved"
        width: 55
        height: 80
        color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width + bottomCurved.width) +36
               && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width + bottomCurved.width) + width +45 ? "#0067c0" : "#d6d6d6"

        onColorChanged: {
            if(color.toString() === "#0067c0")
                currentSnap = this
        }
    }

    Grid {
        spacing: 4
        flow: Grid.LeftToRight
        columns: 2
        rows: 2

        Rect {
            id: lefttopCurved

            curveSide: "topCurved"
            objectName: "leftTopCurved"
            width: 38
            height: 38
            rotation: -90
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width) +46
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width) + width +53
                   && snapHandler.cursorY <= (snapHandler.snapItemTop.height / 2)  ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }

        Rect {
            id: righttopCurved

            curveSide: "topCurved"
            objectName: "rightTopCurved"
            width: 38
            height: 38
            rotation: 90
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width + lefttopCurved.width) +54
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width + lefttopCurved.width) + width +61
                   && snapHandler.cursorY <= (snapHandler.snapItemTop.height / 2) ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }

        Rect {
            id: leftbottomCurved

            curveSide: "bottomCurved"
            objectName: "leftBottomCurved"
            width: 38
            height: 38
            rotation: 90
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width) +46
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width) + width +53
                   && snapHandler.cursorY >= (snapHandler.snapItemTop.height / 2) +1
                   && snapHandler.cursorY <= (snapHandler.snapItemTop.height) ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }

        Rect {
            id: rightbottomCurved

            curveSide: "bottomCurved"
            objectName: "rightBottomCurved"
            width: 38
            height: 38
            rotation: -90
            color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width + leftbottomCurved.width) +54
                   && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width + leftbottomCurved.width) + width +61
                   && snapHandler.cursorY >= (snapHandler.snapItemTop.height / 2) +1
                   && snapHandler.cursorY <= (snapHandler.snapItemTop.height) ? "#0067c0" : "#d6d6d6"

            onColorChanged: {
                if(color.toString() === "#0067c0")
                    currentSnap = this
            }
        }
    }

    Rect {
        id: fullCurved

        curveSide: "allSideCurved"
        objectName: "fullCurved"
        width: 150
        height: 82
        color: snapHandler.cursorX >= (snapHandler.topSnapBarBeginX + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width + leftbottomCurved.width + rightbottomCurved.width) +62
               && snapHandler.cursorX <= ((snapHandler.topSnapBarEndX - __topSnap.width) + leftCurved.width + rightCurved.width + bottomCurved.width + allSideCurved.width + leftbottomCurved.width + rightbottomCurved.width) + width +87
               && snapHandler.cursorY <= (snapHandler.snapItemTop.height) ? "#0067c0" : "#d6d6d6"

        onColorChanged: {
            if(color.toString() === "#0067c0")
                currentSnap = this
        }
    }


}
