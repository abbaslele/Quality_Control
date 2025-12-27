import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects

import "../../"
import "../../Components"
import "../../Pages"

Page {
    id:m_Item


    property ApplicationTheme mApplicationTheme
    property StackView mStackView


    property bool _isConnected: false
    padding: 24


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


    function letsChangeHomeState(val){
        state =val
    }

    function letsChangeThreatSectionState(val){
        // uThreatSectionManager.state =val
    }

    background: Item{

        anchors.fill: parent

        Rectangle{
            anchors.fill: parent
            color: mApplicationTheme.main
            z:0
        }

        LinearGradient {
            z:1
            anchors.fill: parent
            start:  Qt.point(width, 0)
            end: Qt.point(0, height )
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#4B4B4B" }
                GradientStop { position: 1.0; color: "#2C2C2C" }
            }
        }

        // LinearGradient {
        //     id:uThreatGradient
        //     z:2
        //     visible: m_Item.state === "NoThreat" | "AfterThreat" ? false :true
        //     anchors.fill: parent
        //     start:   Qt.point(width/2, 0)
        //     end:  Qt.point(width/2, height-(height-899))
        //     gradient: Gradient {
        //         GradientStop { position: 0.0; color: "#993D47" }
        //         GradientStop { position: 1.0; color: "#00993D47"}
        //     }
        // }
    }

    Loader {
        id: uDialog_Loader
        onLoaded:{
            if (item) {
                item.visible = true // Popups don't need open(), just set visible
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 24

        RowLayout{
            id: uSerialConnection_RowLayout
            spacing: 24
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 120

            Pane{
                id: uAction_Pane
                // Layout.fillWidth: true
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
                    IconButton{
                        id: uLogout_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Exit_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        onClicked: {
                            mStackView.pop()
                        }
                        enabled: false
                    }

                    IconButton{
                        id: uSetting_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Settings_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        onClicked: {

                            uDialog_Loader.setSource("../../Components/CustomDialog.qml", {
                                                         "_currentState": "Setting",
                                                         "mApplicationTheme": m_Item.mApplicationTheme,
                                                         "mAppManager": m_Item.mAppManager
                                                     })

                        }
                        enabled: false
                    }

                    IconButton{
                        id: uReport_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Logs_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        enabled: false
                    }

                    IconButton{
                        id: uExport_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _icon: "Export_Icon_F_E"
                        _Pathbackward: 3
                        _ButtonSize: 90
                        _IconSize: 45
                        enabled: false
                    }
                }
            }

            Pane{
                id: uConnection_Pane
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

                    IconButton{
                        id: uReset_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _Pathbackward: 3
                        _icon: "Reset_Icon_F_E"
                        _ButtonSize : 90
                        _IconSize: 45
                        onClicked: {
                            uCOMConnections_CustomComboBox._Model
                                    = serialMgr.availablePorts()
                        }

                    }

                    CustomComboBox{
                        id: uCOMConnections_CustomComboBox
                        _TitleText: "COM"
                        mApplicationTheme: m_Item.mApplicationTheme
                        _Model: serialMgr.availablePorts()

                        function findIndex(text) {
                            for (var i = 0; i < _Model.length; i++) {
                                if (_Model[i] === text) {
                                    return i
                                }
                            }
                            return -1
                        }

                        onActivated_: {
                            serialMgr.portName = currentText
                        }
                        Component.onCompleted: {
                            if (serialMgr.portName !== "") {
                                var idx = findIndex(serialMgr.portName)
                                if (idx !== -1) {
                                    _CurrentInedx = idx
                                }
                            }
                        }
                    }



                    IconButton{
                        id: uTest_IconButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        _Pathbackward: 3
                        _icon: _isConnected ? "Connected_Icon_F_E" : "Disonnected_Icon_F_E"
                        _ButtonSize : 90
                        _IconSize: 45
                        onClicked: {

                            if (serialMgr.isConnected) {
                                serialMgr.closePort()
                                _isConnected = false
                            } else {
                                serialMgr.openPort()
                                _isConnected = true
                            }

                        }

                    }


                }
            }

            Pane{
                id: uUserLogedin_Pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                padding: 16
                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    border.width: 0
                    radius: 6
                }

                Label{
                    text: "FineTuning"
                    font: mApplicationTheme.font_En_2X_Large_Bold
                    color: mApplicationTheme.mainTint3
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }


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

                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: 200
                        enabled: false
                        spacing: 8

                        Item {

                            Label {
                                id: uTitle_Label
                                anchors.fill: parent
                                rightPadding: 8
                                text: "Support"
                                font: mApplicationTheme.font_En_Large_Regular
                                color: mApplicationTheme.mainTint4
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                            }

                            DropShadow {
                                id:uTitleLabel_DropShadow
                                anchors.fill: uTitle_Label
                                horizontalOffset: 0
                                verticalOffset: 0
                                radius: 10
                                samples: 21
                                color:  mApplicationTheme.white
                                source: uTitle_Label
                                visible: false
                            }
                        }

                        RowLayout{
                            spacing: 8
                            RadioButton{
                                checked: true
                                text: "Right"
                                Material.accent: mApplicationTheme.green
                                Material.foreground: mApplicationTheme.mainTint3
                                font: mApplicationTheme.font_En_Medium_Regular
                            }

                            RadioButton{
                                text: "Left"
                                Material.accent: mApplicationTheme.green
                                Material.foreground: mApplicationTheme.mainTint3
                                font: mApplicationTheme.font_En_Medium_Regular
                            }
                        }
                    }

                    RowLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 8
                        enabled: false
                        // rowSpacing: 8
                        // columnSpacing: 8
                        // columns: 3

                        CustomComboBox{
                            id: uServoType_CustomTextField
                            mApplicationTheme: m_Item.mApplicationTheme
                            Layout.minimumWidth: 180
                            _TitleText: "Servo Type"
                            _DefaultText : "Select Servo Type..."
                            _Model: ["DHS-110" , "DHS-75" ]
                            _CurrentInedx: 0
                        }

                        CustomTextField{
                            id: uSerialNumber_CustomTextField
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TitleText: "Serial Number"
                            _hasClearButton:true
                            _TextfieldText: "N/A"
                        }


                        CustomTextField{
                            id: uP3_CustomTextField
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TitleText: "P3"
                            _isNumberOnly: true
                            _TextfieldText: "N/A"

                        }

                        CustomTextField{
                            id: uP4_CustomTextField
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TitleText: "P4"
                            _isNumberOnly: true
                            _TextfieldText: "N/A"

                        }

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
                            Label{
                                text: "<b>Maximum Error:</b> " + maximumError
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

                Pane{
                    id: uUserAction_Pane
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: 90
                    background: Rectangle {
                        anchors.fill: parent
                        color: mApplicationTheme.mainShade
                        border.width: 0
                        radius: 6
                    }
                    RowLayout{
                        anchors.fill: parent
                        spacing: 16
                        CustomButton{
                            text: "Reject"
                            _ButtonStyle: CustomButton.ButtonStyle.Red
                            mApplicationTheme: m_Item.mApplicationTheme
                            enabled: false
                        }

                        CustomButton{
                            text: "Accept"
                            _ButtonStyle: CustomButton.ButtonStyle.GreenShade
                            mApplicationTheme: m_Item.mApplicationTheme
                            enabled: false

                        }
                    }
                }

                Pane{
                    id: uSystemLog_Pane
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 16
                    Layout.maximumHeight: 350
                    Layout.minimumHeight: 350
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




    NotificationPopup{
        id:uCameraProblemErrorHint_Popup
        mApplicationTheme:m_Item.mApplicationTheme
        _labelText:"در نحوه‌ی عملکرد «دوربین‌ها» مشکلی وجود دارد."
        _textColor:mApplicationTheme.mainTint4
        _backgroundColor:mApplicationTheme.redShade2
        _iconColor:mApplicationTheme.mainTint4
        _hasCloseButton:true
        _iconButtonType:IconButton.ButtonStyle.RedShade2
    }

    NotificationPopup{
        id:uConnectDeviceErrorHint_Popup
        mApplicationTheme:m_Item.mApplicationTheme
        _labelText:"در نحوه‌ی عملکرد «موتور» مشکلی وجود دارد."
        _textColor:mApplicationTheme.mainTint4
        _backgroundColor:mApplicationTheme.redShade2
        _iconColor:mApplicationTheme.mainTint4
        _hasCloseButton:true
        _iconButtonType:IconButton.ButtonStyle.RedShade2

    }
}
