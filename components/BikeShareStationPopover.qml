import QtQuick 2.0
import Ubuntu.Components 0.1

import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

Component
{
    id: popoverComponent
    Popover
    {
        id: bikeSharePopover
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
                    source: "../images/CapitalBikeshare_Logo.jpg"
                    height: units.gu(5)
                    width: units.gu(5)
                }
            }
            ListItem.Header { text: name}
            ListItem.Standard { text: available + " bikes available" }
            ListItem.Standard { text: freeSlots + " parking spots available"}
            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Close"
                    onClicked:
                    {
                        PopupUtils.close(bikeSharePopover)
                    }
                }
            }
        }
    }
}
