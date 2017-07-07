import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.XmlListModel 2.0

Component
{
    Popover
    {
        property int stopId: stop_id
        property string stopName: name
        id: busStopPopover

        onVisibleChanged:
        {
            if(visible)
            {
                fetchStopDetails()
            }
        }
        function fetchStopDetails()
        {
            var location = "http://api.wmata.com/NextBusService.svc/Predictions?StopID={{id}}&api_key=qdkez64kx75ae48mf3xdd4ta";
            location = location.replace("{{id}}",stopId)
            busPredictionsListModel.source = location
        }
        XmlListModel
        {
            id: busPredictionsListModel
            namespaceDeclarations: "declare namespace i='http://www.w3.org/2001/XMLSchema-instance';declare default element namespace 'http://www.wmata.com';"
            query: "/NextBusResponse/Predictions/NextBusPrediction"
            XmlRole{ name: "route"; query:"RouteID/string()" }
            XmlRole{ name: "minutes"; query:"Minutes/string()" }
            XmlRole{ name: "direction"; query:"DirectionText/string()" }

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
                    source: "../images/bus_icon.png"
                    height: units.gu(5)
                    width: units.gu(5)
                }
            }

            ListItem.Header
            {
                text: stopName
            }
            ListItem.Header
            {
                text: "Stop # " + stopId
            }

            ListItem.SingleControl
            {
                visible: busPredictionsListModel.status == XmlListModel.Loading
                control: ActivityIndicator
                {
                    height: units.gu(5)
                    width: units.gu(5)
                    running: busPredictionsListModel.status == XmlListModel.Loading
                }
            }
            ListView
            {
                height: units.gu(25)
                width: parent.width
                model: busPredictionsListModel
                clip: true
                delegate: ListItem.Subtitled
                {
                    height: units.gu(5)
                    text: minutes + " minutes until bus " + route
                    subText: " Heading " +  direction
                }
            }
            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Close"
                    onClicked:
                    {
                        PopupUtils.close(busStopPopover)
                    }
                }
            }

        }
    }
}
