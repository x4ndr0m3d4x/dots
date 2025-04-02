import QtQuick
import QtQuick.Layouts
import Quickshell.Io

// Displays Hyprland workspaces
Rectangle {
    id: workspacesRoot
    color: "transparent" // Or a subtle background like "#3b3d4d"
    radius: 5

    property var workspacesModel: [] // Holds workspace data [{id: 1, name: "1"}, {id: 2, name: "2"}]
    property int activeWorkspaceId: -1

    // Process to fetch workspace data
    Process {
        id: hyprctlProcess

        // Command to get workspaces in JSON format
        command: "hyprctl workspaces -j"

        // Handle successful command execution
        // onFinished: {
        //     if (exitCode === 0) {
        //         try {
        //             // Parse the JSON output
        //             var jsonData = JSON.parse(stdout);
        //             // Sort workspaces by ID for consistent order
        //             jsonData.sort(function (a, b) {
        //                 return a.id - b.id;
        //             });
        //             workspacesModel = jsonData; // Update the model
        //             // Find the active workspace (can also get from hyprctl activeworkspace -j)
        //             var activeWs = workspacesModel.find(ws => ws.windows > 0); // Simple check, might need refinement
        //             // A more reliable way is to call 'hyprctl activeworkspace -j' separately
        //             // For simplicity, we'll just mark the first one with windows for now.
        //             // Or better: parse 'hyprctl monitors -j' which lists activeWorkspace per monitor.
        //             // Let's call activeworkspace:
        //             fetchActiveWorkspace();
        //         } catch (e) {
        //             console.error("Error parsing hyprctl workspaces JSON:", e, stdout);
        //             workspacesModel = []; // Clear model on error
        //         }
        //     } else {
        //         console.error("hyprctl workspaces command failed:", stderr);
        //         workspacesModel = []; // Clear model on error
        //     }
        // }
        // onErrorChanged: {
        //     if (error != Process.NoError) {
        //         console.error("hyprctl workspaces process error:", errorString);
        //         workspacesModel = [];
        //     }
        // }
    }

    // Process to fetch active workspace ID
    Process {
        id: activeWsProcess
        command: "hyprctl activeworkspace -j"
        // onFinished: {
        //     if (exitCode === 0) {
        //         try {
        //             var jsonData = JSON.parse(stdout);
        //             activeWorkspaceId = jsonData.id;
        //         } catch (e) {
        //             console.error("Error parsing hyprctl activeworkspace JSON:", e, stdout);
        //             activeWorkspaceId = -1;
        //         }
        //     } else {
        //         console.error("hyprctl activeworkspace command failed:", stderr);
        //         activeWorkspaceId = -1;
        //     }
        // }
        // onErrorChanged: {
        //     if (error != Process.NoError) {
        //         console.error("hyprctl activeworkspace process error:", errorString);
        //         activeWorkspaceId = -1;
        //     }
        // }
    }

    // Timer to periodically update workspace info
    Timer {
        id: updateTimer
        interval: 2000 // Update every 2 seconds (adjust as needed)
        // Consider using 'hyprctl events' via socat for real-time updates if performance is critical
        running: true
        repeat: true
        onTriggered: {
            if (hyprctlProcess.state === Process.NotRunning && activeWsProcess.state === Process.NotRunning) {
                hyprctlProcess.exec(); // Fetch all workspaces
            }
            // Note: Fetching active workspace separately ensures we have the latest active ID
            // even if the main workspace list update is slightly delayed.
        }
    }

    // Function to trigger active workspace fetch (called after main list is updated)
    function fetchActiveWorkspace() {
        if (activeWsProcess.state === Process.NotRunning) {
            activeWsProcess.exec();
        }
    }

    // Initial fetch on component load
    Component.onCompleted: {
        hyprctlProcess.exec();
    }

    // --- Layout for displaying workspaces ---
    Flow {
        // Use Flow to wrap workspaces if they exceed width
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        // Repeater to create buttons for each workspace
        Repeater {
            model: workspacesModel

            delegate: Rectangle {
                required property var modelData // Access workspace data (id, name, etc.)
                width: 30
                height: 30
                radius: 15 // Make it circular
                // Highlight the active workspace
                color: modelData.id === activeWorkspaceId ? "#bd93f9" : "#44475a" // Purple if active, gray otherwise
                border.color: "#6272a4" // Dracula comment color for border
                border.width: 1

                // Display workspace ID or name
                Text {
                    text: modelData.id // Or use modelData.name if preferred
                    anchors.centerIn: parent
                    color: modelData.id === activeWorkspaceId ? "#282a36" : "#f8f8f2" // Dark text on active, light otherwise
                    font.bold: modelData.id === activeWorkspaceId
                    font.pointSize: 9
                }

                // Make the workspace clickable
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        console.log("Switching to workspace:", modelData.id);
                        var switchProc = Quickshell.Io.Process.create();
                        // Command to switch workspace
                        switchProc.exec("hyprctl dispatch workspace " + modelData.id);
                        switchProc.finished.connect(function () {
                            if (switchProc.exitCode !== 0) {
                                console.error("Failed to switch workspace:", switchProc.stderr);
                            } else {
                                // Optionally trigger an immediate refresh after switching
                                if (hyprctlProcess.state === Process.NotRunning) {
                                    hyprctlProcess.exec();
                                }
                            }
                            switchProc.destroy();
                        });
                    }
                }
            }
        }
    }
}
