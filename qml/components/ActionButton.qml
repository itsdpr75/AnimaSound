import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Styled action button for tools
Button {
    id: actionButton
    Layout.fillWidth: true

    property string buttonText: "Apply"
    property string buttonColor: "#A855F7"

    text: actionButton.buttonText

    background: Rectangle {
        color: actionButton.buttonColor
        radius: 6
        Rectangle {
            anchors.fill: parent
            color: "#ffffff"
            opacity: parent.hovered ? 0.1 : 0
            radius: parent.radius
        }
    }

    contentItem: Text {
        text: actionButton.buttonText
        font.pixelSize: 13
        font.bold: true
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
