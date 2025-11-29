import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    implicitHeight: 200

    // Properties
    property alias encoderAngle: angleDisplay.text
    property alias status: encoderStatus.text
    property alias statusColor: encoderStatus.color

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
                    text: "Encoder Feedback"
                    font.pixelSize: 16
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Text {
                    id: encoderStatus
                    text: "Disconnected"
                    color: "red"
                    font.bold: true
                }
            }

            // Angle display
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: "Angle:"
                    font.pixelSize: 16
                }

                Text {
                    id: angleDisplay
                    text: "0.000"
                    font.pixelSize: 48
                    font.bold: true
                    color: "#FF6B35"
                }

                Text {
                    text: "°"
                    font.pixelSize: 24
                    color: "gray"
                }
            }

            // Visual indicator
            Rectangle {
                Layout.fillWidth: true
                height: 40

                Rectangle {
                    width: parent.width
                    height: 4
                    color: "#e0e0e0"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id: needle
                    width: 4
                    height: 30
                    color: "#FF6B35"
                    anchors.bottom: parent.verticalCenter
                    anchors.bottomMargin: -2
                    anchors.horizontalCenter: parent.left
                    anchors.horizontalCenterOffset: parent.width / 2
                    rotation: (parseFloat(root.encoderAngle) || 0) * 2  // Scale for visibility

                    Behavior on rotation {
                        NumberAnimation { duration: 100 }
                    }
                }
            }
        }
    }
}
