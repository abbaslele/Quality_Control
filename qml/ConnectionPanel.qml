import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    implicitHeight: 250

    // Signals
    signal servoConnect(string servoPort)
    signal servoDisconnect()
    signal encoderConnect(string encoderPort)
    signal encoderDisconnect()

    // Properties
    property alias servoPort: servoCombo.currentText
    property alias encoderPort: encoderCombo.currentText

    // Configuration properties
    property alias startPosition: startPosField.text
    property alias stopPosition: stopPosField.text
    property alias stepCount: stepCountField.text
    property alias startAngle: startAngleField.text
    property alias stopAngle: stopAngleField.text
    property alias useAngleMapping: angleCheckBox.checked

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"
        border.color: "#ccc"
        radius: 5

        ScrollView {
            anchors.fill: parent
            anchors.margins: 10

            ColumnLayout {
                width: parent.width
                spacing: 10

                Text {
                    text: "Device Configuration"
                    font.pixelSize: 16
                    font.bold: true
                }

                // Servo connection row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Servo Port:"
                        Layout.minimumWidth: 100
                    }

                    ComboBox {
                        id: servoCombo
                        Layout.fillWidth: true
                        model: ApplicationController.availablePorts()
                        currentIndex: -1
                    }

                    Button {
                        text: servoCombo.enabled ? "Connect" : "Disconnect"
                        onClicked: {
                            if (servoCombo.enabled) {
                                root.servoConnect(servoCombo.currentText)
                                servoCombo.enabled = false
                            } else {
                                root.servoDisconnect()
                                servoCombo.enabled = true
                            }
                        }
                    }
                }

                // Encoder connection row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Encoder Port:"
                        Layout.minimumWidth: 100
                    }

                    ComboBox {
                        id: encoderCombo
                        Layout.fillWidth: true
                        model: ApplicationController.availablePorts()
                        currentIndex: -1
                    }

                    Button {
                        text: encoderCombo.enabled ? "Connect" : "Disconnect"
                        onClicked: {
                            if (encoderCombo.enabled) {
                                root.encoderConnect(encoderCombo.currentText)
                                encoderCombo.enabled = false
                            } else {
                                root.encoderDisconnect()
                                encoderCombo.enabled = true
                            }
                        }
                    }
                }

                // Configuration parameters
                Text {
                    text: "Position Configuration"
                    font.pixelSize: 14
                    font.bold: true
                    topPadding: 10
                }

                // After the configuration grid:
                // Inside ColumnLayout, after the configuration grid:
                Button {
                    id: calibrateButton
                    text: "Calibrate Encoder at Center (1500μs)"
                    enabled: !servoCombo.enabled && !encoderCombo.enabled
                    onClicked: {
                        ApplicationController.calibrateEncoder()
                    }
                }

                Text {
                    visible: ApplicationController.isCalibrated
                    text: "✓ Calibrated"
                    color: "green"
                    font.bold: true
                }

                Timer {
                    id: calibrateTimer
                    interval: 2000
                    onTriggered: {
                        ApplicationController.calibrateEncoder()
                    }
                }


                // Angle mapping checkbox
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    CheckBox {
                        id: angleCheckBox
                        text: "Use Angle Mapping"
                    }
                }

                // Start/Stop positions
                GridLayout {
                    Layout.fillWidth: true
                    columns: 4
                    columnSpacing: 10
                    rowSpacing: 5

                    Text { text: "Start Position (μs):" }
                    TextField {
                        id: startPosField
                        text: "900"
                        Layout.fillWidth: true
                    }

                    Text { text: "Start Angle (°):"; visible: angleCheckBox.checked }
                    TextField {
                        id: startAngleField
                        text: "-75"
                        Layout.fillWidth: true
                        visible: angleCheckBox.checked
                    }

                    Text { text: "Stop Position (μs):" }
                    TextField {
                        id: stopPosField
                        text: "2100"
                        Layout.fillWidth: true
                    }

                    Text { text: "Stop Angle (°):"; visible: angleCheckBox.checked }
                    TextField {
                        id: stopAngleField
                        text: "75"
                        Layout.fillWidth: true
                        visible: angleCheckBox.checked
                    }

                    Text { text: "Step Count:" }
                    TextField {
                        id: stepCountField
                        text: "10"
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
