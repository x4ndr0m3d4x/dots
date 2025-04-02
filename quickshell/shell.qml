import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            // Panel anchored to the top
            anchors {
                top: true
                left: true
                right: true
            }

            height: 35
            color: "#282a36"

            // Main vertical layout for the panel
            RowLayout {
                anchors.fill: parent

                /// --- Left Sections: Trans Rights, Workspaces, Media Player
                RowLayout {
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        id: transRights
                        text: "🏳️‍⚧️🏳️‍🌈"
                        font.pointSize: 18
                    }

                    Text {
                        id: hyprland
                        text: Hyprland.focusedMonitor.activeWorkspace.id || "Unknown Workspace"
                        color: "white"
                        font.pointSize: 18
                    }

                    Text {
                        id: mediaTitle
                        text: Mpris.players.values[0].trackTitle || "Unknown Track"
                        color: "white"
                        font.pointSize: 18
                    }
                }

                // --- Middle Section: Active Window ---
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10
                }

                // --- Right Section: Date, Time & Power ---
                RowLayout {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillHeight: true
                    spacing: 8

                    Clock {}

                    Button {
                        id: powerButton
                        text: "⏻"
                        Layout.alignment: Qt.AlignHCenter

                        background: Rectangle {
                            color: powerButton.down ? "#ff5555" : "transparent"
                            border.color: "#bd93f9"
                            radius: 5
                        }
                        contentItem: Text {
                            text: powerButton.text
                            font: powerButton.font
                            color: "#ff5555" // Dracula theme red (example)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        // Action when clicked
                        onClicked: {
                            console.log("Power button clicked. Executing command...");
                            var proc = Quickshell.Io.Process.create();
                            // --- Choose ONE command that works for your system ---
                            // Option 1: Use a graphical logout menu like wlogout
                            // proc.exec("wlogout");

                            // Option 2: Terminate the current session via logind
                            // proc.exec("loginctl terminate-session $XDG_SESSION_ID");

                            // Option 3: Initiate system poweroff (may require root privileges)
                            // proc.exec("systemctl poweroff");

                            // Option 4 (Placeholder): Just log a message
                            proc.exec("echo 'Logout command placeholder'");

                            proc.finished.connect(function () {
                                if (proc.exitCode !== 0) {
                                    console.error("Power command failed:", proc.stderr);
                                } else {
                                    console.log("Power command executed successfully.");
                                }
                                proc.destroy(); // Clean up the process object
                            });
                        }
                    }
                }
            }
        }
    }
}
