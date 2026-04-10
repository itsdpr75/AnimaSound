import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Header bar with title and window controls
Rectangle {
    id: headerBar
    height: 60
    color: surfaceColor

    property string titleText: "AnimaSound"
    property string accentColor: "#A855F7"
    property string surfaceColor: "#2a2a3c"
    property string textColor: "#ffffff"

    signal minimizeClicked()
    signal maximizeClicked()
    signal closeClicked()

    RowLayout {
        anchors.fill: parent
        spacing: 20

        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                width: 32
                height: 32
                radius: 8
                color: headerBar.accentColor

                Text {
                    anchors.centerIn: parent
                    text: "♪"
                    font.pixelSize: 18
                    color: "#ffffff"
                }
            }

            Text {
                text: headerBar.titleText
                font.pixelSize: 20
                font.bold: true
                color: headerBar.textColor
            }
        }

        Item { Layout.fillWidth: true }

        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            // Minimize button
            Button {
                width: 40
                height: 32
                text: "─"
                flat: true
                onClicked: headerBar.minimizeClicked()
                background: Rectangle {
                    color: parent.hovered ? "#404050" : "transparent"
                    radius: 4
                }
            }

            // Maximize button
            Button {
                width: 40
                height: 32
                text: "□"
                flat: true
                onClicked: headerBar.maximizeClicked()
                background: Rectangle {
                    color: parent.hovered ? "#404050" : "transparent"
                    radius: 4
                }
            }

            // Close button
            Button {
                width: 40
                height: 32
                text: "✕"
                flat: true
                onClicked: headerBar.closeClicked()
                background: Rectangle {
                    color: parent.hovered ? "#ff4444" : "transparent"
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14
                    color: parent.hovered ? "#ffffff" : headerBar.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
