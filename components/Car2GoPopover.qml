import QtQuick 2.0
import Ubuntu.Components 0.1

import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

Component
{
    Popover
    {
        id: car2GoPopover
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
                    source: "../images/car2go_icon.png"
                    height: units.gu(5)
                    width: units.gu(5)
                }
            }

            Repeater
            {
                id: descriptionListView
                model: description.split("<br/>")

                height: units.gu(30)
                clip: true

                delegate: ListItem.Standard
                {
                    text: modelData
                    height: units.gu(5)
                }

            }

            ListItem.SingleControl
            {
                control: Button
                {
                    text: "Close"
                    onClicked:
                    {
                        PopupUtils.close(car2GoPopover)
                    }
                }
            }
        }
    }
}
