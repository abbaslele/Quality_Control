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
                spacing: 20


                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    // Countdown Display


                    Rectangle {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 500

                        Layout.fillHeight: true
                        color: {
                            switch(backlashTester.currentPhaseText){
                            case "Idle" :
                            case "Forward Direction Reading" :
                                Material.color(Material.Blue, Material.Shade100); break;
                            case  "Calibrating System":
                                Material.color(Material.Grey, Material.Shade100); break;
                            case "Waiting (2 seconds)" :
                                Material.color(Material.Yellow, Material.Shade100); break;
                            case "Reverse Direction Reading" :
                                Material.color(Material.Red, Material.Shade100); break;
                            case  "Test Complete" :
                                Material.color(Material.Green, Material.Shade100); break;
                            default :
                                Material.color(Material.Grey, Material.Shade100); break;
                            }
                        }

                        radius: 8
                        border.width: 2
                        border.color: {

                            switch(backlashTester.currentPhaseText){
                            case "Idle" :
                            case "Forward Direction Reading" :
                                Material.color(Material.Blue); break;
                            case  "Calibrating System":
                                Material.color(Material.Grey); break;
                            case "Waiting (2 seconds)" :
                                Material.color(Material.Yellow); break;
                            case "Reverse Direction Reading" :
                                Material.color(Material.Red); break;
                            case  "Test Complete" :
                                Material.color(Material.Green); break;
                            default :
                                Material.color(Material.Grey); break;

                            }

                            // backlashTester.isRunning ? backlashTester.currentPhaseText === "Forward Direction Reading" ? Material.color(Material.Yellow) : Material.color(Material.Blue) : Material.color(Material.Grey)
                        }
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Countdown"
                                font.pixelSize: 16
                                color: {
                                    switch(backlashTester.currentPhaseText){
                                    case "Idle" :
                                    case "Forward Direction Reading" :
                                        Material.color(Material.Blue, Material.Shade700); break;
                                    case  "Calibrating System":
                                        Material.color(Material.Grey, Material.Shade700); break;
                                    case "Waiting (2 seconds)" :
                                        Material.color(Material.Yellow, Material.Shade700); break;
                                    case "Reverse Direction Reading" :
                                        Material.color(Material.Red, Material.Shade700); break;
                                    case  "Test Complete" :
                                        Material.color(Material.Green, Material.Shade700); break;
                                    default :
                                        Material.color(Material.Grey, Material.Shade700); break;
                                    }
                                }

                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: backlashTester.countdown + " s"
                                font.pixelSize: 48
                                font.bold: true
                                color: {

                                    switch(backlashTester.currentPhaseText){
                                    case "Idle" :
                                    case "Forward Direction Reading" :
                                        Material.color(Material.Blue); break;
                                    case  "Calibrating System":
                                        Material.color(Material.Grey); break;
                                    case "Waiting (2 seconds)" :
                                        Material.color(Material.Yellow); break;
                                    case "Reverse Direction Reading" :
                                        Material.color(Material.Red); break;
                                    case  "Test Complete" :
                                        Material.color(Material.Green); break;
                                    default :
                                        Material.color(Material.Grey); break;

                                    }
                                }
                            }
                        }
                    }
                }


                // Results Display - Max and Average side by side
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 15
                    columnSpacing: 15

                    // Forward Direction
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Material.color(Material.LightBlue, Material.Shade50)
                        radius: 8
                        border.width: 2
                        border.color: Material.color(Material.Blue)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Forward Direction"
                                font.pixelSize: 18
                                font.bold: true
                                color: Material.color(Material.Blue)
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
                                        font.pixelSize: 12
                                        color: Material.color(Material.Grey, Material.Shade700)
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: backlashTester.maxAngleForward.toFixed(3) + "°"
                                        font.pixelSize: 24
                                        font.bold: true
                                        color: Material.color(Material.Blue)
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
                                        font.pixelSize: 12
                                        color: Material.color(Material.Grey, Material.Shade700)
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: backlashTester.avgAngleForward.toFixed(3) + "°"
                                        font.pixelSize: 24
                                        font.bold: true
                                        color: Material.color(Material.LightBlue)
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Samples: " + backlashTester.forwardSampleCount
                                font.pixelSize: 11
                                color: Material.color(Material.Grey, Material.Shade600)
                            }
                        }
                    }

                    // Reverse Direction
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Material.color(Material.DeepOrange, Material.Shade50)
                        radius: 8
                        border.width: 2
                        border.color: Material.color(Material.DeepOrange)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Reverse Direction"
                                font.pixelSize: 18
                                font.bold: true
                                color: Material.color(Material.DeepOrange)
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
                                        font.pixelSize: 12
                                        color: Material.color(Material.Grey, Material.Shade700)
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Math.abs(backlashTester.maxAngleReverse).toFixed(3) + "°"
                                        font.pixelSize: 24
                                        font.bold: true
                                        color: Material.color(Material.DeepOrange)
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
                                        font.pixelSize: 12
                                        color: Material.color(Material.Grey, Material.Shade700)
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Math.abs(backlashTester.avgAngleReverse).toFixed(3) + "°"
                                        font.pixelSize: 24
                                        font.bold: true
                                        color: Material.color(Material.Orange)
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Samples: " + backlashTester.reverseSampleCount
                                font.pixelSize: 11
                                color: Material.color(Material.Grey, Material.Shade600)
                            }
                        }
                    }
                }

                // Backlash Results - Two side by side
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    rowSpacing: 15
                    columnSpacing: 15

                    // Maximum Backlash
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        color: backlashTester.backlashColorMax === "red" ?
                                   Material.color(Material.Red, Material.Shade50) :
                                   Material.color(Material.Green, Material.Shade50)
                        radius: 10
                        border.width: 3
                        border.color: backlashTester.backlashColorMax === "red" ?
                                          Material.color(Material.Red) :
                                          Material.color(Material.Green)

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Maximum Backlash"
                                font.pixelSize: 16
                                font.bold: true
                                color: Material.color(Material.Grey, Material.Shade800)
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 8

                                Text {
                                    text: backlashTester.backlashValueMax.toFixed(3) + "°"
                                    font.pixelSize: 36
                                    font.bold: true
                                    color: backlashTester.backlashColorMax === "red" ?
                                               Material.color(Material.Red) :
                                               Material.color(Material.Green)
                                }

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: backlashTester.backlashColorMax === "red" ?
                                               Material.color(Material.Red) :
                                               Material.color(Material.Green)

                                    Text {
                                        anchors.centerIn: parent
                                        text: backlashTester.backlashValueMax > 0.3 ? "✗" : "✓"
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: "white"
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: backlashTester.backlashValueMax > 0.3 ?
                                          "EXCESSIVE" : "ACCEPTABLE"
                                font.pixelSize: 13
                                font.bold: true
                                color: backlashTester.backlashColorMax === "red" ?
                                           Material.color(Material.Red) :
                                           Material.color(Material.Green)
                            }
                        }
                    }

                    // Average Backlash
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        color: backlashTester.backlashColorAvg === "red" ?
                                   Material.color(Material.Red, Material.Shade50) :
                                   Material.color(Material.Green, Material.Shade50)
                        radius: 10
                        border.width: 3
                        border.color: backlashTester.backlashColorAvg === "red" ?
                                          Material.color(Material.Red) :
                                          Material.color(Material.Green)

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Average Backlash"
                                font.pixelSize: 16
                                font.bold: true
                                color: Material.color(Material.Grey, Material.Shade800)
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 8

                                Text {
                                    text: backlashTester.backlashValueAvg.toFixed(3) + "°"
                                    font.pixelSize: 36
                                    font.bold: true
                                    color: backlashTester.backlashColorAvg === "red" ?
                                               Material.color(Material.Red) :
                                               Material.color(Material.Green)
                                }

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: backlashTester.backlashColorAvg === "red" ?
                                               Material.color(Material.Red) :
                                               Material.color(Material.Green)

                                    Text {
                                        anchors.centerIn: parent
                                        text: backlashTester.backlashValueAvg > 0.3 ? "✗" : "✓"
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: "white"
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: backlashTester.backlashValueAvg > 0.3 ?
                                          "EXCESSIVE" : "ACCEPTABLE"
                                font.pixelSize: 13
                                font.bold: true
                                color: backlashTester.backlashColorAvg === "red" ?
                                           Material.color(Material.Red) :
                                           Material.color(Material.Green)
                            }
                        }
                    }


                }

                Item { Layout.fillHeight: true }
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
