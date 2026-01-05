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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Title Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Material.color(Material.DeepOrange)
            radius: 8

            Text {
                anchors.centerIn: parent
                text: "Gearbox Backlash Testing - Feedback Mode"
                font.pixelSize: 24
                font.bold: true
                color: "white"
            }
        }

        // // Instructions
        // GroupBox {
        //     Layout.fillWidth: true
        //     title: "Instructions"

        //     Text {
        //         width: parent.width
        //         wrapMode: Text.WordWrap
        //         text: "This test measures gearbox backlash by reading encoder values " +
        //               "in both directions for 10 seconds each. The system will:\n" +
        //               "1. Reset and calibrate the servo\n" +
        //               "2. Read and accumulate angle values in forward direction (10s)\n" +
        //               "3. Read and accumulate angle values in reverse direction (10s)\n" +
        //               "4. Calculate total backlash using both Maximum and Average values\n\n" +
        //               "Green = Good (≤ 0.3°), Red = Excessive (> 0.3°)"
        //         font.pixelSize: 14
        //     }
        // }

        // Connection Panel
        GroupBox {
            Layout.fillWidth: true
            title: "Serial Connection"

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                RowLayout {
                    Text { text: "COM Port:" }

                    ComboBox {
                        id: portComboBox
                        Layout.fillWidth: true
                        model: serialMgr.availablePorts()
                        onActivated: {
                            serialMgr.portName = currentText
                        }
                        Component.onCompleted: {
                            if (serialMgr.portName !== "") {
                                currentIndex = find(serialMgr.portName)
                            }
                        }
                    }

                    Button {
                        text: "🔄"
                        onClicked: portComboBox.model = serialMgr.availablePorts()
                    }
                }

                RowLayout {
                    Text { text: "Baud Rate:" }

                    ComboBox {
                        id: baudComboBox
                        Layout.fillWidth: true
                        model: ["9600", "19200", "38400", "57600", "115200"]
                        enabled: false
                        currentIndex: 1
                        onActivated: {
                            serialMgr.baudRate = parseInt(currentText)
                        }
                    }
                }

                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    Button {
                        text: serialMgr.isConnected ? "Disconnect" : "Connect"
                        Layout.fillWidth: true
                        Material.background: serialMgr.isConnected ? Material.Red : Material.Green
                        onClicked: {
                            if (serialMgr.isConnected) {
                                serialMgr.closePort()
                            } else {
                                serialMgr.openPort()
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Button {
                        text: backlashTester.isRunning ? "⏸ Stop Test" : "▶ Start Backlash Test"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        enabled: serialMgr.isConnected && appController.isCalibrated
                        Material.background: backlashTester.isRunning ? Material.Red : Material.Green
                        font.pixelSize: 16
                        font.bold: true
                        onClicked: {
                            if (backlashTester.isRunning) {
                                backlashTester.stopTest()
                            } else {
                                backlashTester.startTest()
                            }
                        }
                    }

                    Button {
                        text: "🔄 Reset"
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 50
                        enabled: !backlashTester.isRunning
                        onClicked: {
                            appController.performCalibration()
                            backlashTester.resetValues()
                    }
                    }
                }

            }
        }


        // Countdown Display
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Material.color(Material.Grey, Material.Shade100)
            radius: 8
            border.width: 2
            border.color: backlashTester.isRunning ? Material.color(Material.Blue) : Material.color(Material.Grey)

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Countdown"
                    font.pixelSize: 16
                    color: Material.color(Material.Grey, Material.Shade700)
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: backlashTester.countdown + " s"
                    font.pixelSize: 48
                    font.bold: true
                    color: backlashTester.isRunning ? Material.color(Material.Blue) : "black"
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

        // Current Status
        GroupBox {
            Layout.fillWidth: true
            title: "Current Status"

            GridLayout {
                anchors.fill: parent
                columns: 4
                rowSpacing: 10
                columnSpacing: 20

                Text { text: "Encoder:" }
                Text {
                    text: deviceCtrl.currentEncoderAngle.toFixed(3) + "°"
                    font.bold: true
                    color: Material.color(Material.Blue)
                }

                Text { text: "Connection:" }
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: serialMgr.isConnected ? "green" : "red"
                }

                Text { text: "Calibrated:" }
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: appController.isCalibrated ? "green" : "gray"
                }

                Text { text: "Test Status:" }
                Text {
                    text: backlashTester.isRunning ? "RUNNING" : "IDLE"
                    font.bold: true
                    color: backlashTester.isRunning ? Material.color(Material.Green) : "gray"
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
