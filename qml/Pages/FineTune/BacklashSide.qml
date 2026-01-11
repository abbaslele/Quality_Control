import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects

import "../../"
import "../../Components"
import "../../Pages"

Item {


    property ApplicationTheme mApplicationTheme
    property StackView mStackView

    property bool _isConnected: false

    // Access controllers

    property var backlashTester: appController.backlashTester()
    property var deviceCtrl: appController.deviceController()
    property var serialMgr: appController.serialPort()
    property var maximumError: 0



    // Test data model
    ListModel {
        id: testDataModel
    }


    Connections {
        target: appController

        function onTestDataPoint(pulse, expectedAngle, actualAngle, error) {
            testDataModel.append({
                                     "pulse": pulse,
                                     "expected": expectedAngle.toFixed(3),
                                     "actual": actualAngle.toFixed(3),
                                     "error": error.toFixed(3)
                                 })
            // console.log("Suuuuuuuuuu pulse : " +  pulse  + "expected : " + expectedAngle + "actual : " +  actualAngle + "error : " + error)

            if((Math.abs(error.toFixed(3)) > Math.abs(maximumError)) && (Math.abs(error.toFixed(3)) < 2.00 )){
                maximumError = error.toFixed(3)
            }
        }

        function onStatusMessage(message) {
            uSystemLog_TextArea.text += message + "\n"
        }
    }


    ColumnLayout{
        anchors.fill: parent
        spacing: 24

        RowLayout{
            id: uDetail_RowLayout

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 150

            Pane{
                id: uDetail_Pane
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


                    RowLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 8
                        enabled: false
                        // rowSpacing: 8
                        // columnSpacing: 8
                        // columns: 3



                        // CustomTextField{
                        //     id: uP3_CustomTextField
                        //     mApplicationTheme: m_Item.mApplicationTheme
                        //     _TitleText: "P3"
                        //     _isNumberOnly: true
                        //     _TextfieldText: "N/A"

                        // }

                        // CustomTextField{
                        //     id: uP4_CustomTextField
                        //     mApplicationTheme: m_Item.mApplicationTheme
                        //     _TitleText: "P4"
                        //     _isNumberOnly: true
                        //     _TextfieldText: "N/A"

                        // }

                    }

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
                            maximumError = 0
                            if (sequencer.isRunning) {
                                appController.stopTest()
                            } else {
                                testDataModel.clear()

                                appController.startTest()

                            }
                        }
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

        }

        RowLayout{
            id: uData_RowLayout
            spacing: 16
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 675
            Layout.minimumHeight: 675

            Pane{
                id: uOnlineTest_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumWidth: parent.width / 3 * 2
                padding: 16

                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }


                GridLayout {
                    anchors.fill: parent
                    columns: 2
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

            }


        }

    }
}
