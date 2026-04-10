import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Reusable tool section container
Rectangle {
    id: toolSection
    Layout.fillWidth: true
    implicitHeight: contentLoader.item ? contentLoader.item.implicitHeight + 24 : 100
    color: "#252538"
    radius: 6

    property string sectionIcon: ""
    property string sectionTitle: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Header row
        Row {
            spacing: 8
            Text { text: toolSection.sectionIcon; font.pixelSize: 16 }
            Text { text: toolSection.sectionTitle; font.pixelSize: 13; font.bold: true; color: "#ffffff" }
        }

        // Content area - use Loader to inject content
        Loader {
            id: contentLoader
            Layout.fillWidth: true
            sourceComponent: contentComponent
        }
    }

    // Default content component - can be overridden
    property alias contentComponent: contentComponent

    Component {
        id: contentComponent
        Item {
            implicitHeight: 40
        }
    }
}
