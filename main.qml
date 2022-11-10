import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: rootItem
    width: 1280
    height: 720
    visible: true
    title: qsTr("Hello World")

    property real xPos       : 0.0
    property real yPos       : 0.0
    property real widthRect  : 0.0
    property real heightRect : 0.0
    property Rectangle highlightItem : null

    Rectangle {
        id: videoRender
        anchors.centerIn: parent
        width: parent.width / 2
        height: parent.height / 2
        border { color: "blue"; width: 2 }

        MouseArea {
            id: selectArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            clip: true
            property point startPoint: Qt.point(0, 0)
            onPressed: (mouse) => {
                if (rootItem.highlightItem != null) {
                    rootItem.highlightItem.destroy();
                }
                rootItem.highlightItem = highlightComponent.createObject(selectArea, {
                    "x" : mouse.x, "y" : mouse.y
                });
                startPoint = Qt.point(mouse.x, mouse.y);
            }
            onPositionChanged: (mouse) => {
                console.log(mouse.x + " - " + mouse.y)
                if (mouse.x >= 0) {
                if (mouse.x <= startPoint.x)
                    rootItem.highlightItem.x = mouse.x;
                else
                    rootItem.highlightItem.x = startPoint.x;
                if (mouse.x < 0)
                    rootItem.highlightItem.width = startPoint.x;
                else if (mouse.x > videoRender.width)
                    rootItem.highlightItem.width = videoRender.width - startPoint.x;
                else
                    rootItem.highlightItem.width = Math.abs(mouse.x - startPoint.x);
                }

                if (mouse.y >= 0) {
                if (mouse.y <= startPoint.y)
                    rootItem.highlightItem.y = mouse.y;
                else
                    rootItem.highlightItem.y = startPoint.y;
                if (mouse.y < 0)
                    rootItem.highlightItem.height =  startPoint.y;
                else if (mouse.y > videoRender.height)
                    rootItem.highlightItem.height = videoRender.height - startPoint.y;
                else
                    rootItem.highlightItem.height = Math.abs(mouse.y - startPoint.y);
                }
            }
            onReleased: {
                if (rootItem.highlightItem.width !== 0 && rootItem.highlightItem.height !== 0) {
                    console.log("RECT at x = " + rootItem.highlightItem.x + " || y = " + rootItem.highlightItem.y + " || w = "
                                + rootItem.highlightItem.width + " || h = " + rootItem.highlightItem.height);
                    videoRender.scaleRectInfos();
                }
            }
            onClicked:(mouse) => {
                if (mouse.button === Qt.RightButton) {
                    rootItem.xPos       = 0.0;
                    rootItem.yPos       = 0.0;
                    rootItem.widthRect  = 0.0;
                    rootItem.heightRect = 0.0;
                    videoRender.invScaleRectInfos();
                }
            }

            Component {
                id: highlightComponent
                Rectangle {
                    color: "lightyellow"
                    opacity: 0.5
                    border.color: "red"
                    border.width: 2
                }
            }
        }

        onWidthChanged: {
            invScaleRectInfos();
            scaleRectInfos();
        }

        onHeightChanged: {
            invScaleRectInfos();
            scaleRectInfos();
        }

        function scaleRectInfos() {
            if (highlightItem == null) return;
            xPos        = highlightItem.x / videoRender.width;
            yPos        = highlightItem.y / videoRender.height;
            widthRect   = highlightItem.width / videoRender.width;
            heightRect  = highlightItem.height / videoRender.height;
        }

        function invScaleRectInfos() {
            if (highlightItem == null) return;
            highlightItem.x      = xPos * videoRender.width;
            highlightItem.y      = yPos * videoRender.height;
            highlightItem.width  = widthRect * videoRender.width;
            highlightItem.height = heightRect * videoRender.height;
        }
    }
}
