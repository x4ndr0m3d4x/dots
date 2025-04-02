import QtQuick
import QtQuick.Layouts
import Quickshell.Io

// Displays currently playing media info from playerctl
Rectangle {
    id: mediaRoot
    color: "transparent" // Or a subtle background
    radius: 5

    property string mediaStatus: "Stopped" // Playing, Paused, Stopped, NoPlayer
    property string mediaTitle: "Nothing Playing"
    property string mediaArtist: ""
    property string mediaInfo: "Nothing Playing" // Combined info

    // Process to fetch media metadata and status
    Process {
        id: playerctlProcess

        // Get status and metadata in one go if possible, or chain commands.
        // Using status first, then metadata if playing/paused.
        command: "playerctl status"

        onFinished: {
            if (exitCode === 0) {
                var statusOutput = stdout.trim();
                if (statusOutput === "Playing" || statusOutput === "Paused") {
                    mediaStatus = statusOutput;
                    // If playing or paused, get metadata
                    fetchMetadata();
                } else {
                    // Covers "Stopped" or any other output (implies no player or stopped)
                    mediaStatus = "Stopped";
                    mediaTitle = "Nothing Playing";
                    mediaArtist = "";
                    updateMediaInfo();
                }
            } else {
                // playerctl might return non-zero if no players are running
                if (stderr.includes("No players found")) {
                    mediaStatus = "NoPlayer";
                } else {
                    mediaStatus = "Error";
                    console.error("playerctl status command failed:", stderr);
                }
                mediaTitle = "Nothing Playing";
                mediaArtist = "";
                updateMediaInfo();
            }
        }
        onErrorChanged: {
            if (error != Process.NoError) {
                console.error("playerctl status process error:", errorString);
                mediaStatus = "Error";
                mediaTitle = "Nothing Playing";
                mediaArtist = "";
                updateMediaInfo();
            }
        }
    }

    // Process specifically for metadata (called by the status process)
    Process {
        id: metadataProcess
        // Format: Artist - Title. Adjust {{...}} fields as needed. See 'playerctl metadata -h'
        command: "playerctl metadata --format '{{artist}} - {{title}}'"

        onFinished: {
            if (exitCode === 0) {
                var fullTitle = stdout.trim();
                // Basic split, might need refinement if artist/title contains '-'
                var parts = fullTitle.split(' - ');
                if (parts.length >= 2) {
                    mediaArtist = parts[0].trim();
                    mediaTitle = parts.slice(1).join(' - ').trim(); // Join back if title had '-'
                } else {
                    mediaArtist = ""; // No artist found
                    mediaTitle = fullTitle; // Assume the whole output is the title
                }
            } else {
                console.error("playerctl metadata command failed:", stderr);
                // Keep previous title/artist? Or clear them? Clearing might be confusing.
                // Let's clear them if metadata fails.
                mediaTitle = "Metadata Error";
                mediaArtist = "";
            }
            updateMediaInfo(); // Update the display text
        }
        onErrorChanged: {
            if (error != Process.NoError) {
                console.error("playerctl metadata process error:", errorString);
                mediaTitle = "Metadata Error";
                mediaArtist = "";
                updateMediaInfo();
            }
        }
    }

    // Function to trigger metadata fetch
    function fetchMetadata() {
        if (metadataProcess.state === Process.NotRunning) {
            metadataProcess.exec();
        }
    }

    // Function to update the combined mediaInfo string
    function updateMediaInfo() {
        if (mediaStatus === "Playing" || mediaStatus === "Paused") {
            if (mediaArtist !== "") {
                mediaInfo = mediaArtist + " - " + mediaTitle;
            } else {
                mediaInfo = mediaTitle;
            }
        } else if (mediaStatus === "NoPlayer" || mediaStatus === "Stopped") {
            mediaInfo = "Nothing Playing";
        } else {
            mediaInfo = "Media Status Error";
        }
    }

    // Timer to periodically update media info
    Timer {
        id: updateTimer
        interval: 3000 // Update every 3 seconds (adjust as needed)
        // Consider using 'playerctl --follow' or D-Bus for real-time updates
        running: true
        repeat: true
        onTriggered: {
            if (playerctlProcess.state === Process.NotRunning && metadataProcess.state === Process.NotRunning) {
                playerctlProcess.exec(); // Start the update chain
            }
        }
    }

    // Initial fetch on component load
    Component.onCompleted: {
        playerctlProcess.exec();
    }

    // --- Layout for displaying media info ---
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        // Media Status Icon (Example using text)
        Text {
            id: statusIcon
            text: {
                switch (mediaStatus) {
                case "Playing":
                    return "▶"; // Play icon
                case "Paused":
                    return "⏸"; // Pause icon
                default:
                    return "⏹"; // Stop icon (covers Stopped, NoPlayer, Error)
                }
            }
            color: {
                // Change color based on status
                switch (mediaStatus) {
                case "Playing":
                    return "#50fa7b"; // Dracula green
                case "Paused":
                    return "#ffb86c"; // Dracula orange
                default:
                    return "#6272a4"; // Dracula comment/gray
                }
            }
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        // Media Info Text (Scrolling if too long)
        Flickable { // Allows scrolling if text overflows
            id: flickableArea
            width: parent.width
            height: mediaText.implicitHeight > 35 ? 35 : mediaText.implicitHeight // Limit height
            contentWidth: mediaText.implicitWidth
            contentHeight: mediaText.implicitHeight
            clip: true // Clip content outside the flickable area
            flickableDirection: Flickable.HorizontalFlick // Allow horizontal scrolling

            Text {
                id: mediaText
                text: mediaInfo // Display combined artist/title
                color: "#f8f8f2" // Dracula foreground
                font.pointSize: 8
                // No wrapMode needed because Flickable handles overflow
            }

            // Optional: Add simple scroll indicator (e.g., fade effect) if needed
        }

        // Media Control Buttons (Optional)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Button {
                text: "⏮" // Previous
                font.pointSize: 10
                onClicked: runMediaCommand("previous")
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "#f8f8f2"
                }
            }
            Button {
                text: (mediaStatus === "Playing" ? "⏸" : "▶") // Play/Pause toggle
                font.pointSize: 10
                onClicked: runMediaCommand("play-pause")
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "#f8f8f2"
                }
            }
            Button {
                text: "⏭" // Next
                font.pointSize: 10
                onClicked: runMediaCommand("next")
                background: Rectangle {
                    color: "transparent"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "#f8f8f2"
                }
            }
        }
    }

    // Function to run playerctl commands
    function runMediaCommand(command) {
        console.log("Running playerctl command:", command);
        var mediaProc = Quickshell.Io.Process.create();
        mediaProc.exec("playerctl " + command);
        mediaProc.finished.connect(function () {
            if (mediaProc.exitCode !== 0) {
                console.error("playerctl", command, "failed:", mediaProc.stderr);
            } else {
                // Trigger an immediate refresh after action
                if (playerctlProcess.state === Process.NotRunning) {
                    playerctlProcess.exec();
                }
            }
            mediaProc.destroy();
        });
    }
}
