import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects
import AppManager 1.0


import "../../"
import "../../Components"
import "../../Pages"


Page {
    id:m_Item


    property ApplicationTheme mApplicationTheme
    property AppManager mAppManager
    property StackView mStackView

    padding: 24

    state: "NoThreat"

    states: [
        State {
            // name: "NoThreat" ; PropertyChanges {target: uThreatSectionManager ;state :"NoThreat"}
        },
        State {
            // name: "Threat" ; PropertyChanges {target: uThreatSectionManager ;state :"Threat"}
        }
    ]

    function letsChangeHomeState(val){
        state =val
    }

    function letsChangeThreatSectionState(val){
        // uThreatSectionManager.state =val
    }

    background: Item{

        anchors.fill: parent

        Rectangle{
            anchors.fill: parent
            color: mApplicationTheme.main
            z:0
        }

        LinearGradient {
            z:1
            anchors.fill: parent
            start:  Qt.point(width, 0)
            end: Qt.point(0, height )
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#4B4B4B" }
                GradientStop { position: 1.0; color: "#2C2C2C" }
            }
        }

        LinearGradient {
            id:uThreatGradient
            z:2
            visible: m_Item.state === "NoThreat" | "AfterThreat" ? false :true
            anchors.fill: parent
            start:   Qt.point(width/2, 0)
            end:  Qt.point(width/2, height-(height-899))
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#993D47" }
                GradientStop { position: 1.0; color: "#00993D47"}
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent

        RowLayout{
            id: uSerialConnection_RowLayout

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 90

            Pane{
                // id: uSerialConnection_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.main
                    border.width: 0
                    radius: 6
                }
            }

            Pane{
                // id: uSerialConnection_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.main
                    border.width: 0
                    radius: 6
                }
            }

            Pane{
                // id: uSerialConnection_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.main
                    border.width: 0
                    radius: 6
                }
            }
        }


        RowLayout{
            id: uDetail_RowLayout

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 90

            Pane{
                // id: uSerialConnection_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.main
                    border.width: 0
                    radius: 6
                }
            }

        }

        RowLayout{
            id: uData_RowLayout

            Layout.fillWidth: true
            Layout.fillHeight: true

            Pane{
                // id: uSerialConnection_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.main
                    border.width: 0
                    radius: 6
                }
            }

            ColumnLayout{

                Pane{
                    // id: uSerialConnection_Pane
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    background: Rectangle {
                        anchors.fill: parent
                        color: mApplicationTheme.main
                        border.width: 0
                        radius: 6
                    }
                }

                Pane{
                    // id: uSerialConnection_Pane
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: 90
                    background: Rectangle {
                        anchors.fill: parent
                        color: mApplicationTheme.main
                        border.width: 0
                        radius: 6
                    }
                }

                Pane{
                    // id: uSerialConnection_Pane
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    background: Rectangle {
                        anchors.fill: parent
                        color: mApplicationTheme.main
                        border.width: 0
                        radius: 6
                    }
                }
            }

        }

    }




    NotificationPopup{
        id:uCameraProblemErrorHint_Popup
        mApplicationTheme:m_Item.mApplicationTheme
        _labelText:"در نحوه‌ی عملکرد «دوربین‌ها» مشکلی وجود دارد."
        _textColor:mApplicationTheme.mainTint4
        _backgroundColor:mApplicationTheme.redShade2
        _iconColor:mApplicationTheme.mainTint4
        _hasCloseButton:true
        _iconButtonType:IconButton.ButtonStyle.RedShade2


    }

    NotificationPopup{
        id:uConnectDeviceErrorHint_Popup
        mApplicationTheme:m_Item.mApplicationTheme
        _labelText:"در نحوه‌ی عملکرد «موتور» مشکلی وجود دارد."
        _textColor:mApplicationTheme.mainTint4
        _backgroundColor:mApplicationTheme.redShade2
        _iconColor:mApplicationTheme.mainTint4
        _hasCloseButton:true
        _iconButtonType:IconButton.ButtonStyle.RedShade2

    }
}
