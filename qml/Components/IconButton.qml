import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"

Button {
    id: root
    property ApplicationTheme mApplicationTheme
    property string _icon : ""
    property int _Pathbackward : 2
    property int _ButtonSize: 48
    property int  _IconSize: 32
    property string _number :""
    property string _numberFont: mApplicationTheme.font_En_Large_Regular
    property bool _isNumberButton: false
    property color _color: mApplicationTheme.mainTint2
    property bool _isDarkDropShadow: false
    property bool  showIconDropShadow: false
    property bool  showNumberDropShadow: false

    property string pathBack:{
        switch(_Pathbackward){
        case 3:
            return "../../../"
        default : {
            return "../../"
        }
        }
    }


    enum ButtonStyle {
        Special,
        Main,
        MainShade,
        MainTint1,
        RedShade2,
        GreenShade,
        YellowShade2
    }

    property int _ButtonStyle: IconButton.ButtonStyle.Main

    property string mNormalBGColor: mApplicationTheme.main
    property string mBGOnStateColor: mApplicationTheme.mainTint1
    property string mIconOnStateColor: mApplicationTheme.mainTint1
    property string mEnableIconColor: mApplicationTheme.mainTint4
    property string mDisableIconColor: mApplicationTheme.mainTint2
    property string mPressedBGColor: mApplicationTheme.mainTint1
    property string mPressedIconColor: mApplicationTheme.mainTint4
    property string mInRangeBgColor: mApplicationTheme.mainShade



    Component.onCompleted: {

        if(_isNumberButton){
            uIcon_Image.visible=false
            uNumber_Text.visible=true
            showIconDropShadow=false
            showNumberDropShadow=true
        }
        else{
            uIcon_Image.visible=true
            uNumber_Text.visible=true
            showIconDropShadow=true
            showNumberDropShadow=false
        }

        switch(_ButtonStyle) {
        case IconButton.ButtonStyle.Special:
            mNormalBGColor = mApplicationTheme.mainTint1
            mDisableIconColor = mApplicationTheme.mainTint1
            mPressedBGColor = mApplicationTheme.mainTint2
            mPressedIconColor = mApplicationTheme.mainTint4
            mBGOnStateColor= mApplicationTheme.blue
            mIconOnStateColor =mApplicationTheme.mainTint4
            break

        case IconButton.ButtonStyle.Main:
            mNormalBGColor = mApplicationTheme.main
            mDisableIconColor = mApplicationTheme.mainTint1
            mPressedBGColor = mApplicationTheme.mainTint1
            mPressedIconColor = mApplicationTheme.mainTint4
            mBGOnStateColor= mApplicationTheme.mainTint3
            mIconOnStateColor =mApplicationTheme.mainTint0
            break
        case IconButton.ButtonStyle.MainShade:
            mNormalBGColor = mApplicationTheme.mainShade
            mDisableIconColor = mApplicationTheme.mainTint1
            mPressedBGColor = mApplicationTheme.main
            mPressedIconColor = mApplicationTheme.mainTint4
            mBGOnStateColor= mApplicationTheme.mainTint2
            mIconOnStateColor =mApplicationTheme.mainShade
            break
        case IconButton.ButtonStyle.MainTint1:
            mNormalBGColor = mApplicationTheme.mainTint1
            mDisableIconColor = mApplicationTheme.mainTint2
            mPressedBGColor = mApplicationTheme.mainTint2
            mPressedIconColor = mApplicationTheme.mainTint4
            mBGOnStateColor= mApplicationTheme.mainTint4
            mIconOnStateColor =mApplicationTheme.mainTint1
            break
        case IconButton.ButtonStyle.RedShade2:
            mNormalBGColor = mApplicationTheme.redShade2
            mDisableIconColor = mApplicationTheme.redShade1
            mPressedBGColor = mApplicationTheme.red
            mPressedIconColor = mApplicationTheme.redShade2
            mBGOnStateColor= mApplicationTheme.darkRed1
            mIconOnStateColor =mApplicationTheme.mainTint4
            break
        case IconButton.ButtonStyle.GreenShade:
            mNormalBGColor = mApplicationTheme.greenShade
            mDisableIconColor = mApplicationTheme.green
            mPressedBGColor = mApplicationTheme.greenTint1
            mPressedIconColor = mApplicationTheme.greenShade
            mBGOnStateColor= mApplicationTheme.darkGreen
            mIconOnStateColor =mApplicationTheme.mainTint4
            break
        case IconButton.ButtonStyle.YellowShade2:
            mNormalBGColor = mApplicationTheme.yellowShade2
            mDisableIconColor = mApplicationTheme.yellowShade1
            mPressedBGColor = mApplicationTheme.yellow
            mPressedIconColor = mApplicationTheme.yellowShade2
            mBGOnStateColor= mApplicationTheme.blue
            mIconOnStateColor =mApplicationTheme.darkYellow
            break

        }
    }


    state: "Normal"
    states:[
        State{
            name: "Pressed"
            PropertyChanges { target: background; color: mPressedBGColor }
            PropertyChanges { target: root; _color:mPressedIconColor }
            PropertyChanges { target: uIcon_DropShadow; visible:false }
            PropertyChanges { target: uNumber_DropShadow; visible:false }


        },
        State{
            name: "Normal"
            PropertyChanges { target: background; color:mNormalBGColor }
            PropertyChanges { target: root; _color:mEnableIconColor }
            PropertyChanges { target: uIcon_DropShadow; visible:false }
            PropertyChanges { target: uNumber_DropShadow; visible:false }

        },
        State{
            name: "Hover"
            PropertyChanges { target: background; color:mNormalBGColor }
            PropertyChanges { target: root; _color:mEnableIconColor }
            PropertyChanges { target: uIcon_DropShadow; visible:showIconDropShadow }
            PropertyChanges { target: uNumber_DropShadow; visible:showNumberDropShadow }

        },
        State{
            name: "Disable"
            PropertyChanges { target: background; color:mNormalBGColor }
            PropertyChanges { target: root; _color:mDisableIconColor }
            PropertyChanges { target: uIcon_DropShadow; visible:false }
            PropertyChanges { target: uNumber_DropShadow; visible:false }
        },
        State{
            name: "On"
            PropertyChanges { target: background; color:mBGOnStateColor }
            PropertyChanges { target: root; _color:mIconOnStateColor }
            PropertyChanges { target: uIcon_DropShadow; visible:showIconDropShadow }
            PropertyChanges { target: uNumber_DropShadow; visible:false }
        },
        State{
            name: "InRange"
            PropertyChanges { target: background; color:mInRangeBgColor }
            PropertyChanges { target: root; _color:mEnableIconColor }
            PropertyChanges { target: uIcon_DropShadow; visible:showIconDropShadow }
            PropertyChanges { target: uNumber_DropShadow; visible:false }
        }
    ]

    // onStateChanged: {
    //     if(state === "On"){
    //         console.log("number ", _number , " is On")
    //     }
    // }
    background: Rectangle {
        id : background
        // anchors.fill: parent
        radius: 6

    }

    property bool isRTL : true

    property string buttonText_Tooltip
    ToolTip.text: buttonText_Tooltip
    ToolTip.visible: {
        if(buttonText_Tooltip !== ""){
            hovered
        }else{
            null
        }
    }

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    topInset: 0
    bottomInset: 0
    leftInset: 0
    rightInset: 0

    ToolTip.delay: 500
    ToolTip.timeout: 4000

    Layout.fillHeight: true
    Layout.fillWidth:  true

    Layout.minimumWidth: _ButtonSize
    Layout.maximumWidth: _ButtonSize
    Layout.maximumHeight: _ButtonSize
    Layout.minimumHeight: _ButtonSize

    width: _ButtonSize
    height: _ButtonSize
    Material.roundedScale : Material.NotRounded

    Material.elevation: mApplicationTheme.elevation


    // onPressed: state = state !== "Disable" ? "Pressed" : "Disable"
    // onReleased: state = state !== "Disable" ? "Normal" : "Disable"
    onEnabledChanged: state =  enabled ? "Normal" : "Disable"
    onPressed: state = state !== "Disable" ? (state === "On" ? "On" : "Pressed") : "Disable"
    onReleased: state = state !== "Disable" ? (state === "On" ? "On" : "Normal") : "Disable"
    onHoveredChanged: {
        if (enabled) {
            if (state === "On") {
                if(_isNumberButton){
                    hovered ? state = "Hover" : state = "On";
                }
                //state = "On"
            }
            else if(state === "InRane"){
                hovered ? state = "Hover" : state = "InRane";
            }
            else{
                hovered ? state = "Hover" : state = "Normal";
            }
        }
        else {
            state = "Disable";
        }
    }
    // When toggling/on logic elsewhere, set state="On".


    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: state != "Disable" ? Qt.PointingHandCursor : Qt.ForbiddenCursor

    }

    contentItem: Item {
        width: root._ButtonSize
        height: root._ButtonSize



        Image {
            id: uIcon_Image
            source: root._icon === "" ? "" : root.pathBack + "Resources/Icons/" + root._icon + ".svg"
            width: source !== "" ? root._IconSize : 0
            height: source !== "" ? root._IconSize : 0
            anchors.centerIn: parent
            visible: source !== ""

            ColorOverlay{
                source: parent
                anchors.fill: parent
                color: _color
            }
        }

        DropShadow {
            id:uIcon_DropShadow
            anchors.fill: uIcon_Image
            source: uIcon_Image
            horizontalOffset: 0
            verticalOffset: 0
            radius: 10
            samples: 21
            color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
            visible: false
        }

        Text{
            id: uNumber_Text
            // topPadding: 6
            // rightPadding: 6

            anchors.centerIn: parent

            text: _number
            color: _color
            font: _numberFont
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: false
        }

        DropShadow {
            id:uNumber_DropShadow
            anchors.fill: uNumber_Text
            source: uNumber_Text
            horizontalOffset: 0
            verticalOffset: 0
            radius: 10
            samples: 21
            color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
            visible: false
        }

    }

}
