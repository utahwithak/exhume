//
//  AppDelegate.swift
//  Exhume
//
//  Created by Carl Wieland on 9/22/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }

}

