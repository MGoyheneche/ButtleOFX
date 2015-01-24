import os
import shutil

from buttleofx.gui.browser_v2.actions.actionInterface import ActionInterface


class Copy(ActionInterface):

    def __init__(self, browserItem, destination):
        # destination must be a directory
        if not destination.isFolder():
            raise TypeError
        super().__init__(browserItem)
        self._destination = destination

    def action(self):
        browserItem = self.getBrowserItem()
        destination = self._destination
        destinationPath = destination.getPath()

        # Copy file
        if browserItem.isFile():
            # TODO: Check destination permission in try catch
            if os.path.exists(destinationPath):
                shutil.copy2(browserItem.getPath(), destinationPath)

        # Copy Folder
        if browserItem.isFolder():
            # TODO: Check destination permission in try catch
            shutil.copytree(browserItem.getParentPath(), destinationPath)
