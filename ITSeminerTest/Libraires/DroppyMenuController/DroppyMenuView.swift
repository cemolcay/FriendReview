//
//  DroppyMenuView.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

struct DroppyMenuViewAppeareance {
    
    var tintColor: UIColor
    var font: UIFont
    var backgroundColor: UIColor
    
    var lineWidth: CGFloat
    
    var gravityMagnitude: CGFloat
    var springVelocity: CGFloat
    var springDamping: CGFloat
}

extension DroppyMenuViewAppeareance {
    
    init () {
        self.tintColor = UIColor.whiteColor()
        self.font = UIFont.AvenirNextRegular(20)
        self.backgroundColor = UIColor (white: 0, alpha: 0.7)
        self.gravityMagnitude = 5
        self.springDamping = 0.9
        self.springVelocity = 0.9
        self.lineWidth = 1
    }
}

protocol DroppyMenuViewDelegate {
    func droppyMenu (droppyMenu: DroppyMenuView, didItemPressedAtIndex index: Int)
    func droppyMenuDidClosePressed (droppyMenu: DroppyMenuView)
}

class DroppyMenuView: UIView {

    
    // MARK: Properties
    
    var delegate: DroppyMenuViewDelegate?
    var appeareance: DroppyMenuViewAppeareance! {
        didSet {
            backgroundColor = appeareance.backgroundColor
            for view in subviews {
                if let view = view as? UIButton {
                    view.setTitleColor(appeareance.tintColor, forState: .Normal)
                    view.titleLabel?.font = appeareance.font
                    if let layer = view.layer.sublayers?[0] as? CAShapeLayer {
                        layer.strokeColor = appeareance.tintColor.CGColor
                        layer.lineWidth = appeareance.lineWidth
                    } else if let layer = view.layer.sublayers?[1] as? CALayer {
                        layer.backgroundColor = appeareance.tintColor.CGColor
                        
                        var f = layer.frame
                        f.size.height = appeareance.lineWidth
                        layer.frame = f
                    }
                }
            }
        }
    }
    
    var isAnimating: Bool = false
    
    
    
    // MARK: Lifecycle
    
    convenience init (items: [String]) {
        self.init (items: items, appeareance: DroppyMenuViewAppeareance())
    }

    init (items: [String], appeareance: DroppyMenuViewAppeareance) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.appeareance = appeareance
        
        let itemHeight = frame.size.height / CGFloat(items.count + 1)
        var currentY: CGFloat = 0
        var tag: Int = 0
        
        for title in items {
            
            let item = createItem(title, currentY: currentY, itemHeight: itemHeight)
            item.tag = tag++
            currentY += item.h
            addSubview(item)
        }
        
        let close = closeButton(itemHeight)
        close.y = currentY
        addSubview(close)
        
        backgroundColor = appeareance.backgroundColor
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
 
    
    // MARK: Create
    
    func createItem (title: String, currentY: CGFloat, itemHeight: CGFloat) -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: currentY, width: frame.size.width, height: itemHeight))
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(appeareance.tintColor, forState: .Normal)
        button.titleLabel?.font = appeareance.font
        button.addTarget(self, action: "itemPressed:", forControlEvents: .TouchUpInside)
        
        let sep = CALayer ()
        sep.frame = CGRect (x: 0, y: button.h, width: button.w, height: appeareance.lineWidth)
        sep.backgroundColor = appeareance.tintColor.CGColor
        button.layer.addSublayer(sep)
        
        return button
    }
    
    func closeButton (itemHeight: CGFloat) -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: itemHeight))
        button.addTarget(self, action: "closePressed:", forControlEvents: .TouchUpInside)
        
        let close = CAShapeLayer ()
        close.frame = CGRect (x: 0, y: 0, width: 20, height: 20)
        close.position = button.layer.position
        
        let path = UIBezierPath ()
        let a: CGFloat = 20
        path.moveToPoint(CGPoint (x: 0, y: 0))
        path.addLineToPoint(CGPoint (x: a, y: a))
        path.moveToPoint(CGPoint (x: 0, y: a))
        path.addLineToPoint(CGPoint (x: a, y: 0))
        
        close.path = path.CGPath
        close.lineWidth = appeareance.lineWidth
        close.strokeColor = appeareance.tintColor.CGColor
        button.layer.addSublayer (close)
        
        return button
    }
    
    
    
    // MARK: Action
    
    func itemPressed (sender: UIButton) {
        
        if isAnimating {
            return
        }
        
        delegate?.droppyMenu(self, didItemPressedAtIndex: sender.tag)
    }
    
    func closePressed (sender: UIButton) {
        
        if isAnimating {
            return
        }
        
        delegate?.droppyMenuDidClosePressed(self)
    }

}
