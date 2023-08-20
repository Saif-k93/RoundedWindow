import QtQuick
import QtQuick.Controls
import "../js/Alpha.js" as Alpha

Rectangle {
    id: _window

    antialiasing: true

    function setLRMargin() {
        if(round >= 0 && round <= 100) return 5
        if(round >= 101 && round <= 140) return 20
        if(round >= 141 && round <= 194) return 40
    }

    function setBMargin() {
        if(round >= 0 && round <= 10) return 5
        if(round >= 11 && round <= 35) return 25
        if(round >= 36 && round <= 60) return 55
        if(round >= 61 && round <= 80) return 80
        if(round >= 81 && round <= 100) return 90
        else
            return 100
    }

    gradient: Gradient {GradientStop {position: 1; color: "#00f9f9f9"}}

    anchors {
        top: windowHandler.__roundRect.bottom
        right: parent.right
        left: parent.left
        bottom: parent.bottom
        topMargin: 36
        rightMargin: setLRMargin()
        leftMargin: setLRMargin()
        bottomMargin: setBMargin()
    }
    clip: true


}
