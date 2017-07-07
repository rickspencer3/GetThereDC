import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.XmlListModel 2.0

Component
{
    Popover
    {
        property string stationId: stationCode
        property string stationName: name
        property var lineCodes: {"RD":"Red","BL":"Blue","YL":"Yellow","OR":"Orange","GR":"Green"}
        property var arriveCodes: {"ARR":"Arriving","BRD":"Boarding"}
        id: metroStationPopover

        onVisibleChanged:
        {
            if(visible)
            {
                fetchStationDetails()
            }
        }
        function fetchStationDetails()
        {
            var location =  "http://api.wmata.com/StationPrediction.svc/GetPrediction/{{code}}?api_key=qdkez64kx75ae48mf3xdd4ta";
            location = location.replace("{{code}}",stationId)
            trainPredictionsListModel.source = location
        }
        XmlListModel
        {
            id: trainPredictionsListModel
            namespaceDeclarations: "declare namespace i='http://www.w3.org/2001/XMLSchema-instance';declare default element namespace 'http://www.wmata.com';"
            query: "/AIMPredictionResp/Trains/AIMPredictionTrainInfo"
            XmlRole{ name: "line"; query:"Line/string()" }
            XmlRole{ name: "minutes"; query:"Min/string()" }
            XmlRole{ name: "destination"; query:"DestinationName/string()" }

            onStatusChanged:
            {
                //print(source)
                if(status == XmlListModel.Null)
                {
                    //print("No stop data set")
                }
                if(status == XmlListModel.Ready)
                {
                    //print(count + " bus predictions loaded from xml")
                }
                if(status == XmlListModel.Loading)
                {
                    //print("Loading stop data")
                }
                if(status == XmlListModel.Error)
                {
                    //print("ERROR: " + errorString())
                }
            }
        }

        Column
        {
            id: containerLayout
            anchors
            {
                left: parent.left
                top: parent.top
                right: parent.right
            }

            ListItem.SingleControl
            {
                control: Image
                {
                    source: "../images/metro_station_poi.png"
                    height: units.gu(5)
                    width: units.gu(5)
                }
            }

            ListItem.Header
            {
                text: stationName
            }

            ListItem.SingleControl
            {
                visible: trainPredictionsListModel.status == XmlListModel.Loading
                control: ActivityIndicator
                {
                    height: units.gu(5)
                    width: units.gu(5)
                    running: trainPredictionsListModel.status == XmlListModel.Loading
                }
            }
            ListView
            {
                height: units.gu(25)
                width: parent.width
                model: trainPredictionsListModel
                clip: true
                delegate: ListItem.Subtitled
                {
                    height: units.gu(5)
                    visible: metroStationPopover.lineCodes[line]
                    text:
                    {
                        if(minutes === "BRD" | minutes === "ARR")
                        {
                            return metroStationPopover.lineCodes[line] + " Line "  + metroStationPopover.arriveCodes[minutes]
                        }
                        else
                        {
                            var m = " minutes until "
                            if(minutes === 1){m = " minute until "}
                            return minutes + m + metroStationPopover.lineCodes[line] + " Line"
                        }
                    }
                    subText: "To " + destination
                }

            }

            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Close"
                    onClicked:
                    {
                        PopupUtils.close(metroStationPopover)
                    }
                }
            }

        }
    }
}
