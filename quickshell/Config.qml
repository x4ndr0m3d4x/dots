pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property int barHeight: 35

    readonly property int sectionSpacing: 10
    readonly property int leftComponentsSpacing: 8
    readonly property int rightComponentsSpacing: 8

    readonly property int clockWidth: 200
    readonly property color clockColor: Qt.rgba(255 / 255, 182 / 255, 142 / 255, 1)
}
