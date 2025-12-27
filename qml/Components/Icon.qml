import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../"

Image {
    property ApplicationTheme mApplicationTheme : ApplicationTheme{}
    property string _icon : ""
    property string _color: mApplicationTheme.mainTint4


    property int _size: 30

    property int _Pathbackward : 2


    property string pathBack:{
        switch(_Pathbackward){
        case 3:
            return "../../../"
        default : {
            return "../../"
        }
        }
    }

    source: _icon === "" ? "" : pathBack + "Resources/Icons/"+ _icon +".svg"

    fillMode: Image.PreserveAspectFit

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.minimumHeight: _size
    Layout.maximumHeight: _size
    Layout.minimumWidth: _size
    Layout.maximumWidth: _size

    ColorOverlay{
        source: parent
        anchors.fill: parent
        color: _color
    }
}
