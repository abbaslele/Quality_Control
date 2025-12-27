import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes 1.15

import "../"

Popup {
    id:root

    property ApplicationTheme mApplicationTheme
    property color _iconColor:mApplicationTheme.mainTint4
    property int _iconButtonType: IconButton.ButtonStyle.GreenShade
    property string _tipMessage: "در این بخش می‌توانید تنظمیات رصد خودکار را/n تعیین یا اصلاح کنید."
    property bool _hasCloseButton: false
    property color _backgroundColor:mApplicationTheme.greenShade
    property font _tipFont: mApplicationTheme.font_En_Medium_Bold

    padding: 0

    width: uMain_ColumnLayout.implicitWidth
    height: uMain_ColumnLayout.implicitHeight

    background: Rectangle{
        anchors.fill: parent
        color:mApplicationTheme.transparent
    }

    // Layout.minimumHeight: uMain_ColumnLayout.implicitHeight
    // Layout.minimumWidth:  uMain_ColumnLayout.implicitWidth


    ColumnLayout{
        id:uMain_ColumnLayout
        anchors.fill: parent

        spacing: 0

        Pane{
            id:uContent_Pane

            Layout.minimumHeight: uContent_RowLayout.implicitHeight
            Layout.minimumWidth: uContent_RowLayout.implicitWidth

            Layout.fillHeight: true
            Layout.fillWidth: true



            padding:0

            background:Item {
                id: uBackground_Item
                anchors.fill: parent

                Rectangle{
                    anchors.fill: parent
                    color: _backgroundColor
                    radius: 6

                }

                Rectangle {
                    id: bottomRightFlat
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    height: parent.height / 2
                    width: parent.width / 2
                    color: _backgroundColor
                    radius: 0
                }

            }



            Pane{
                id:uPadded_Pane
                anchors.fill: parent

                topPadding:24
                rightPadding:29
                bottomPadding:29
                leftPadding:24

                background: Rectangle{
                    anchors.fill: parent
                    color: mApplicationTheme.transparent

                }

                RowLayout{
                    id:uContent_RowLayout
                    layoutDirection: "RightToLeft"
                    anchors.fill: parent

                    spacing: 24

                    ColumnLayout{
                        id:uIcon_ColumnLayout
                        Layout.fillHeight: visible ? true : false
                        Layout.fillWidth: visible ? true : false
                        visible: _hasCloseButton

                        IconButton{
                            id:uClose_IconButton
                            mApplicationTheme: root.mApplicationTheme
                            _icon:"Close_Icon_O_E"
                            _IconSize:48
                            _ButtonStyle:_iconButtonType
                            _color:_iconColor
                            visible: _hasCloseButton

                            onClicked: {
                                root.close();
                            }
                        }

                        Item{
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                        }

                    }

                    Label{
                        id:uHint_Label
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        //Layout.maximumWidth: 460
                        wrapMode: Text.WordWrap
                        font: _tipFont
                        color:mApplicationTheme.mainTint4
                        text:_tipMessage


                    }

                }
            }
        }

        Pane{
            id:uShape_Pane

            Layout.maximumHeight: 32
            Layout.minimumHeight: 32
            Layout.fillWidth: true

            padding:0

            background: Rectangle{
                anchors.fill: parent
                color:mApplicationTheme.transparent
            }


            Shape {
                id: triangle
                width: 24
                height: 32
                anchors.right: parent.right
                anchors.top: parent.top

                ShapePath {
                    strokeWidth: 0
                    strokeColor: mApplicationTheme.transparent
                    fillColor: _backgroundColor  // Change color as needed

                    startX: 0
                    startY: 0

                    PathLine { x: triangle.width; y: 0 }
                    PathLine { x: triangle.width; y: triangle.height-6 }
                    PathArc {
                        x: triangle.width-6; y: triangle.height-6                  // Ends partway along the top
                        radiusX: 6; radiusY: 6
                        useLargeArc: false
                        direction: PathArc.Clockwise

                    }
                    PathLine { x: 0; y: 0 }
                }
            }

        }


    }

}
