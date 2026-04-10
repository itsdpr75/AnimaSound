import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Tools panel with audio effects
Rectangle {
    id: toolsPanel
    Layout.preferredWidth: 320
    Layout.fillHeight: true
    color: surfaceColor

    property string accentColor: "#A855F7"
    property string surfaceColor: "#2a2a3c"
    property string backgroundColor: "#1e1e2e"
    property string textColor: "#ffffff"
    property string textSecondary: "#a0a0b0"

    signal timeStretchApplied(double rate)
    signal pitchShiftApplied(double semitones)
    signal hpssApplied()
    signal trimSilenceApplied(double threshold)
    signal normalizeApplied()
    signal saveAudioClicked()

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 48
            color: toolsPanel.backgroundColor

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: "Audio Effects"
                font.pixelSize: 14
                font.bold: true
                color: toolsPanel.textColor
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: 320
                spacing: 8

                // Time Stretch Section
                Rectangle {
                    Layout.fillWidth: true
                    height: 160
                    color: "#252538"
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Row { spacing: 8
                            Text { text: "⏱"; font.pixelSize: 16 }
                            Text { text: "Time Stretch"; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
                        }

                        RowLayout { spacing: 8
                            Text { text: "Rate:"; color: toolsPanel.textSecondary; font.pixelSize: 13 }
                            Slider {
                                id: timeStretchSlider
                                Layout.fillWidth: true
                                from: 0.5
                                to: 2.0
                                value: 1.0
                                stepSize: 0.1
                            }
                            Text {
                                text: timeStretchSlider.value.toFixed(2)
                                color: toolsPanel.accentColor
                                font.pixelSize: 13
                                font.bold: true
                                width: 40
                            }
                        }

                        Button {
                            text: "Apply"
                            Layout.fillWidth: true
                            background: Rectangle { color: toolsPanel.accentColor; radius: 6 }
                            contentItem: Text {
                                text: "Apply"; font.pixelSize: 13; font.bold: true; color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: toolsPanel.timeStretchApplied(timeStretchSlider.value)
                        }
                    }
                }

                // Pitch Shift Section
                Rectangle {
                    Layout.fillWidth: true
                    height: 160
                    color: "#252538"
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Row { spacing: 8
                            Text { text: "🎵"; font.pixelSize: 16 }
                            Text { text: "Pitch Shift"; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
                        }

                        RowLayout { spacing: 8
                            Text { text: "Semitones:"; color: toolsPanel.textSecondary; font.pixelSize: 13 }
                            Slider {
                                id: pitchShiftSlider
                                Layout.fillWidth: true
                                from: -12
                                to: 12
                                value: 0
                                stepSize: 1
                            }
                            Text {
                                text: (pitchShiftSlider.value > 0 ? "+" : "") + pitchShiftSlider.value
                                color: toolsPanel.accentColor
                                font.pixelSize: 13
                                font.bold: true
                                width: 40
                            }
                        }

                        Button {
                            text: "Apply"
                            Layout.fillWidth: true
                            background: Rectangle { color: toolsPanel.accentColor; radius: 6 }
                            contentItem: Text {
                                text: "Apply"; font.pixelSize: 13; font.bold: true; color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: toolsPanel.pitchShiftApplied(pitchShiftSlider.value)
                        }
                    }
                }

                // HPSS Section
                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    color: "#252538"
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Row { spacing: 8
                            Text { text: "🎼"; font.pixelSize: 16 }
                            Text { text: "Harmonic/Percussive"; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
                        }

                        Button {
                            text: "Separate"
                            Layout.fillWidth: true
                            background: Rectangle { color: toolsPanel.accentColor; radius: 6 }
                            contentItem: Text {
                                text: "Separate"; font.pixelSize: 13; font.bold: true; color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: toolsPanel.hpssApplied()
                        }
                    }
                }

                // Trim Silence Section
                Rectangle {
                    Layout.fillWidth: true
                    height: 160
                    color: "#252538"
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Row { spacing: 8
                            Text { text: "✂"; font.pixelSize: 16 }
                            Text { text: "Trim Silence"; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
                        }

                        RowLayout { spacing: 8
                            Text { text: "Threshold (dB):"; color: toolsPanel.textSecondary; font.pixelSize: 13 }
                            Slider {
                                id: trimSlider
                                Layout.fillWidth: true
                                from: 10
                                to: 60
                                value: 30
                                stepSize: 1
                            }
                            Text {
                                text: "-" + trimSlider.value + " dB"
                                color: toolsPanel.accentColor
                                font.pixelSize: 13
                                font.bold: true
                                width: 60
                            }
                        }

                        Button {
                            text: "Apply"
                            Layout.fillWidth: true
                            background: Rectangle { color: toolsPanel.accentColor; radius: 6 }
                            contentItem: Text {
                                text: "Apply"; font.pixelSize: 13; font.bold: true; color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: toolsPanel.trimSilenceApplied(trimSlider.value)
                        }
                    }
                }

                // Normalize Section
                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    color: "#252538"
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Row { spacing: 8
                            Text { text: "📊"; font.pixelSize: 16 }
                            Text { text: "Normalize"; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
                        }

                        Button {
                            text: "Normalize"
                            Layout.fillWidth: true
                            background: Rectangle { color: toolsPanel.accentColor; radius: 6 }
                            contentItem: Text {
                                text: "Normalize"; font.pixelSize: 13; font.bold: true; color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: toolsPanel.normalizeApplied()
                        }
                    }
                }

                // Save Section
                Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    color: "#252538"
                    radius: 6

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Row { spacing: 8
                            Text { text: "💾"; font.pixelSize: 16 }
                            Text { text: "Save Audio"; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
                        }

                        Button {
                            text: "Save As..."
                            Layout.fillWidth: true
                            background: Rectangle { color: toolsPanel.accentColor; radius: 6 }
                            contentItem: Text {
                                text: "Save As..."; font.pixelSize: 13; font.bold: true; color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: toolsPanel.saveAudioClicked()
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
