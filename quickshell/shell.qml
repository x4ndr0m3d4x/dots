import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens;

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            height: 30

            RowLayout {
                anchors.fill: parent
                spacing: 0

                RowLayout {
                    Layout.alignment: Qt.AlignLeft
                    RowLayout {
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

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    RowLayout {
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

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    RowLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            id: date 
                            text: DateTime.date 
                        }

                        Text {
                            id: time
                            text: DateTime.time
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
