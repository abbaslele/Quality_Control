import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"
import"../Components"
import "../Pages/LoginStack"

Page {
    id:uLogin_Pane
    leftPadding: 275

    property StackView mStackView
    property ApplicationTheme mApplicationTheme
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



        },
        State {name: Login.LoginStates.ChangePassword ;
            PropertyChanges {target: uLogin_Pane ; }




        },
        State {name: Login.LoginStates.Login ;

            PropertyChanges {target: uLogin_Pane ;}
            PropertyChanges {target: uErrorHint_Pane ; Layout.minimumWidth:332;}


        },
        State {name: Login.LoginStates.NormalLogin ;

            PropertyChanges {target: uLogin_Pane ;}
            PropertyChanges {target: uErrorHint_Pane ; Layout.minimumWidth:332;}


        },
        State {name: Login.LoginStates.SecurityQuestion ;

            PropertyChanges {target: uLogin_Pane ; }


        },
        State {name: Login.LoginStates.RecoverPassword ;
            PropertyChanges {target: uLogin_Pane ; }
            PropertyChanges {target: uErrorHint_Pane ; Layout.maximumWidth:332;}

        }
    ]


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
            spacing: 36

            ColumnLayout{
                id:uLogo_RowLayout
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Item {

                    Layout.maximumWidth: 250
                    Layout.minimumWidth: 250
                    Layout.minimumHeight:250
                    Layout.maximumHeight:250
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

                CustomTextField{
                    id:uUserName_CustomTextField
                    Layout.fillWidth: true
                    Layout.minimumHeight: 45
                    mApplicationTheme: uLogin_Pane.mApplicationTheme
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
                    mApplicationTheme: uLogin_Pane.mApplicationTheme
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
                    mApplicationTheme: uLogin_Pane.mApplicationTheme
                    _Model: ['FineTuning' , 'Backlash Test']

                    on_CurrentInedxChanged: {
                        uLogin_Pane.state = _CurrentInedx
                    }
                }

            }


            ColumnLayout{
                id:uButton_ColumnLayout
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing:12

                CustomButton{
                    id:uEnter_CustomButton

                    Layout.fillWidth: true
                    Layout.minimumHeight: 45
                    Layout.maximumHeight: 45
                    mApplicationTheme: uLogin_Pane.mApplicationTheme
                    _ButtonStyle: CustomButton.ButtonStyle.Primary
                    text: "Login"
                    //enabled: false
                    //enabled:_isEnterButtonEnabled

                    onClicked: {
                        //برای تست
                        if(uLogin_Pane.state === '0'){

                            mStackView.push("Backlash/Home.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme,  "mStackView": uLogin_Pane.mStackView})

                        }
                        else
                        {
                            //Home اگر اطلاعات درست بود ورود به
                            mStackView.push("Backlash/Home.qml", {"mApplicationTheme": uLogin_Pane.mApplicationTheme,  "mStackView": uLogin_Pane.mStackView})


                        }


                    }
                }

                CustomButton{
                    id:uExit_CustomButton



                    Layout.fillWidth: true
                    Layout.minimumHeight: 45
                    Layout.maximumHeight: 45

                    mApplicationTheme: uLogin_Pane.mApplicationTheme
                    _ButtonStyle: CustomButton.ButtonStyle.Secondary
                    text: "Exit"

                    onClicked: {
                        Qt.quit()
                    }
                }
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
