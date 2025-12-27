import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes 1.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material 2.15

import "date-conversion.js" as DateConversion
import "../"

Popup {
    id:root

    property ApplicationTheme mApplicationTheme

    property var lastSelectedDate
    property bool _isDarkDropShadow: false
    property var currentDate: DateConversion.today()
    property bool _isForThreat: true


    property var selectedDate: currentDate


    property color yearRectColor: "transparent"
    property color monthRectColor: "transparent"
    property color dayNameRectColor: "transparent"
    property color dayNumberBackColor: mApplicationTheme.main
    property color daysTextColor: mApplicationTheme.mainTint4
    property color selectedDayBGColor: mApplicationTheme.mainTint3
    property color rangeMiddleColor: mApplicationTheme.mainTint2
    property int selectedDayBorderWidth: 3
    property color rectangleColor: "transparent"


    // Range selection properties
    property var rangeStartDate: null
    property var rangeEndDate: null
    property var rangeStartDateLastSelected: null
    property var rangeEndDateLastSelected: null

    property bool isSelectingRange: false



    property int displayYear: currentDate["y"]
    property int displayMonth: currentDate["m"]
    property int displayDay: currentDate["d"]


    property string thisMonth: DateConversion.monthName(displayMonth)
    property int daysInMonth: DateConversion.dayInMonth(displayYear, displayMonth)
    property int firstDayOfMonth: DateConversion.dayNumber(displayYear, displayMonth, 1)


    padding: 0
    // width: 434
    // height: 735
    clip: true
    modal: true
    focus: true
    background: Rectangle{
        anchors.fill: parent
        color:"transparent"
    }

    signal showResult(var startDate, var endDate)

    function navigateMonth(direction) {
        let newMonth = displayMonth + direction
        let newYear = displayYear

        if (newMonth > 12) {
            newMonth = 1
            newYear++
        } else if (newMonth < 1) {
            newMonth = 12
            newYear--
        }

        displayYear = newYear
        displayMonth = newMonth
        refreshCalendar()
    }

    function navigateYear(direction) {
        displayYear += direction

        if (displayYear === currentDate["y"] && displayMonth > currentDate["m"]) {
            displayMonth = currentDate["m"];
        }

        refreshCalendar()
    }

    function setToCurrentMonthYear() {
        displayYear = currentDate["y"];
        displayMonth = currentDate["m"];
        refreshCalendar();
    }


    function refreshCalendar() {
        // Force update of calculated properties
        thisMonth = DateConversion.monthName(displayMonth)
        daysInMonth = DateConversion.dayInMonth(displayYear, displayMonth)
        firstDayOfMonth = DateConversion.dayNumber(displayYear, displayMonth, 1)

        // Trigger visual update
        calendarRepeater.model = 0
        calendarRepeater.model = 36
    }


    function selectDay(day) {
        if (day <= 0 || day > daysInMonth) return

        let selectedDateObj = {
            "y": displayYear,
            "m": displayMonth,
            "d": day
        }

        // Range selection
        handleRangeSelection(selectedDateObj)

        refreshCalendar()
    }
    function dateEquals(a, b) {
        return a && b && a.y === b.y && a.m === b.m && a.d === b.d;
    }

    function handleRangeSelection(dateObj) {
        if (!rangeStartDate) {
            // First click - set start date
            rangeStartDate = dateObj
            rangeEndDate = null
            isSelectingRange = true
        }
        else if (!rangeEndDate) {
            if (dateEquals(rangeStartDate,dateObj)){
                rangeStartDate = null
                isSelectingRange = false
                return
            }

            // Second click - set end date
            if (compareDates(dateObj, rangeStartDate) >= 0) {
                rangeEndDate = dateObj
                isSelectingRange = false
                //dateRangeSelected(rangeStartDate, rangeEndDate)
            }
            else {
                // If clicked date is before start date, swap them
                rangeEndDate = rangeStartDate
                rangeStartDate = dateObj
                isSelectingRange = false
                //dateRangeSelected(rangeStartDate, rangeEndDate)
            }
        }
        else if(dateEquals(rangeEndDate,dateObj)){
            rangeEndDate = null
            isSelectingRange = true
            return
        }
        else {
            // Third click - start new range
            rangeStartDate = dateObj
            rangeEndDate = null
            isSelectingRange = true
        }
    }

    function compareDates(date1, date2) {
        if (date1.y !== date2.y) return date1.y - date2.y
        if (date1.m !== date2.m) return date1.m - date2.m
        return date1.d - date2.d
    }

    /**
 * Check if a date is within the selected range
 */
    function isDateInRange(dateObj) {
        if (!rangeStartDate || !rangeEndDate) return false

        return compareDates(dateObj, rangeStartDate) >= 0 &&
                compareDates(dateObj, rangeEndDate) <= 0
    }

    /**
 * Check if a date is the start of the range
 */
    function isRangeStart(dateObj) {
        if (!rangeStartDate) return false
        return compareDates(dateObj, rangeStartDate) === 0
    }

    /**
 * Check if a date is the end of the range
 */
    function isRangeEnd(dateObj) {
        if (!rangeEndDate) return false
        return compareDates(dateObj, rangeEndDate) === 0
    }

    /**
 * Reset range selection
 */
    function resetRange() {
        rangeStartDate = null
        rangeEndDate = null
        isSelectingRange = false
        refreshCalendar()
    }


    Component.onCompleted: {

        if(_isForThreat){
            root.width= 434
            root.height= 735
            uLeft_Pane.visible=true
            uBottom_Pane.visible=false
            topLeftFlat.visible =true
            bottomLeftFlat.visible =false
        }
        else{
            root.width= 410
            root.height= 767
            uLeft_Pane.visible=false
            uBottom_Pane.visible=true
            topLeftFlat.visible =false
            bottomLeftFlat.visible =true
        }

        lastSelectedDate =selectedDate
        rangeStartDate = currentDate
        rangeStartDateLastSelected=rangeStartDate
        refreshCalendar()
    }

    ColumnLayout{
        id:uOuter_ColumnLayout
        anchors.fill: parent
        spacing: 0

        RowLayout{
            id:uMain_RowLayout
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0

            Pane{
                id:uLeft_Pane
                Layout.maximumWidth: visible? 32 : 0
                Layout.minimumWidth: visible? 32 : 0
                Layout.fillHeight: visible? true : false
                visible: _isForThreat ? true : false

                padding:0

                background: Rectangle{
                    anchors.fill: parent
                    color:"transparent"
                }


                Shape {
                    id: uTopTriangle
                    width: 32
                    height: 24
                    anchors.right: parent.right
                    anchors.top: parent.top

                    ShapePath {
                        strokeWidth: 0
                        strokeColor: "transparent"
                        // fillColor: mApplicationTheme.mainTint0  // Change color as needed
                        fillColor: mApplicationTheme.mainTint0  // Change color as needed

                        startX: uTopTriangle.width
                        startY: uTopTriangle.height

                        PathLine { x: uTopTriangle.width; y: 0 }
                        PathLine { x: 6; y: 0 }      // Instead of (width, 0)
                        // Arc from near top-right to near top-left
                        PathArc {
                            x: 6; y: 6                   // Ends partway along the top
                            radiusX: 4; radiusY: 4
                            useLargeArc: false
                            direction: PathArc.Counterclockwise
                        }

                        PathLine { x: uTopTriangle.width; y: uTopTriangle.height }
                    }
                }

            }

            Pane{
                id:uRight_Pane
                Layout.fillHeight: true
                Layout.fillWidth: true

                padding:0
                background: Rectangle{
                    anchors.fill: parent
                    color: mApplicationTheme.mainTint0
                    radius: 6
                }

                Rectangle {
                    id: topLeftFlat
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: parent.height / 2
                    width: parent.width / 2
                    color: mApplicationTheme.mainTint0
                    radius: 0
                }

                Rectangle {
                    id: bottomLeftFlat
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    height: parent.height / 2
                    width: parent.width / 2
                    color: mApplicationTheme.mainTint0
                    radius: 0
                }

                Pane{
                    id:uPadded_Pane
                    anchors.fill: parent

                    padding: 16


                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"

                    }


                    ColumnLayout{

                        anchors.fill: parent

                        spacing: 48


                        ColumnLayout{
                            id:uHeader_ColumnLayout
                            Layout.fillWidth: true
                            Layout.maximumHeight: 212
                            spacing: 12

                            ColumnLayout{
                                id:uHeaderFirst_ColumnLayout
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 8


                                Pane {
                                    id: uNavigationYear_Pane
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 45
                                    padding: 0

                                    background: Rectangle {
                                        color: mApplicationTheme.mainShade
                                        radius: 6
                                    }

                                    RowLayout {
                                        anchors.fill: parent

                                        IconButton {
                                            id:nextYearButton
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.maximumWidth: 45
                                            mApplicationTheme: root.mApplicationTheme
                                            _icon: "Left_Arrow_Icon_F_E"
                                            _ButtonSize: 45
                                            enabled: displayYear < currentDate["y"]
                                            _IconSize:36
                                            onClicked: navigateYear(1)
                                            _ButtonStyle: IconButton.ButtonStyle.MainShade

                                        }

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            Text {
                                                id: headerText
                                                anchors.centerIn: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                color: mApplicationTheme.mainTint4
                                                font: mApplicationTheme.font_En_Small_Bold
                                                text: DateConversion.toFarsiNumber(displayYear)
                                            }
                                        }

                                        IconButton {
                                            id: prevYearButton
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.maximumWidth: 45
                                            mApplicationTheme: root.mApplicationTheme
                                            _icon: "Right_Arrow_Icon_F_E"
                                            _ButtonSize: 45
                                            _IconSize:36
                                            onClicked: navigateYear(-1)
                                            _ButtonStyle: IconButton.ButtonStyle.MainShade
                                        }
                                    }
                                }

                                Pane {
                                    id: uNavigationMonth_Pane
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 45
                                    padding: 0

                                    background: Rectangle {
                                        color: mApplicationTheme.mainShade
                                    }

                                    RowLayout {
                                        anchors.fill: parent

                                        IconButton {
                                            id:nextButton
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.maximumWidth: 45
                                            mApplicationTheme: root.mApplicationTheme
                                            _icon: "Left_Arrow_Icon_F_E"
                                            _ButtonSize: 45
                                            enabled: !(displayYear === currentDate["y"] && displayMonth === currentDate["m"])
                                            _IconSize:36
                                            onClicked: navigateMonth(1)
                                            _ButtonStyle: IconButton.ButtonStyle.MainShade
                                        }

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            Text {
                                                id: monthText
                                                anchors.centerIn: parent
                                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                color: mApplicationTheme.mainTint4
                                                text: thisMonth
                                                font: mApplicationTheme.font_En_Small_Bold
                                            }
                                        }

                                        IconButton {
                                            id: prevButton
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.maximumWidth: 45
                                            mApplicationTheme: root.mApplicationTheme
                                            _icon: "Right_Arrow_Icon_F_E"
                                            _ButtonSize: 45
                                            _IconSize:36
                                            onClicked: navigateMonth(-1)
                                            _ButtonStyle: IconButton.ButtonStyle.MainShade
                                        }
                                    }
                                }

                            }

                            ColumnLayout{
                                id:uHeaderSecond_ColumnLayout
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 12
                                RowLayout{
                                    id:uDays_RowLayout
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    spacing: 12
                                    CustomButton{
                                        id:uYesterday_CustomButton
                                        mApplicationTheme: root.mApplicationTheme
                                        _ButtonStyle:CustomButton.ButtonStyle.Main
                                        _textFont:mApplicationTheme.font_En_Small_Regular
                                        _textColor:mApplicationTheme.mainTint4
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        text: "دیروز"

                                        onClicked: {
                                            setToCurrentMonthYear()
                                            rangeStartDate=null
                                            rangeEndDate=null
                                            selectDay(currentDate["d"]-1)
                                        }


                                    }
                                    CustomButton{
                                        id:uToday_CustomButton
                                        mApplicationTheme: root.mApplicationTheme
                                        _ButtonStyle:CustomButton.ButtonStyle.Main
                                        _textFont:mApplicationTheme.font_En_Small_Regular
                                        _textColor:mApplicationTheme.mainTint4
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        text: "امروز"

                                        onClicked: {
                                            setToCurrentMonthYear()
                                            rangeStartDate=null
                                            rangeEndDate=null
                                            selectDay(currentDate["d"])


                                        }
                                    }

                                }

                                CustomButton{
                                    id:uLastWeek_CustomButton
                                    mApplicationTheme: root.mApplicationTheme
                                    _ButtonStyle:CustomButton.ButtonStyle.Main
                                    _textFont:mApplicationTheme.font_En_Small_Regular
                                    _textColor:mApplicationTheme.mainTint4
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    text: "هفته‌ی اخیر"

                                    onClicked: {
                                        setToCurrentMonthYear()
                                        rangeStartDate=null
                                        rangeEndDate=null

                                        if(currentDate["d"]-6 <1){
                                            navigateMonth(-1)
                                          selectDay(DateConversion.dayInMonth(displayYear, displayMonth)-((currentDate["d"]-6) *-1))
                                            navigateMonth(1)
                                        }
                                        else{
                                            selectDay(currentDate["d"]-6)
                                        }


                                        selectDay(currentDate["d"])
                                    }
                                }

                            }
                        }


                        ColumnLayout {
                            id: uDateNumber_ColumnLayout
                            Layout.fillWidth: true
                            Layout.maximumHeight: 350
                            // spacing: 3
                            Layout.alignment: Qt.AlignHCenter

                            GridLayout {
                                id: calendarGrid
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter
                                columns: 6
                                rowSpacing: 16
                                columnSpacing: 16

                                Repeater {
                                    id: calendarRepeater
                                    model: 36


                                    delegate: Rectangle {
                                        id: dayCell
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 45
                                        Layout.minimumHeight: 45
                                        Layout.maximumWidth: 45
                                        Layout.maximumHeight: 45

                                        // Calculate day number for this cell
                                        property int dayNumber: {
                                            let cellDay = index - firstDayOfMonth + 1
                                            return (cellDay > 0 && cellDay <= daysInMonth) ? cellDay : 0
                                        }

                                        property bool isValidDay: dayNumber > 0

                                        // Create date object for this cell
                                        property var cellDate: isValidDay ? {
                                                                                "y": displayYear,
                                                                                "m": displayMonth,
                                                                                "d": dayNumber
                                                                            } : null

                                        // Visual state calculations
                                        property bool isSingleSelected: {
                                            if (!selectedDate || !isValidDay) return false
                                            return selectedDate.y === displayYear &&
                                                    selectedDate.m === displayMonth &&
                                                    selectedDate.d === dayNumber
                                        }

                                        property bool isRangeStart: isValidDay && root.isRangeStart(cellDate)
                                        property bool isRangeEnd: isValidDay && root.isRangeEnd(cellDate)
                                        property bool isInRange: isValidDay && root.isDateInRange(cellDate)

                                        // Color logic
                                        color: {
                                            if (!isValidDay) return dayNumberBackColor

                                            if (isRangeStart || isRangeEnd) {
                                                return selectedDayBGColor
                                            } else if (isInRange) {
                                                return rangeMiddleColor
                                            }
                                            else {
                                                return dayNumberBackColor
                                            }


                                        }

                                        radius: 6

                                        Text {
                                            id: uDayNumber_Text
                                            anchors.centerIn: parent
                                            text: dayCell.isValidDay ? DateConversion.toFarsiNumber(dayCell.dayNumber) : ""
                                            color:uDay_MouseArea.enabled  ? mApplicationTheme.mainTint4 : mApplicationTheme.mainTint1
                                            font: mApplicationTheme.font_En_Large_Regular
                                        }

                                        DropShadow {
                                            id:uNumber_DropShadow
                                            anchors.fill: uDayNumber_Text
                                            source: uDayNumber_Text
                                            horizontalOffset: 0
                                            verticalOffset: 0
                                            radius: 10
                                            samples: 21
                                            color: _isDarkDropShadow ? mApplicationTheme.black : mApplicationTheme.white
                                            visible: false
                                        }

                                        MouseArea {
                                            id:uDay_MouseArea
                                            anchors.fill: parent
                                            //enabled: dayCell.isValidDay
                                            enabled: dayCell.isValidDay &&
                                                     (displayYear < currentDate["y"] ||
                                                      (displayYear === currentDate["y"] &&
                                                       (displayMonth < currentDate["m"] ||
                                                        (displayMonth === currentDate["m"] && dayCell.dayNumber <= currentDate["d"]))))

                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (dayCell.isValidDay) {
                                                    selectDay(dayCell.dayNumber)
                                                }
                                            }

                                            onPressed: {
                                                if (dayCell.isValidDay) {
                                                    parent.opacity = 0.8
                                                }
                                            }

                                            onReleased: {
                                                parent.opacity = 1.0
                                            }

                                            onEntered: {
                                                uNumber_DropShadow.visible=true
                                            }

                                            onExited: {
                                                uNumber_DropShadow.visible=false
                                            }
                                        }
                                    }






                                    // delegate: IconButton {
                                    //     id: dayCell
                                    //     mApplicationTheme: root.mApplicationTheme
                                    //     _isNumberButton:true
                                    //     _ButtonSize:45

                                    //     // Calculate day number for this cell
                                    //     property int dayNumber: {
                                    //         let cellDay = index - firstDayOfMonth + 1
                                    //         return (cellDay > 0 && cellDay <= daysInMonth) ? cellDay : 0
                                    //     }

                                    //     property bool isValidDay: dayNumber > 0

                                    //     // Create date object for this cell
                                    //     property var cellDate: isValidDay ? {
                                    //                                             "y": displayYear,
                                    //                                             "m": displayMonth,
                                    //                                             "d": dayNumber
                                    //                                         } : null

                                    //     _number: dayCell.isValidDay ? DateConversion.toFarsiNumber(dayCell.dayNumber) : ""

                                    //     // Visual state calculations
                                    //     property bool isSingleSelected: {
                                    //         if (!selectedDate || !isValidDay) return false
                                    //         return selectedDate.y === displayYear &&
                                    //                 selectedDate.m === displayMonth &&
                                    //                 selectedDate.d === dayNumber
                                    //     }

                                    //     property bool isRangeStart: isValidDay && root.isRangeStart(cellDate)
                                    //     property bool isRangeEnd: isValidDay && root.isRangeEnd(cellDate)
                                    //     property bool isInRange: isValidDay && root.isDateInRange(cellDate)

                                    //     state:{
                                    //         if (isRangeStart || isRangeEnd) {
                                    //             return "On"
                                    //         } else if (isInRange) {
                                    //             return "InRange"
                                    //         } else {
                                    //             return "Normal"
                                    //         }
                                    //     }


                                    //     onClicked: {

                                    //         if(dayCell.isValidDay) {
                                    //             selectDay(dayCell.dayNumber)
                                    //             //state = state === "On" ? state = "Normal" : state = "On"
                                    //         }
                                    //     }

                                    // }



                                }
                            }
                        }



                        RowLayout{
                            id:uActionButtons_RowLayout
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 12

                            CustomButton{
                                id:uShow_CustomButton
                                mApplicationTheme: root.mApplicationTheme
                                _ButtonStyle:CustomButton.ButtonStyle.Primary
                                _textFont:mApplicationTheme.font_En_Small_Regular
                                _textColor:mApplicationTheme.mainTint4
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                text: "نمایش"

                                enabled: rangeStartDate === null && rangeEndDate===null ? false : true

                                onClicked: {

                                    // if(!rangeStartDate && !rangeEndDate)
                                    // {
                                    //     root.close()
                                    // }
                                    // else{
                                        showResult(rangeStartDate,rangeEndDate)
                                        root.close()
                                    //}

                                }

                            }
                            CustomButton{
                                id:uClose_CustomButton
                                mApplicationTheme: root.mApplicationTheme
                                _ButtonStyle:CustomButton.ButtonStyle.Secondary
                                _textFont:mApplicationTheme.font_En_Small_Regular
                                _textColor:mApplicationTheme.mainTint4
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                text: "بستن"

                                onClicked: root.close()
                            }

                        }

                    }


                }
            }

        }

        Pane{
            id:uBottom_Pane
            Layout.maximumHeight: visible? 32 : 0
            Layout.minimumHeight: visible? 32 : 0
            Layout.fillWidth:  visible? true : false

            padding:0

            background: Rectangle{
                anchors.fill: parent
                color:"transparent"
            }


            Shape {
                id: uLeftTriangle
                width: 24
                height: 32
                anchors.left: parent.left
                anchors.top: parent.top

                ShapePath {
                    strokeWidth: 0
                    strokeColor: "transparent"
                    fillColor: mApplicationTheme.mainTint0

                    startX: uLeftTriangle.width
                    startY: 0

                    PathLine { x: 0; y: 0 }
                    PathLine { x: 0; y: uLeftTriangle.height - 6 }
                    PathArc {
                        x: 6; y: uLeftTriangle.height - 6
                        radiusX: 6; radiusY: 6
                        useLargeArc: false
                        direction: PathArc.Counterclockwise
                    }
                    PathLine { x: uLeftTriangle.width; y: 0 }
                }

            }

        }

    }

}
