import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import AppManager 1.0

import "../"
import"../Components"
import "../Pages/LoginStack"

Page {
    id:uLogin_Pane
    leftPadding: 275

    property StackView mStackView
    property ApplicationTheme mApplicationTheme
    property AppManager mAppManager
    property int result

    background: Image {
        id: uLoginBackground_Image
        anchors.fill: parent
        source: "qrc:/Resources/Images/Login_Page_Background.png"
        fillMode: Image.PreserveAspectCrop
    }

    enum LoginStates
    {
        FirstLogin,
        ChangePassword,
        Login,
        NormalLogin,
        SecurityQuestion,
        RecoverPassword
    }



    Component.onCompleted: {



        // if(mAppManager.isUserPasswordDefault)
        // {
        //     state=Login.LoginStates.FirstLogin
        //     setErrorHintText("اطلاعات موقتِ ورود را وارد کنید.",mApplicationTheme.greenTint2,mApplicationTheme.greenShade)
        // }
        // else{
        //     state=Login.LoginStates.Login
        //     setErrorHintText("با اطلاعات جدید وارد شوید.",mApplicationTheme.greenTint2,mApplicationTheme.greenShade)
        // }

    }



    function setErrorHintText(text , textColor,backgroundColor,borderColor){
        uErrorHint_Label.text = text
        uErrorHint_Label.color = textColor
        uErrorHintBackground.color=backgroundColor
        uErrorHintBackground.border.color = borderColor
        uErrorHint_Label.visible = uErrorHint_Label.text !== ""
    }

    state: Login.LoginStates.FirstLogin
    states: [
        State {name: Login.LoginStates.FirstLogin ;
            PropertyChanges {target: uLogin_Pane ; }
            PropertyChanges {target: uErrorHint_Pane ; Layout.minimumWidth:332;}
            PropertyChanges {target: uLoginButtonsManager ; state:Login.LoginStates.FirstLogin;}



        },
        State {name: Login.LoginStates.ChangePassword ;
            PropertyChanges {target: uLogin_Pane ; }
            PropertyChanges {target: uLoginButtonsManager ; state:Login.LoginStates.ChangePassword;}




        },
        State {name: Login.LoginStates.Login ;

            PropertyChanges {target: uLogin_Pane ;}
            PropertyChanges {target: uErrorHint_Pane ; Layout.minimumWidth:332;}
            PropertyChanges {target: uLoginButtonsManager ; state:Login.LoginStates.Login;}


        },
        State {name: Login.LoginStates.NormalLogin ;

            PropertyChanges {target: uLogin_Pane ;}
            PropertyChanges {target: uErrorHint_Pane ; Layout.minimumWidth:332;}
            PropertyChanges {target: uLoginButtonsManager ; state:Login.LoginStates.NormalLogin;}


        },
        State {name: Login.LoginStates.SecurityQuestion ;

            PropertyChanges {target: uLogin_Pane ; }
            PropertyChanges {target: uLoginButtonsManager ; state:Login.LoginStates.SecurityQuestion;}


        },
        State {name: Login.LoginStates.RecoverPassword ;
            PropertyChanges {target: uLogin_Pane ; }
            PropertyChanges {target: uErrorHint_Pane ; Layout.maximumWidth:332;}
            PropertyChanges {target: uLoginButtonsManager ; state:Login.LoginStates.RecoverPassword;}

        }
    ]

    onStateChanged: {
        switch(state){
        case '0' /*Login.LoginStates.FirstLogin*/:
            // setErrorHintText("اطلاعات موقتِ ورود را وارد کنید.",mApplicationTheme.greenTint2,mApplicationTheme.darkGreen,mApplicationTheme.greenShade)
            uLoginBody_StackView.replace("LoginStack/LoginBody.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme , "isFirstLogin":true})
            break;
        case '1' :
            setErrorHintText("رمز ورود را تغییر دهید. سؤال امنیتی را تعیین کنید، جواب مناسبی برای آن انتخاب کنید و همه‌ی این اطلاعات را خوب به‌ خاطر بسپارید.",
                             mApplicationTheme.yelloTint2,mApplicationTheme.darkYellow,mApplicationTheme.yellowShade1)
            uLoginBody_StackView.replace("LoginStack/ChangePasswordBody.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme})
            //uLoginPanel_Pane.height=892
            break;
        case '2':
            setErrorHintText("با اطلاعات جدید وارد شوید.",mApplicationTheme.greenTint2,mApplicationTheme.darkGreen,mApplicationTheme.greenShade)
            uLoginBody_StackView.replace("LoginStack/LoginBody.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme , "isFirstLogin":false})
            break;
        case '3':
            uLoginBody_StackView.replace("LoginStack/LoginBody.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme , "isFirstLogin":false})
            setErrorHintText("", "transparent","transparent","transparent")
            break;
        case '4':
            setErrorHintText("به سؤال امنیتی جواب دهید تا امکان بازیابی رمز عبور برای شما فراهم شود.",
                             mApplicationTheme.yelloTint2,mApplicationTheme.darkYellow,mApplicationTheme.yellowShade1)
            uLoginBody_StackView.replace("LoginStack/SecurityQuestionBody.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme})
            break;
        case '5':
            setErrorHintText("رمز جدید را تعیین کنید و در حفظ و به‌خاطرسپاری آن کوشا باشید.",
                             mApplicationTheme.yelloTint2,mApplicationTheme.darkYellow,mApplicationTheme.yellowShade1)
            uLoginBody_StackView.replace("LoginStack/RecoverPasswordBody.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme})
            break;
        default:
            console.log("Wrong State: " , state)
            break;
        }
    }

    Pane {
        id: uLoginPanel_Pane
        topPadding: 80
        leftPadding: 48
        rightPadding: 48
        bottomPadding: 48


        anchors{
            verticalCenter: parent.verticalCenter
        }

        background: Rectangle {
            anchors.fill: parent
            color: mApplicationTheme.mainShade
            radius: 6
        }

        ColumnLayout{
            id:uLogin_ColumnLayout
            // anchors.fill: parent
            spacing: 96

            ColumnLayout{
                id:uLogo_RowLayout
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Item {

                    Layout.maximumWidth: 300
                    Layout.minimumWidth: 300
                    Layout.minimumHeight:300
                    Layout.maximumHeight:300
Layout.fillHeight: true
Layout.fillWidth: true
                    Image {
                        id: uLogo_Icon
                        anchors.fill: parent
                        source: "../../Resources/Icons/ApplicationLogo.svg"
                        fillMode: Image.PreserveAspectFit
                        Layout.minimumHeight:600
                        Layout.maximumHeight:600
                        Layout.minimumWidth:600
                        Layout.maximumWidth:600
                        // mApplicationTheme: uLogin_Pane.mApplicationTheme
                        // _icon:"ApplicationLogo"
                        // _color:mApplicationTheme.mainTint4
                        // _size:100
                    }
                    DropShadow {
                        anchors.fill: uLogo_Icon
                        horizontalOffset: 0   // Center horizontally
                        verticalOffset: 0     // Center vertically
                        radius: 70
                        samples: 141
                        spread: 0
                        color:  mApplicationTheme.white_Op50
                        source: uLogo_Icon
                    }
                }

                Label {
                    id: uTitle_Label
                    rightPadding: 8
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "QC Application"
                    font: mApplicationTheme.font_En_Large_Regular
                    color: mApplicationTheme.mainTint4
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ColumnLayout{
                id:uBody_ColumnLayout
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 36

                Pane{
                    id: uErrorHint_Pane
                    topPadding: 12
                    bottomPadding: 12
                    leftPadding: 16
                    rightPadding: 16

                    //     Layout.fillWidth: true
                    //     Layout.minimumHeight: uErrorHint_Label.visible ? 55 : 0
                    Layout.maximumHeight: uErrorHint_Label.visible ? 88 : 0
                    Layout.maximumWidth: 604

                    background: Rectangle {
                        id: uErrorHintBackground
                        anchors.fill: parent
                        color: mApplicationTheme.main
                        border.width: 1
                        radius: 6
                    }

                    Label {
                        id: uErrorHint_Label
                        font: mApplicationTheme.font_En_Small_Bold
                        color: mApplicationTheme.red
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                        wrapMode: Text.WordWrap
                        visible: text !== ""
                    }
                }



                StackView{
                    id:uLoginBody_StackView

                    Layout.fillWidth: true

                    Layout.minimumHeight: currentItem ? currentItem.implicitHeight : 0


                    replaceEnter: Transition {
                        PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 500 }
                    }
                    replaceExit: Transition {
                        PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 500 }
                    }
                    pushEnter: Transition {
                        PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
                    }
                    pushExit: Transition {
                        PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 250 }
                    }
                    popEnter: Transition {
                        PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
                    }
                    popExit: Transition {
                        PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 250 }
                    }

                }

            }

            LoginButtonsManager{
                id:uLoginButtonsManager
                mApplicationTheme: uLogin_Pane.mApplicationTheme
                mAppManager: uLogin_Pane.mAppManager
                mStackView: uLogin_Pane.mStackView
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

        }
    }

    NotificationPopup{
        id:uErrorHint_Popup
        mApplicationTheme:uLogin_Pane.mApplicationTheme
        _labelText:"لطفاً اطلاعات را به‌درستی وارد کنید."
        _textColor:mApplicationTheme.mainTint4
        _backgroundColor:mApplicationTheme.redShade2
        _iconColor:mApplicationTheme.mainTint4
        _hasCloseButton:true
        _iconButtonType:IconButton.ButtonStyle.RedShade2

        //maybe need to change these 3
        width: uLogin_Pane.width
        x: 0 -uLogin_Pane.leftPadding
        y:uLogin_Pane.height - height-uLogin_Pane.topPadding
    }


}
