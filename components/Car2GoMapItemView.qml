import QtQuick 2.0
import Ubuntu.Components 0.1
import QtPositioning 5.2
import QtLocation 5.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1


MapItemView
{
    model: car2goModel

    delegate: MapQuickItem
    {
        id: car2GoPoiItem
        coordinate: QtPositioning.coordinate(coordinatesString.split(",")[1],coordinatesString.split(",")[0])
        anchorPoint.x: car2GoPoiImage.width * 0.5
        anchorPoint.y: car2GoPoiImage.height
        z: 9

        sourceItem: Image
        {
            id: car2GoPoiImage
            width: units.gu(3)
            height: units.gu(3)
            source: "../images/car2go_poi.png"
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    PopupUtils.open(car2goPopoverComponent)
                }
            }
        }

        Car2GoPopover
        {
            id: car2goPopoverComponent
        }
    }
}
