import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects

import "../"

ColumnLayout {
    id: uMain_ColumnLayout
    property string _DefaultText: "Please Select Mode ..."
    property ApplicationTheme mApplicationTheme
    property color textColor: mApplicationTheme.mainTint2
    property color backgroundColor: mApplicationTheme.main
    property string _TitleText: ""
    property int _popupY: parent.y
    property bool _isBGLight: true
    property alias currentIndex: comboBoxRoot.currentIndex
    property bool _isDarkDropShadow: false
    property var _Model: []
    property var _CurrentInedx: 0


    signal activated_()
    // Test data model
    ListModel {
        id: testDataModel
    }



    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.maximumHeight: 96
    Layout.minimumHeight: 96


    spacing:8

    signal comboBoxCurrentIndexChanged(int index)

    RowLayout{
        id:uTitle_RowLayout
        Layout.maximumHeight: 43
        Layout.fillWidth: true
        spacing: 8


        Item {
            width: 36
            height: 36
            Layout.alignment: Qt.AlignVCenter

            Icon {
                id: uTitle_Icon
                anchors.centerIn: parent
                mApplicationTheme: uMain_ColumnLayout.mApplicationTheme
                _icon: "Right_Arrow_Icon_F_E"
                width: 36
                height: 36
                _color: mApplicationTheme.mainTint3
            }

            DropShadow {
                id:uTitleIcon_DropShadow
                anchors.fill: uTitle_Icon
                horizontalOffset: 0
                verticalOffset: 0
                radius: 10
                samples: 21
                color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                source: uTitle_Icon
                visible: false
            }
        }

        // Label container - takes remaining space
        Item {
            // Layout.fillWidth: true
            // Layout.fillHeight: true

            Label {
                id: uTitle_Label
                anchors.fill: parent
                rightPadding: 8
                text: _TitleText
                font: mApplicationTheme.font_En_Large_Regular
                color: mApplicationTheme.mainTint4
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            DropShadow {
                id:uTitleLabel_DropShadow
                anchors.fill: uTitle_Label
                horizontalOffset: 0
                verticalOffset: 0
                radius: 10
                samples: 21
                color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                source: uTitle_Label
                visible: false
            }
        }
    }

    ComboBox {
        id: comboBoxRoot

        Layout.fillWidth: true
        hoverEnabled: true

        model: _Model
        currentIndex: _CurrentInedx
        contentItem: Text {
                text: comboBoxRoot.displayText
                anchors.fill: parent
                elide: Text.ElideRight
                clip: true
                font: mApplicationTheme.font_En_Medium_Regular
                color: textColor
                leftPadding: text.length > 0 ? (parent.height + 8) : 16
                rightPadding: 16
                topPadding: 4
                bottomPadding: 4
            }

        // Component.onCompleted: { currentIndex = -1 }

        onActivated:  {activated_()}

        onCurrentIndexChanged: {
            uMain_ColumnLayout.comboBoxCurrentIndexChanged(currentIndex)
        }

        displayText: {
        //     // if (currentIndex < 0)
        //     //     return _DefaultText.substring(0, 20)
            var fullText = model[currentIndex]
        //     var maxLen = 20
        //     if (fullText.length <= maxLen)
                return fullText
        //     else
        //         return fullText.substring(0, maxLen) + "..."
        }

        background: Rectangle {
            anchors.fill: parent
            color: _isBGLight ? mApplicationTheme.main : mApplicationTheme.mainShade
            radius: 6
        }

        onHoveredChanged: {
            if (hovered) {
                uTitleIcon_DropShadow.visible = true
                uTitleLabel_DropShadow.visible = true
            } else {
                uTitleIcon_DropShadow.visible = false
                uTitleLabel_DropShadow.visible = false
            }
        }

        indicator: Canvas {
            id: canvas
            x: comboBoxRoot.width - 20 - comboBoxRoot.rightInset - comboBoxRoot.rightPadding  // Fixed left position
            y: comboBoxRoot.topPadding + (comboBoxRoot.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            rotation: comboBoxRoot.popup.opened ? 180 : 0
            transformOrigin: Item.Center

            onPaint: {
                var context = getContext("2d")
                context.reset()
                context.beginPath()
                context.moveTo(0, 0)
                context.lineTo(width, 0)
                context.lineTo(width / 2, height)
                context.closePath()
                context.fillStyle = mApplicationTheme.mainTint2
                context.fill()
            }

            Behavior on rotation {
                NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
            }
        }



        popup: Popup {
            id: comboBoxPopup
            width: comboBoxRoot.width  // match ComboBox width

            // contentItem is ListView showing combo items
            contentItem: ListView {
                id: listViewPopup
                width: parent.width
                model: comboBoxRoot.model
                currentIndex: comboBoxRoot.highlightedIndex
                delegate: ItemDelegate {
                    width: listViewPopup.width
                    height: implicitContentHeight
                    contentItem: Text {
                        text: modelData
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        color: parent.hovered ? mApplicationTheme.mainTint3 : mApplicationTheme.mainTint2
                        font: mApplicationTheme.font_En_Medium_Regular
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        padding: 8
                        maximumLineCount: 2
                    }
                    background: Rectangle {
                        color: parent.hovered ? mApplicationTheme.mainTint1 : mApplicationTheme.transparent
                        radius: 4
                    }
                    onClicked: {
                        comboBoxRoot.currentIndex = index
                        comboBoxRoot.popup.close()
                    }
                }
            }

            // Bind popup height to ListView's contentHeight with max height limit
            height: Math.min(listViewPopup.contentHeight + padding * 2, 612)
            padding: 8
            background: Rectangle {
                color: mApplicationTheme.main
                radius: 4
            }

            x: width + 8 // Position to the left
            y: (comboBoxRoot.height - height) / 2  // Center vertically

        }


    }
}
