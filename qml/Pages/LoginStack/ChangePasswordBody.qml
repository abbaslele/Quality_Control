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
    id:uChangePasswordBody_ColumnLayout

    property ApplicationTheme mApplicationTheme

    Layout.fillHeight: true
    Layout.fillWidth: true
    spacing: 12

    Layout.minimumHeight: uChangePasswordRow1_RowLayout.implicitHeight +12 +  uChangePasswordRow2_RowLayout.implicitHeight

    RowLayout{
        id:uChangePasswordRow1_RowLayout
        Layout.fillHeight: true
        Layout.fillWidth: true
        layoutDirection: "RightToLeft"
        spacing:36

        CustomTextField{
            id:uNewPassword_CustomTextField
            mApplicationTheme: uChangePasswordBody_ColumnLayout.mApplicationTheme
            _echoMode:TextInput.Password
            _TitleText:"رمز عبور"
            _titleIcon:"Left_Arrow_Icon_F_E"
            Layout.minimumWidth: 284

            onClearButtonClicked: {
                LoginButtonsManager.uSave_CustomButton.enabled=false
            }

            onTextChanged: {

                if(uNewPassword_CustomTextField._TextfieldText.length >0 && uSecurityQuestion_CustomComboBox.currentIndex !== -1 &&
                        uRepeatPassword_CustomTextField._TextfieldText.length>0 && uSecurityAnswer_CustomTextField._TextfieldText.length>0){
                    LoginButtonsManager.uSave_CustomButton.enabled=true
                }
                else{
                    LoginButtonsManager.uSave_CustomButton.enabled=false
                }
            }
        }

        CustomComboBox{
            id:uSecurityQuestion_CustomComboBox
            mApplicationTheme: uChangePasswordBody_ColumnLayout.mApplicationTheme
            Layout.minimumWidth: 284
            Layout.maximumWidth: 284
            _TitleText:"سؤال امنیتی"
            _Model: [
                                   "نام معلم دوره‌ی ابتدایی؟",
                                   "رنگ مورد علاقه؟",
                                   "نام صمیمی‌ترین دوست؟",
                                   "تعداد دوستان صمیمی؟",
                                   "حیوان مورد علاقه؟",
                                   "کلمه‌ای که برای شما معنای خاصی دارد؟",
                                   "ویژگی شخصیتی بارز شما؟",
                                   "نام غذایی که دوست ندارید؟",
                                   "وسیله‌ی نقلیه‌ای که ترجیح می‌دهید؟",
                                   "تفریح و سرگرمی معمول؟"
                               ]

            onComboBoxCurrentIndexChanged: {
                if(uNewPassword_CustomTextField._TextfieldText.length >0 && currentIndex !== -1 &&
                        uRepeatPassword_CustomTextField._TextfieldText.length>0 && uSecurityAnswer_CustomTextField._TextfieldText.length>0){
                    LoginButtonsManager.uSave_CustomButton.enabled=true
                }
                else{
                    LoginButtonsManager.uSave_CustomButton.enabled=false
                }
            }

        }
    }

    RowLayout{
        id:uChangePasswordRow2_RowLayout
        Layout.fillHeight: true
        Layout.fillWidth: true
        layoutDirection: "RightToLeft"
        spacing:36

        CustomTextField{
            id:uRepeatPassword_CustomTextField
            mApplicationTheme: uChangePasswordBody_ColumnLayout.mApplicationTheme
            _echoMode:TextInput.Password
            _TitleText:"تأیید رمز عبور"
            _titleIcon:"Left_Arrow_Icon_F_E"
            // Layout.minimumWidth: 284
            // Layout.maximumWidth: 284
            onClearButtonClicked: {
                LoginButtonsManager.uSave_CustomButton.enabled=false
            }
            onTextChanged: {
                if(uNewPassword_CustomTextField._TextfieldText.length >0 && uSecurityQuestion_CustomComboBox.currentIndex !== -1 &&
                        uRepeatPassword_CustomTextField._TextfieldText.length>0 && uSecurityAnswer_CustomTextField._TextfieldText.length>0){
                    LoginButtonsManager.uSave_CustomButton.enabled=true
                }
                else{
                    LoginButtonsManager.uSave_CustomButton.enabled=false
                }
            }
        }

        CustomTextField{
            id:uSecurityAnswer_CustomTextField
            mApplicationTheme: uChangePasswordBody_ColumnLayout.mApplicationTheme
            _TitleText:"پاسخ"
            _titleIcon:"Left_Arrow_Icon_F_E"
            // Layout.minimumWidth: 284
            // Layout.maximumWidth: 284

            onClearButtonClicked: {
                LoginButtonsManager.uSave_CustomButton.enabled=false
            }

            onTextChanged: {
                if(uNewPassword_CustomTextField._TextfieldText.length >0 && uSecurityQuestion_CustomComboBox.currentIndex !== -1 &&
                        uRepeatPassword_CustomTextField._TextfieldText.length>0 && uSecurityAnswer_CustomTextField._TextfieldText.length>0){
                    LoginButtonsManager.uSave_CustomButton.enabled=true
                }
                else{
                   LoginButtonsManager.uSave_CustomButton.enabled=false
                }
            }
        }
    }

}
