import QtQuick
import QtQuick.Layouts


GridLayout {
    id: gridLayout

    anchors.fill: parent
    anchors.margins: 15
    clip: true

    rows: 2
    flow: GridLayout.TopToBottom
    rowSpacing: 5

    RowLayout {

        spacing: 11

        Rect {
            id: leftCurved

            curveSide: "leftCurved"
            objectName: qsTr("leftCurved")
            width: 50
            height: 80
        }

        Rect {
            id: rightCurved

            curveSide: "rightCurved"
            objectName: "rightCurved"
            width: 50
            height: 80
        }

        Column {

            spacing: 6

            Rect {
                id: topCurved

                curveSide: "topCurved"
                objectName: "topCurved"
                width: 80
                height: 35
            }

            Rect {
                id: bottomCurved

                curveSide: "bottomCurved"
                objectName: "bottomCurved"
                width: 80
                height: 35
            }
        }

        Rect {
            id: allSideCurved

            curveSide: "allSideCurved"
            objectName: "allSideCurved"
            width: 55
            height: 80
        }
    }

    RowLayout {

        spacing: 11

        Grid {
            spacing: 4
            flow: Grid.LeftToRight
            columns: 2
            rows: 2

            Rect {
                id: lefttopCurved

                curveSide: "topCurved"
                objectName: "leftTopCurved"
                width: 52
                height: 40
            }
            Rect {
                id: righttopCurved

                curveSide: "topCurved"
                objectName: "rightTopCurved"
                width: 52
                height: 40
            }
            Rect {
                id: leftbottomCurved

                curveSide: "bottomCurved"
                objectName: "leftBottomCurved"
                width: 52
                height: 40
            }
            Rect {
                id: rightbottomCurved

                curveSide: "bottomCurved"
                objectName: "rightBottomCurved"
                width: 52
                height: 40
            }
        }
        Rect {
            id: fullCurved

            curveSide: "allSideCurved"
            objectName: "fullCurved"
            width: 150
            height: 82
        }
    }
}
