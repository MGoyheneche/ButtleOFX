import QtQuick 2.1
import QtQuick.Layouts 1.0
import ButtleFileModel 1.0
import QtQuick.Controls 1.0

import "../../../gui"

Rectangle {
    id: browser
    color: "#353535"

    signal buttonCloseClicked(bool clicked)
    signal buttonFullscreenClicked(bool clicked)

    QtObject {
        id: m
        property string directory: _browser.getFirstFolder()
        property string fileFolder: "/"
        property int nbInSeq
        property string filter:"*"
        property variant selected
        property bool showSeq: false
    }

    ListModel {
        id: listPrevious
    }

    FileModelBrowser {
        id: firstFile
    }

    focus: true

    Tab {
        id: tabBar
        name: "Browser"
        onCloseClicked: browser.buttonCloseClicked(true)
        onFullscreenClicked: browser.buttonFullscreenClicked(true)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: tabBar.height

        HeaderBar {
            id: headerBar
            y: tabBar.height
            z: files.z + 1
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            listPrevious: listPrevious
            parentFolder: m.fileFolder
            folder: m.directory

            onChangeFolder: {
                m.directory = folder
            }
            onRefreshFolder: {
                files.forceActiveFocusOnRefresh()
            }
            onChangeSeq: {
                m.showSeq = seq
            }
        }

        WindowFiles {
            id: files
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 120
            z: 1

            showSeq: m.showSeq
            viewList: headerBar.isInListView
            folder: m.directory
            filterName: m.filter

            onGoToFolder: {
                listPrevious.append({"url": m.directory})
                m.directory= newFolder
            }
            onChangeFileFolder: {
                m.fileFolder = fileFolder
            }
            onChangeNbFilesInSeq: {
                m.nbInSeq = nb
            }
            onChangeSelectedList: {
                m.selected = selected
            }
        }

        FooterBar {
            id: footerBar
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            selected: m.selected
            nbInSeq: m.nbInSeq

            onChangeFilter: {
                m.filter = newFilter
            }
            onOpenFolder: {
                listPrevious.append({"url": m.directory})
                m.directory = newFolder
            }
        }
    }


    Keys.onPressed: {
        if (event.key == Qt.Key_Tab) {
            headerBar.forceActiveFocusOnPathWithTab()
            event.accepted = true
        }
        if (event.key == Qt.Key_Return) {
            files.enterFolder()
            event.accepted = true
        }
        if ((event.key == Qt.Key_L) && (event.modifiers & Qt.ControlModifier)) {
            headerBar.forceActiveFocusOnPath()
            event.accepted = true
        }
        if ((event.key == Qt.Key_N) && (event.modifiers & Qt.ControlModifier)) {
            files.forceActiveFocusOnCreate()
            event.accepted = true
        }
        if (event.key == Qt.Key_F2) {
            files.forceActiveFocusOnRename()
            event.accepted = true
        }
        if (event.key == Qt.Key_F5) {
            files.forceActiveFocusOnRefresh()
            event.accepted = true
        }
        if (event.key == Qt.Key_Delete) {
            files.forceActiveFocusOnDelete()
            event.accepted = true
        }
        if (event.key == Qt.Key_Right) {
            files.forceActiveFocusOnChangeIndexOnRight()
            event.accepted = true
        }
        if (event.key == Qt.Key_Left) {
            files.forceActiveFocusOnChangeIndexOnLeft()
            event.accepted = true
        }
        if (event.key == Qt.Key_Down) {
            files.forceActiveFocusOnChangeIndexOnDown()
            event.accepted = true
        }
        if (event.key == Qt.Key_Up) {
            files.forceActiveFocusOnChangeIndexOnUp()
            event.accepted = true
        }
    }

}
