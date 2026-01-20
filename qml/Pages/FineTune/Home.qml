import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects

import "../../"
import "../../Components"
import "../../Pages"

Page {
    id:m_Item


    property ApplicationTheme mApplicationTheme
    property StackView mStackView


    property bool _isConnected: false
    padding: 24


    // Access controllers
    property var serialMgr: appController.serialPort()
    property var deviceCtrl: appController.deviceController()
    property var sequencer: appController.positionSequencer()
    property var maximumError: 0




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

        // LinearGradient {
        //     id:uThreatGradient
        //     z:2
        //     visible: m_Item.state === "NoThreat" | "AfterThreat" ? false :true
        //     anchors.fill: parent
        //     start:   Qt.point(width/2, 0)
        //     end:  Qt.point(width/2, height-(height-899))
        //     gradient: Gradient {
        //         GradientStop { position: 0.0; color: "#993D47" }
        //         GradientStop { position: 1.0; color: "#00993D47"}
        //     }
        // }
    }

    Loader {
        id: uDialog_Loader
        onLoaded:{
            if (item) {
                item.visible = true // Popups don't need open(), just set visible
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 24

        RowLayout{
            id: uSerialConnection_RowLayout
            spacing: 24
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 120

            Pane{
                id: uAction_Pane
                // Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 16
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }
                RowLayout{
                    anchors.fill: parent
                    spacing: 16
                    IconButton{
                        id: uLogout_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Exit_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        onClicked: {
                            mStackView.pop()
                        }

                    }

                    IconButton{
                        id: uSetting_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Settings_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        onClicked: {

                            uDialog_Loader.setSource("../../Components/CustomDialog.qml", {
                                                         "_currentState": "Setting",
                                                         "mApplicationTheme": m_Item.mApplicationTheme,
                                                     })

                        }
                    }

                    IconButton{
                        id: uReport_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Logs_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        enabled: false
                    }

                    IconButton{
                        id: uExport_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Export_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        enabled: false
                    }
                }
            }

            Pane{
                id: uConnection_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 16
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }
                RowLayout{
                    anchors.fill: parent
                    spacing: 16

                    IconButton{
                        id: uReset_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _Pathbackward: 3
                        _icon: "Reset_Icon_F_E"
                        _ButtonSize : 90
                        _IconSize: 45
                        onClicked: {
                            uCOMConnections_CustomComboBox._Model
                                    = serialMgr.availablePorts()
                        }

                    }

                    CustomComboBox{
                        id: uCOMConnections_CustomComboBox
                        _TitleText: "COM"
                        mApplicationTheme: m_Item.mApplicationTheme
                        _Model: serialMgr.availablePorts()

                        function findIndex(text) {
                            for (var i = 0; i < _Model.length; i++) {
                                if (_Model[i] === text) {
                                    return i
                                }
                            }
                            return -1
                        }

                        onActivated_: {
                            serialMgr.portName = currentText
                        }
                        Component.onCompleted: {
                            if (serialMgr.portName !== "") {
                                var idx = findIndex(serialMgr.portName)
                                if (idx !== -1) {
                                    _CurrentInedx = idx
                                }
                            }
                        }
                    }



                    IconButton{
                        id: uTest_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _Pathbackward: 3
                        _icon: _isConnected ? "Connected_Icon_F_E" : "Disonnected_Icon_F_E"
                        _ButtonSize : 90
                        _IconSize: 45
                        onClicked: {

                            if (serialMgr.isConnected) {
                                serialMgr.closePort()
                                _isConnected = false
                            } else {
                                serialMgr.openPort()
                                _isConnected = true
                            }

                        }

                    }


                }
            }

            Pane{
                id: uUserLogedin_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 16
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }

                RowLayout{
                    anchors.fill: parent
                    spacing: 16

                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: 200
                        enabled: false
                        spacing: 8

                        Item {

                            Label {
                                id: uTitle_Label
                                anchors.fill: parent
                                rightPadding: 8
                                text: "Support"
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
                                color:  mApplicationTheme.white
                                source: uTitle_Label
                                visible: false
                            }
                        }

                        RowLayout{
                            spacing: 8
                            RadioButton{
                                checked: true
                                text: "Right"
                                Material.accent: mApplicationTheme.green
                                Material.foreground: mApplicationTheme.mainTint3
                                font: mApplicationTheme.font_En_Medium_Regular
                            }

                            RadioButton{
                                text: "Left"
                                Material.accent: mApplicationTheme.green
                                Material.foreground: mApplicationTheme.mainTint3
                                font: mApplicationTheme.font_En_Medium_Regular
                            }
                        }
                    }

                    CustomComboBox{
                        id: uServoType_CustomTextField
                        mApplicationTheme: m_Item.mApplicationTheme
                        Layout.minimumWidth: 180
                        _TitleText: "Servo Type"
                        _DefaultText : "Select Servo Type..."
                        _Model: ["DHS-110" , "DHS-75" ]
                        _CurrentInedx: 0
                    }

                    CustomTextField{
                        id: uSerialNumber_CustomTextField
                        mApplicationTheme: m_Item.mApplicationTheme
                        _TitleText: "Serial Number"
                        _hasClearButton:true
                        _TextfieldText: "N/A"
                    }
                }
            }
        }


        TabBar {
            id: u_TabBar
            Layout.fillWidth: true
            background: Rectangle {
                id: background
                anchors.fill: parent
                border.width: 0
                radius: 6
                color: "transparent"
            }
            Material.accent: mApplicationTheme.greenTint1


            TabButton {
                id: uFineTune_TabButton
                text: qsTr("Fine Tune")
                font: mApplicationTheme.font_En_Medium_Regular
                Material.foreground: mApplicationTheme.mainTint4
                Material.accent: mApplicationTheme.greenTint1
            }
            TabButton {
                id: uBacklash_TabButton
                text: qsTr("Backlash")
                font: mApplicationTheme.font_En_Medium_Regular
                Material.foreground: mApplicationTheme.mainTint4
                Material.accent: mApplicationTheme.greenTint1
            }
        }

        StackLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            currentIndex: u_TabBar.currentIndex
            FineTuneSide{
                Layout.fillHeight: true
                Layout.fillWidth: true
                mApplicationTheme : m_Item.mApplicationTheme
            }
            BacklashSide{
                Layout.fillHeight: true
                Layout.fillWidth: true
                mApplicationTheme : m_Item.mApplicationTheme
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
