import QtQuick 1.1

Rectangle {
    //color: "#343434"
    property string labelElement
    property string idElement
    property string parentName

    // The MenuList where from the element come
    property variant menuListItem

    // To remember the path
    color: menuListItem.currentElementLabel == labelElement ? "#bbb" : "#343434"

    property variant type: _buttleData.isAPlugin(idElement) ? "plugin" : "category"
    property variant clickFrom: tools

    Text {
        id: textMenuElement
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        color: type == "category" ? "#eee" : "#00b2a1"
        text: nodeMenuElement.labelElement
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        // On mouse exited the element, we destroy its submenu if it exists.
        onExited: {
            if (mouseX <= nodeMenuElement.x + nodeMenuElement.width - 10) {
                menuListItem.destroyNextMenu();
            }
        }

        // On mouse entered the element, we create the new next menu (only if this element is a category)
        onEntered: {
            menuListItem.currentElementLabel = textMenuElement.text
            if(type=="category") {
                menuListItem.destroyNextMenu();
                menuListItem.createNextMenu(nodeMenuElement.parentName, nodeMenuElement.labelElement, nodeMenuElement.x + nodeMenuElement.width, nodeMenuElement.y)
            }
        }

        // On mouse clicked, we call the creationNode fonction if the element is a plugin. Then we destroy the menu.
        onClicked: {
            if (nodeMenuElement.type == "plugin") {
                console.log("creation node")
                clickFrom.clickCreationNode(nodeMenuElement.idElement);
                if (tools.children) {
                    tools.children.destroy();
                }
            }
        }
    }
}
