import QtQuick3D
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import Qt5Compat.GraphicalEffects



import "../"
import "../../"
import "../Pages"

Item {
    id:m_Item



    property ApplicationTheme mApplicationTheme

    property  bool isMapOnDeviceCentered: true

    property real deviceLat : 35.744396
    property real deviceLong : 51.521739

    property real mapLat : deviceLat
    property real mapLong : deviceLong


    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.minimumWidth: 672
    Layout.minimumHeight: 504



    MapManager {
        id: mapManager
        mapTextureData: _mapTextureData
        mapCenterLatitude: mapLat
        mapCenterLongitude: mapLong


        onTileSetCompletedChanged:{
            if(tileSetCompleted){
                uBeforeMapLoad_RowLayout.visible = false
            }
        }

    }

    Item {
        id: maskRect
        anchors.fill: parent
        layer.enabled: true
        visible:false

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(1,1,1,1)

            radius: 12
        }
    }

    Item {
        id: sourceItem
        anchors.fill: parent
        layer.enabled: true
        visible: false



        View3D {


            id: view3D
            anchors.fill: parent

            environment: SceneEnvironment {


                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.High
            }

            OrthographicCamera {


                id: camera
                position: Qt.vector3d(0, 0, 600)
                horizontalMagnification: Math.max(Math.min(view3D.width, view3D.height), 1) * 0.9 * 0.5
                verticalMagnification: horizontalMagnification

            }
            camera: camera
            DirectionalLight {
                position: Qt.vector3d(-500, 500, -100)
                color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
                ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
            }


            Model {
                id:uMap_Model


                // source: "#Cylinder"
                // eulerRotation: Qt.vector3d(-90,0,0)
                // source: "#Plane" // Assuming you're using a flat plane

                geometry: MapGeometry {

                }

                materials: [

                    CustomMaterial {

                        property TextureInput tex: TextureInput {
                            enabled: true
                            texture: Texture{
                                textureData: MapTextureData {
                                    id: _mapTextureData
                                }
                            }
                        }

                        cullMode: CustomMaterial.NoCulling
                        vertexShader: "qrc:/Resources/shaders/Map.vert"
                        fragmentShader: "qrc:/Resources/shaders/Map.frag"
                        shadingMode: CustomMaterial.Unshaded
                    }
                ]

            }









            // Item {
            //     focus: true
            //     anchors.fill: parent
            //     Keys.onPressed: {
            //         var moveStep = 10000; // adjust based on sensitivity

            //         switch(event.key) {
            //         case Qt.Key_Left:
            //             //longSpinbox.value -= moveStep;
            //             mapLong -= moveStep;
            //             event.accepted = true;
            //             break;
            //         case Qt.Key_Right:
            //             //longSpinbox.value += moveStep;
            //             mapLong += moveStep;
            //             event.accepted = true;
            //             break;
            //         case Qt.Key_Up:
            //             // latSpinbox.value += moveStep;
            //             mapLat += moveStep;
            //             event.accepted = true;
            //             break;
            //         case Qt.Key_Down:
            //             //latSpinbox.value -= moveStep;
            //             mapLat -= moveStep;
            //             event.accepted = true;
            //             break;
            //         }
            //     }
            // }

        }

    }

    Item {
        id:uShaderEffect_Item
        anchors.fill: parent
        layer.enabled: true
        layer.effect: ShaderEffect {
            property var maskItem: maskRect
            property var srcItem: sourceItem
            vertexShader: "qrc:/Resources/shaders/Mask.vert.qsb"
            fragmentShader: "qrc:/Resources/shaders/Mask.frag.qsb"
            blending: true

        }
    }

    MouseArea {

        id: panMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        property real startX
        property real startY

        z:2

        onPressed: {
            startX = mouseX
            startY = mouseY
        }

        onPositionChanged: {
            if (pressedButtons & Qt.LeftButton) {
                var dx = (mouseX - startX) * 0.005 // Sensitivity
                var dy = (mouseY - startY) * 0.005

                mapLong -= dx * 10000  / 1000000.0
                mapLat += dy * 10000  / 1000000.0

                startX = mouseX
                startY = mouseY

                if(deviceLat !== mapLat || deviceLong !== mapLong){
                    isMapOnDeviceCentered = false
                }
                else{
                    isMapOnDeviceCentered = true
                }

            }
        }
    }

    MouseArea {
        id:uWheel_MouseArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton

        z:2

        onWheel: function(event) {
            var zoomSpeed = 0.10
            var delta = -event.angleDelta.y * zoomSpeed

            var newZoom = camera.horizontalMagnification - delta
            camera.horizontalMagnification = Math.max(0.1, newZoom)
            camera.verticalMagnification = camera.horizontalMagnification
        }
    }

    RowLayout{
        id:uHeader_RowLayout

        anchors{
            top: parent.top
            left: parent.left

            leftMargin: 24
            topMargin: 24
            rightMargin: 24

        }

        z:3
        width: parent.width -48
        height: 48
        spacing: 0


        RowLayout{
            id:uLeftSide_RowLayout
            Layout.fillHeight: true
            Layout.maximumWidth: 114
            spacing: 24

            IconButton{
                id:uSetMapCoordinates_IconButton
                mApplicationTheme: m_Item.mApplicationTheme
                _icon:"System_Location_Icon_F_E"
                _IconSize:36
                _ButtonStyle:IconButton.ButtonStyle.Main
                _ButtonSize:45
                _color:mApplicationTheme.mainTint4
                _Pathbackward:3



                onClicked: {
                    uLatitude_CustomTextField._TextfieldText = deviceLat
                    uLongitude_CustomTextField._TextfieldText = deviceLong
                    uMapCoordinates_Popup.open()
                }

                Popup{
                    id:uMapCoordinates_Popup
                    x:parent.x -24
                    y: parent.y -24 +212

                    width: 672
                    height:292

                    modal: true
                    padding: 0



                    background: Rectangle{
                        anchors.fill: parent
                        color: mApplicationTheme.mainShade
                        radius: 12
                    }

                    Rectangle{
                        anchors.top: parent.top
                        width: parent.width
                        height: parent.height/2
                        color: mApplicationTheme.mainShade
                        radius: 0
                    }

                    Pane{
                        id:uInnerPadded_Pane
                        anchors.fill: parent

                        padding: 24

                        background: mApplicationTheme.transparentBack

                        ColumnLayout{
                            anchors.fill: parent
                            spacing: 24

                            RowLayout{
                                spacing: 24
                                Layout.minimumHeight: 37
                                layoutDirection: "RightToLeft"

                                Icon{
                                    id:uSystemLocationInPopup_Icon
                                    _icon:"System_Location_Icon_F_E"
                                    _size:36
                                    _Pathbackward:3
                                    _color:mApplicationTheme.green
                                    Layout.alignment: Qt.AlignTop
                                }

                                Label{
                                    text:"تعیین موقعیت سامانه:"
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignRight

                                    font: mApplicationTheme.font_En_Medium_Regular
                                    color: mApplicationTheme.mainTint3

                                }

                            }

                            RowLayout{
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 16

                                CustomTextField{
                                    id:uLatitude_CustomTextField // عرض جغرافیایی
                                    mApplicationTheme: m_Item.mApplicationTheme
                                    _TitleText:"عرض جغرافیایی"
                                    _TextfieldText:mapLat
                                    _isLatitude:true

                                    onClearButtonClicked: {

                                        uLatitude_CustomTextField.state ="Normal"
                                        uSaveCoordinates_customButton.enabled = false
                                    }

                                    onTextChanged: {
                                        uLatitude_CustomTextField.state ="Normal"

                                        if(uLongitude_CustomTextField._TextfieldText ==="" && uLatitude_CustomTextField._TextfieldText === ""){
                                            uSaveCoordinates_customButton.enabled = false

                                        }
                                        else{
                                            uSaveCoordinates_customButton.enabled = true
                                        }
                                    }

                                }

                                CustomTextField{
                                    id:uLongitude_CustomTextField // طول جغرافیایی
                                    mApplicationTheme: m_Item.mApplicationTheme
                                    _TitleText:"طول جغرافیایی"
                                    _TextfieldText:mapLong
                                    _isLongitude:true

                                    onClearButtonClicked: {
                                        uLongitude_CustomTextField.state ="Normal"
                                        uSaveCoordinates_customButton.enabled = false
                                    }

                                    onTextChanged: {
                                        uLongitude_CustomTextField.state ="Normal"

                                        if(uLongitude_CustomTextField._TextfieldText ==="" && uLatitude_CustomTextField._TextfieldText === ""){
                                            uSaveCoordinates_customButton.enabled = false

                                        }
                                        else{
                                            uSaveCoordinates_customButton.enabled = true
                                        }
                                    }

                                }

                            }

                            Item{
                                Layout.fillWidth: true
                                Layout.maximumHeight: 0
                            }

                            RowLayout{
                                layoutDirection: "LeftToRight"
                                spacing: 24
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                CustomButton{
                                    id:uSaveCoordinates_customButton
                                    mApplicationTheme: m_Item.mApplicationTheme
                                    _ButtonStyle:CustomButton.ButtonStyle.Primary
                                    _textFont:mApplicationTheme.font_En_Small_Regular
                                    _textColor:mApplicationTheme.mainTint4
                                    Layout.fillHeight: true
                                    Layout.maximumWidth: 168

                                    text: "ذخیره"

                                    onClicked: {
                                        // نمایش نقشه با مختصات جدید

                                        let lat = parseFloat(uLatitude_CustomTextField._TextfieldText)
                                        let lon =  parseFloat(uLongitude_CustomTextField._TextfieldText)

                                        let latValid = (lat >= -90 && lat <= 90)
                                        let lonValid = (lon >= -180 && lon <= 180)

                                        uLatitude_CustomTextField.state = latValid ? "Normal" : "Danger"
                                        uLongitude_CustomTextField.state = lonValid ? "Normal" : "Danger"



                                        if(latValid && lonValid){
                                            deviceLat = lat
                                            deviceLong = lon


                                            mapLat=deviceLat
                                            mapLong = deviceLong


                                            uMapCoordinates_Popup.close()

                                        }


                                    }
                                }

                                CustomButton{
                                    id:uCloseCoordinatesPopup_customButton

                                    mApplicationTheme: m_Item.mApplicationTheme
                                    _ButtonStyle:CustomButton.ButtonStyle.Secondary
                                    _textFont:mApplicationTheme.font_En_Small_Regular
                                    _textColor:mApplicationTheme.mainTint4
                                    Layout.fillHeight: true
                                    Layout.maximumWidth: 168
                                    text: "انصراف"

                                    onClicked: {

                                        uMapCoordinates_Popup.close()
                                    }

                                }



                            }


                        }


                    }

                }

            }


            IconButton{
                id:uSetMapDeviceLocation_IconButton
                mApplicationTheme: m_Item.mApplicationTheme
                _icon:"Location_Icon_F_E"
                _IconSize:36
                _ButtonStyle:IconButton.ButtonStyle.Main
                _ButtonSize:45
                _color:mApplicationTheme.mainTint4
                _Pathbackward:3

                enabled: isMapOnDeviceCentered ? false : true

                onClicked: {
                    mapLat=deviceLat
                    mapLong = deviceLong
                    isMapOnDeviceCentered = true

                }
            }
        }


        RowLayout{
            id:uBeforeMapLoad_RowLayout

            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 16
            Layout.alignment: Qt.AlignRight
            layoutDirection: "RightToLeft"

            Icon{
                id:uMapHeader_Icon

                mApplicationTheme: m_Item.mApplicationTheme
                _size:48
                _color:mApplicationTheme.green
                _icon:"Direction_Icon_F_E"

            }

            Label{
                id:uMapHeader_Label
                text: "نقشه به‌زودی نمایان می‌شود..."
                color: mApplicationTheme.mainTint3
                font: mApplicationTheme.font_En_Medium_Regular
                Layout.fillHeight: true
                //Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Qt.AlignVCenter

            }
        }



    }

}
