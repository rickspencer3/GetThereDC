import QtQuick 2.0
import Ubuntu.Components 0.1
import QtPositioning 5.2
import QtLocation 5.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1


MapItemView
{
    model: bikeStationModel
    
    delegate: MapQuickItem
    {
        id: poiItem
        coordinate: QtPositioning.coordinate(lat,lng)
        anchorPoint.x: poiImage.width * 0.5
        anchorPoint.y: poiImage.height
        z: 9
        sourceItem: Image
        {
            id: poiImage
            width: units.gu(2)
            height: units.gu(2)
            source: "../images/bike_poi.png"
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    PopupUtils.open(bikeSharePopoverComponent)
                }
            }
        }
        BikeShareStationPopover
        {
            id: bikeSharePopoverComponent
        }
    }
}
