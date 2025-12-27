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
    id:uSecurityQuestionBody_ColumnLayout

    property ApplicationTheme mApplicationTheme

    spacing: 12

    Layout.minimumHeight: uSequrityQuestion_Label.implicitHeight +12 +  uSecurityAnswerCheck_CustomTextField.implicitHeight


    Label{
        id:uSequrityQuestion_Label
        // Layout.fillWidth: true
        Layout.minimumHeight: 45
        Layout.maximumHeight: 45

        text: "نام غذایی که دوست ندارید؟"
        Layout.minimumWidth: 284
        Layout.maximumWidth: 284

        font: mApplicationTheme.font_En_Medium_Bold
        color:mApplicationTheme.mainTint4

    }

    CustomTextField{
        id:uSecurityAnswerCheck_CustomTextField
        Layout.fillWidth: true
        Layout.minimumHeight: 45
        Layout.maximumHeight: 45
        mApplicationTheme: uSecurityQuestionBody_ColumnLayout.mApplicationTheme

        _placeholderText:"این‌جا بنویسید..."
        Layout.minimumWidth: 284
        Layout.maximumWidth: 284
        onTextChanged: {
            if(uSecurityAnswerCheck_CustomTextField._TextfieldText.length>0)
            {
                uContinue_CustomButton.enabled=true
            }
            else
            {
                uContinue_CustomButton.enabled=false
            }
        }
    }
}
