import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                bottom: true
            }

            width: 50

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft
                    ColumnLayout {
                        spacing: 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            color: "blue"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        Rectangle {
                            color: "lightblue"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    ColumnLayout {
                        spacing: 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            color: "orange"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        Rectangle {
                            color: "red"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignRight
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: date
                            text: DateTime.date
                        }

                        Text {
                            id: hours
                            text: DateTime.hours
                            font.pointSize: 16
                        }

                        Text {
                            id: minutes
                            text: DateTime.minutes
                            font.pointSize: 16
                        }

                        Rectangle {
                            id: power

                            color: "lightgreen"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
            }
        }
    }
}
