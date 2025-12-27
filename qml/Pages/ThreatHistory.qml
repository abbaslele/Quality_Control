import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects
import AppManager 1.0
import Threat 1.0

import "../Components/date-conversion.js" as DateConversion

import "../"
import "../Components"
import "../Pages"
import "../Pages/CameraControlStack"
import "../Pages/ThreatSectionStack"


Page {
    id:m_Item


    property ApplicationTheme mApplicationTheme
    property AppManager mAppManager
    property StackView mTStackView
    property var filterStartDate
    property var filterEndDate
    property var fromDateGregorian
    property var toDateGregorian
    property var qFromDate
    property var qToDate
    property bool isFirstTime: true


    property var mThreatHNormalVideoOutput
    property var mThreatHThermalVideoOutput

    property int initPage: 1
    property int itemsPerPage: 6

    // Connections{
    //     target: mAppManager

    //     function onThreatListUpdated() {
    //         uPagination.totalItems =mAppManager.filteredThreatsCount
    //         uResultValue_Label.text = mApplicationTheme.toPersianNumber(mAppManager.filteredThreatsCount)
    //     }
    // }



    Component.onCompleted: {
        updateFilteredModel(initPage,itemsPerPage)

    }

    function selectCard(cardIndex){

        uThreatHistory_GridLayout.selectedCardIndex=cardIndex
    }


    function updateFilteredModel(currentPage ,itemsPerPage) {

        uThreatHistory_GridLayout.selectedCardIndex = -1
        mAppManager.stop()

        if(filterStartDate  && !filterEndDate){ // فقط تاریخ شروع

            fromDateGregorian =  DateConversion.jalali_to_gregorian(filterStartDate.y,filterStartDate.m,filterStartDate.d)
            toDateGregorian =  fromDateGregorian
            qFromDate = new Date(fromDateGregorian[0], fromDateGregorian[1] - 1, fromDateGregorian[2]);
            qToDate = new Date(toDateGregorian[0], toDateGregorian[1] - 1, toDateGregorian[2]);


            filterEndDate= filterStartDate
            mAppManager.getThreatsByDate(qFromDate,qToDate, currentPage, itemsPerPage)
        }
        else if(!filterStartDate){ // بدون فیلتر تاریخ
            mAppManager.getAllThreats(currentPage, itemsPerPage)
        }
        else{ // فیلتر بازه تاریخ
            fromDateGregorian =  DateConversion.jalali_to_gregorian(filterStartDate.y,filterStartDate.m,filterStartDate.d)
            toDateGregorian =  DateConversion.jalali_to_gregorian(filterEndDate.y,filterEndDate.m,filterEndDate.d)
            qFromDate = new Date(fromDateGregorian[0], fromDateGregorian[1] - 1, fromDateGregorian[2]);
            qToDate = new Date(toDateGregorian[0], toDateGregorian[1] - 1, toDateGregorian[2]);

            mAppManager.getThreatsByDate(qFromDate,qToDate, currentPage, itemsPerPage)
        }

    }


    padding: 0

    background: Item{

        anchors.fill: parent

        Rectangle{
            anchors.fill: parent
            color: mApplicationTheme.main
            z:0
        }

        LinearGradient {
            z:1
            anchors.fill: parent
            start:  Qt.point(width, 0)
            end: Qt.point(0, height )
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#4B4B4B" }
                GradientStop { position: 1.0; color: "#2C2C2C" }
            }
        }
    }


    state: "NoSelection"


    states: [
        State {
            name: "NoSelection"
            PropertyChanges {target: uCameraFeedManager; _isVideoSelected :false}
            PropertyChanges {target: uThreatHistory_GridLayout; selectedCardIndex:-1}
        },
        State {
            name: "ThreatReview"
            PropertyChanges {target: uCameraFeedManager; _isVideoSelected :true}
        }

    ]

    // onStateChanged: {
    //     if(state === "NoSelection"){
    //     }
    //     else if (state === "ThreatReview"){
    //     }
    // }

    function changeThreatHistoryState(val){
        state =val
    }


    Pane{
        id:uThreatHistoryPadded_Pane
        anchors.fill: parent
        padding: 24

        background: Rectangle{
            anchors.fill: parent
            color: mApplicationTheme.transparent
        }

        RowLayout{
            id:uMain_RowLayout
            anchors.fill: parent
            spacing: 24

            ColumnLayout{
                id:uLeftSide_ColumnLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 24

                StackView{
                    id:uMapStackView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Component.onCompleted: {
                        push("../Components/MapView.qml", {"mApplicationTheme": m_Item.mApplicationTheme , "mAppManager": m_Item.mAppManager})
                    }
                }


                CameraFeedManager{
                    id:uCameraFeedManager
                    mApplicationTheme: m_Item.mApplicationTheme
                    _cameraIcon:"Right_Camera_Icon_F_E"
                    _cameraType:"دوربین مرئی"
                    _cameraModel:"SB-VIS-V0"
                    _hasVisual: false
                    _isVideoSelected :false
                    _CameraFeedManagerStyle: CameraFeedManager.CameraFeedStyle.ThreatHistory



                    // onMNormalVideoOutputChanged: {

                    //     m_Item.mThreatHNormalVideoOutput = mNormalVideoOutput
                    // }

                    // onMThermalVideoOutputChanged: {

                    //     m_Item.mThreatHThermalVideoOutput = mThermalVideoOutput
                    // }

                }

            }

            Pane{
                id:uThreatHistory_Pane

                Layout.fillHeight: true
                Layout.minimumWidth: 1176
                Layout.maximumWidth: 1176
                padding:24
                leftPadding: 24
                rightPadding: 24


                background: Rectangle{
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade
                    radius: mApplicationTheme.defaultRadius12
                }


                ColumnLayout{
                    id:uMain_ColumnLayout
                    spacing: 19
                    anchors.fill: parent


                    ColumnLayout{
                        id:uTop_ColumnLayout
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 24

                        RowLayout{
                            id:uHeader_RowLayout
                            Layout.fillHeight: true
                            Layout.maximumHeight: 80
                            spacing: 0


                            IconButton{
                                id:uThreatLogFilter_IconButton
                                mApplicationTheme: m_Item.mApplicationTheme
                                _icon:"Filter_Icon_F_E"
                                _color:mApplicationTheme.mainTint4
                                _ButtonStyle:IconButton.ButtonStyle.Main
                                _IconSize:48
                                _ButtonSize:80

                                onClicked: {

                                    uPersianCalendar.open()
                                }
                                PersianCalendar{
                                    id:uPersianCalendar
                                    mApplicationTheme: m_Item.mApplicationTheme
                                    _isForThreat:true

                                    x:parent.x + parent.width + 4
                                    y: parent.y + parent.height / 2

                                    onShowResult: {
                                        uThreatLogFilter_IconButton.state="On"

                                        filterStartDate=startDate
                                        filterEndDate=endDate

                                        updateFilteredModel(uPagination.currentPage,uPagination._itemsPerPage)


                                        // console.log("startDate: " , startDate)
                                        // console.log("endDate: " , endDate)

                                    }
                                }
                            }

                            Label{
                                id:uThreatHistoryTitle_Label
                                text: "تاریخچه‌ی تهدیدها"
                                font: mApplicationTheme.font_En_Large_Bold
                                color: mApplicationTheme.mainTint4
                                verticalAlignment:  Qt.AlignVCenter
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignRight
                            }


                        }

                        ColumnLayout{
                            id:uBody_ColumnLayout
                            spacing : 0
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.minimumHeight: 816

                            GridLayout{
                                id: uThreatHistory_GridLayout
                                Layout.fillWidth: true

                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                                columns: 2
                                rowSpacing: 24
                                columnSpacing: 24
                                flow: GridLayout.LeftToRight

                                property int selectedCardIndex: -1

                                Repeater {
                                    id: uThreatHistory_Repeater
                                    model: threatModel

                                    delegate: ThreatHistoryCard {
                                        id: uThreatCard
                                        mApplicationTheme: m_Item.mApplicationTheme
                                        mAppManager: m_Item.mAppManager
                                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop


                                        _cardNumber: model.id
                                        _threatDeviceModelName: model.name
                                        _trackVideoDuration: model.trackDuration
                                        _angle: model.angleVec[0]
                                        _distance: model.distanceVec[0]
                                        _dateTimeString: model.positionVec[0].dateTimeString
                                        _lat: Math.floor(model.positionVec[0].latitude * 1e6) / 1e6
                                        _long: Math.floor(model.positionVec[0].longitude * 1e6) / 1e6
                                        _height: model.positionVec[0].height
                                        _normalVideoSource: model.videoLocation.normalVideoLocation
                                        _thermalVideoSource: model.videoLocation.thermalVideoLocation

                                        property int realIndex: index + ((uPagination.currentPage-1)*itemsPerPage)

                                        // Component.onCompleted: {
                                        //     if(uCameraFeedManager){
                                        //         console.log("uCameraFeedManager exist")
                                        //         _normalVideoOutput= uCameraFeedManager.mNormalVideoOutput
                                        //         _thermalVideoOutput=uCameraFeedManager.mThermalVideoOutput
                                        //     }
                                        // }

                                        // _normalVideoOutput: uCameraFeedManager.mNormalVideoOutput
                                        // _thermalVideoOutput:uCameraFeedManager.mThermalVideoOutput

                                      // _normalVideoOutput:  m_Item.mThreatHNormalVideoOutput

                                      //  _thermalVideoOutput: m_Item.mThreatHThermalVideoOutput

                                        _cardIndex:realIndex
                                        state: realIndex === uThreatHistory_GridLayout.selectedCardIndex ? "Selected" : "Normal"

                                        // Component.onDestruction:{

                                        //     Connections = null
                                        // }
                                        // Connections {
                                        //     target: uCameraFeedManager
                                        //     function onSwitchCamera(isThermalCamera) { uThreatCard._isThermalCamera = isThermalCamera }
                                        // }



                                        // on_MediaPlayerStateChanged: {
                                        //     if(uCameraFeedManager){
                                        //         if(_mediaPlayerState ===  ThreatHistoryCard.MediaPlayStates.Playing || _mediaPlayerState ===  ThreatHistoryCard.MediaPlayStates.Paused ){
                                        //             uCameraFeedManager._hasVisual=true
                                        //         }
                                        //         else{
                                        //             uCameraFeedManager._hasVisual=false
                                        //         }
                                        //     }
                                        // }

                                    }

                                }

                            }

                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                            }
                        }
                    }


                    RowLayout{
                        id:uFooter_RowLayout
                        layoutDirection: "LeftToRight"
                        Layout.fillWidth: true
                        Layout.maximumHeight: 45
                        spacing: 0


                        CustomButton{
                            id:uReturn_CustomButton
                            Layout.minimumHeight: 45
                            Layout.maximumHeight: 45
                            Layout.minimumWidth: 168
                            Layout.maximumWidth: 168

                            mApplicationTheme: m_Item.mApplicationTheme
                            _ButtonStyle: CustomButton.ButtonStyle.Secondary
                            _textFont:mApplicationTheme.font_En_Small_Regular


                            text: "بازگشت"
                            onClicked: {

                                changeThreatHistoryState("NoSelection")

                                uMapStackView.clear()

                                m_Item.mTStackView.pop()
                            }
                        }

                        Item{
                            //Layout.minimumWidth:88
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        Pagination{
                            id:uPagination
                            mApplicationTheme: m_Item.mApplicationTheme
                            Layout.maximumWidth: 359
                            totalItems: mAppManager.filteredThreatsCount
                            _itemsPerPage:itemsPerPage

                            onCurrentPageChanged:{
                                // console.log("Current Page Changed :" , currentPage)
                                // if(!isFirstTime){
                                updateFilteredModel(currentPage, _itemsPerPage)
                                // }
                                // isFirstTime=false
                                previousEnabled = currentPage > 1
                                nextEnabled = currentPage < pageCount
                            }

                        }

                        Item{
                            //Layout.minimumWidth:160
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        RowLayout{
                            id:uResultCounetr_RowLayout
                            //Layout.fillHeight: true
                            Layout.maximumWidth: 150
                            layoutDirection: "LeftToRight"
                            Layout.alignment: Qt.AlignBottom | Qt.AlignRight


                            spacing: 16

                            Label{
                                id:uResultValue_Label
                                text:mApplicationTheme.toPersianNumber(mAppManager.filteredThreatsCount)
                                font: mApplicationTheme.font_En_Medium_Regular
                                color: mApplicationTheme.mainTint2
                                //Layout.fillHeight: true
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignBottom
                            }

                            Label{
                                id:uReslutTitle_Label
                                text: "تعداد نتایج"
                                font: mApplicationTheme.font_En_Medium_Regular
                                color: mApplicationTheme.mainTint3
                                //Layout.fillHeight: true
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignBottom



                            }

                        }

                    }

                }


            }


        }

    }

}
