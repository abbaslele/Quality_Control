import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick3D
import QtQuick.Layouts
import QtQuick.Shapes 1.15
import Qt5Compat.GraphicalEffects



import "../"
import "../../"
import "../Pages"


Slider {
    id: m_Item

    property ApplicationTheme mApplicationTheme
    property var _mediaPlayer
    property real sliderValue: 0
    property real changedValue: 0
    property bool userIsInteracting: false

    width: 51
    height: 6
    from: 0
    to: _mediaPlayer ? _mediaPlayer.duration : 100
    stepSize: 1

    signal videoEnded()


    background: Item{
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: mApplicationTheme.mainTint2
            clip:true


            Rectangle {
                id: fillRect
                width:m_Item.value === m_Item.to ? 0: (m_Item.value - m_Item.from) / (m_Item.to - m_Item.from) * parent.width
                height: parent.height
                color: mApplicationTheme.mainTint4

                radius: m_Item.value === m_Item.to ? 4 : 4
                layer.enabled: true
                layer.smooth: true
                clip: true

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: m_Item.value === m_Item.to ? 0 : 4
                    color: fillRect.color
                    radius: 0
                }
            }

        }

        Item{
            id:uMask_Item
            anchors.fill: parent


            Shape {
                id:topLeft
                width: 3
                height: 4
                anchors.top: parent.top
                anchors.left: parent.left

                ShapePath {
                    strokeWidth: 0
                    strokeColor: mApplicationTheme.transparent
                    fillColor: mApplicationTheme.main
                    startX: 0
                    startY: 0

                    PathLine { x: topLeft.width; y: 0 }

                    PathArc {
                        x: 0; y: topLeft.height
                        radiusX: 3
                        radiusY: 4
                        useLargeArc: false
                        direction: PathArc.Counterclockwise
                    }

                }
            }

            Shape {
                id:bottomLeft
                width: 3
                height: 4
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                ShapePath {
                    strokeWidth: 0
                    strokeColor: mApplicationTheme.transparent
                    fillColor: mApplicationTheme.main
                    startX: 0
                    startY: bottomLeft.height


                    PathLine { x: bottomLeft.width; y: bottomLeft.height }

                    PathArc {
                        x: 0; y: 0
                        radiusX: 3
                        radiusY: 4
                        useLargeArc: false
                        direction: PathArc.Clockwise
                    }

                }
            }

            Shape {
                id:topRight
                width: 3
                height: 4
                anchors.top: parent.top
                anchors.right: parent.right

                ShapePath {
                    strokeWidth: 0
                    strokeColor: mApplicationTheme.transparent
                    fillColor: mApplicationTheme.main
                    startX: 0
                    startY: 0

                    PathArc {
                        x: topRight.width; y: topRight.height
                        radiusX: 3
                        radiusY: 4
                        useLargeArc: false
                        direction: PathArc.Clockwise
                    }

                    PathLine { x: topRight.width; y: 0 }
                }
            }

            Shape {
                id:bottomRight
                width: 3
                height: 4
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                ShapePath {
                    strokeWidth: 0
                    strokeColor: mApplicationTheme.transparent
                    fillColor: mApplicationTheme.main
                    startX: bottomRight.width
                    startY: 0

                    PathArc {
                        x: 0; y: bottomRight.height
                        radiusX: 3
                        radiusY: 4
                        useLargeArc: false
                        direction: PathArc.Clockwise
                    }

                    PathLine { x: bottomRight.width; y: bottomRight.height }

                }
            }

        }

    }


    handle: Item {
        width: 0
        height: 0
        visible: false
    }

    value: userIsInteracting ? value : sliderValue

    Connections {
        target: _mediaPlayer
        function onPositionChanged() {
            if (!userIsInteracting) {
                sliderValue = _mediaPlayer.position
            }
        }
        function onDurationChanged() {
            m_Item.to = _mediaPlayer.duration
        }
    }

    onPressedChanged: {
        userIsInteracting = pressed
    }


    onValueChanged: {
        // console.log("Value: " , value)
        if (userIsInteracting) {
            changedValue = value
            _mediaPlayer.position = changedValue
            // mAppManager.setElapsed(value)
        }
        if (value === _mediaPlayer.duration) {
            videoEnded()
        }
    }
}


