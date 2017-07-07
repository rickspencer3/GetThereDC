import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.XmlListModel 2.0
import QtPositioning 5.2

Component
{
    Popover
    {
        id: searchPopover
        Column
        {
            anchors
            {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: units.gu(1)
            }
            spacing: units.gu(1)
            ListItem.SingleControl
            {
                control: Icon
                {
                    name: "search"
                    color: UbuntuColors.midAubergine
                    height: units.gu(5)
                    width: units.gu(5)
                }
            }
            TextField
            {
                id: addressField
                width: parent.width
                placeholderText: "Address"
            }

            OptionSelector
            {
                id: citySelector
                text: "City"
                model: ["Washington, DC", "Arlington, VA", "Alexandria, VA", "Bethesda, MD", "Fairfax, VA", "Falls Church, VA", "Reston, VA", "Rockville, MD", "Silver Spring, MD"]
            }
            Button
            {
                text: "search"
                onClicked:
                {
                    var url = "http://nominatim.openstreetmap.org/search/{{address}},%20{{city}}?format=xml"
                    url = url.replace("{{address}}", addressField.text)
                    url = url.replace("{{city}}", citySelector.model[citySelector.selectedIndex])
                    resultsModel.source = url
                    resultsModel.reload()
                }
            }

            UbuntuListView
            {
                height:units.gu(25)
                width: parent.width
                clip: true
                id: resultsList
                model: resultsModel

                delegate: ListItem.Standard
                {
                    text: displayName
                    height: units.gu(5)
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            getThereMap.navigateToFoundLocation(lat, lon)
                            PopupUtils.close(searchPopover)
                        }
                    }
                }
            }



            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Close"
                    onClicked:
                    {
                        PopupUtils.close(searchPopover)
                    }
                }
            }
        }

        ActivityIndicator
        {
            anchors.centerIn: parent
            visible: resultsModel.status == XmlListModel.Loading
            running: true
        }

        XmlListModel
        {
            id: resultsModel
            query: "/searchresults/place"

            XmlRole { name: "lat"; query: "@lat/string()";}
            XmlRole { name: "lon"; query: "@lon/string()";}
            XmlRole { name: "displayName"; query: "@display_name/string()";}
            onStatusChanged:
            {
                if(status == XmlListModel.Null)
                {
                    //print("No xml data set")
                }
                if(status == XmlListModel.Ready)
                {
                    //print(count + " results loaded from xml")
                }
                if(status == XmlListModel.Loading)
                {
                    //print(resultsModel.source)
                    //print("Loading results data")
                }
                if(status == XmlListModel.Error)
                {
                    //print("ERROR: " + errorString())
                }
            }
        }
    }
}
