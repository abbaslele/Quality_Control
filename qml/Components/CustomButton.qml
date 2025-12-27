import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"

Button {
    id: uCustomButton_Button

    property ApplicationTheme mApplicationTheme
    property string _buttonIcon: ""
    property string _textColor: mApplicationTheme.mainTint4
    property var _textFont: mApplicationTheme.font_En_Medium_Regular
    property int _iconSize: 24
    property int _iconPaneSize: 32
    property string _iconColor: mApplicationTheme.mainTint4
    property bool _isDarkDropShadow: false
    property bool showIconDropShadow: false
    property bool _textToRight: false
    property int _contentSideMargin: 16

    property int _Pathbackward: 2
    property bool iconOnRight: isRTL

    property string pathBack: {
        switch(_Pathbackward) {
        case 3:
            return "../../../"
        default:
            return "../../"
        }
    }

    // Define enum properly
    enum ButtonStyle {
        Primary,
        Secondary,
        Red,
        RedShade1,
        Yellow,
        YellowShade1,
        Green,
        GreenShade,
        Main,
        MainTint1,
        RedShade2,
        YellowShade2
    }

    // Add a property to hold the current style
    property int _ButtonStyle: CustomButton.ButtonStyle.Primary

    property string mNormalBGColor: mApplicationTheme.primaryColor
    property string mEnableTextColor: mApplicationTheme.mainTint4
    property string mDisableTextColor: mApplicationTheme.primaryDisColor
    property string mPressedBGColor: mApplicationTheme.mainTint4
    property string mPressedTextColor: mApplicationTheme.primaryColor


    Component.onCompleted: {

        if(_buttonIcon !== "")
        {
            showIconDropShadow= true
        }

        switch(_ButtonStyle) {
        case CustomButton.ButtonStyle.Primary:
            mNormalBGColor = mApplicationTheme.primaryColor
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.primaryDisColor
            mPressedTextColor = mApplicationTheme.primaryColor
            break
        case CustomButton.ButtonStyle.Secondary:
            mNormalBGColor = mApplicationTheme.secondaryColor
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.secondaryDisColor
            mPressedTextColor = mApplicationTheme.secondaryColor
            break
        case CustomButton.ButtonStyle.Red:
            mNormalBGColor = mApplicationTheme.red
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.redTint1
            mPressedTextColor = mApplicationTheme.red
            break
        case CustomButton.ButtonStyle.RedShade1:
            mNormalBGColor = mApplicationTheme.redShade1
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.redTint1
            mPressedTextColor = mApplicationTheme.redShade1
            break
        case CustomButton.ButtonStyle.Yellow:
            mNormalBGColor = mApplicationTheme.yellow
            mEnableTextColor = mApplicationTheme.mainShade
            mDisableTextColor = mApplicationTheme.yellowTint1
            mPressedTextColor = mApplicationTheme.yellow
            break
        case CustomButton.ButtonStyle.YellowShade1:
            mNormalBGColor = mApplicationTheme.yellowShade1
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.yellowTint1
            mPressedTextColor = mApplicationTheme.yellowShade1
            break
        case CustomButton.ButtonStyle.Green:
            mNormalBGColor = mApplicationTheme.green
            mEnableTextColor = mApplicationTheme.mainShade
            mDisableTextColor = mApplicationTheme.greenTint1
            mPressedTextColor = mApplicationTheme.green
            break
        case CustomButton.ButtonStyle.GreenShade:
            mNormalBGColor = mApplicationTheme.greenShade
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.greenTint1
            mPressedTextColor = mApplicationTheme.greenShade
            break
        case CustomButton.ButtonStyle.Main:
            mNormalBGColor = mApplicationTheme.main
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.mainTint1
            mPressedTextColor = mApplicationTheme.main
            break
        case CustomButton.ButtonStyle.MainTint1:
            mNormalBGColor = mApplicationTheme.mainTint1
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.mainTint2
            mPressedTextColor = mApplicationTheme.mainTint1
            break
        case CustomButton.ButtonStyle.RedShade2:
            mNormalBGColor = mApplicationTheme.redShade2
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.red
            mPressedTextColor = mApplicationTheme.redShade2
            break
        case CustomButton.ButtonStyle.YellowShade2:
            mNormalBGColor = mApplicationTheme.yellowShade2
            mEnableTextColor = mApplicationTheme.mainTint4
            mDisableTextColor = mApplicationTheme.yellowShade1
            mPressedTextColor = mApplicationTheme.yellowShade2
            break
        }
    }


    contentItem: Item {

        anchors{
            fill: parent
            leftMargin: _contentSideMargin
            rightMargin: _contentSideMargin
        }

        RowLayout{
            anchors.fill: parent
            spacing: 12
            layoutDirection: iconOnRight ? Qt.RightToLeft : Qt.LeftToRight


            Item {
                // Layout.fillHeight: true
                Layout.minimumWidth: visible ? _iconPaneSize :0
                Layout.maximumWidth: visible ? _iconPaneSize :0
                Layout.minimumHeight: visible ? _iconPaneSize :0
                Layout.maximumHeight: visible ? _iconPaneSize :0
                // Layout.fillHeight: true
                // Layout.fillWidth: true
                visible: _buttonIcon !== ""

                Icon {
                    id:uButton_Icon
                    anchors.centerIn: parent
                    _icon: _buttonIcon
                    height: _iconSize
                    width: _iconSize
                    _size: visible ? _iconSize :0
                    _Pathbackward: _Pathbackward
                    _color: _iconColor
                    visible:  _buttonIcon !== ""

                    ColorOverlay {
                        source: parent
                        anchors.fill: parent
                        color: _iconColor
                    }
                }

                DropShadow {
                    id:uIcon_DropShadow
                    anchors.fill: uButton_Icon
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 10
                    samples: 21
                    color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                    source: uButton_Icon
                    visible: false
                }
            }

            Item {
                id:uText_Item
                Layout.fillHeight: true
                Layout.fillWidth: true

                Item {
                    id: textWrapper
                    anchors.centerIn: parent
                    Text {
                        id: uButton_Text
                        anchors.centerIn: parent
                        text: uCustomButton_Button.text
                        color: _textColor
                        font: _textFont
                        horizontalAlignment: _textToRight? Text.AlignRight :  Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    DropShadow {
                        id:uButtonText_DropShadow
                        anchors.fill: uButton_Text
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 10
                        samples: 21
                        color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                        source: uButton_Text
                        visible: false
                    }

                }

            }



        }


    }




    state: "Normal"
    states: [
        State {
            name: "Pressed"
            PropertyChanges { target: background; color: mPressedBGColor }
            PropertyChanges { target: uButton_Text; color: mPressedTextColor }
            PropertyChanges { target: uCustomButton_Button; _iconColor: mPressedTextColor }

            PropertyChanges { target: uButtonText_DropShadow; visible: false }
            PropertyChanges { target: uIcon_DropShadow; visible: false }


        },
        State {
            name: "Normal"
            PropertyChanges { target: background; color: mNormalBGColor }
            PropertyChanges { target: uButton_Text; color: mEnableTextColor }
            PropertyChanges { target: uCustomButton_Button; _iconColor: mEnableTextColor }

            PropertyChanges { target: uButtonText_DropShadow; visible: false }
            PropertyChanges { target: uIcon_DropShadow; visible: false }


        },
        State {
            name: "Disable"
            PropertyChanges { target: background; color: mNormalBGColor }
            PropertyChanges { target: uButton_Text; color: mDisableTextColor }
            PropertyChanges { target: uCustomButton_Button; _iconColor: mDisableTextColor }

            PropertyChanges { target: uButtonText_DropShadow; visible: false }
            PropertyChanges { target: uIcon_DropShadow; visible: false }


        },
        State {
            name: "Hover"
            PropertyChanges { target: uButtonText_DropShadow; visible: true }
            PropertyChanges { target: uButton_Text; color: mEnableTextColor }
            PropertyChanges { target: uCustomButton_Button; _iconColor: mEnableTextColor }

            PropertyChanges { target: background; color: mNormalBGColor }
            PropertyChanges { target: uIcon_DropShadow; visible: showIconDropShadow }


        }
    ]

    background: Rectangle {
        id: background
        anchors.fill: parent
        border.width: 0
        radius: 6
    }

    property bool isRTL: true
    property string buttonText_Tooltip

    ToolTip.text: buttonText_Tooltip
    ToolTip.visible: buttonText_Tooltip !== "" ? hovered : false
    ToolTip.delay: 500
    ToolTip.timeout: 4000

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.minimumHeight: 48
    Layout.preferredHeight: 48
    Layout.maximumHeight: 60

    Material.roundedScale: Material.NotRounded
    Material.elevation: mApplicationTheme.elevation

    onPressed: state = state !== "Disable" ? "Pressed" : "Disable"
    onReleased: state = state !== "Disable" ? "Normal" : "Disable"
    onEnabledChanged: state =  enabled ? "Normal" : "Disable"
    onHoveredChanged: state = enabled ? hovered? "Hover": "Normal" :  "Disable"



    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: state !== "Disable" ? Qt.PointingHandCursor : Qt.ForbiddenCursor
    }
}
