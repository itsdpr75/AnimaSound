import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

ApplicationWindow {
    id: root
    visible: true
    width: 1400
    height: 900
    minimumWidth: 1000
    minimumHeight: 700
    title: qsTr("AnimaSound")
    color: "#121218"
    flags: Qt.FramelessWindowHint | Qt.Window

    // Theme colors
    readonly property string accentColor: "#A855F7"
    readonly property string backgroundColor: "#1e1e2e"
    readonly property string surfaceColor: "#2a2a3c"
    readonly property string textColor: "#ffffff"
    readonly property string textSecondary: "#a0a0b0"

    // Audio state
    property bool audioLoaded: false
    property string fileName: ""
    property double duration: 0
    property int sampleRate: 0
    property int channels: 0
    property bool isProcessing: false
    property string processingStatus: ""
    property double processingProgress: 0

    // For dragging the frameless window
    property int dragOffsetX: 0
    property int dragOffsetY: 0

    // Use components
    header: AppHeader {
        titleText: "AnimaSound"
        accentColor: root.accentColor
        surfaceColor: root.surfaceColor
        textColor: root.textColor

        onMinimizeClicked: root.showMinimized()
        onMaximizeClicked: root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized()
        onCloseClicked: Qt.quit()

        // Drag support for frameless window
        MouseArea {
            anchors.fill: parent
            onPressed: function(mouse) {
                root.dragOffsetX = mouse.x
                root.dragOffsetY = mouse.y
            }
            onPositionChanged: function(mouse) {
                root.x = root.x + (mouse.x - root.dragOffsetX)
                root.y = root.y + (mouse.y - root.dragOffsetY)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Drop zone
        DropZone {
            id: dropZone
            audioLoaded: root.audioLoaded
            fileName: root.fileName
            duration: root.duration
            sampleRate: root.sampleRate
            channels: root.channels
            accentColor: root.accentColor
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            textSecondary: root.textSecondary

            onFileSelected: function(filePath) {
                audioProcessor.load_file(filePath)
            }

            onBrowseClicked: {
                audioProcessor.browse_file()
            }
        }

        // Divider
        Rectangle { Layout.fillWidth: true; height: 1; color: "#2a2a3c" }

        // Main workspace
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Tools panel
            ToolPanel {
                id: toolsPanel
                accentColor: root.accentColor
                surfaceColor: root.surfaceColor
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                textSecondary: root.textSecondary

                onTimeStretchApplied: function(rate) {
                    audioProcessor.time_stretch(rate)
                }

                onPitchShiftApplied: function(semitones) {
                    audioProcessor.pitch_shift(semitones)
                }

                onHpssApplied: {
                    audioProcessor.separate_hpss()
                }

                onTrimSilenceApplied: function(threshold) {
                    audioProcessor.trim_silence(threshold)
                }

                onNormalizeApplied: {
                    audioProcessor.normalize_audio()
                }

                onSaveAudioClicked: {
                    audioProcessor.browse_save()
                }
            }

            // Divider
            Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: "#2a2a3c" }

            // Right side - Processing bar + Visualization
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Progress bar (shown during processing)
                Rectangle {
                    Layout.fillWidth: true
                    height: root.isProcessing ? 48 : 0
                    color: root.backgroundColor
                    visible: root.isProcessing
                    clip: true

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Text {
                            text: "⏳"
                            font.pixelSize: 16
                        }

                        Text {
                            text: root.processingStatus
                            font.pixelSize: 13
                            color: root.textColor
                            Layout.fillWidth: true
                            elide: Text.ElideMiddle
                        }

                        Text {
                            text: Math.round(root.processingProgress) + "%"
                            font.pixelSize: 13
                            font.bold: true
                            color: root.accentColor
                            width: 50
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: root.accentColor
                    visible: root.isProcessing
                    clip: true

                    Rectangle {
                        width: parent.width * (root.processingProgress / 100.0)
                        height: parent.height
                        color: root.accentColorLight
                    }
                }

                // Visualization panel
                VisualizationPanel {
                    id: vizPanel
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    accentColor: root.accentColor
                    backgroundColor: root.backgroundColor
                    textSecondary: root.textSecondary

                    onChartChanged: function(chartType) {
                        console.log("Chart changed:", chartType)
                        if (root.audioLoaded) {
                            vizPanel.setStatus("Generating " + chartType + " chart...")
                            chartBackend.generate_chart(chartType)
                        }
                    }
                }
            }
        }
    }

    // Connections to audio processor
    Connections {
        target: audioProcessor

        function onFile_loaded(filename, dur, sr, ch) {
            root.audioLoaded = true
            root.fileName = filename
            root.duration = dur
            root.sampleRate = sr
            root.channels = ch
            root.isProcessing = false
            root.processingProgress = 100
            vizPanel.setStatus("Loaded: " + filename)
            chartBackend.generate_chart('waveform')
        }

        function onError_occurred(message) {
            root.isProcessing = false
            root.processingProgress = 0
            vizPanel.setStatus("Error: " + message)
            console.error(message)
        }

        function onAnalysis_complete(results) {
            root.isProcessing = false
            root.processingProgress = 100
            vizPanel.setStatus("Analysis complete - Tempo: " + results['tempo'].toFixed(1) + " BPM")
        }

        function onProcessing_started(statusText) {
            root.isProcessing = true
            root.processingProgress = 0
            root.processingStatus = statusText
            vizPanel.setStatus(statusText)
        }

        function onProgress_updated(progress) {
            root.processingProgress = progress
        }

        function onProcessing_complete(results) {
            root.isProcessing = false
            root.processingProgress = 100
            vizPanel.setStatus(results['status'])
        }
    }

    // Connections to chart backend
    Connections {
        target: chartBackend

        function onChart_ready(chartType) {
            root.isProcessing = false
            root.processingProgress = 100
            vizPanel.setStatus("Chart ready: " + chartType)
        }

        function onChart_error(message) {
            root.isProcessing = false
            root.processingProgress = 0
            vizPanel.setStatus("Chart error: " + message)
            console.error(message)
        }
    }
}
