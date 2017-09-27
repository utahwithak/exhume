//
//  ViewController.swift
//  Exhume
//
//  Created by Carl Wieland on 9/22/17.
//  Copyright © 2017 Datum Apps. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var scrollView: NSScrollView!
    var container: SectionViewsContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        container = SectionViewsContainer(frame: NSRect(x: 0, y: 0, width: 4096, height: 4096))
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.lightGray.cgColor
        scrollView.documentView = container

    }

    var document: Document? {
        return representedObject as? Document
    }

    override var representedObject: Any? {
        didSet {
            refreshView()
        }
    }


    func refreshView() {
        for v in container.subviews {
            v.removeFromSuperview()
        }

        if let document = document {
            var xLine = 0
            for (index,section) in document.sections.values.enumerated()  {

                let sectionView = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("sectionView")) as! SectionView

                sectionView.representedObject = section

                container.addSubview(sectionView.view)

                childViewControllers.append(sectionView)

                if index % 20 == 0 {
                    xLine += 1
                }

                sectionView.view.frame = NSRect(x: xLine * 200, y: (index % 20) * 100, width: 150, height: 75)

            }
        }

    }

}

