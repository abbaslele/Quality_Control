import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15

import "Pages/Backlash"
ApplicationWindow {
    id:uMainQml

    title: `${Application.name} v${Application.version}`
    visibility : Window.Maximized
    // visibility : Window.FullScreen
    minimumHeight: 900
    minimumWidth: 1200

    ApplicationTheme{id:mApplicationTheme}

    Home
    {
        id:uHome
        mApplicationTheme:mApplicationTheme
        // mStackView: mStackView
    }

    StackView
    {
        id:mStackView
        anchors.fill: parent
        initialItem: uHome
    }

}
