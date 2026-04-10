import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Visualization area with chart tabs
ColumnLayout {
    id: visualizationPanel
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 0

    property var chartTypes: ["waveform", "spectrogram", "melspectrogram", "chroma", "tempogram"]
    property string currentChart: "waveform"
    property string accentColor: "#A855F7"
    property string backgroundColor: "#1e1e2e"
    property string textSecondary: "#a0a0b0"

    signal chartChanged(string chartType)

    // Chart type selector
    Rectangle {
        Layout.fillWidth: true
        height: 48
        color: visualizationPanel.backgroundColor

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            spacing: 8

            Repeater {
                model: ["Waveform", "Spectrogram", "Mel Spec", "Chroma", "Tempogram"]
                
                Button {
                    text: modelData
                    flat: true
                    padding: 8

                    background: Rectangle {
                        color: parent.hovered ? "#3a3a4c" : (visualizationPanel.chartTypes[index] === visualizationPanel.currentChart ? visualizationPanel.accentColor : "transparent")
                        radius: 6
                    }

                    contentItem: Text {
                        text: modelData
                        font.pixelSize: 12
                        font.bold: visualizationPanel.chartTypes[index] === visualizationPanel.currentChart
                        color: visualizationPanel.chartTypes[index] === visualizationPanel.currentChart ? "#ffffff" : visualizationPanel.textSecondary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        visualizationPanel.currentChart = visualizationPanel.chartTypes[index]
                        visualizationPanel.chartChanged(visualizationPanel.currentChart)
                    }
                }
            }
        }
    }

    // Chart display area
    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: visualizationPanel.backgroundColor

        ScrollView {
            anchors.fill: parent
            clip: true

            Column {
                width: parent.width
                spacing: 0

            Image {
                id: chartImage
                source: chartBackend && chartBackend.chart_image_path ? "file:///" + chartBackend.chart_image_path : ""
                fillMode: Image.PreserveAspectFit
                width: parent.width
                height: Math.max(implicitHeight, parent.height)
                asynchronous: true

                Component.onCompleted: {
                    if (!chartBackend) {
                        console.error("chartBackend not available in QML context")
                    }
                }
            }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Load an audio file to see visualization"
                    font.pixelSize: 16
                    color: visualizationPanel.textSecondary
                    visible: chartImage.source === ""
                    y: parent.height / 2 - height / 2
                }
            }
        }

        Connections {
            target: chartBackend
            function onChart_image_changed() {
                // Force image reload by updating the source
                chartImage.source = ""
                if (chartBackend.chart_image_path) {
                    chartImage.source = "file:///" + chartBackend.chart_image_path
                }
            }
        }
    }

    // Status bar
    Rectangle {
        Layout.fillWidth: true
        height: 32
        color: "#2a2a3c"

        Text {
            id: statusText
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            text: "Ready"
            font.pixelSize: 12
            color: visualizationPanel.textSecondary
        }
    }

    // Expose status text for external updates
    function setStatus(text) {
        statusText.text = text
    }

    function getStatus() {
        return statusText.text
    }
}
