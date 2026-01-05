import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"

Dialog {
    id: m_Item

    property ApplicationTheme mApplicationTheme: m_Item.mApplicationTheme
    property string _currentState: "AddDevice"
    property string _name: ""
    property string _ip: ""
    property int dialogWidth: 328
    property int dialogHeight: 496
    property string headerTitle: ""
    property string uHeader_IconSource: ""
    property var uHeader_IconColor
    property var _deviceNameList: []
    property string uYes_CustomButtonText: ""
    property string uNo_CustomButtonText: ""
    property bool showSettingContent_ColumnLayout: true
    property bool showRemoveContent: false
    property bool isNameValid: true
    property bool isIpValid: false
    property string _logsHeaderIcon: "Logs_Icon_F_E"

    anchors.centerIn: parent
    padding: 0
    topPadding: 0
    topMargin: 0
    bottomPadding: 48

    // Required for anchor positioning to work:
    parent: Overlay.overlay

    width: 328
    height: 496

    // function isValidIp(input) {
    //     var pattern = /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)){3}$/;
    //     var result = pattern.test(input);
    //     return result;
    // }

    function yesButton() {
        if(_currentState === "Setting") {
            appController.saveSettings()
            console.log("Saved")
            m_Item.close()
        }
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
    }


    function updateState() {
        switch(_currentState) {
        case "Setting":
            headerTitle = "Setting"
            uHeader_IconSource = "Settings_Icon_F_E"
            uHeader_IconColor = mApplicationTheme.mainTint3
            dialogWidth = 700
            dialogHeight = 600
            showSettingContent_ColumnLayout = true
            uYes_CustomButtonText = "Save"
            uNo_CustomButtonText = "Cancel"
            break;

        }
        // Apply size changes
        width = dialogWidth
        height = dialogHeight
    }

    Component.onCompleted: {
        updateState()
    }

    ColumnLayout {
        id: uMain_ColumnLayout
        anchors.fill: parent
        spacing: 48

        // Header Section
        Pane {
            id: uHeaderPart_Pane
            topPadding: 12
            bottomPadding: 12
            leftPadding: 16
            rightPadding: 16
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            Layout.maximumHeight: 64

            background: Rectangle {
                color: mApplicationTheme.mainShade
                radius: 0 // Explicitly disable rounding
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Icon {
                    id: uHeader_Icon
                    mApplicationTheme: m_Item.mApplicationTheme
                    _size: 40
                    _color: uHeader_IconColor
                    _icon: uHeader_IconSource
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                }

                Label {
                    id: uHeaderText_Label
                    padding: 0
                    Layout.fillWidth: true
                    color: m_Item.mApplicationTheme.mainTint3
                    font: m_Item.mApplicationTheme.font_En_3X_Large_Regular
                    text: headerTitle
                }

                IconButton {
                    id: uCloseButton_IconButton
                    mApplicationTheme: m_Item.mApplicationTheme
                    _icon: "Close_Icon_O_E"
                    _IconSize: 40
                    _ButtonSize: 48
                    _ButtonStyle : IconButton.ButtonStyle.Main
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    onClicked: {
                        m_Item.close()
                    }
                }
            }
        }

        // Body Section
        ColumnLayout {
            id: uBodyPart_ColumnLayout
            spacing: 24
            Layout.rightMargin: 24
            Layout.leftMargin: 24
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Add/Edit Content
            ColumnLayout {
                id: uSettingBodyPart_ColumnLayout
                spacing: 24
                visible: showSettingContent_ColumnLayout
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: uSetting_ColumnLayout
                    spacing: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    LayoutMirroring.enabled: true
                    LayoutMirroring.childrenInherit: true
                    GridLayout{
                        rowSpacing: 8
                        columnSpacing: 8
                        columns: 2

                        RadioButton{
                            enabled: false
                            text: "Rotational"
                            Material.accent: mApplicationTheme.green
                            Material.foreground: mApplicationTheme.mainTint3
                            font: mApplicationTheme.font_En_Medium_Regular
                        }

                        RadioButton{
                            text: "Sectoral"
                            checked: true
                            Material.accent: mApplicationTheme.green
                            Material.foreground: mApplicationTheme.mainTint3
                            font: mApplicationTheme.font_En_Medium_Regular
                        }

                        CustomSpinBox{
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TextLabel : "End Pulse"
                            _From: 500
                            _To: 2300
                            _Value: appController.endPulse
                            onValueChanged: appController.endPulse = _Value
                        }

                        CustomSpinBox{
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TextLabel : "Start Pulse"
                            _From: 500
                            _To: 2300
                            _Value: appController.startPulse
                            onValueChanged: appController.startPulse = _Value
                        }

                        CustomSpinBox{
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TextLabel : "End Angle"
                            _From: -180
                            _To: 180
                            _Value: appController.endAngle
                            onValueChanged: appController.endAngle = _Value
                        }

                        CustomSpinBox{
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TextLabel : "Start Angle"
                            _From: -180
                            _To: 180
                            _Value: appController.startAngle
                            onValueChanged: appController.startAngle = _Value
                        }

                        CustomSpinBox{
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TextLabel : "Interval (ms)"
                            _From: 100
                            _To: 5000
                            _Stepsize: 100
                            _Value: sequencer.intervalMs
                            onValueChanged: sequencer.intervalMs = _Value
                        }

                        CustomSpinBox{
                            mApplicationTheme: m_Item.mApplicationTheme
                            _TextLabel : "Steps"
                            _From: 2
                            _To: 50
                            _Value: appController.steps
                            onValueChanged: appController.steps = _Value
                        }
                    }
                }

                Item{
                    Layout.fillHeight: true
                }

                RowLayout {
                    id: uActionButtons_RowLayout
                    spacing: 23
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.alignment: Qt.AlignBottom

                    CustomButton {
                        id: uNo_CustomButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        text: uNo_CustomButtonText
                        _ButtonStyle: CustomButton.ButtonStyle.MainTint1
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        Layout.maximumHeight: 40
                        onClicked: {
                            m_Item.close()
                        }
                    }

                    CustomButton {
                        id: uYes_CustomButton
                        mApplicationTheme: m_Item.mApplicationTheme
                        text: uYes_CustomButtonText
                        _ButtonStyle: CustomButton.ButtonStyle.GreenShade
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        Layout.maximumHeight: 40

                        onClicked: {
                            yesButton()
                        }
                    }
                }
            }



        }
    }
}
