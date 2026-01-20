import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

import "../../"
import "../../Components"
import "../../Pages"

Item {
    id: root

    property var backlashTester: appController.backlashTester()
    property var deviceCtrl: appController.deviceController()
    property var serialMgr: appController.serialPort()
    property ApplicationTheme mApplicationTheme

    Connections {
        target: backlashTester

        function onBacklashoutputLog(outputResult){
            uSystemLog_TextArea.text += outputResult +"\n"
        }

    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 24

        Pane{
            id: uDetail_Pane
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 120
            Layout.maximumHeight: 120
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
                    id: uCalibrate_IconButton
                    mApplicationTheme: m_Item.mApplicationTheme
                    _ButtonStyle: (uSerialNumber_CustomTextField._TextfieldText !== "" ) ? IconButton.ButtonStyle.Main :  IconButton.ButtonStyle.GreenShade
                    _ButtonSize: 96
                    _IconSize:48
                    _icon: "Distance_Icon_F_E"
                    enabled: serialMgr.isConnected && !sequencer.isRunning
                    onClicked: {
                        appController.performCalibration()
                        backlashTester.resetValues()
                        uSystemLog_TextArea.text = ""
                    }

                }

                IconButton{
                    id: uStartStop_IconButton
                    mApplicationTheme: m_Item.mApplicationTheme
                    _ButtonStyle: sequencer.isRunning ? IconButton.ButtonStyle.Main : IconButton.ButtonStyle.GreenShade
                    _ButtonSize: 96
                    _IconSize:48
                    _icon: sequencer.isRunning ? "Pause_Icon_F_E" : "Play_Icon_F_E"
                    enabled: serialMgr.isConnected && appController.isCalibrated
                    onClicked: {
                        if (backlashTester.isRunning) {
                            backlashTester.stopTest()
                        } else {
                            backlashTester.startTest()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Label{
                    text: backlashTester.currentPhaseText
                    font: mApplicationTheme.font_En_Medium_Bold
                    color: mApplicationTheme.mainTint3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumWidth: 300
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                CustomButton{
                    text: "Reject"
                    _ButtonStyle: CustomButton.ButtonStyle.Red
                    Layout.maximumWidth: 150
                    mApplicationTheme: m_Item.mApplicationTheme
                    enabled: false
                }

                CustomButton{
                    text: "Accept"
                    _ButtonStyle: CustomButton.ButtonStyle.GreenShade
                    Layout.maximumWidth: 150
                    mApplicationTheme: m_Item.mApplicationTheme
                    enabled: false

                }

            }
        }


        RowLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 16

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 16


                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    // Countdown Display

                    Pane{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        background:  Rectangle {
                            Layout.fillWidth: true

                            Layout.fillHeight: true
                            color: {
                                switch(backlashTester.currentPhaseText){
                                case "Idle" :
                                    mApplicationTheme.mainShade; break;
                                case "Forward Direction Reading" :
                                    mApplicationTheme.secondaryColor; break;
                                case  "Calibrating System":
                                    mApplicationTheme.mainShade; break;
                                case "Waiting (2 seconds)" :
                                    mApplicationTheme.darkYellow; break;
                                case "Reverse Direction Reading" :
                                    mApplicationTheme.yellowShade2; break;
                                case  "Test Complete" :
                                    mApplicationTheme.darkGreen; break;
                                default :
                                    mApplicationTheme.mainShade; break;
                                }
                            }
                            radius: 6
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 5

                            Label{
                                text: backlashTester.currentPhaseText
                                font: mApplicationTheme.font_En_3X_Large_Bold
                                color: mApplicationTheme.mainTint3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Countdown"
                                font: mApplicationTheme.font_En_Large_Regular
                                color: mApplicationTheme.mainTint3;

                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: backlashTester.countdown + " s"
                                font: mApplicationTheme.font_En_3X_Large_Bold
                                color: {
                                    switch(backlashTester.currentPhaseText){
                                    case "Idle" :
                                        mApplicationTheme.mainTint3; break;
                                    case "Forward Direction Reading" :
                                        mApplicationTheme.primaryDisColor; break;
                                    case  "Calibrating System":
                                        mApplicationTheme.mainTint3; break;
                                    case "Waiting (2 seconds)" :
                                        mApplicationTheme.mainTint3; break;
                                    case "Reverse Direction Reading" :
                                        mApplicationTheme.yellow; break;
                                    case  "Test Complete" :
                                        mApplicationTheme.mainTint3; break;
                                    default :
                                        mApplicationTheme.mainTint3; break;

                                    }
                                }
                            }
                        }

                    }
                }


                // Results Display - Max and Average side by side
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    // Forward Direction
                    Pane{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: 570
                        background: Rectangle {
                            anchors.fill: parent
                            color: mApplicationTheme.secondaryColor
                            radius: 6
                        }
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Forward Direction"
                                font: mApplicationTheme.font_En_Large_Bold
                                color: mApplicationTheme.mainTint3
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20

                                ColumnLayout {
                                    spacing: 5
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Maximum"
                                        font: mApplicationTheme.font_En_3X_Small_Regular
                                        color: mApplicationTheme.mainTint3                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: backlashTester.maxAngleForward.toFixed(3) + "°"
                                        font: mApplicationTheme.font_En_Medium_Bold
                                        color: mApplicationTheme.primaryDisColor
                                    }
                                }

                                Rectangle {
                                    width: 2
                                    height: 50
                                    color: mApplicationTheme.mainTint3
                                }

                                ColumnLayout {
                                    spacing: 5
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Average"
                                        font: mApplicationTheme.font_En_3X_Small_Regular
                                        color: mApplicationTheme.mainTint3                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: backlashTester.avgAngleForward.toFixed(3) + "°"
                                        font: mApplicationTheme.font_En_Medium_Bold
                                        color: mApplicationTheme.primaryDisColor
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Samples: " + backlashTester.forwardSampleCount
                                font: mApplicationTheme.font_En_3X_Small_Regular
                                color: mApplicationTheme.mainTint3
                            }
                        }
                    }

                    // Reverse Direction
                    Pane{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: 570
                        background: Rectangle {
                            anchors.fill: parent
                            color: mApplicationTheme.yellowShade2
                            radius: 6
                        }
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Reverse Direction"
                                font: mApplicationTheme.font_En_Large_Bold
                                color: mApplicationTheme.mainTint3
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 20

                                ColumnLayout {
                                    spacing: 5
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Maximum"
                                        font: mApplicationTheme.font_En_3X_Small_Regular
                                        color: mApplicationTheme.mainTint3

                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Math.abs(backlashTester.maxAngleReverse).toFixed(3) + "°"
                                        font: mApplicationTheme.font_En_Medium_Bold
                                        color: mApplicationTheme.yellow
                                    }
                                }

                                Rectangle {
                                    width: 2
                                    height: 50
                                    color: Material.color(Material.Grey, Material.Shade300)
                                }

                                ColumnLayout {
                                    spacing: 5
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Average"
                                        font: mApplicationTheme.font_En_3X_Small_Regular
                                        color: mApplicationTheme.mainTint3
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Math.abs(backlashTester.avgAngleReverse).toFixed(3) + "°"
                                        font: mApplicationTheme.font_En_Medium_Bold
                                        color: mApplicationTheme.yellow
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Samples: " + backlashTester.reverseSampleCount
                                font: mApplicationTheme.font_En_3X_Small_Regular
                                color: mApplicationTheme.mainTint3
                            }
                        }
                    }
                }

                // Backlash Results - Two side by side
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    // Maximum Backlash
                    Pane{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: 570

                        background:Rectangle {
                            anchors.fill: parent
                            color: backlashTester.backlashColorMax === "red" ?
                                       mApplicationTheme.darkRed1 :
                                       mApplicationTheme.darkGreen
                            radius: 6

                        }
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Maximum Backlash"
                                font: mApplicationTheme.font_En_Large_Bold
                                color: mApplicationTheme.mainTint3
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 8

                                Text {
                                    text: backlashTester.backlashValueMax.toFixed(3) + "°"
                                    font: mApplicationTheme.font_En_3X_Large_Bold
                                    color: backlashTester.backlashColorMax === "red" ?
                                               mApplicationTheme.sharpRed :
                                               mApplicationTheme.green
                                }

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: backlashTester.backlashColorMax === "red" ?
                                               mApplicationTheme.sharpRed :
                                               mApplicationTheme.green

                                    Text {
                                        anchors.centerIn: parent
                                        text: backlashTester.backlashValueMax > 0.3 ? "✗" : "✓"
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: backlashTester.backlashColorAvg === "red" ?
                                                   mApplicationTheme.darkRed1 :
                                                   mApplicationTheme.darkGreen
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: backlashTester.backlashValueMax > 0.3 ?
                                          "EXCESSIVE" : "ACCEPTABLE"
                                font: mApplicationTheme.font_En_2X_Small_Bold
                                color: backlashTester.backlashColorAvg === "red" ?
                                           mApplicationTheme.sharpRed :
                                           mApplicationTheme.green
                            }
                        }
                    }

                    // Average Backlash
                    Pane{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: 570
                        background: Rectangle {
                            anchors.fill: parent
                            color: backlashTester.backlashColorAvg === "red" ?
                                       mApplicationTheme.darkRed1 :
                                       mApplicationTheme.darkGreen
                            radius: 6

                        }
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Average Backlash"
                                font: mApplicationTheme.font_En_Large_Bold
                                color: mApplicationTheme.mainTint3

                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 8

                                Text {
                                    text: backlashTester.backlashValueAvg.toFixed(3) + "°"
                                    font: mApplicationTheme.font_En_3X_Large_Bold
                                    color: backlashTester.backlashColorAvg === "red" ?
                                               mApplicationTheme.sharpRed :
                                               mApplicationTheme.green
                                }

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: backlashTester.backlashColorAvg === "red" ?
                                               mApplicationTheme.sharpRed :
                                               mApplicationTheme.green

                                    Text {
                                        anchors.centerIn: parent
                                        text: backlashTester.backlashValueAvg > 0.3 ? "✗" : "✓"
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: backlashTester.backlashColorAvg === "red" ?
                                                   mApplicationTheme.darkRed1 :
                                                   mApplicationTheme.darkGreen
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: backlashTester.backlashValueAvg > 0.3 ?
                                          "EXCESSIVE" : "ACCEPTABLE"
                                font: mApplicationTheme.font_En_2X_Small_Bold
                                color: backlashTester.backlashColorAvg === "red" ?
                                           mApplicationTheme.sharpRed :
                                           mApplicationTheme.green
                            }
                        }
                    }


                }

            }


            Pane{
                id: uSystemLog_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 700
                Layout.maximumWidth: 700
                padding: 16
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }

                ScrollView {
                    id: scrollView
                    anchors.fill: parent
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                    clip: true

                    TextArea {
                        id: uSystemLog_TextArea
                        font: mApplicationTheme.font_En_2X_Small_Regular
                        Material.foreground: mApplicationTheme.mainTint4
                        Material.accent: 'transparent'
                        selectByMouse: true
                        selectByKeyboard: false
                        readOnly: true
                        wrapMode: TextArea.Wrap

                        background: Rectangle {
                            color: "transparent"
                        }

                        onTextChanged: {
                            cursorPosition = length
                        }
                    }
                }
            }
        }
    }
}
