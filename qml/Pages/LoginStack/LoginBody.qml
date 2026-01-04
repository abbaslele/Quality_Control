import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"
import "../../"
import"../../Components"
import "../../Pages/LoginStack"



ColumnLayout{
    id:uLoginBody_ColumnLayout

    property bool isFirstLogin: false
    property ApplicationTheme mApplicationTheme

    spacing: 12
    // Layout.minimumHeight: uUserName_CustomTextField.implicitHeight +12+ uPassword_CustomTextField.implicitHeight +12+
    //                                  uRecoverPassword_Label.visible ? uRecoverPassword_Label.implicitHeight  :0  -12
    height: uUserName_CustomTextField.implicitHeight +12+ uPassword_CustomTextField.implicitHeight +12+
            uRecoverPassword_Label.visible ? uRecoverPassword_Label.implicitHeight  :0  -12

    CustomTextField{
        id:uUserName_CustomTextField
        Layout.fillWidth: true
        Layout.minimumHeight: 45
        mApplicationTheme: uLoginBody_ColumnLayout.mApplicationTheme
        _titleIcon:"Right_Arrow_Icon_F_E"

        _TitleText:"Username"
        Component.onCompleted: {
            _TextfieldText="Admin"
        }

        onClearButtonClicked: {
            console.log("username clearbutton clicked")
            LoginButtonsManager._isEnterButtonEnabled =false/* .uEnter_CustomButton.enabled=false*/
            LoginButtonsManager.setSaveButtonEnabled(false)
        }

        onTextChanged: {
            uUserName_CustomTextField.state="Normal"
            uPassword_CustomTextField.state="Normal"
            if(uUserName_CustomTextField && uUserName_CustomTextField._TextfieldText.length >0 && uPassword_CustomTextField && uPassword_CustomTextField._TextfieldText.length>0)
            {
                //m_Item.uEnter_CustomButton.enabled=true
            }
            else
            {
                //m_Item.uEnter_CustomButton.enabled=false
            }
        }

    }

    CustomTextField{
        id:uPassword_CustomTextField
        Layout.fillWidth: true
        Layout.minimumHeight: 45
        mApplicationTheme: uLoginBody_ColumnLayout.mApplicationTheme
        _echoMode:TextInput.Password
        _titleIcon:"Right_Arrow_Icon_F_E"
        _TitleText:"Password"
        Component.onCompleted: {
            _TextfieldText="Admin"
        }

        onClearButtonClicked: {
            //m_Item.uEnter_CustomButton.enabled=false
        }

        onTextChanged: {
            uUserName_CustomTextField.state="Normal"
            uPassword_CustomTextField.state="Normal"
            if(uUserName_CustomTextField && uUserName_CustomTextField._TextfieldText.length >0 && uPassword_CustomTextField && uPassword_CustomTextField._TextfieldText.length>0)
            {
                //m_Item.uEnter_CustomButton.enabled=true
            }
            else
            {
                //m_Item.uEnter_CustomButton.enabled=false
            }
        }
    }

    CustomComboBox{
        _TitleText : 'Mode'
        mApplicationTheme: uLoginBody_ColumnLayout.mApplicationTheme
        _Model: ['FineTuning' , 'Backlash Test']
        onComboBoxCurrentIndexChanged: {

            uLogin_Pane.state = _CurrentInedx
            console.log(_CurrentInedx)
        }
    }

    Label {
        id: uRecoverPassword_Label
        Layout.fillWidth: true
        text: "بازیابی رمز عبور"
        font: mApplicationTheme.font_En_2X_Small_Bold
        color: mApplicationTheme.mainTint2
        horizontalAlignment: Text.AlignRight
        visible: isFirstLogin ? false : true

        MouseArea {
            anchors.fill: parent
            onClicked: uLogin_Pane.state = Login.LoginStates.RecoverPassword
            HoverHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape:  Qt.PointingHandCursor
                onHoveredChanged: uRecoverPassword_Label.font.underline =  hovered
            }
        }
    }
}

