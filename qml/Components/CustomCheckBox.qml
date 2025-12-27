import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"
Item {
    property ApplicationTheme mApplicationTheme: m_Item.mApplicationTheme


    property string _text

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.maximumHeight: 26
    Layout.minimumHeight: 26
    RowLayout {
        anchors.fill: parent
        layoutDirection: Qt.RightToLeft  // راست به چپ برای پشتیبانی از فارسی

        CheckBox {
            id: checkbox
            // Layout.alignment: Qt.AlignRight
            Material.accent: mApplicationTheme.green
            Material.roundedScale : Material.NotRounded
            HoverHandler {
                id: mouse
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape: Qt.PointingHandCursor
            }
        }

        Text {
            text: _text
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            color: mApplicationTheme.mainTint3
            font: mApplicationTheme.font_En_Medium_Regular
            elide: Text.ElideRight

        }

        HoverHandler {
            id: mouse1
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            cursorShape: Qt.PointingHandCursor
        }
    }
    // اضافه کردن MouseArea برای کلیک روی کل آیتم
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // تغییر وضعیت چک‌باکس با کلیک روی هر قسمت آیتم
            checkbox.checked = !checkbox.checked;
        }
    }
}
