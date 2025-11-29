import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Basic 2.15

ApplicationWindow {
    visible: true
    width: 900
    height: 700
    title: "Quality Control - Servo & Encoder System"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            text: "Servo & Encoder Quality Control"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Connection Panel
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text { text: "Port:" }
            ComboBox {
                id: portCombo
                Layout.fillWidth: true
                model: ApplicationController.availablePorts()
                currentIndex: -1
            }

            Button {
                text: portCombo.enabled ? "Connect" : "Disconnect"
                onClicked: {
                    if (portCombo.enabled) {
                        ApplicationController.connectDevice(portCombo.currentText)
                        portCombo.enabled = false
                    } else {
                        ApplicationController.disconnectDevice()
                        portCombo.enabled = true
                    }
                }
            }

            Button {
                text: "Calibrate"
                enabled: !portCombo.enabled && !ApplicationController.isCalibrated
                onClicked: ApplicationController.calibrateDevice()
            }

            Text {
                visible: ApplicationController.isCalibrated
                text: "✓ Calibrated"
                color: "green"
                font.bold: true
            }
        }

        // Configuration
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            columnSpacing: 10

            Text { text: "Start Pos (μs):" }
            TextField { id: startPos; text: "900" }

            Text { text: "Stop Pos (μs):" }
            TextField { id: stopPos; text: "2100" }

            Text { text: "Steps:" }
            TextField { id: stepCount; text: "10" }

            Text { text: "Encoder Offset:" }
            TextField {
                id: offsetField
                text: ApplicationController.isCalibrated ? ApplicationController.encoderCenterOffset.toFixed(1) : "--"
                readOnly: true
            }
        }

        // Control Panel
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: "Start Test"
                enabled: ApplicationController.deviceConnected && ApplicationController.isCalibrated && !ApplicationController.sequenceRunning
                onClicked: ApplicationController.startSequence()
            }

            Button {
                text: "Stop Test"
                enabled: ApplicationController.sequenceRunning
                onClicked: ApplicationController.stopSequence()
            }

            Button {
                text: "Calibrate"
                onClicked: ApplicationController.calibrateDevice()
            }


            Button {
                text: "Clear Log"
                onClicked: ApplicationController.clearErrorLog()
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Max Error: " + (ApplicationController.maxError || 0).toFixed(3) + "°"
                font.bold: true
                color: ApplicationController.maxError > 1.0 ? "red" : "green"
            }

            Rectangle {
                width: 20
                height: 20
                color: ApplicationController.servoFailed ? "red" : "transparent"
                radius: 10
                visible: ApplicationController.servoFailed

                Text {
                    anchors.centerIn: parent
                    text: "!"
                    color: "white"
                    font.bold: true
                }
            }
        }

        // Status Display
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 10

            Text { text: "Commanded:"; font.bold: true }
            Text {
                text: (ApplicationController.currentPosition || 0) + " μs"
            }

            Text { text: "Encoder Angle:"; font.bold: true }
            Text {
                text: (ApplicationController.currentAngle || 0).toFixed(3) + "°"
                color: "#2196F3"
            }
        }

        // Error Log
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            TextArea {
                text: ApplicationController.errorLog
                readOnly: true
                font.family: "Courier New"
                font.pixelSize: 11
            }
        }

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            height: 25
            color: "darkgray"

            Text {
                anchors.fill: parent
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter
                text: ApplicationController.deviceConnected ? "Connected" : "Disconnected"
                color: "white"
            }
        }
    }
}
