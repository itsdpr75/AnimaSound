import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Chart card component
Rectangle {
    id: chartCard
    Layout.fillWidth: true
    Layout.preferredHeight: 250

    property string cardTitle: "Chart"
    property string cardIcon: "📊"
    property string chartType: ""
    property string accentColor: "#A855F7"
    property string backgroundColor: "#1e1e2e"
    property string textColor: "#ffffff"
    property string textSecondary: "#a0a0b0"

    color: backgroundColor
    radius: 8
    border.color: "#3a3a4c"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // Chart header
        RowLayout {
            spacing: 8

            Text {
                text: chartCard.cardIcon
                font.pixelSize: 20
            }

            Text {
                text: chartCard.cardTitle
                font.pixelSize: 16
                font.bold: true
                color: chartCard.textColor
                Layout.fillWidth: true
            }

            Button {
                text: "🔄 Generate"
                font.pixelSize: 12
                background: Rectangle {
                    color: parent.hovered ? Qt.lighter(chartCard.accentColor, 1.2) : chartCard.accentColor
                    radius: 6
                }
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    chartBackend.generate_chart(chartCard.chartType)
                }
            }
        }

        // Chart image area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#151520"
            radius: 6

            Text {
                anchors.centerIn: parent
                text: "Chart will appear here"
                font.pixelSize: 14
                color: chartCard.textSecondary
            }
        }
    }
}
