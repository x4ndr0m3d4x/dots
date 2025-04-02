import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    id: clock
    width: 100
    height: 35
    spacing: 2

    Timer {
        interval: 1000 // Once per minute
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();

            var hours = now.getHours();
            hour1.num = hours / 10;
            hour2.num = hours % 10;

            var minutes = now.getMinutes();
            minute1.num = minutes / 10;
            minute2.num = minutes % 10;

            var seconds = now.getSeconds();
            second1.num = seconds / 10;
            second2.num = seconds % 10;
        }
    }

    RowLayout {
        spacing: 0

        ClockNumber {
            id: hour1
        }

        ClockNumber {
            id: hour2
        }
    }

    Text {
        id: hour_minute_colon
        Layout.fillHeight: true
        text: ":"
        font.pointSize: 18
        color: "white"
    }

    RowLayout {
        spacing: 0

        ClockNumber {
            id: minute1
        }

        ClockNumber {
            id: minute2
        }
    }

    Text {
        id: minute_second_colon
        Layout.fillHeight: true
        text: ":"
        font.pointSize: 18
        color: "white"
    }

    RowLayout {
        spacing: 0

        ClockNumber {
            id: second1
        }

        ClockNumber {
            id: second2
        }
    }
}
