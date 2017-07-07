import QtQuick 2.0
import Ubuntu.Components 0.1
import QtPositioning 5.2
import QtLocation 5.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 0.1 as ListItem


XmlListModel
{
    property var latlong
    property int mapRadius
    property string old_url: ""

    query: "/StopsResp/Stops/Stop"

    namespaceDeclarations: "declare namespace i='http://www.w3.org/2001/XMLSchema-instance';declare default element namespace 'http://www.wmata.com';"
    
    XmlRole { name: "lat"; query: "Lat/string()"}
    XmlRole { name: "lng"; query: "Lon/string()"}
    XmlRole {name: "name"; query: "Name/string()"}
    XmlRole {name: "stop_id"; query: "StopID/string()"}

    onLatlongChanged:
    {
        setSourceUrl()
    }
    onMapRadiusChanged:
    {
        setSourceUrl()
    }
    function setSourceUrl()
    {
            if(!latlong)return;
            var url = "http://api.wmata.com/Bus.svc/Stops?lat={{lat}}&lon={{lon}}&radius={{rad}}&api_key=qdkez64kx75ae48mf3xdd4ta"
            url = url.replace("{{lat}}",latlong[0])
            url = url.replace("{{lon}}",latlong[1])
            url = url.replace("{{rad}}",mapRadius)
            if(url != old_url)
            {
                source = url
            }
            old_url = url
    }
    onStatusChanged:
    {
        if(status == XmlListModel.Null)
        {
            //print("No bus xml data set")
        }
        if(status == XmlListModel.Ready)
        {
            //print(count + " stops loaded from xml")
        }
        if(status == XmlListModel.Loading)
        {
            //print("Loading bus data")
        }
        if(status == XmlListModel.Error)
        {
            //print("ERROR: " + errorString())
        }
    }
}
