import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts

import "../"

ColumnLayout{
    property ApplicationTheme mApplicationTheme: m_Item.mApplicationTheme

    property bool _isBGLight: true
    property string _TextLabel : ""
    property int _Stepsize: 1
    property int _from: 1
    property int _to: 100000
    property bool _Editable: true

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 8
    Layout.maximumHeight: 96
    Layout.minimumWidth: 150

    Label{
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: _TextLabel
        Material.foreground: mApplicationTheme.mainTint3
        font:  mApplicationTheme.font_En_Medium_Regular
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    SpinBox {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: 80
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
        stepSize: _Stepsize
        from: _from
        to: _to
        font: mApplicationTheme.font_En_Small_Regular
        Material.foreground: mApplicationTheme.mainTint3
        Material.roundedScale : Material.FullScale
        editable: _Editable
    }



}
