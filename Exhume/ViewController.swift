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

    var sectionViews = [UInt64: SectionView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        container = SectionViewsContainer(frame: NSRect(x: 0, y: 0, width: 10000, height: 10000))
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.lightGray.cgColor
        scrollView.documentView = container
        scrollView.allowsMagnification = true
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = true

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

        sectionViews.removeAll()

        if let document = document {
            var xLine = 0
            for (index,section) in document.sections.values.enumerated()  {

                let sectionView = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("sectionView")) as! SectionView

                sectionView.representedObject = section

                sectionViews[section.start] = sectionView
                container.addSubview(sectionView.view)

                childViewControllers.append(sectionView)

                if index % 20 == 0 {
                    xLine += 1
                }

                sectionView.view.frame = NSRect(x: xLine * 400, y: (index % 20) * 300 , width: 300, height: 150)

            }
        }

        var boundingBox = view.frame

        for (_, sectionVC) in sectionViews {
            boundingBox = boundingBox.union(sectionVC.view.frame)
            guard let section = sectionVC.representedObject as? Section else {
                sectionVC.view.removeFromSuperview()
                sectionVC.removeFromParentViewController()
                continue
            }

            for call in section.calls {
                guard let dest = call.destination else {
                    continue
                }

                print("Found Dest!")
                guard let destView = sectionViews[dest.start] else {
                    continue
                }
                print("Found dest View!")

                let arrowView = ArrowView(from: sectionVC, to: destView)
                container.arrowViews.append(arrowView)

            }
            view.frame = boundingBox
            container.arrowViews.forEach({ $0.refreshPath()})


        }

    }

}

