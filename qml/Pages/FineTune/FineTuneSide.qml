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
            Layout.maximumHeight: 120
            Layout.minimumHeight: 120

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

                    Label{
                        text: "<b>Maximum Error:</b> " + maximumError
                        font: mApplicationTheme.font_En_Medium_Regular
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

        }

        RowLayout{
            id: uData_RowLayout
            spacing: 16
            Layout.fillWidth: true
            Layout.fillHeight: true

            Pane{
                id: uOnlineTest_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 16

                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }
                ColumnLayout{
                    anchors.fill: parent
                    spacing: 8
                    Pane{
                        Layout.fillWidth: true
                        background: Rectangle {
                            anchors.fill: parent
                            color: mApplicationTheme.main
                            border.width: 0
                            radius: 0
                        }
                        RowLayout {
                            anchors.fill: parent
                            spacing: 1

                            Repeater {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                model: [ "Row" , "Pulse (μs)", "Expected Angle", "Actual Angle", "Error"]

                                Text {
                                    Layout.minimumWidth: parent.parent.width / 5
                                    Layout.minimumHeight: 40
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    // anchors.centerIn: parent
                                    text: modelData
                                    color: mApplicationTheme.mainTint4
                                    font: mApplicationTheme.font_En_Small_Bold
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

                            delegate: Pane {
                                width: resultsListView.width
                                height: 40

                                background:  Rectangle{
                                    anchors.fill: parent
                                    color:{
                                        var err = Math.abs(parseFloat(model.error))
                                        if (err > 1.09) return mApplicationTheme.darkRed1
                                        if (err > 0.9) return mApplicationTheme.darkYellow
                                        return mApplicationTheme.main
                                    }
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 1

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.width / 5
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        text: model.index
                                        font: mApplicationTheme.font_En_2X_Small_Regular
                                        color: mApplicationTheme.mainTint4
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.width / 5
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        text: model.pulse
                                        font: mApplicationTheme.font_En_2X_Small_Regular
                                        color: mApplicationTheme.mainTint4
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.width / 5
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        text: model.expected + "°"
                                        font: mApplicationTheme.font_En_2X_Small_Regular
                                        color: mApplicationTheme.mainTint4
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.width / 5
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        text: model.actual + "°"
                                        font: mApplicationTheme.font_En_2X_Small_Regular
                                        color: mApplicationTheme.greenTint1
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.width / 5
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        text: model.error + "°"
                                        font: Math.abs(parseFloat(model.error)) > 1.0 ? mApplicationTheme.font_En_2X_Small_Bold :  mApplicationTheme.font_En_2X_Small_Regular
                                        color: {
                                            var err = Math.abs(parseFloat(model.error))
                                            if (err > 1.09) return mApplicationTheme.redShade1
                                            if (err > 0.9) return mApplicationTheme.yellowShade1
                                            return mApplicationTheme.mainTint4
                                        }
                                    }



                                }


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

            /*
            ColumnLayout{
                spacing: 16
                Pane{
                    id: uResult_Pane
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 16
                    background: Rectangle {
                        anchors.fill: parent
                        color: mApplicationTheme.mainShade
                        border.width: 0
                        radius: 6
                    }
                    ColumnLayout{
                        spacing: 16
                        anchors.fill: parent

                        RowLayout{
                            Label{
                                text: "Serialnumber: J5469"
                                font: mApplicationTheme.font_En_2X_Large_Bold
                                color: mApplicationTheme.mainTint3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Qt.AlignVCenter
                            }

                        }
                        RowLayout{
                            Label{
                                text: "<b>Type:</b> DHS-110"
                                font: mApplicationTheme.font_En_Medium_Regular
                                color: mApplicationTheme.mainTint3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Qt.AlignVCenter
                            }


                        }

                        RowLayout{
                            Label{
                                text: "<b>P3:</b> N/A"
                                font: mApplicationTheme.font_En_Medium_Regular
                                color: mApplicationTheme.mainTint3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Qt.AlignVCenter
                            }
                            Label{
                                text: "<b>P4:</b> N/A"
                                font: mApplicationTheme.font_En_Medium_Regular
                                color: mApplicationTheme.mainTint3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Qt.AlignVCenter
                            }
                        }
                    }
                }
*/


            // }

        }

    }
}
