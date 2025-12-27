import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

import "../"

ColumnLayout {
    id: root

    property ApplicationTheme mApplicationTheme
    property string _placeholderText: ""
    property int _echoMode: TextInput.Normal
    property alias _TextfieldText: _textField.text
    property string _titleIcon:""
    property string _TitleText: ""
    property bool _hasClearButton: true
    property string help_Text: ""
    property string previousText: ""
    property int margin: 40  // Safety margin to prevent overflow
    property var availableWidth
    property bool _isBGLight: true
    property bool _isDarkDropShadow: false
    property bool _isReadOnly: false
    property bool _isAngleTextField: false
    property string angleWord: " درجه"
    property string _angleNumber
    property string onlyNumbers: ""
    property bool _isLongitude: false
    property bool _isLatitude: false
    property bool _isOnlyNaturalNumbers: false
    property int _maxNumber:-1
    property bool _isNumberOnly: false
    property bool _allowDecimal: false
    property int  _intMin: -2147483648
    property int  _intMax: 2147483647

    enum TextAlignment{
        Right,
        Left,
        Center
    }

    property int _textAlignment : CustomTextField.TextAlignment.Right

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 96
    Layout.maximumHeight: 96
    Layout.minimumWidth: 150
    spacing: 8

    // RegularExpressionValidator {
    //     id: regexAngleValidator
    //      regularExpression: /^[\d\u06F0-\u06F9\u0660-\u0669]*$/
    // }
    IntValidator {
        id: intVal
        bottom: _intMin
        top: _intMax
    }

    DoubleValidator {
        id: dblVal
        bottom: -1e12
        top: 1e12
        decimals: 6
        notation: DoubleValidator.StandardNotation
    }

    signal clearButtonClicked()

    state: "Normal"

    states: [
        State {
            name: "Normal"
            PropertyChanges { target: rightBorder; visible:false; }
            PropertyChanges { target: _textField; color: mApplicationTheme.mainTint2  }
        },
        State {
            name: "Accepted"
            PropertyChanges { target: rightBorder; color: mApplicationTheme.greenShade ; visible:true; }
            PropertyChanges { target: _textField; color: mApplicationTheme.greenTint1  }
        },
        State {
            name: "Caution"
            PropertyChanges { target: rightBorder; color: mApplicationTheme.yellowShade1 ; visible:true; }
            PropertyChanges { target: _textField; color: mApplicationTheme.yellowTint1  }
        },
        State {
            name: "Danger"
            PropertyChanges { target: rightBorder; color: mApplicationTheme.redShade1 ; visible:true; }
            PropertyChanges { target: _textField; color: mApplicationTheme.redTint1 }

        }

    ]

    // Title Label
    RowLayout{
        id:uTitle_RowLayout
        spacing: 8
        Layout.fillHeight: visible ? true : false
        Layout.fillWidth: visible ? true : false
        visible: _TitleText !=="" ? true : false


        Item {
            width: visible ? 36 : 0
            height: visible ? 36 : 0
            Layout.alignment: Qt.AlignVCenter

            visible: _titleIcon !=="" ? true : false

            Icon {
                id: uTitle_Icon
                anchors.centerIn: parent
                mApplicationTheme: root.mApplicationTheme
                _icon: _titleIcon
                visible: _titleIcon !=="" ? true : false
                width: 36
                height: 36
                _color: mApplicationTheme.mainTint4
            }

            DropShadow {
                id:uTitleIcon_DropShadow
                anchors.fill: uTitle_Icon
                horizontalOffset: 0
                verticalOffset: 0
                radius: 10
                samples: 21
                color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                source: uTitle_Icon
                visible: false
            }
        }

        //Label container - takes remaining space
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                id: uTitle_Label
                anchors.fill: parent
                Layout.fillWidth: true

                rightPadding: 8
                text: _TitleText
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
                color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                source: uTitle_Label
                visible: false
            }
        }

    }

    Text {
        id: textMetrics
        visible: false
        font: _textField.font
    }

    Item {
        id: textFieldContainer
        Layout.fillWidth: true
        Layout.preferredHeight: 45
        Layout.minimumHeight: 40
        Layout.maximumHeight: 60

        TextField {
            id: _textField
            anchors.fill: parent

            horizontalAlignment: _textAlignment === CustomTextField.TextAlignment.Center ? TextInput.AlignHCenter: TextInput.AlignRight
            leftPadding: 16
            rightPadding: _hasClearButton && _textField.text.length > 0 ? (parent.height + 8) : 16
            Layout.minimumWidth: 80

            readOnly: _isReadOnly

            topPadding: 4
            bottomPadding: 4
            //verticalAlignment: TextInput.AlignVCenter

            selectByMouse: !_isReadOnly ?  true  : false
            mouseSelectionMode: TextInput.SelectCharacters
            persistentSelection: true


            //focus: true

            echoMode: _echoMode
            placeholderText: _placeholderText
            font: mApplicationTheme.font_En_Medium_Regular

            Material.roundedScale: Material.NotRounded
            Material.foreground: mApplicationTheme.mainTint2

            selectedTextColor: mApplicationTheme.main
            selectionColor: mApplicationTheme.mainTint2

            background: Rectangle {
                id: background
                anchors.fill: parent
                radius: 6
                color: _isBGLight ? mApplicationTheme.main : mApplicationTheme.mainShade

                Rectangle {
                    id: rightBorderNotRounded
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 2
                    width: 2
                    visible: rightBorder.visible
                    color: rightBorder.color
                }

                Rectangle {
                    id: rightBorder
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 4
                    visible: false
                    radius: 6
                }
            }

            RegularExpressionValidator {
                id: naturalNumbersRegExpValidator
                regularExpression: /^\+?[1-9][0-9]*$/
            }



            RegularExpressionValidator {
                id: decimalRegExpValidator
                regularExpression: /^-?\d*\.?\d*$/   // Regex for optional minus, digits, optional decimal, digits
            }

            validator: _isNumberOnly
                       ? (_allowDecimal ? dblVal : intVal)
                       : (_isLatitude || _isLongitude ? decimalRegExpValidator
                          : _isOnlyNaturalNumbers ? naturalNumbersRegExpValidator
                          : null)

            inputMethodHints: _isNumberOnly
                                  ? (_allowDecimal ? Qt.ImhFormattedNumbersOnly : Qt.ImhDigitsOnly)
                                  : Qt.ImhNone

            Component.onCompleted: {
                availableWidth = width - leftPadding - rightPadding - margin
            }

            //validator: _isAngleTextField ? regexAngleValidator : undefined


            onTextChanged: {
                // Don't validate if we're clearing the text (empty string)
                if (text === "") {
                    previousText = ""
                    return
                }

                // Update text alignment based on content
                if(_textAlignment !== CustomTextField.TextAlignment.Center){
                    horizontalAlignment = isPersianText(text) || text === "" ?
                                TextInput.AlignRight : TextInput.AlignLeft
                }
                if( text !== "" && isPersianText(text) )
                {
                    uClear_IconButton.anchors.right = undefined
                    uClear_IconButton.anchors.rightMargin= 0
                    uClear_IconButton.anchors.left= parent.left
                    uClear_IconButton.anchors.leftMargin= 4
                }
                else
                {
                    uClear_IconButton.anchors.left= undefined
                    uClear_IconButton.anchors.leftMargin= 0
                    uClear_IconButton.anchors.right= parent.right
                    uClear_IconButton.anchors.rightMargin= 4
                }

                // Emit custom signal
                root.textChanged()

                // Update metrics with current text
                textMetrics.text = text

                if(_echoMode === TextInput.Normal){
                    if (textMetrics.width > availableWidth) {
                        text = previousText
                    } else {
                        previousText = text
                    }
                }
                else if(_echoMode === TextInput.Password) {
                    if ((textMetrics.width/3) > availableWidth) {
                        text = previousText
                    } else {
                        previousText = text
                    }
                }
            }

            onAccepted: {
                _textField.focus = false
                // if (_isAngleTextField) {
                //            if (_textField.text === "") {
                //                _textField.text = mApplicationTheme.toPersianNumber("0")
                //            }
                //            _angleNumber = mApplicationTheme.toPersianNumber(_textField.text)

                //        }
                //        selectAll() // Ensure selection after accepting input


                var val = parseFloat(text)
                if ((_isLatitude && (val < -90 || val > 90)) ||
                        (_isLongitude && (val < -180 || val > 180))) {
                    _TextfieldText = ""
                } else {
                    root.accepted()
                }

                root.accepted()
            }

            hoverEnabled: true
            onHoveredChanged: {
                if (hovered) {
                    if(_titleIcon !==""){
                        uTitleIcon_DropShadow.visible = true
                    }
                    uTitleLabel_DropShadow.visible = true
                } else {
                    uTitleIcon_DropShadow.visible = false
                    uTitleLabel_DropShadow.visible = false
                }
            }

            onEditingFinished: {
                if(_isAngleTextField){

                    if(_textField.text===""){
                        _textField.text =mApplicationTheme.toPersianNumber("0")

                    }
                    var digitsOnly = _textField.text.replace(/[^\d\u06F0-\u06F9\u0660-\u0669]+/g, "")
                    onlyNumbers = digitsOnly
                    _angleNumber =mApplicationTheme.toPersianNumber(onlyNumbers)
                    if (_textField.text.indexOf(angleWord) === -1) {
                        _textField.text = _angleNumber + angleWord
                    }
                    // else{
                    //     _textField.text = _angleNumber
                    // }
                }
            }



            onActiveFocusChanged: {
                if(activeFocus){
                    if(!_isReadOnly){
                        if(_isAngleTextField){

                            _textField.text = _angleNumber
                        }
                        selectAll()
                    }
                }
            }

        }

        // Clear button positioned over the TextField
        IconButton {
            id: uClear_IconButton
            mApplicationTheme: root.mApplicationTheme
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 4
            width: parent.height - 8
            height: width
            padding: 0
            flat: true
            Material.roundedScale: Material.NotRounded
            Material.background: "transparent"
            visible: _textField.text.length > 0 && _hasClearButton && !_isReadOnly
            _icon: "Close_Icon_O_E"
            _color:mApplicationTheme.mainTint2
            _ButtonSize:32
            _ButtonStyle:_isBGLight ?  IconButton.ButtonStyle.Main  : IconButton.ButtonStyle.MainShade


            onClicked: {
                _textField.text = ""
                if(root.state ==="Danger")
                {
                    root.state = "Normal"
                }
                root.clearButtonClicked()
                if(!_isAngleTextField){
                    _textField.forceActiveFocus()
                }

                if(_isAngleTextField){
                    _angleNumber = mApplicationTheme.toPersianNumber("0")
                    if (_textField.text.indexOf(angleWord) === -1) {
                        _textField.text = _angleNumber + angleWord
                    }
                    // else{
                    //     _textField.text = _angleNumber
                    // }
                    _textField.focus = false

                }
            }
        }
    }




    // Help Text Label
    Label {
        id: helpLabel
        Layout.fillWidth: true
        text: help_Text
        font: mApplicationTheme.font_En_Small_Regular
        color: root.state === "Danger" ? mApplicationTheme.red :
                                         root.state === "Accepted" ? mApplicationTheme.green : mApplicationTheme.mainTint2
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
        visible: help_Text.length > 0
    }

    // Functions
    function isPersianText(text) {
        if (!text) return false;
        for (let i = 0; i < text.length; i++) {
            let charCode = text.charCodeAt(i);
            if (charCode === 32 || charCode < 32) continue;  // skip space/control

            // Check Persian/Arabic digit ranges (numbers)
            if ((charCode >= 0x0660 && charCode <= 0x0669) || // Arabic-Indic digits
                    (charCode >= 0x06F0 && charCode <= 0x06F9) || // Persian digits
                    (charCode >= 0x0030 && charCode <= 0x0039)) { // English digits
                return false; // contains digit - return false
            }

            // Check if character is Persian/Arabic letter
            if ((charCode >= 0x0600 && charCode <= 0x06FF) ||
                    (charCode >= 0xFB50 && charCode <= 0xFDFF) ||
                    (charCode >= 0xFE70 && charCode <= 0xFEFF)) {
                // Persian character found, continue checking others
                continue;
            } else {
                return false; // not Persian letter or digit -> false
            }
        }
        return true; // all characters Persian letters or spaces
    }


    function checkPasswordValidation(text) {
        const minLength = 8
        const hasLetter = /[a-zA-Z]/.test(text)
        const hasNumber = /[0-9]/.test(text)

        if (text.length >= minLength && hasLetter && hasNumber) {
            state = "Accepted"
            help_Text = ""
        } else if (text.length < 6) {
            state = "Danger"
            help_Text = "رمز ورود صحیح حداقل ۸ جزء دارد."
        } else {
            state = "Danger"
            help_Text = "رمز ورود مناسب حداقل ۸ جزء و ترکیبی از اعداد و حروف لاتین است."
        }
    }

    // Public API
    function clear() {
        _textField.clear()
    }

    function selectAll() {
        _textField.selectAll()
    }

    // function focus() {
    //     _textField.forceActiveFocus()
    // }

    // Signals
    signal textChanged()
    signal accepted()
    signal helpTextChange()
}
