import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Visualization panel showing all charts in a scrollable list
ColumnLayout {
    id: visualizationPanel
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 0

    property string accentColor: "#A855F7"
    property string backgroundColor: "#1e1e2e"
    property string textSecondary: "#a0a0b0"
    property string textColor: "#ffffff"

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: visualizationPanel.backgroundColor

        ScrollView {
            anchors.fill: parent
            clip: true

            ColumnLayout {
                width: parent.width - 32
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                // Waveform Card
                ChartCard {
                    Layout.fillWidth: true
                    cardTitle: "Waveform"
                    cardIcon: "📈"
                    chartType: "waveform"
                    accentColor: visualizationPanel.accentColor
                    backgroundColor: visualizationPanel.backgroundColor
                    textColor: visualizationPanel.textColor
                    textSecondary: visualizationPanel.textSecondary
                }

                // Spectrogram Card
                ChartCard {
                    Layout.fillWidth: true
                    cardTitle: "Spectrogram"
                    cardIcon: "🌈"
                    chartType: "spectrogram"
                    accentColor: visualizationPanel.accentColor
                    backgroundColor: visualizationPanel.backgroundColor
                    textColor: visualizationPanel.textColor
                    textSecondary: visualizationPanel.textSecondary
                }

                // Mel Spectrogram Card
                ChartCard {
                    Layout.fillWidth: true
                    cardTitle: "Mel Spectrogram"
                    cardIcon: "🎵"
                    chartType: "melspectrogram"
                    accentColor: visualizationPanel.accentColor
                    backgroundColor: visualizationPanel.backgroundColor
                    textColor: visualizationPanel.textColor
                    textSecondary: visualizationPanel.textSecondary
                }

                // Chroma Card
                ChartCard {
                    Layout.fillWidth: true
                    cardTitle: "Chroma"
                    cardIcon: "🎹"
                    chartType: "chroma"
                    accentColor: visualizationPanel.accentColor
                    backgroundColor: visualizationPanel.backgroundColor
                    textColor: visualizationPanel.textColor
                    textSecondary: visualizationPanel.textSecondary
                }

                // Tempogram Card
                ChartCard {
                    Layout.fillWidth: true
                    cardTitle: "Tempogram"
                    cardIcon: "⏱"
                    chartType: "tempogram"
                    accentColor: visualizationPanel.accentColor
                    backgroundColor: visualizationPanel.backgroundColor
                    textColor: visualizationPanel.textColor
                    textSecondary: visualizationPanel.textSecondary
                }

                Item { Layout.fillHeight: true }
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

    function setStatus(text) {
        statusText.text = text
    }

    function getStatus() {
        return statusText.text
    }

    function generateAllCharts() {
        chartBackend.generate_chart('waveform')
    }
}
