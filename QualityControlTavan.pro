QT += core gui qml quick serialport widgets charts

CONFIG += c++17

# Disable deprecated warnings
DEFINES += QT_DEPRECATED_WARNINGS

# Output directories
DESTDIR = bin
OBJECTS_DIR = build/obj
MOC_DIR = build/moc
RCC_DIR = build/rcc
UI_DIR = build/ui

TARGET = QualityControl

# Source files
SOURCES += \
    main.cpp \
    src/serial/SerialPortManager.cpp \
    src/control/DeviceController.cpp \
    src/control/PositionSequencer.cpp \
    src/core/ApplicationController.cpp

# Header files
HEADERS += \
    src/serial/SerialPortManager.h \
    src/control/DeviceController.h \
    src/control/PositionSequencer.h \
    src/core/ApplicationController.h

# QML files
RESOURCES += qml.qrc \
    Resources/Resources.qrc

# Default rules for deployment
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


RC_ICONS +=  "Resources/Icons/QualityControl.ico"
