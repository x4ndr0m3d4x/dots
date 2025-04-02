import QtQuick
import QtQuick.Layouts
import Quickshell.Io

// Displays the title of the active Hyprland window
Rectangle {
    id: windowRoot
    color: "transparent" // Or a subtle background
    radius: 5

    property string activeWindowTitle: "..." // Placeholder

    // Process to fetch active window data
    Process {
        id: hyprctlProcess

        // Command to get active window in JSON format
        command: "hyprctl activewindow -j"

        // Handle successful command execution
        onFinished: {
            if (exitCode === 0) {
                try {
                    // Parse the JSON output
                    var jsonData = JSON.parse(stdout);
                    // Update the property - use class or title as available
                    activeWindowTitle = jsonData.title || jsonData.class || "Unknown Window";
                    if (activeWindowTitle.length > 50) {
                        // Truncate long titles
                        activeWindowTitle = activeWindowTitle.substring(0, 47) + "...";
                    }
                } catch (e) {
                    console.error("Error parsing hyprctl activewindow JSON:", e, stdout);
                    activeWindowTitle = "Error Parsing";
                }
            } else {
                // Handle cases where no window is active or command fails
                if (stderr.includes("No active window")) {
                    activeWindowTitle = "No Active Window";
                } else {
                    console.error("hyprctl activewindow command failed:", stderr);
                    activeWindowTitle = "Error Fetching";
                }
            }
        }
        onErrorChanged: {
            if (error != Process.NoError) {
                console.error("hyprctl activewindow process error:", errorString);
                activeWindowTitle = "Process Error";
            }
        }
    }

    // Timer to periodically update active window info
    Timer {
        id: updateTimer
        interval: 1500 // Update every 1.5 seconds (adjust as needed)
        // Consider using 'hyprctl events' (specifically 'activewindowv2') via socat for real-time updates
        running: true
        repeat: true
        onTriggered: {
            if (hyprctlProcess.state === Process.NotRunning) {
                hyprctlProcess.exec();
            }
        }
    }

    // Initial fetch on component load
    Component.onCompleted: {
        hyprctlProcess.exec();
    }

    // --- Layout for displaying the window title ---
    Flickable {
        // Use Flickable in case title is very long
        anchors.fill: parent
        anchors.margins: 3
        contentWidth: titleText.implicitWidth
        contentHeight: titleText.implicitHeight
        clip: true
        flickableDirection: Flickable.HorizontalFlick

        Text {
            id: titleText
            text: activeWindowTitle
            color: "#f1fa8c" // Dracula yellow (example)
            font.pointSize: 8
            font.italic: true
            // Elide or wrap as preferred, Flickable handles overflow
            // elide: Text.ElideRight
            // wrapMode: Text.WordWrap // If you prefer wrapping over scrolling
        }
    }
}
