import QtQuick

QtObject {

    //رنگهای مورد استفاده در برنامه
    property color mainShadeOp: "#80232323"
    property color mainShade: "#232323"
    property color main: "#2C2C2C"
    property color mainTint0: "#323232"
    property color mainTint1: "#4A4A4A"
    property color mainTint2: "#858585"
    property color mainTint3: "#C0C0C0"
    property color mainTint4: "#FDFDFD"
    property color darkRed3: "#382324"
    property color darkRed2: "#3B1D20"
    property color darkRed1: "#522B2F"
    property color redShade2: "#7A3139"
    property color redShade1: "#993D47"
    property color red: "#B95D6C"
    property color redTint1: "#D59EA7"
    property color redTint2: "#EACED3"
    property color sharpRed: "#C7465E"
    property color darkYellow: "#413A2F"
    property color yellowShade2: "#95703D"
    property color yellowShade1: "#BA8C4C"
    property color yellow: "#E3AB5E"
    property color yellowTint1: "#EECD9E"
    property color yelloTint2: "#F7E6CF"
    property color darkGreen: "#263A2F"
    property color greenShade: "#4A946B"
    property color green: "#5DB986"
    property color greenTint1: "#9ED5B6"
    property color greenTint2: "#DFF1E7"
    property color blue: "#3543DD"
    property color primaryColor: "#322B77"
    property color secondaryColor: "#2A283C"
    property color primaryDisColor: "#6D63C7"
    property color secondaryDisColor: "#615D82"
    property color white: "#FFFFFF"
    property color black: "#000000"
    property color white_Op50: "#80FFFFFF"
    property color transparent: "transparent"



    property FontLoader alanSansFont:  FontLoader {
        id: customFont
        source: "qrc:/Resources/Fonts/AlanSans-VariableFont_wght.ttf"
    }

    property string fontFaFamily: alanSansFont.status === FontLoader.Ready ? alanSansFont.name : "Arial"

    property font font_En_3X_Large_Regular: Qt.font({ family: fontFaFamily, pixelSize: 36 , weight: Font.Normal})
    property font font_En_3X_Large_Bold: Qt.font({ family: fontFaFamily, pixelSize: 36 , weight: Font.Bold})
    property font font_En_2X_Large_Regular: Qt.font({ family: fontFaFamily, pixelSize: 32 , weight: Font.Normal})
    property font font_En_2X_Large_Bold: Qt.font({ family: fontFaFamily, pixelSize: 32 , weight: Font.Bold	})
    property font font_En_Large_Regular:   Qt.font({ family: fontFaFamily, pixelSize: 28 , weight: Font.Normal})
    property font font_En_Large_Bold:   Qt.font({ family: fontFaFamily, pixelSize: 28 , weight: Font.Bold })
    property font font_En_Medium_Regular:     Qt.font({ family: fontFaFamily, pixelSize: 24 , weight: Font.Normal	})
    property font font_En_Medium_Bold:     Qt.font({ family: fontFaFamily, pixelSize: 24 , weight: Font.Bold })
    property font font_En_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 20 , weight: Font.Normal	})
    property font font_En_Small_Bold:  Qt.font({ family: fontFaFamily, pixelSize: 20 , weight: Font.Bold	})
    property font font_En_2X_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 16 , weight: Font.Normal	})
    property font font_En_2X_Small_Bold:  Qt.font({ family: fontFaFamily, pixelSize: 16 , weight: Font.Bold	})
    property font font_En_3X_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 14 , weight: Font.Normal	})
    property font font_En_3X_Small_Bold:  Qt.font({ family: fontFaFamily, pixelSize: 14 , weight: Font.Bold	})
    property font font_En_4X_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 12 , weight: Font.Normal	})


    //متفرقه
    property int coulmSpacing: 4
    property int  defaultRadius6: 6
    property int  defaultRadius12: 6

    property Rectangle transparentBack: Rectangle{
        anchors.fill: parent
        color: mApplicationTheme.transparent
        radius: 12
    }



    function toPersianNumber(number) {
        // Ensure the number is converted to string safely
        return number
        .toString()
        .replace(/[0-9]/g, d => String.fromCharCode(d.charCodeAt(0) + 1728));
    }


    function toEnglishNumber(persianNumber) {
        const persianDigits = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];
        return persianNumber.replace(/[۰-۹]/g, function(d) {
            return persianDigits.indexOf(d);
        });
    }

    function formatMs(ms) {
        // console.log("ms is : ", ms);
        var totalSeconds = Math.floor(ms / 1000);
        var hours = Math.floor(totalSeconds / 3600);
        var minutes = Math.floor((totalSeconds % 3600) / 60);
        var seconds = totalSeconds % 60;

        // Format with leading zeros for hours, minutes, seconds
        var hStr = hours.toString().padStart(2, '0');
        var mStr = minutes.toString().padStart(2, '0');
        var sStr = seconds.toString().padStart(2, '0');

        // Compose the time string
        return mApplicationTheme.toPersianNumber(hStr)  + ":" + mApplicationTheme.toPersianNumber(mStr) + ":" + mApplicationTheme.toPersianNumber(sStr);
    }


}
