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

        if let document = document, let rootSection = document.rootSection {


            let sectionView = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("sectionView")) as! SectionView

            sectionView.representedObject = rootSection
            sectionView.view.frame = NSRect(x: 100, y: 502, width: 300, height: 150)

            sectionViews[rootSection.start] = sectionView
            sectionView.isRoot = true

            container.addSubview(sectionView.view)
            childViewControllers.append(sectionView)

            var viewsToVisit = [SectionView]()
            viewsToVisit.append(sectionView)

            while let toVisit = viewsToVisit.popLast() {

                let callCount = toVisit.section!.calls.count

                for (index, dest) in toVisit.section!.calls.enumerated() {

                    guard let destination = dest.destination else {
                        continue
                    }

                    let childView = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("sectionView")) as! SectionView

                    childView.representedObject = destination
                    let bottomY = 500 + ((CGFloat(callCount) - CGFloat(index)) * CGFloat(30))
                    childView.view.frame = NSRect(x: toVisit.view.frame.maxX + CGFloat(50 * (index + 1)), y: bottomY, width: 300, height: 150)

                    sectionViews[destination.start] = childView

                    container.addSubview(childView.view)
                    childViewControllers.append(childView)

                    viewsToVisit.append(childView)



                }



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

                guard let destView = sectionViews[dest.start] else {
                    continue
                }

                let arrowView = ArrowView(from: sectionVC, to: destView)
                container.arrowViews.append(arrowView)

            }
            view.frame = boundingBox
            container.arrowViews.forEach({ $0.refreshPath()})


        }

    }

}

