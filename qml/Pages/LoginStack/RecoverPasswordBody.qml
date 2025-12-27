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
    id:uRecoverPasswordBody_ColumnLayout

    property ApplicationTheme mApplicationTheme

    spacing: 12

    Layout.minimumHeight: uSetNewPassword_CustomTextField.implicitHeight +12 +  uSetRepeatPassword_CustomTextField.implicitHeight

    CustomTextField{
        id:uSetNewPassword_CustomTextField
        Layout.fillWidth: true
        Layout.minimumHeight: 45
        Layout.maximumHeight: 45
        mApplicationTheme: uRecoverPasswordBody_ColumnLayout.mApplicationTheme
        _echoMode:TextInput.Password
        _TitleText:"رمز عبور"
        _titleIcon:"Left_Arrow_Icon_F_E"
        // Layout.minimumWidth: 284
        // Layout.maximumWidth: 284
        onTextChanged: {
            uSetNewPassword_CustomTextField.state="Normal"
            uSetRepeatPassword_CustomTextField.state="Normal"
            if(uSetNewPassword_CustomTextField._TextfieldText.length >0 && uSetRepeatPassword_CustomTextField._TextfieldText.length >0)
            {
                uSave_CustomButton.enabled=true
            }
            else
            {
                uSave_CustomButton.enabled=false
            }
        }
    }

    CustomTextField{
        id:uSetRepeatPassword_CustomTextField
        Layout.fillWidth: true
        Layout.minimumHeight: 45
        Layout.maximumHeight: 45
        mApplicationTheme: uRecoverPasswordBody_ColumnLayout.mApplicationTheme
        _echoMode:TextInput.Password
        _TitleText:"تأیید رمز عبور"
        _titleIcon:"Left_Arrow_Icon_F_E"
        // Layout.minimumWidth: 284
        // Layout.maximumWidth: 284
        onTextChanged: {
            uSetNewPassword_CustomTextField.state="Normal"
            uSetRepeatPassword_CustomTextField.state="Normal"
            if(uSetNewPassword_CustomTextField._TextfieldText.length >0 && uSetRepeatPassword_CustomTextField._TextfieldText.length >0)
            {
                uSave_CustomButton.enabled=true
            }
            else
            {
                uSave_CustomButton.enabled=false
            }
        }
    }

}
