import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    implicitHeight: 350

    // Properties
    property alias commandedPosition: commandedPosText.text
    property bool sequenceRunning: false
    property alias status: servoStatus.text
    property alias statusColor: servoStatus.color
    property alias maxError: maxErrorText.text
    property alias servoFailed: failureIcon.visible
    property alias errorLog: errorLogView.text

    Rectangle {
        anchors.fill: parent
        color: "#fafafa"
        border.color: "#ddd"
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Servo Control & Validation"
                    font.pixelSize: 16
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                // Failure indicator
                Rectangle {
                    id: failureIcon
                    width: 20
                    height: 20
                    color: "red"
                    radius: 10
                    visible: false

                    Text {
                        anchors.centerIn: parent
                        text: "!"
                        color: "white"
                        font.bold: true
                    }
                }

                Text {
                    id: servoStatus
                    text: "Disconnected"
                    color: "red"
                    font.bold: true
                }
            }

            // Commanded position
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Commanded Position:"
                    Layout.minimumWidth: 150
                }

                Text {
                    id: commandedPosText
                    text: "1500"
                    font.bold: true
                    font.pixelSize: 18
                    color: "#2196F3"
                }

                Text {
                    text: "μs"
                    color: "gray"
                }
            }

            // Encoder angle
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Actual Angle:"
                    Layout.minimumWidth: 150
                }

                Text {
                    id: actualAngleText
                    text: ApplicationController.currentEncoderAngle.toFixed(3)
                    font.bold: true
                    font.pixelSize: 18
                    color: "#FF6B35"
                }

                Text {
                    text: "°"
                    color: "gray"
                }

                // Binding to update automatically
                Binding {
                    target: actualAngleText
                    property: "text"
                    value: ApplicationController.currentEncoderAngle.toFixed(3)
                }
            }

            // Maximum error
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Max Error:"
                    Layout.minimumWidth: 150
                }

                Text {
                    id: maxErrorText
                    text: "0.000"
                    font.bold: true
                    font.pixelSize: 18
                    color: m_maxError > 1.0 ? "red" : "green"
                }

                Text {
                    text: "°"
                    color: "gray"
                }

                // Binding for color change
                Binding {
                    target: maxErrorText
                    property: "color"
                    value: parseFloat(maxErrorText.text) > 1.0 ? "red" : "green"
                }

                // Binding to update automatically
                Binding {
                    target: maxErrorText
                    property: "text"
                    value: ApplicationController.maxError.toFixed(3)
                }
            }

            // Control buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    text: "Start Sequence"
                    enabled: !root.sequenceRunning
                    onClicked: ApplicationController.startSequence()
                }

                Button {
                    text: "Stop Sequence"
                    enabled: root.sequenceRunning
                    onClicked: ApplicationController.stopSequence()
                }

                Button {
                    text: "Clear Log"
                    onClicked: ApplicationController.clearErrorLog()
                }

                Item { Layout.fillWidth: true }
            }

            // Progress indicator
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Status:"
                    Layout.minimumWidth: 150
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 20
                    color: "#e0e0e0"
                    radius: 10

                    Rectangle {
                        width: parent.width * (root.sequenceRunning ? 1 : 0)
                        height: parent.height
                        color: "#4CAF50"
                        radius: 10

                        Behavior on width {
                            NumberAnimation { duration: 1000 }
                        }
                    }
                }

                Text {
                    text: root.sequenceRunning ? "Running" : "Idle"
                    color: root.sequenceRunning ? "green" : "gray"
                    font.bold: true
                }
            }

            // Error log
            Text {
                text: "Error Log:"
                font.bold: true
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextArea {
                    id: errorLogView
                    text: ApplicationController.errorLog
                    readOnly: true
                    font.family: "Courier New"
                    font.pixelSize: 12
                    background: Rectangle { color: "#f5f5f5" }
                }
            }
        }
    }
}
