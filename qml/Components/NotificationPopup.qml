import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "../"

Popup {
    id:root

    height: 96
    width: parent.width
    padding: 0

    property ApplicationTheme mApplicationTheme
    property string _labelText
    property color _textColor
    property color _backgroundColor
    property color _iconColor
    property bool _hasCloseButton: true
    property int _iconButtonType: IconButton.ButtonStyle.Main
    property int _yesButtonType:CustomButton.ButtonStyle.Primary
    property int _noButtonType:CustomButton.ButtonStyle.Secondary
    property int _finalY :parent.height-height




    x: 0
    y: parent.height

    Behavior on y {
           NumberAnimation {
               duration: 500  // adjust duration
               easing.type: Easing.OutQuad // fast to slow
           }
       }

       // When the popup is opened, set y to final position to trigger animation
       onVisibleChanged: {
           if (visible) {
               root.y = _finalY;
           } else {
               root.y = parent.height+height;  // move offscreen when hidden
           }
       }





    Component.onCompleted: {
        if(_hasCloseButton)
        {
            uPopupClose_IconButton.visible=true
            uPopup_Icon.visible=false
            uPopupActionButtons_RowLayout.visible=false
        }
        else
        {
            uPopupClose_IconButton.visible=false
            uPopup_Icon.visible=true
            uPopupActionButtons_RowLayout.visible=true
        }

    }

    Pane{
        anchors.fill: parent
        padding: 0

        background: Rectangle{
            id:uPopupBackground
            anchors.fill:parent
            color:_backgroundColor
        }


        RowLayout{
            id:uPopup_RowLayout
            anchors.fill: parent
            layoutDirection: "RightToLeft"
            spacing: 0

            Pane{
                id:uIconButton_Pane
                Layout.fillHeight: true
                Layout.maximumWidth: 96
                Layout.minimumWidth: 96
                Layout.minimumHeight: 96
                padding: 8

                background: Rectangle{
                    anchors.fill:parent
                    color:"transparent"
                }

                ColumnLayout{
                    anchors.fill: parent
                    IconButton{
                        id:uPopupClose_IconButton
                        mApplicationTheme: root.mApplicationTheme
                        _icon:"Close_Icon_O_E"
                        _IconSize:48
                        _ButtonStyle:_iconButtonType

                        _ButtonSize:80

                        _color:_iconColor

                        onClicked: {
                            root.close();
                        }

                    }

                }
            }

            Pane{
                id:uMiddleSide_Pane
                Layout.fillHeight: true
                Layout.fillWidth: true
                leftPadding: 10
                rightPadding: 10

                background: Rectangle{
                    anchors.fill:parent
                    color:"transparent"
                }

                Pane{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 48

                    background: Rectangle{
                        anchors.fill:parent
                        color:"transparent"
                    }

                    RowLayout{
                        anchors.fill: parent
                        layoutDirection: "RightToLeft"
                        spacing: 24

                        Icon{
                            id:uPopup_Icon
                            _icon:"Caution_Icon_F_E"
                            _size:48
                            _color:_iconColor
                        }

                        Label{
                            id:uPopup_Label
                            font:mApplicationTheme.font_En_Medium_Bold
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            text: _labelText
                            color:_textColor
                        }

                        RowLayout{
                            id:uPopupActionButtons_RowLayout
                            spacing: 12
                            Layout.maximumHeight: 45
                            Layout.maximumWidth: 348

                            CustomButton{
                                id:uPopupNo_CustomButton
                                mApplicationTheme: root.mApplicationTheme
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                _ButtonStyle:_noButtonType
                                _textFont:mApplicationTheme.font_En_Small_Regular
                                text: "خیر"

                                onClicked: {
                                    uErrorHint_Popup.close();
                                }

                            }
                            CustomButton{
                                id:uPopupYes_CustomButton
                                mApplicationTheme: root.mApplicationTheme
                                _ButtonStyle:_yesButtonType
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                _textFont:mApplicationTheme.font_En_Small_Regular
                                text: "بله"
                            }
                        }

                    }

                }


            }

            Pane{
                id:uLeftSide_Pane
                Layout.fillHeight: true
                Layout.maximumWidth: 96

                background: Rectangle{
                    anchors.fill: parent
                    color:"transparent"
                }

            }

        }
    }

}
