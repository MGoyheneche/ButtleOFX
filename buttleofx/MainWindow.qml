import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import QtQml 2.1
import QuickMamba 1.0
import QtQuick.Dialogs 1.0

import "gui/graph/qml"
import "gui/viewer/qml"
import "gui/paramEditor/qml"
import "gui/browser/qml"

ApplicationWindow {
    property int selectedView : 1

    width: 1200
    height: 800
    id: mainWindowQML

    //TopFocusHandler {
    // //anchors.fill: parent
    //}

    Keys.onPressed: {

        // Graph toolbar
/*        if (event.key == Qt.Key_Delete) {
           _buttleManager.deleteSelection();
        }
*/        if ((event.key == Qt.Key_Z) && (event.modifiers & Qt.ControlModifier)) {
            if(_buttleManager.canUndo) {
                _buttleManager.undo();
            }
        }
        if ((event.key == Qt.Key_Y) && (event.modifiers & Qt.ControlModifier)) {
            if(_buttleManager.canRedo) {
                _buttleManager.redo();
            }
        }
        if ((event.key == Qt.Key_D) && (event.modifiers & Qt.ControlModifier)){
            if (!_buttleData.currentSelectedNodeWrappers.isEmpty()) {
                _buttleManager.nodeManager.duplicationNode()
            }
        }
        if ((event.key == Qt.Key_C) && (event.modifiers & Qt.ControlModifier)){
            if (!_buttleData.currentSelectedNodeWrappers.isEmpty()) {
                _buttleManager.nodeManager.copyNode()
            }
        }
        if ((event.key == Qt.Key_V) && (event.modifiers & Qt.ControlModifier)){
           if (_buttleData.canPaste) {
                _buttleManager.nodeManager.pasteNode();
           }
        }
        if ((event.key == Qt.Key_X) && (event.modifiers & Qt.ControlModifier)){
            if (!_buttleData.currentSelectedNodeWrappers.isEmpty()) {
                _buttleManager.nodeManager.cutNode()
            }
        }
        if ((event.key == Qt.Key_S) && (event.modifiers & Qt.ControlModifier)){
            if(_buttleData.graphCanBeSaved) {
                finderSaveGraph.open()
            }
        }
        if ((event.key == Qt.Key_O) && (event.modifiers & Qt.ControlModifier)){
            finderLoadGraph.open()
        }

        // Viewer
        if ((event.key == Qt.Key_1) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(1)
        }
        if ((event.key == Qt.Key_2) && (event.modifiers & Qt.KeypadModifier)){

            player.changeViewer(2)
        }
        if ((event.key == Qt.Key_3) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(3)
        }
        if ((event.key == Qt.Key_4) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(4)
        }
        if ((event.key == Qt.Key_5) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(5)
        }
        if ((event.key == Qt.Key_6) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(6)
        }
        if ((event.key == Qt.Key_7) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(7)
        }
        if ((event.key == Qt.Key_8) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(8)
        }
        if ((event.key == Qt.Key_9) && (event.modifiers & Qt.KeypadModifier)){
            player.changeViewer(9)
        }
        // Assign the mosquito to the selected node
        if ((event.key == Qt.Key_Return)||(event.key == Qt.Key_Enter)) {
            var selectedNodes = _buttleData.currentSelectedNodeWrappers

            // we assign the mosquito only if there is only one node selected
            if(selectedNodes.count == 1) {
                var node = selectedNodes.get(0)
                _buttleData.currentViewerNodeWrapper = node
                _buttleData.currentViewerFrame = 0
                _buttleData.assignNodeToViewerIndex(node, 0)
                _buttleEvent.emitViewerChangedSignal()
            }
        }

        // Player
        if (event.key == Qt.Key_Space && player.node != null) {
            if(player.isPlaying) {
                player.doAction("pause");
            }
            else {
                player.doAction("play");
            }
        }

        // Send the selected node on the parameters editor
        if ((event.key == Qt.Key_P)) {
            var selectedNodes = _buttleData.currentSelectedNodeWrappers

            // we send the node only if there is only one node selected
            if(selectedNodes.count == 1) {
                var node = selectedNodes.get(0)
                _buttleData.currentParamNodeWrapper = node
            }
        }
    }

    FinderLoadGraph{ id: finderLoadGraph }
    FinderSaveGraph{ id: finderSaveGraph }

    menuBar: MenuBar {
        Menu {
            title: "File"

            MenuItem {
                text: "Open"
                shortcut: "Ctrl+O"
                onTriggered: finderLoadGraph.open()
            }

            MenuItem {
                text: "Save"
                shortcut: "Ctrl+S"
                onTriggered:
                    if(_buttleData.graphCanBeSaved) {
                        finderSaveGraph.open()
                    }
            }

            MenuSeparator { }

            MenuItem {
                id: quitButton
                text: "Exit"
                onTriggered: Qt.quit()
                //connect(quitButton, SIGNAL(quit()), mainWindowQML, SLOT(quit()));
            }
        }

        Menu {
            title: "Edit"

            MenuItem {
                text: "Undo"
                shortcut: "Ctrl+Z"
                onTriggered:
                    if(_buttleManager.canUndo) {
                        _buttleManager.undo();
                    }
            }

            MenuItem {
                text: "Redo"
                shortcut: "Ctrl+Y"
                onTriggered:
                    if(_buttleManager.canRedo) {
                        _buttleManager.redo();
                    }
            }

            MenuSeparator { }

            MenuItem {
                text: "Copy"
                shortcut: "Ctrl+C"
                onTriggered:
                    if(!_buttleData.currentSelectedNodeWrappers.isEmpty()) {
                        _buttleManager.nodeManager.copyNode()
                    }
            }

            MenuItem {
                text: "Paste"
                shortcut: "Ctrl+V"
                onTriggered:
                    if(_buttleData.canPaste) {
                        _buttleManager.nodeManager.pasteNode();
                    }
            }

            MenuItem {
                text: "Cut"
                shortcut: "Ctrl+X"
                onTriggered:
                    if (!_buttleData.currentSelectedNodeWrappers.isEmpty()) {
                        _buttleManager.nodeManager.cutNode()
                    }
            }

            MenuItem {
                text: "Duplicate"
                shortcut: "Ctrl+D"
                onTriggered:
                    if (!_buttleData.currentSelectedNodeWrappers.isEmpty()) {
                        _buttleManager.nodeManager.duplicationNode()
                    }
            }

            MenuItem {
                text: "Delete"
                //shortcut: "del"
                onTriggered: _buttleManager.deleteSelection()
            }
        }

        Menu {
            id: nodesMenu
            title: "Nodes"

            Instantiator {
                model: _buttleData.pluginsIdentifiers
                MenuItem {
                    text: object
                    onTriggered: _buttleManager.nodeManager.creationNode(object, 0, 0)
                }
                onObjectAdded: nodesMenu.insertItem(index, object)
                onObjectRemoved: nodesMenu.removeItem(object)
            }
        }

        Menu {
            title: "View"

            MenuItem {
                text: "Default"
                onTriggered: selectedView = 1
            }

            MenuItem {
                text: "Browser Mode"
                onTriggered: selectedView = 2
            }

            MenuItem {
                text: "Mikros Mode"
                onTriggered: selectedView = 3
            }

            MenuSeparator { }

            MenuItem {
                text: "Browser"
                onTriggered: browser.parent.visible = true
                enabled: browser.parent.visible==true ? false : true
            }

            MenuItem {
                text: "Viewer"
                onTriggered: player.parent.visible = true
                enabled: player.parent.visible==true ? false : true
            }

            MenuItem {
                text: "Graph"
                onTriggered: graphEditor.parent.visible = true
                enabled: graphEditor.parent.visible==true ? false : true
            }

            MenuItem {
                text: "Parameters"
                onTriggered: paramEditor.parent.visible = true
                enabled: paramEditor.parent.visible==true ? false : true
            }
        }

/* A revoir
        Menu {
            title: "Add"

            MenuItem {
                text: "New Node"
                onTriggered: _addMenu.showMenu(parent.x, mainMenu.height)
            }
        }
*/
    }
/*
    Rectangle {
        id: mainMenu
        width: parent.width
        height: 32
        color: "#141414"

        Row {
            spacing: 10
            x: 3

            Image {
                id: mosquito
                source: _buttleData.buttlePath + "/gui/img/icons/logo_icon.png"
                y: 5
            }

            Text {
                color: "white"
                text: "File"
                y: 11
                font.pointSize: 10

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        _fileMenu.showMenu(parent.x, mainMenu.height)
                    }
                }
            }

            Text {
                color: "white"
                text: "Edit"
                y: 11
                font.pointSize: 10

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        _editMenu.showMenu(parent.x, mainMenu.height)
                    }
                }
            }

            Text {
                color: "white"
                text: "Add"
                y: 11
                font.pointSize: 10

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        _addMenu.showMenu(parent.x, mainMenu.height)
                    }
                }
            }
        }
    }
*/
    //this rectangle represents the zone under the menu, it allows to define the anchors.fill and margins for the SplitterRow
    Rectangle {
        id: modulsContainer
        width: parent.width
        height: parent.height - y
        color: "#353535"

        SplitView {
            anchors.fill: parent
            anchors.margins: 3
            orientation: Qt.Horizontal

            SplitView {
                id: leftColumn
                implicitWidth: 0.3 * parent.width
                implicitHeight: parent.height
                orientation: Qt.Vertical
                Layout.fillWidth: true
                Layout.minimumWidth: 200

                TabView {
                    id: topLeftView
                    Layout.minimumHeight: 200
                    Layout.fillHeight: true
                    implicitWidth: parent.width

                    style: TabStyle {
                            onButtonCloseClicked: parent.removeTab(0)
                        }

                    Component.onCompleted: {
                        switch(selectedView){
                            case 1:
                                visible = true
                                addTab("Browser", browser)
                                break
                            case 2:
                            case 3:
                                visible = true
                                addTab("Viewer", player)
                                break
                            default:
                                break
                        }
                    }
                }//topLeftView

                TabView {
                    id: bottomLeftView
                    Layout.minimumHeight: 200
                    Layout.fillHeight: true
                    implicitWidth: parent.width
                    implicitHeight: 0.5 * parent.height
                    z: -1

                    style: TabStyle {
                            onButtonCloseClicked: {parent.removeTab(0); parent.visible = false; selectedView=-1}
                        }

                    Component.onCompleted: {
                        switch(selectedView){
                            case 1:
                            case 2:
                                visible = true
                                addTab("Parameters", paramEditor)
                                break
                            case 3:
                                visible = true
                                addTab("Browser", browser)
                                break
                            default:
                                break
                        }
                    }
                }//bottomLeftView

            }//leftColumn

            SplitView {
                id: rightColumn
                implicitWidth: 0.7 * parent.width
                implicitHeight: parent.height
                orientation: Qt.Vertical
                Layout.fillWidth: true
                Layout.minimumWidth: 200

                TabView {
                    id: topRightView
                    Layout.minimumHeight: 200
                    Layout.fillHeight: true
                    implicitWidth: parent.width

                    style: TabStyle {
                            onButtonCloseClicked: {parent.removeTab(0); parent.visible = false; selectedView=-1}
                        }

                    Component.onCompleted: {
                        switch(selectedView){
                            case 1:
                                visible = true
                                addTab("Viewer", player)
                                break
                            case 2:
                                visible = true
                                addTab("Browser", browser)
                                break
                            case 3:
                                visible = true
                                addTab("Parameters", paramEditor)
                                break
                            default:
                                break
                        }
                    }
                }//topRightView

                TabView {
                    id: bottomRightView
                    Layout.minimumHeight: 200
                    Layout.fillHeight: true
                    implicitWidth: parent.width
                    implicitHeight: 0.5 * parent.height
                    z: -1

                    style: TabStyle {
                            onButtonCloseClicked: {parent.removeTab(0); parent.visible = false; selectedView=-1}
                        }

                    Component.onCompleted: {
                        switch(selectedView){
                            case 1:
                            case 2:
                                visible = true
                                rightColumn.implicitWidth = 0.7 * rightColumn.parent.width
                                addTab("Graph", graphEditor)
                                break
                            case 3:
                                visible = false
                                rightColumn.implicitWidth = 0.3 * rightColumn.parent.width
                                break
                            default:
                                break
                        }
                    }
                }//bottomRightView
            }//rightColumn
        }//splitview
    }//modulsContainer


    Item {
        id: subviews
        visible: false

        Component {
            id: player
            Player {
                anchors.fill: parent
                node: _buttleData.currentViewerNodeWrapper
            }
        }

        Component {
            id: graphEditor
            GraphEditor {
                anchors.fill: parent
            }

        }

        Component {
            id: paramEditor
            ParamEditor {
                anchors.fill: parent
                params: _buttleData.currentParamNodeWrapper ? _buttleData.currentParamNodeWrapper.params : null
                currentParamNode: _buttleData.currentParamNodeWrapper
            }
        }

        Component {
            id: browser
            Browser {
                anchors.fill: parent
            }
        }
    }
}
