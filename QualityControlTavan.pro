QT += core gui qml quick serialport

CONFIG += c++17

TARGET = QualityControl
TEMPLATE = app

DEFINES += QT_DEPRECATED_WARNINGS

# Source files
SOURCES += \
    main.cpp \
    src/control/devicecontroller.cpp \
    src/serial/SerialPortManager.cpp \
    src/control/PositionSequencer.cpp \
    src/core/ApplicationController.cpp

HEADERS += \
    src/control/devicecontroller.h \
    src/serial/SerialPortManager.h \
    src/control/PositionSequencer.h \
    src/core/ApplicationController.h

# QML resource file
RESOURCES += qml/qml.qrc

# Remove the problematic copydata section entirely
# (delete these lines:)
# copydata.commands = ...
# first.depends = ...
# export(first.depends)
# export(copydata.commands)
# QMAKE_EXTRA_TARGETS += first copydata

# Installation
target.path = $$[QT_INSTALL_EXAMPLES]/qualitycontrol
INSTALLS += target
