import QtQuick 2.0
import Ubuntu.Components 0.1
import QtPositioning 5.2
import QtLocation 5.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

MapItemView
{
    id: busMapItemView
    model: metroStationsModel

    delegate: MapQuickItem
    {
        id: stationPoiItem
        coordinate: QtPositioning.coordinate(lat,lng)
        anchorPoint.x: stationPoiImage.width * 0.5
        anchorPoint.y: stationPoiImage.height * 0.5
        z: 8//set to -1 to make invisible

        sourceItem: Image
        {
            id: stationPoiImage
            width: units.gu(3)
            height: units.gu(3)
            source: "../images/metro_station_poi.png"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    PopupUtils.open(metroStationPopoverComponent)
                }
            }
        }
        MetroStationPopover
        {
            id: metroStationPopoverComponent
        }
    }
}
