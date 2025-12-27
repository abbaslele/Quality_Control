import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import AppManager 1.0

import "../"
import "../../"
import"../../Components"
import "../../Pages/LoginStack"



Pane{
    id:m_Item
    // Layout.fillHeight: true
    // Layout.fillWidth: true


    padding: 0

    property ApplicationTheme mApplicationTheme
    property AppManager mAppManager
    property StackView mStackView
    property bool _isEnterButtonEnabled: true


    Layout.minimumHeight:   uEnter_CustomButton.visible ? uEnter_CustomButton.implicitHeight +12 : 0 +
                            uSave_CustomButton.visible ? uSave_CustomButton.implicitHeight +12 : 0 +
                            uExit_CustomButton.visible ? uExit_CustomButton.implicitHeight +12 : 0 +
                             uContinue_CustomButton.visible ? uContinue_CustomButton.implicitHeight +12 : 0 +
                             uCancel_CustomButton.visible ? uCancel_CustomButton.implicitHeight   : 0 -12


    // Layout.preferredHeight:  uEnter_CustomButton.visible ? uEnter_CustomButton.implicitHeight +12 : 0 +
    //                                                        uSave_CustomButton.visible ? uSave_CustomButton.implicitHeight +12 : 0 +
    //                                                        uExit_CustomButton.visible ? uExit_CustomButton.implicitHeight +12 : 0 +
    //                                                         uContinue_CustomButton.visible ? uContinue_CustomButton.implicitHeight +12 : 0 +
    //                                                         uCancel_CustomButton.visible ? uCancel_CustomButton.implicitHeight : 0

    // Layout.maximumHeight: uEnter_CustomButton.visible ? uEnter_CustomButton.implicitHeight +12 : 0 +
    //                                                     uSave_CustomButton.visible ? uSave_CustomButton.implicitHeight +12 : 0 +
    //                                                     uExit_CustomButton.visible ? uExit_CustomButton.implicitHeight +12 : 0 +
    //                                                      uContinue_CustomButton.visible ? uContinue_CustomButton.implicitHeight +12 : 0 +
    //                                                      uCancel_CustomButton.visible ? uCancel_CustomButton.implicitHeight   : 0 -12

    background: Rectangle{
        anchors.fill: parent
        color: mApplicationTheme.transparent
    }

    function setSaveButtonEnabled(val) {
        uSave_CustomButton.enabled = val;
    }

    on_IsEnterButtonEnabledChanged: {
        if(_isEnterButtonEnabled){
            uEnter_CustomButton.enabled =true
        }
        else{
            console.log("inside enterbutton disabled")
            uEnter_CustomButton.enabled =false
        }
    }
    // enum LoginButtonsState{
    //     EnterButtonEnable,
    //     EnterButtonDisable,
    //     SaveButtonEnable,
    //     SaveButtonDisable,
    //     ContinueButtonEnable,
    //     ContinueButtonDisable
    // }

    state: Login.LoginStates.FirstLogin

    states: [
        State {name: Login.LoginStates.FirstLogin ;

            //actionButtons show/hide
            PropertyChanges {target: uEnter_CustomButton ; visible:true;}
            PropertyChanges {target: uSave_CustomButton ; visible:false;}
            PropertyChanges {target: uExit_CustomButton ; visible:true;}
            PropertyChanges {target: uContinue_CustomButton ; visible:false;}
            PropertyChanges {target: uCancel_CustomButton ; visible:false;}


        },
        State {name: Login.LoginStates.ChangePassword ;

            //actionButtons show/hide
            PropertyChanges {target: uEnter_CustomButton ; visible:false;}
            PropertyChanges {target: uSave_CustomButton ; visible:true;}
            PropertyChanges {target: uExit_CustomButton ; visible:true;}
            PropertyChanges {target: uContinue_CustomButton ; visible:false;}
            PropertyChanges {target: uCancel_CustomButton ; visible:false;}


        },
        State {name: Login.LoginStates.Login ;

            //actionButtons show/hide
            PropertyChanges {target: uEnter_CustomButton ; visible:true;}
            PropertyChanges {target: uSave_CustomButton ; visible:false;}
            PropertyChanges {target: uExit_CustomButton ; visible:true;}
            PropertyChanges {target: uContinue_CustomButton ; visible:false;}
            PropertyChanges {target: uCancel_CustomButton ; visible:false;}

        },
        State {name: Login.LoginStates.NormalLogin ;

            //actionButtons show/hide
            PropertyChanges {target: uEnter_CustomButton ; visible:true;}
            PropertyChanges {target: uSave_CustomButton ; visible:false;}
            PropertyChanges {target: uExit_CustomButton ; visible:true;}
            PropertyChanges {target: uContinue_CustomButton ; visible:false;}
            PropertyChanges {target: uCancel_CustomButton ; visible:false;}

        },
        State {name: Login.LoginStates.SecurityQuestion ;

            //actionButtons show/hide
            PropertyChanges {target: uEnter_CustomButton ; visible:false;}
            PropertyChanges {target: uSave_CustomButton ; visible:false;}
            PropertyChanges {target: uExit_CustomButton ; visible:false;}
            PropertyChanges {target: uContinue_CustomButton ; visible:true;}
            PropertyChanges {target: uCancel_CustomButton ; visible:true;}

        },
        State {name: Login.LoginStates.RecoverPassword ;

            //actionButtons show/hide
            PropertyChanges {target: uEnter_CustomButton ; visible:false;}
            PropertyChanges {target: uSave_CustomButton ; visible:true;}
            PropertyChanges {target: uExit_CustomButton ; visible:false;}
            PropertyChanges {target: uContinue_CustomButton ; visible:false;}
            PropertyChanges {target: uCancel_CustomButton ; visible:true;}
        }
    ]

    ColumnLayout{
        id:uMain_ColumnLayout



        anchors.fill: parent
        spacing:12

        CustomButton{
            id:uEnter_CustomButton

            Layout.fillWidth: true
            Layout.minimumHeight: 45
            Layout.maximumHeight: 45
            mApplicationTheme: m_Item.mApplicationTheme
            _ButtonStyle: CustomButton.ButtonStyle.Primary
            text: "Login"
            //enabled: false
            //enabled:_isEnterButtonEnabled

            onClicked: {
                //برای تست
                //uErrorHint_Popup.open()
                // uLogin_Pane.state=Login.LoginStates.ChangePassword
                //uPassword_CustomTextField.state="Danger"
                if(uLogin_Pane.state === '0'){
                    //uLogin_Pane.state=Login.LoginStates.ChangePassword

                    mStackView.push("../Backlash/Home.qml", {"mApplicationTheme": m_Item.mApplicationTheme, "mAppManager": m_Item.mAppManager, "mStackView": m_Item.mStackView})


                    //uLogin_Pane.state=Login.LoginStates.Login
                }
                else
                {
                    //Home اگر اطلاعات درست بود ورود به
                }

                // result =mAppManager.userLoginCheck(uUserName_CustomTextField._TextfieldText,uPassword_CustomTextField._TextfieldText)

                // switch (result){
                // case 1:
                //     // enter home
                //     break;
                // case 2:
                //     //change password
                //     break;
                // case 3:
                //     console.log("Wrong Info")
                //     showErrorPopup("لطفاً اطلاعات را به‌درستی وارد کنید.",mApplicationTheme.mainTint4,mApplicationTheme.redShade1,mApplicationTheme.mainTint4,
                //                    CustomButton.ButtonStyle.Secondary,CustomButton.ButtonStyle.Primary,true)
                //     break;
                // case -1:
                //     console.log("DB Error")
                //     break;
                // default:
                //     console.log("Wrong result")
                //     break;
                // }

            }
        }

        CustomButton{
            id:uExit_CustomButton



            Layout.fillWidth: true
            Layout.minimumHeight: 45
            Layout.maximumHeight: 45

            mApplicationTheme: m_Item.mApplicationTheme
            _ButtonStyle: CustomButton.ButtonStyle.Secondary
            text: "Exit"

            onClicked: {
                Qt.quit()
            }
        }

        CustomButton{
            id:uSave_CustomButton

            Layout.fillWidth: true
            Layout.minimumHeight: 45
            Layout.maximumHeight: 45

            mApplicationTheme: m_Item.mApplicationTheme
            _ButtonStyle: CustomButton.ButtonStyle.Primary
            text: "Save"
            enabled: false
            onClicked: {

                // ذخیره اطلاعات در دیتابیس در اینجا
                uLogin_Pane.state=Login.LoginStates.FirstLogin
            }
        }

        CustomButton{
            id:uContinue_CustomButton


            Layout.fillWidth: true
            Layout.minimumHeight: 45
            Layout.maximumHeight: 45

            mApplicationTheme: m_Item.mApplicationTheme
            _ButtonStyle: CustomButton.ButtonStyle.Primary
            text: "Continue"
            enabled: false
            onClicked: {
                // شرط درست بودن سوال امنیتی
                uLogin_Pane.state=Login.LoginStates.ChangePassword
            }
        }

        CustomButton{
            id:uCancel_CustomButton

            Layout.fillWidth: true
            Layout.minimumHeight: 45
            Layout.maximumHeight: 45

            mApplicationTheme: m_Item.mApplicationTheme
            _ButtonStyle: CustomButton.ButtonStyle.Secondary
            text: "Cancel"
            onClicked: {
                // شرط ورود کاربر در حالت اولین بار
                uLogin_Pane.state=Login.LoginStates.FirstLogin

                // در غیر اینصورت
                // uLogin_Pane.state=Login.LoginStates.Login
            }
        }
    }

}
