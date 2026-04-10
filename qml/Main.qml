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

    // Use components
    header: AppHeader {
        titleText: "AnimaSound"
        accentColor: root.accentColor
        surfaceColor: root.surfaceColor
        textColor: root.textColor

        onMinimizeClicked: root.showMinimized()
        onMaximizeClicked: root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized()
        onCloseClicked: Qt.quit()
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

            // Visualization panel
            VisualizationPanel {
                id: vizPanel
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

    // Connections to audio processor
    Connections {
        target: audioProcessor

        function onFile_loaded(filename, dur, sr, ch) {
            root.audioLoaded = true
            root.fileName = filename
            root.duration = dur
            root.sampleRate = sr
            root.channels = ch
            vizPanel.setStatus("Loaded: " + filename)
            // Generate initial waveform chart
            chartBackend.generate_chart('waveform')
        }

        function onError_occurred(message) {
            vizPanel.setStatus("Error: " + message)
            console.error(message)
        }

        function onAnalysis_complete(results) {
            vizPanel.setStatus("Analysis complete - Tempo: " + results['tempo'].toFixed(1) + " BPM")
        }

        function onProcessing_complete(results) {
            vizPanel.setStatus(results['status'])
        }
    }

    // Connections to chart backend
    Connections {
        target: chartBackend

        function onChart_ready(chartType) {
            vizPanel.setStatus("Chart ready: " + chartType)
        }

        function onChart_error(message) {
            vizPanel.setStatus("Chart error: " + message)
            console.error(message)
        }
    }
}
