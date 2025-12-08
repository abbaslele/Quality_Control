import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: mainWindow

    Material.theme: Material.Light
    Material.accent: Material.Blue

    property ApplicationTheme mApplicationTheme

    // Access controllers
    property var serialMgr: appController.serialPort()
    property var deviceCtrl: appController.deviceController()
    property var sequencer: appController.positionSequencer()
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

            if(Math.abs(error.toFixed(3)) > Math.abs(maximumError)){
                maximumError = error.toFixed(3)
            }
        }

        function onStatusMessage(message) {
            statusBar.text = message
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 100
            Layout.maximumHeight:  100
            color: Material.color(Material.Blue)
            radius: 5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15

                Image {
                    id: name
                    source: "qrc:/Resources/Images/TavanLogo.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.maximumWidth: 200
                }

                Text {
                    text: "Servo Motor Quality Control"
                    font: mApplicationTheme.font_En_2X_Large_Bold
                    color: "white"
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: serialMgr.isConnected ? "lightgreen" : "red"
                }

                Text {
                    text: serialMgr.isConnected ? "Connected" : "Disconnected"
                    color: "white"
                    font.pixelSize: 14
                }
            }
        }

        // Main content area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // Left panel - Controls
            ColumnLayout {
                Layout.maximumWidth: 550
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 10

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
                    }
                }

                // RowLayout{
                //     Layout.fillWidth: true
                //     Layout.fillHeight: true
                // Configuration Panel
                GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "Test Configuration"

                    GridLayout {
                        anchors.fill: parent
                        columns: 4
                        rowSpacing: 10
                        columnSpacing: 10

                        Text { text: "Start Pulse:" }
                        SpinBox {
                            id: startPulseBox
                            from: 900
                            to: 2250
                            value: appController.startPulse
                            editable: true
                            onValueChanged: appController.startPulse = value
                        }

                        Text { text: "End Pulse:" }
                        SpinBox {
                            id: endPulseBox
                            from: 900
                            to: 2250
                            value: appController.endPulse
                            editable: true
                            onValueChanged: appController.endPulse = value
                        }

                        Text { text: "Start Angle (°):" }
                        SpinBox {
                            id: startAngleBox
                            from: -180
                            to: 180
                            value: appController.startAngle
                            editable: true
                            onValueChanged: appController.startAngle = value
                        }

                        Text { text: "End Angle (°):" }
                        SpinBox {
                            id: endAngleBox
                            from: -180
                            to: 180
                            value: appController.endAngle
                            editable: true
                            onValueChanged: appController.endAngle = value
                        }

                        Text { text: "Steps:" }
                        SpinBox {
                            id: stepsBox
                            from: 2
                            to: 50
                            value: appController.steps
                            editable: true
                            onValueChanged: appController.steps = value
                        }

                        Text { text: "Interval (ms):" }
                        SpinBox {
                            id: intervalBox
                            from: 100
                            to: 5000
                            stepSize: 100
                            enabled: false
                            value: sequencer.intervalMs
                            editable: true
                            onValueChanged: sequencer.intervalMs = value
                        }

                        Button {
                            Layout.columnSpan:  4
                            text: "💾 Save Settings"
                            Layout.fillWidth: true
                            onClicked: appController.saveSettings()
                        }

                    }
                }

                // Control Buttons
                GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "Operations"

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10

                        Button {
                            text: "🎯 Calibrate System"
                            Layout.fillWidth: true
                            Material.background: Material.Orange
                            enabled: serialMgr.isConnected && !sequencer.isRunning
                            onClicked: {
                                appController.performCalibration()
                            }
                        }

                        Button {
                            text: sequencer.isRunning ? "⏸ Stop Test" : "▶ Start Test"
                            Layout.fillWidth: true
                            Material.background: sequencer.isRunning ? Material.Red : Material.Green
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


                        RowLayout{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            CheckBox {
                                text: "Continuous Loop"
                                checked: sequencer.loopEnabled
                                onCheckedChanged: sequencer.loopEnabled = checked
                            }

                            Item{Layout.fillWidth: true}

                            Text { text: "Number of Loops:" }

                            SpinBox {
                                id: loopsBox
                                from: 1
                                to: 100
                                value: 4
                                editable: true
                                onValueChanged: sequencer.maxLoops = value
                            }
                        }
                    }
                }
                // }

                // Current Status


            }

            // Right panel - Results
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    title: "Test Results"

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        // Header Row
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: Material.color(Material.Blue)

                            Row {
                                anchors.fill: parent
                                spacing: 1

                                Repeater {
                                    model: ["Pulse (μs)", "Expected Angle", "Actual Angle", "Error"]

                                    Rectangle {
                                        width: parent.parent.width / 4
                                        height: 40
                                        color: Material.color(Material.Blue)

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData
                                            color: "white"
                                            font.bold: true
                                            font.pixelSize: 13
                                        }
                                    }
                                }
                            }
                        }

                        // Data Rows
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true

                            ListView {
                                id: resultsListView
                                model: testDataModel
                                spacing: 1

                                delegate: Rectangle {
                                    width: resultsListView.width
                                    height: 40

                                    color: {
                                        var err = Math.abs(parseFloat(model.error))
                                        if (err > 0.855) return "#ffcdd2"
                                        if (err > 0.6) return "#fff9c4"
                                        return "white"
                                    }

                                    Row {
                                        anchors.fill: parent
                                        spacing: 1

                                        Rectangle {
                                            width: parent.width / 4
                                            height: 40
                                            color: "transparent"
                                            border.width: 1
                                            border.color: "#e0e0e0"

                                            Text {
                                                anchors.centerIn: parent
                                                text: model.pulse
                                                font: mApplicationTheme.font_En_2X_Small_Regular
                                            }
                                        }

                                        Rectangle {
                                            width: parent.width / 4
                                            height: 40
                                            color: "transparent"
                                            border.width: 1
                                            border.color: "#e0e0e0"

                                            Text {
                                                anchors.centerIn: parent
                                                text: model.expected + "°"
                                                font: mApplicationTheme.font_En_2X_Small_Regular
                                            }
                                        }

                                        Rectangle {
                                            width: parent.width / 4
                                            height: 40
                                            color: "transparent"
                                            border.width: 1
                                            border.color: "#e0e0e0"

                                            Text {
                                                anchors.centerIn: parent
                                                text: model.actual + "°"
                                                font: mApplicationTheme.font_En_2X_Small_Regular
                                                color: Material.color(Material.Green)
                                            }
                                        }

                                        Rectangle {
                                            width: parent.width / 4
                                            height: 40
                                            color: "transparent"
                                            border.width: 1
                                            border.color: "#e0e0e0"

                                            Text {
                                                anchors.centerIn: parent
                                                text: model.error + "°"
                                                font: Math.abs(parseFloat(model.error)) > 1.0 ? mApplicationTheme.font_En_2X_Small_Bold :  mApplicationTheme.font_En_2X_Small_Regular
                                                color: {
                                                    var err = Math.abs(parseFloat(model.error))
                                                    if (err > 2.0) return Material.color(Material.Red)
                                                    if (err > 1.0) return Material.color(Material.Orange)
                                                    return "black"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                GroupBox {
                    Layout.fillWidth: true
                    title: "Current Status"

                    RowLayout {
                        anchors.fill: parent

                        Text {
                            text: "Servo Position:"
                            font: mApplicationTheme.font_En_2X_Small_Regular
                        }
                        Text {
                            text: deviceCtrl.currentServoPosition + " μs"
                            color: Material.color(Material.Blue)
                            font: mApplicationTheme.font_En_Small_Bold
                        }

                        Item { Layout.fillWidth: true }


                        Text {
                            text: "Encoder Angle:"
                            font: mApplicationTheme.font_En_2X_Small_Regular
                        }
                        Text {
                            text: deviceCtrl.currentEncoderAngle.toFixed(2) + "°"
                            color: Material.color(Material.Green)
                            font: mApplicationTheme.font_En_Small_Bold
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "Sequence Step:"
                            font: mApplicationTheme.font_En_2X_Small_Regular
                        }
                        Text {
                            text: (sequencer.currentIndex + 1) + " / " + sequencer.totalSteps
                            font: mApplicationTheme.font_En_Small_Bold
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "Current Loop:"
                            font: mApplicationTheme.font_En_2X_Small_Regular
                        }
                        Text {
                            text: (sequencer.currentLoop + 1) + " / " + sequencer.maxLoops
                            color: Material.color(Material.Orange)
                            font: mApplicationTheme.font_En_Small_Bold
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "Maxium Error:"
                            font: mApplicationTheme.font_En_2X_Small_Regular
                        }
                        Text {
                            text: maximumError
                            color: Material.color(Material.Orange)
                            font: mApplicationTheme.font_En_Small_Bold
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "Calibrated:"
                            font: mApplicationTheme.font_En_2X_Small_Regular
                        }
                        Rectangle {
                            width: 16
                            height: 16
                            radius: 8
                            color: appController.isCalibrated ? "green" : "gray"
                        }
                    }
                }

            }
        }

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: Material.color(Material.Grey, Material.Shade200)
            radius: 3

            Text {
                id: statusBar
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "Ready"
                font.pixelSize: 12
            }
        }
    }
}
