import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects

import "../"

RowLayout{
    id:m_Item


    property ApplicationTheme mApplicationTheme
    property StackView mStackView
    property int _itemsPerPage: 6
    property int currentPage: 1
    property real totalItems: 64 // example, bind this to your actual card count
    property int pageCount: Math.max(1, Math.ceil(totalItems / _itemsPerPage))
    property bool previousEnabled: currentPage > 1
    property bool nextEnabled: currentPage < pageCount


    onCurrentPageChanged: {
        previousEnabled = currentPage > 1
        nextEnabled = currentPage < pageCount

    }


    spacing: 8
    Layout.maximumWidth:359
    // Layout.maximumWidth: uThreatLogPagingInfo_RowLayout.implicitWidth
    //                      + 8 + uActionButtons_RowLayout.implicitWidth
    Layout.fillHeight: true

    RowLayout {
        id: uThreatLogPagingInfo_RowLayout
        spacing: 12
        Layout.fillWidth: true
        Layout.fillHeight: true

        CustomTextField{
            id:uCurrentPage_CustomTextField


            mApplicationTheme: m_Item.mApplicationTheme
            _TextfieldText: currentPage.toString()
            _isBGLight: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 125
            Layout.maximumWidth: 125
            Layout.maximumHeight: 45
            _textAlignment:CustomTextField.TextAlignment.Center
            _hasClearButton:false
            _isOnlyNaturalNumbers:true
            _maxNumber:pageCount


            onTextChanged: {
                if (_maxNumber !== -1) {
                    var numericValue = parseInt(mApplicationTheme.toEnglishNumber(_TextfieldText),10)
                    if (numericValue > _maxNumber) {
                        _TextfieldText = mApplicationTheme.toPersianNumber(_maxNumber.toString()); // Limit input to maxNumber
                    }
                }
                _TextfieldText= mApplicationTheme.toPersianNumber(_TextfieldText)
                currentPage = parseInt(mApplicationTheme.toEnglishNumber(_TextfieldText),10)
            }

        }


        Label{
            id:uPageCount_Label

            text:"/ " + mApplicationTheme.toPersianNumber(pageCount.toString())
            font: mApplicationTheme.font_En_Medium_Regular
            color: mApplicationTheme.mainTint4
            Layout.fillWidth: true
            //Layout.fillHeight: true
            Layout.minimumWidth: 112
            Layout.maximumWidth: 112
            Layout.alignment: Qt.AlignVCenter

            horizontalAlignment: Text.AlignLeft

        }


    }


    RowLayout{
        id:uActionButtons_RowLayout
        spacing: 12
        Layout.fillHeight: true
        //Layout.fillWidth: true


        IconButton{
            id:uPrevious_IconButton
            mApplicationTheme: m_Item.mApplicationTheme
            _icon:"Left_Arrow_Icon_F_E"
            _color:mApplicationTheme.mainTint4
            _ButtonStyle:IconButton.ButtonStyle.Main
            _IconSize:36
            _ButtonSize:45

            enabled: previousEnabled
            onClicked:{

                currentPage = Math.max(1, currentPage - 1)
                uCurrentPage_CustomTextField._TextfieldText = mApplicationTheme.toPersianNumber(currentPage.toString())
            }
        }

        IconButton{
            id:uNext_IconButton
            mApplicationTheme: m_Item.mApplicationTheme
            _icon:"Right_Arrow_Icon_F_E"
            _color:mApplicationTheme.mainTint4
            _ButtonStyle:IconButton.ButtonStyle.Main
            _IconSize:36
            _ButtonSize:45

            enabled: nextEnabled
            onClicked:{
                currentPage = Math.min(pageCount, currentPage + 1)
                uCurrentPage_CustomTextField._TextfieldText = mApplicationTheme.toPersianNumber(currentPage.toString())
            }
        }
    }

}
