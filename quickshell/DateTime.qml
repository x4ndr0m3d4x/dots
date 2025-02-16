pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property var date: formatDate(new Date())
    property string time: formatTime(new Date())

    Timer {
        interval: 1000 * 60
        running: true
        repeat: true
        onTriggered: { 
            date = formatDate(new Date())
            time = formatTime(new Date())
        }
    }

    function formatDate(date) {
        let day = date.getDate();
        let suffix = getDateSuffix(day);
        let month = Qt.formatDate(date, "MMMM");
        return `${day}${suffix} of ${month}`;
    }

    function formatTime(date) {
        return Qt.formatTime(date, "hh:mm");
    }

    function getDateSuffix(day) {
        if (day >= 11 && day <= 13) return "th";
        switch (day % 10) {
            case 1: return "st";
            case 2: return "nd";
            case 3: return "rd";
            default: return "th";
        }
    }
}
