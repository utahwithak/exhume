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

        if let section = section {
            sectionTitle.stringValue =  String(format:"0x%06X \(section.instructions.count)", section.start)
        }
    }
    
    @objc dynamic var section: Section? {
        return representedObject as? Section
    }

//    override var representedObject: Any? {
//        didSet {
//
//        }
//    }
}
