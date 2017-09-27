//
//  SectionView.swift
//  Exhume
//
//  Created by Carl Wieland on 9/26/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

class SectionView: NSViewController {


    @IBOutlet weak var sectionTitle: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer?.backgroundColor = NSColor.white.cgColor
        view.layer?.cornerRadius = 12
        view.layer?.borderColor = NSColor.darkGray.cgColor
        let dropShadow = NSShadow()
        dropShadow.shadowColor = NSColor.lightGray
        dropShadow.shadowOffset = NSSize(width: 0, height: -10)
        dropShadow.shadowBlurRadius = 10

        self.view.shadow = dropShadow
        if let section = section {
            sectionTitle.stringValue =  String(format:"0x%06X \(section.instructions.count)", section.start)
        }
    }


    @objc dynamic var section: Section? {
        return representedObject as? Section
    }

    /// Point for call's destination to use
    var inPoint: CGPoint {
        return CGPoint(x: view.frame.origin.x, y: view.frame.origin.y + view.frame.height - 20)
    }

    var outPoint: CGPoint {
        return CGPoint(x: view.frame.origin.x + view.frame.width, y: view.frame.origin.y + view.frame.height - 20)
    }



//    override var representedObject: Any? {
//        didSet {
//
//        }
//    }
}
