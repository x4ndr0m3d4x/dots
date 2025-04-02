import QtQuick

Canvas {
    id: canvas

    property int paddingLeft: 4
    property int paddingRight: 4
    property int paddingTopBottom: 0
    property int num: 9
    property int textY: 50
    property int textWidth: 10

    property color bgColor: "red"
    property color boxShadow: "red"
    property bool noBackgroundForZero: false

    Component.onCompleted: {
        num = 0;
    }

    width: textWidth + paddingLeft + paddingRight
    height: Config.barHeight - paddingTopBottom

    onTextYChanged: {
        requestPaint();
    }

    onNumChanged: {
        if (num == 10)
            num = 0;

        requestPaint();
        textY = -parent.height * (num - 1);
    }

    TextMetrics {
        id: txtMeter
        font.family: "sans-serif"
        font.pixelSize: 18 / 2
        font.bold: true
        text: canvas.num
    }

    onPaint: {
        var now = new Date();
        var ctx = getContext("2d");
        ctx.reset();
        ctx.font = `bold ${18}px sans-serif`;
        for (let i = 0; i < 10; i++) {
            // --- Background ---
            // ctx.fillStyle = bgColor;
            // ctx.fillRect(0, textY + parent.height * (i - 1), textWidth + paddingRight + paddingLeft, parent.height);
            // ctx.save();
            // ctx.globalCompositeOperation = "destination-out";
            // --- Digits ---
            ctx.fillStyle = Qt.rgba(255, 255, 255, 1);
            ctx.fillText(i, paddingLeft, textY + parent.height * i - Config.barHeight / 2 + paddingTopBottom / 2 + txtMeter.tightBoundingRect.height / 2 + 3);
            ctx.globalCompositeOperation = "source-over";
            ctx.restore();
        }
    }

    Behavior on textY {
        PropertyAnimation {
            duration: 250
            easing.type: Easing.OutQuad
        }
    }
}
