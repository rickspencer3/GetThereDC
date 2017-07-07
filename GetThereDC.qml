import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import QtPositioning 5.2
import QtLocation 5.0 as Location
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.rick-rickspencer3.gettheredc"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(50)
    height: units.gu(75)
    property bool dataLoading: bikeStationModel.status === XmlListModel.Loading | busStopListModel.status === XmlListModel.Loading
    property int minimumBusDataZoomLevel: 16
    property int bikeShareRefreshMinutes: 3
    property int car2goRefreshMinutes: 3

    Page
    {
        title: i18n.tr("")
        PositionSource
        {
            id: positionSource
            onPositionChanged:
            {
                getThereMap.center = QtPositioning.coordinate(0, 0,0)
                getThereMap.center = position.coordinate
            }
        }

        Location.Map
        {
            id: getThereMap
            anchors.fill: parent
            center: QtPositioning.coordinate(38.87, -77.045)
            zoomLevel: 13

            plugin:  Location.Plugin { name: "osm"}
            BusMapItemView
            {
            }

            BikeShareMapItemView
            {
            }
            MetroStopMapItemView
            {

            }
            Car2GoMapItemView
            {

            }

            Timer
            {
                id: mapRestTimer
                running: false
                interval: 2000
                onTriggered:
                {
                    //stop the timer and set the new latlong
                    running: false

                    if(getThereMap.zoomLevel >= minimumBusDataZoomLevel)
                    {
                        busStopListModel.latlong = [getThereMap.center.latitude,getThereMap.center.longitude]

                        var tr = getThereMap.toCoordinate(Qt.point(0,0))
                        var bl = getThereMap.toCoordinate(Qt.point(getThereMap.width,getThereMap.height))
                        var latdiff = bl.latitude - tr.latitude
                        var londiff = bl.longitude - tr.longitude
                        //TODO: fix this silly calculation for the radius
                        var rad = (latdiff > londiff) ? latdiff *  (34.67 * 5280 / 3) : londiff *  (34.67 * 5280 / 3 )

                        busStopListModel.mapRadius = rad
                    }

                }
            }
            Timer
            {
                interval: (1000  * 60 * bikeShareRefreshMinutes)
                running: true
                repeat: true
                onTriggered:
                {
                    bikeStationModel.reload()
                }
            }
            Timer
            {
                interval: (1000  * 60 * car2goRefreshMinutes)
                running: true
                repeat: true
                onTriggered:
                {
                    car2goModel.reload()
                }
            }

            onZoomLevelChanged:
            {
                    timeMapRest()
            }
            onCenterChanged:
            {
                    timeMapRest()
            }
            function timeMapRest()
            {
                if(mapRestTimer.running)
                {
                    mapRestTimer.restart()
                }
                else
                {
                    mapRestTimer.start()
                }
            }
            function navigateToFoundLocation(lat, lon)
            {
                getThereMap.center = QtPositioning.coordinate(0, 0,0)
                var newCoords = QtPositioning.coordinate(lat, lon, 0)
                getThereMap.center = newCoords
                findItem.coordinate = newCoords
                getThereMap.zoomLevel = 17
                getThereMap.addMapItem(findItem)
            }
            Location.MapQuickItem
            {
                id: findItem
                anchorPoint.x: findImage.width * 0.5
                anchorPoint.y: findImage.height
                z: 8

                sourceItem: Image
                {
                    id: findImage
                    width: units.gu(5)
                    height: units.gu(5)
                    source: "images/pushpin.png"
                }
            }
        }
        Column
        {
            anchors
            {
                bottom: parent.bottom
                right: parent.right
                left:parent.left
                bottomMargin: units.gu(0.5)
                leftMargin: units.gu(0.5)
            }
            Text
            {
                visible: getThereMap.zoomLevel < minimumBusDataZoomLevel
                text: "Zoom in to load more bus stops"
                font.family: "Ubuntu"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: units.gu(2)
            }
            Row
            {
                spacing: units.gu(2)
                Column
                {
                    Repeater
                    {
                        model: [{"buttonText":"+","changeLevel":1},{"buttonText":"-","changeLevel":-1}]
                        UbuntuShape
                        {
                            width: units.gu(5)
                            height: units.gu(5)
                            color: UbuntuColors.midAubergine

                            Label
                            {
                                anchors.centerIn: parent
                                text: modelData["buttonText"]
                            }
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked: getThereMap.zoomLevel += modelData["changeLevel"]
                            }
                        }
                    }
                }
                Icon
                {
                    name: "favorite-selected"
                    color: UbuntuColors.midAubergine

                    height: units.gu(5)
                    width: units.gu(5)
                    anchors
                    {
                        bottom: parent.bottom
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            PopupUtils.open(favoriteComponent)
                        }
                    }
                }
                Icon
                {
                    name: "search"
                    color: UbuntuColors.midAubergine
                    height: units.gu(5)
                    width: units.gu(5)
                    anchors
                    {
                        bottom: parent.bottom
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            PopupUtils.open(searchPopoverComponent)
                        }
                    }
                }
                Icon
                {
                    name: "location"
                    color: UbuntuColors.midAubergine
                    height: units.gu(5)
                    width: units.gu(5)
                    anchors
                    {
                        bottom: parent.bottom
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            positionSource.update()
                        }
                    }
                }
            }
        }


        UbuntuShape
        {
            height: units.gu(20)
            width: units.gu(20)
            anchors.centerIn: parent
            color: "black"
            opacity: .9
            visible: dataLoading
        }
        ActivityIndicator
        {
            anchors.centerIn: parent
            running: true
            visible: dataLoading
        }

        Column
        {
            height: units.gu(20)
            width: units.gu(20)
            anchors
            {
                centerIn: parent
            }
            ListItem.Standard
            {
                visible: bikeStationModel.status == XmlListModel.Loading
                text: "Loading Bike Share Data"


            }
            ListItem.Standard
            {
                visible: busStopListModel.status == XmlListModel.Loading
                text: "Loading Bus Data"
            }
            ListItem.Standard
            {
                visible: car2goModel.status == XmlListModel.Loading
                text: "Loading Car2Go Data"
            }
        }

    }
    FavoritePopover
    {
        id: favoriteComponent
    }
    SearchPopover
    {
        id: searchPopoverComponent
    }

    XmlListModel
    {
        id: metroStationsModel
        source: "metroStations.xml"
        query: "/StationsResp/Stations/Station"
        namespaceDeclarations: "declare namespace i='http://www.w3.org/2001/XMLSchema-instance';declare default element namespace 'http://www.wmata.com';"
        XmlRole { name: "lat"; query: "Lat/string()" }
        XmlRole { name: "lng"; query: "Lon/string()" }
        XmlRole { name: "stationCode"; query: "Code/string()" }
        XmlRole { name: "name"; query: "Name/string()" }
    }

    XmlListModel
    {
        id: bikeStationModel
        source: "https://www.capitalbikeshare.com/data/stations/bikeStations.xml"
        query: "/stations/station"
        XmlRole { name: "lat"; query: "lat/string()"; isKey: true }
        XmlRole { name: "lng"; query: "long/string()"; isKey: true }
        XmlRole {name: "name"; query: "name/string()"; isKey: true}
        XmlRole {name: "available"; query: "nbBikes/string()"; isKey: true}
        XmlRole {name: "freeSlots"; query: "nbEmptyDocks/string()"; isKey: true}
    }
    XmlListModel
    {
        id: car2goModel
        source: "https://www.car2go.com/api/v2.1/vehicles?loc=WashingtonDC&oauth_consumer_key=GetThereDC"
        namespaceDeclarations: "declare namespace ns2='http://www.w3.org/2005/Atom';declare default element namespace 'http://www.opengis.net/kml/2.2';"

        query: "/kml/Document/Placemark"
        XmlRole {name: "description"; query: "description/string()"; isKey: true}
        XmlRole {name: "coordinatesString"; query:"Point/coordinates/string()"; isKey: true }
    }

    BusStopListModel
    {
        id: busStopListModel
    }
}
