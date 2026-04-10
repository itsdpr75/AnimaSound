import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Drop zone for audio files - shows upload area or file info
Rectangle {
    id: dropZone
    Layout.fillWidth: true
    Layout.preferredHeight: audioLoaded ? 100 : 250
    color: backgroundColor

    property bool audioLoaded: false
    property string fileName: ""
    property double duration: 0
    property int sampleRate: 0
    property int channels: 0
    property string accentColor: "#A855F7"
    property string backgroundColor: "#1e1e2e"
    property string textColor: "#ffffff"
    property string textSecondary: "#a0a0b0"

    signal fileSelected(string filePath)
    signal browseClicked()

    function formatDuration(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0')
    }

    DropArea {
        id: dropAreaInternal
        anchors.fill: parent
        onDropped: function(drop) {
            if (drop.urls.length > 0) {
                var url = drop.urls[0]
                var path = url.toString()
                if (path.indexOf("file://") === 0) {
                    path = path.substring(7)
                }
                console.log("Dropped:", path)
                dropZone.fileSelected(path)
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !audioLoaded
        onClicked: dropZone.browseClicked()
    }

    // Drop zone content (when no audio)
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16
        visible: !audioLoaded

        Text {
            text: "🎵"
            font.pixelSize: 64
            color: dropZone.accentColor
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: "Drag and drop an audio file here"
            font.pixelSize: 20
            color: dropZone.textColor
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: "or click to browse"
            font.pixelSize: 14
            color: dropZone.textSecondary
            Layout.alignment: Qt.AlignCenter
        }

        Button {
            id: browseButton
            text: "Browse Files"
            Layout.alignment: Qt.AlignCenter
            padding: 12
            leftPadding: 24
            rightPadding: 24

            background: Rectangle {
                color: dropZone.accentColor
                radius: 8
                Rectangle {
                    anchors.fill: parent
                    color: "#ffffff"
                    opacity: parent.hovered ? 0.1 : 0
                    radius: 8
                }
            }

            contentItem: Text {
                text: browseButton.text
                font.pixelSize: 14
                font.bold: true
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: dropZone.browseClicked()
        }
    }

    // File info (when audio loaded)
    RowLayout {
        anchors.centerIn: parent
        spacing: 32
        visible: audioLoaded

        // File column
        ColumnLayout {
            spacing: 4
            Text { text: "File"; font.pixelSize: 12; color: dropZone.textSecondary }
            Text { text: dropZone.fileName; font.pixelSize: 16; font.bold: true; color: dropZone.textColor }
        }

        Rectangle { width: 1; height: 40; color: "#404050" }

        // Duration column
        ColumnLayout {
            spacing: 4
            Text { text: "Duration"; font.pixelSize: 12; color: dropZone.textSecondary }
            Text { text: dropZone.formatDuration(dropZone.duration); font.pixelSize: 16; font.bold: true; color: dropZone.accentColor }
        }

        Rectangle { width: 1; height: 40; color: "#404050" }

        // Sample rate column
        ColumnLayout {
            spacing: 4
            Text { text: "Sample Rate"; font.pixelSize: 12; color: dropZone.textSecondary }
            Text { text: dropZone.sampleRate + " Hz"; font.pixelSize: 16; font.bold: true; color: dropZone.accentColor }
        }

        Rectangle { width: 1; height: 40; color: "#404050" }

        // Channels column
        ColumnLayout {
            spacing: 4
            Text { text: "Channels"; font.pixelSize: 12; color: dropZone.textSecondary }
            Text {
                text: {
                    if (dropZone.channels === 1) return "Mono"
                    if (dropZone.channels === 2) return "Stereo"
                    return dropZone.channels.toString()
                }
                font.pixelSize: 16
                font.bold: true
                color: dropZone.accentColor
            }
        }

        Button {
            id: changeFileButton
            text: "Change File"
            Layout.leftMargin: 16

            background: Rectangle {
                color: "transparent"
                border.color: dropZone.accentColor
                border.width: 1
                radius: 6
                Rectangle {
                    anchors.fill: parent
                    color: dropZone.accentColor
                    opacity: parent.hovered ? 0.2 : 0
                    radius: 6
                }
            }

            contentItem: Text {
                text: changeFileButton.text
                font.pixelSize: 13
                color: dropZone.accentColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: dropZone.browseClicked()
        }
    }
}
