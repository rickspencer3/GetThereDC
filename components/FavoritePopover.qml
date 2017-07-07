import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import U1db 1.0 as U1db
import QtPositioning 5.2

Component
{
    Popover
    {
        U1db.Database
        {
            id: getThereFavorites
            path: "getThereFavorites"
        }

        id: favoritePopover
        Column
        {
            anchors
            {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            ListItem.SingleControl
            {
                control: Icon
                {
                    color: UbuntuColors.midAubergine
                    height: units.gu(5)
                    width: units.gu(5)
                    name: "favorite-selected"
                }
            }

            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Favorite This Location"
                    onClicked:
                    {
                        PopupUtils.open(favoriteNameComposer)
                    }
                }
                Component
                {
                    id: favoriteNameComposer
                    ComposerSheet
                    {
                        id: sheet
                        title: "Name the Location"
                        TextField
                        {
                            id: favoriteTextField
                            text: "Favorite Location"
                        }

                        onCancelClicked: PopupUtils.close(sheet)
                        onConfirmClicked:
                        {
                            var qmlString = "import QtQuick 2.0; import U1db 1.0 as U1db; U1db.Document {database: getThereFavorites; docId: '{{docId}}'; create: true;"
                            qmlString += " defaults: { 'faveName':'{{faveName}}', 'zoomLevel': '{{zoomLevel}}', 'latitude':'{{latitude}}', 'longitude':'{{longitude}}' }}"
                            var zm = getThereMap.zoomLevel
                            var lat = getThereMap.center.latitude
                            var lon = getThereMap.center.longitude
                            qmlString = qmlString.replace("{{docId}}",zm + "_" + lat + "_" + lon)
                            qmlString = qmlString.replace("{{faveName}}",favoriteTextField.text)
                            qmlString = qmlString.replace("{{zoomLevel}}",zm)
                            qmlString = qmlString.replace("{{latitude}}",lat)
                            qmlString = qmlString.replace("{{longitude}}",lon)
                            Qt.createQmlObject(qmlString, getThereFavorites);
                            PopupUtils.close(sheet)
                        }
                    }
                }
            }
            ListView
            {
                height: units.gu(25)
                width: parent.width
                model: getThereFavorites
                delegate: ListItem.Standard
                {
                    height: units.gu(5)
                    text: contents.faveName
                    onClicked:
                    {
                        getThereMap.center = QtPositioning.coordinate(0, 0,0)
                        getThereMap.center = QtPositioning.coordinate(contents.latitude, contents.longitude,0)
                        getThereMap.zoomLevel = contents.zoomLevel
                        PopupUtils.close(favoritePopover)
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
                        PopupUtils.close(favoritePopover)
                    }
                }
            }
        }
    }
}
