//
//  AppDelegate.swift
//  PhotoGallery
//
//  Created by Koray Birand on 9/29/18.
//  Copyright © 2018 Koray Birand. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    private var browserWindowControllers: Set<AAPLBrowserWindowController> = []
    
    /*
     Given a file:// URL that points to a folder, opens a new browser window that
     displays the image files in that folder.
     */
    private func openBrowserWindowForFolderURL(_ folderURL: URL) {
        let browserWindowController = AAPLBrowserWindowController(rootURL: folderURL)
        browserWindowController.showWindow(self)
        
        /*
         Add browserWindowController to browserWindowControllers, to keep it
         alive.
         */
        browserWindowControllers.insert(browserWindowController)
        
        /*
         Watch for the window to be closed, so we can let it and its
         controller go.
         */
        if let browserWindow = browserWindowController.window {
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.browserWindowWillClose(_:)), name: NSWindow.willCloseNotification, object: browserWindow)
        }
    }
    
    // CocoaSlideCollection's "File" -> "Browse Folder..." (Cmd+O) menu item sends this.
    /*
     Action method invoked by the "File" -> "Open Browser..." menu command.
     Prompts the user to choose a folder, using a standard Open panel, then opens
     a browser window for that folder using the method above.
     */
    @IBAction func openBrowserWindow(_: AnyObject) {
        
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Choose"
        openPanel.message = "Choose a directory containing images:"
        openPanel.title = "Choose Directory"
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        let pictureDirectories = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true)
        openPanel.directoryURL = URL(fileURLWithPath: pictureDirectories[0])
        
        openPanel.begin {result in
            if result == NSApplication.ModalResponse.OK {
                self.openBrowserWindowForFolderURL(openPanel.urls[0])
            }
        }
    }
    
    // When a browser window is closed, release its BrowserWindowController.
    @objc func browserWindowWillClose(_ notification: Notification) {
        let browserWindow = notification.object as! NSWindow
        browserWindowControllers.remove(browserWindow.delegate as! AAPLBrowserWindowController)
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: browserWindow)
    }
    
    
    //MARK: NSApplicationDelegate Methods
    
    // Browse a default folder on launch.
    func applicationDidFinishLaunching(_ notification: Notification) {
        ///Volumes/stuff_disk/ongoing/Beymen/Beymen_Dept_Store_Men_FW18/Output/previews
        self.openBrowserWindowForFolderURL(URL(fileURLWithPath: "/Users/koraybirand/Desktop/001476_Beymen-Club-Lookbook_FW18"))
        
        //self.openBrowserWindowForFolderURL(URL(fileURLWithPath: "/Library/Desktop Pictures"))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

