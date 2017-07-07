import QtQuick 2.0
import Ubuntu.Components 0.1
import QtPositioning 5.2
import QtLocation 5.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

MapItemView
{
    id: busMapItemView
    model: busStopListModel

    delegate: MapQuickItem
    {
        id: busPoiItem
        coordinate: QtPositioning.coordinate(lat,lng)
        anchorPoint.x: busPoiImage.width * 0.5
        anchorPoint.y: busPoiImage.height
        z: 8//set to -1 to make invisible

        sourceItem: Image
        {
            id: busPoiImage
            width: units.gu(2.5)
            height: units.gu(2.5)
            source: "../images/bus_poi.png"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    PopupUtils.open(busStopPopoverComponent)
                }
            }
        }
        BusStopPopover
        {
            id: busStopPopoverComponent
        }
    }
}
