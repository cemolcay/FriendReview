//
//  MaterialCardView.swift
//  MaterialCardView
//
//  Created by Cem Olcay on 22/01/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

enum MaterialAnimationTimingFunction {
    case SwiftEnterInOut
    case SwiftExitInOut
    
    func timingFunction () -> CAMediaTimingFunction {
        switch self {
            
        case .SwiftEnterInOut:
            return CAMediaTimingFunction (controlPoints: 0.4027, 0, 0.1, 1)
            
        case .SwiftExitInOut:
            return CAMediaTimingFunction (controlPoints: 0.4027, 0, 0.2256, 1)
        }
    }
}

enum MaterialRippleLocation {
    case Center
    case TouchLocation
}


extension UIView {

    func addRipple (action: (()->Void)?) {
        addRipple(true, action: action)
    }
    
    func addRipple (
        withOverlay: Bool,
        action: (()->Void)?) {
        addRipple(
            UIColor.Gray(51, alpha: 0.1),
            duration: 0.9,
            location: .TouchLocation,
            withOverlay: withOverlay,
            action: action)
    }
    
    func addRipple (
        color: UIColor,
        duration: NSTimeInterval,
        location: MaterialRippleLocation,
        withOverlay: Bool,
        action: (()->Void)?) {
        
        let ripple = RippleLayer (
            superLayer: layer,
            color: color,
            animationDuration: duration,
            location: location,
            withOverlay: withOverlay,
            action: action)

        addTapGesture(1, action: { [unowned self] (tap) -> () in
            ripple.animate(tap.locationInView (self))
            action? ()
        })
    }
}

class RippleLayer: CALayer {
    
    
    // MARK: Properties
    
    var color: UIColor!
    var animationDuration: NSTimeInterval!
    var location: MaterialRippleLocation! = .TouchLocation
    
    var action: (()->Void)?
    var overlay: CALayer?
    
    
    // MARK: Animations
    
    lazy var rippleAnimation: CAAnimation = {
        let scale = CABasicAnimation (keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 15
        
        let opacity = CABasicAnimation (keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.autoreverses = true
        opacity.duration = self.animationDuration / 2
        
        let anim = CAAnimationGroup ()
        anim.animations = [scale, opacity]
        anim.duration = self.animationDuration
        anim.timingFunction = MaterialAnimationTimingFunction.SwiftEnterInOut.timingFunction()
        
        return anim
    } ()
    
    lazy var overlayAnimation: CABasicAnimation = {
        let overlayAnim = CABasicAnimation (keyPath: "opacity")
        overlayAnim.fromValue = 1
        overlayAnim.toValue = 0
        overlayAnim.duration = self.animationDuration
        overlayAnim.timingFunction = MaterialAnimationTimingFunction.SwiftEnterInOut.timingFunction()
        
        return overlayAnim
    } ()
    
    
    // MARK: Lifecylce 
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init!(layer: AnyObject!) {
        super.init(layer: layer)
    }
    
    init (
        superLayer: CALayer,
        color: UIColor,
        animationDuration: NSTimeInterval,
        location: MaterialRippleLocation,
        withOverlay: Bool,
        action: (()->Void)?) {
            
        super.init()
        self.color = color
        self.animationDuration = animationDuration
        self.location = location
        self.action = action
            
        initRipple(superLayer)

        if withOverlay {
            initOverlay(superLayer)
        }
    }

    
    // MARK: Setup
    
    func initOverlay (superLayer: CALayer) {
        overlay = CALayer ()
        overlay!.frame = superLayer.frame
        overlay!.backgroundColor = UIColor.Gray(0, alpha: 0.05).CGColor
        overlay!.opacity = 0
        superLayer.addSublayer(overlay!)
    }
    
    func initRipple (superLayer: CALayer) {
        let size = min(superLayer.frame.size.width, superLayer.frame.size.height) / 2
        frame = CGRect (x: 0, y: 0, width: size, height: size)
        backgroundColor = color.CGColor
        opacity = 0
        cornerRadius = size/2
        
        masksToBounds = true
        superLayer.masksToBounds = true
        superLayer.addSublayer(self)
    }
    
    
    // MARK: Animate
    
    func animate (touchLocation: CGPoint) {
        
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        if location == .TouchLocation {
            position = touchLocation
        } else {
            position = superlayer.position
        }
        CATransaction.commit()
    
        let animationGroup = rippleAnimation as! CAAnimationGroup
        if let over = overlay {
            over.addAnimation(overlayAnimation, forKey: "overlayAnimation")
        }
        
        addAnimation(animationGroup, forKey: "rippleAnimation")
    }

}


struct MaterialCardAppeareance {
    
    var headerBackgroundColor: UIColor
    var cellBackgroundColor: UIColor
    var borderColor: UIColor
    
    var titleFont: UIFont
    var titleColor: UIColor
    
    var textFont: UIFont
    var textColor: UIColor
    
    var shadowColor: UIColor
    var rippleColor: UIColor
    var rippleDuration: NSTimeInterval
    
    var bottomLineOffset: CGFloat
    
    init (
        headerBackgroundColor: UIColor,
        cellBackgroundColor: UIColor,
        borderColor: UIColor,
        titleFont: UIFont,
        titleColor: UIColor,
        textFont: UIFont,
        textColor: UIColor,
        shadowColor: UIColor,
        rippleColor: UIColor,
        rippleDuration: NSTimeInterval,
        bottomLineOffset: CGFloat) {
            
        self.headerBackgroundColor = headerBackgroundColor
        self.cellBackgroundColor = cellBackgroundColor
        self.borderColor = borderColor
        
        self.titleFont = titleFont
        self.titleColor = titleColor
        
        self.textFont = textFont
        self.textColor = textColor
            
        self.shadowColor = shadowColor
        self.rippleColor = rippleColor
        self.rippleDuration = rippleDuration
            
        self.bottomLineOffset = bottomLineOffset
    }
}

class MaterialCardCell: UIView {
    
    
    // MARK: Constants
    
    let itemPadding: CGFloat = 14
    
    
    // MARK: Properties
    
    private var parentCard: MaterialCardView!
    
    var bottomLine: UIView?
    
    
    // MARK: Lifecyle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init (card: MaterialCardView) {
        super.init(frame: CGRect(x: 0, y: 0, width: card.w, height: 0))
        parentCard = card
    }
    
    
    // MARK: Create
    
    func addTitle (title: String) {
        let title = UILabel (
            x: 20,
            y: h,
            width: parentCard.w - itemPadding*2,
            padding: itemPadding,
            text: title,
            textColor: parentCard.appeareance.titleColor,
            textAlignment: .Left,
            font: parentCard.appeareance.titleFont)
        addView(title)
    }
    
    func addText (text: String) {
        let text = UILabel (
            x: itemPadding,
            y: h,
            width: parentCard.w - itemPadding*2,
            padding: itemPadding,
            text: text,
            textColor: parentCard.appeareance.textColor,
            textAlignment: .Left,
            font: parentCard.appeareance.textFont)
        addView(text)
    }
    
    func addView (view: UIView) {
        addSubview(view)
        h += view.h
    }
    
    func drawBottomLine (full isFull: Bool = false) {
        if let line = bottomLine {
            return
        }
        
        let bottomLineOffset: CGFloat = isFull ? 0 : parentCard.appeareance.bottomLineOffset
        
        bottomLine = UIView (x: bottomLineOffset, y: h - 0.5, w: w - bottomLineOffset + 20, h: 0.5)
        bottomLine!.backgroundColor = parentCard.appeareance.borderColor
        addSubview(bottomLine!)
    }
    
    func removeBottomLine () {
        if let l = bottomLine {
            l.removeFromSuperview()
            bottomLine = nil
        }
    }

}

extension UIView {
    func materialize () {
//        addShadow(
//            CGSize (width: 0, height: 0),
//            radius: 1,
//            color: UIColor.ShadowColor(),
//            opacity: 0.5,
//            cornerRadius: 1)
        addBorder(0.5, color: UIColor.CardBorderColor())
    }
}

class MaterialCardView: UIView {
    
    
    // MARK: Constants
    
    let cardRadius: CGFloat = 2
    let rippleDuration: NSTimeInterval = 0.9
    let shadowOpacity: Float = 0.5
    let shadowRadius: CGFloat = 1
    
    let estimatedRowHeight: CGFloat = 53
    let estimatedHeaderHeight: CGFloat = 40
    
    
    
    // MARK: Properties
    
    var appeareance: MaterialCardAppeareance!
    var items: [MaterialCardCell] = []
    var contentView: UIView!
    
    var hasHeader: Bool = false
    var hasFooter: Bool = false
    
    
    // MARK: Lifecylce
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init () {
        self.init()
        defaultInit()
    }
    
    
    init (x: CGFloat, y: CGFloat, w: CGFloat) {
        super.init(frame: CGRect (x: x, y: y, width: w, height: 0))
        defaultInit()
    }
    
    func defaultInit () {
        h = 0
        appeareance = defaultAppeareance()
        backgroundColor = UIColor.whiteColor()
        
        contentView = UIView (frame: CGRect (x: 0, y: 0, width: w, height: 0))
        addSubview(contentView)
    }
    
    
    
    // MARK: Setup
    
    func defaultAppeareance () -> MaterialCardAppeareance {
        return MaterialCardAppeareance (
            headerBackgroundColor: UIColor.CardHeaderColor(),
            cellBackgroundColor: UIColor.CardCellColor(),
            borderColor: UIColor.CardBorderColor(),
            titleFont: UIFont.TitleFont(),
            titleColor: UIColor.TitleColor(),
            textFont: UIFont.TextFont(),
            textColor: UIColor.TextColor(),
            shadowColor: UIColor.ShadowColor(),
            rippleColor: UIColor.RippleColor(),
            rippleDuration: rippleDuration,
            bottomLineOffset: 20)
    }
    
    
    
    // MARK: Card
    
    func updateFrame () {
        var current = 0
        var currentY: CGFloat = 0
        for item in items {
            item.y = currentY
            currentY += item.h
            
            item.removeBottomLine()
            if current < items.count - 1 { // skip last cell
                
                if current == 0 { // first cell
                    
                    if hasHeader {
                        item.drawBottomLine(full: true)
                    } else {
                        item.drawBottomLine()
                    }
                    
                } else if current == items.count - 2 { // get cell before last
                    if hasFooter {
                        item.drawBottomLine(full: true)
                    } else {
                        item.drawBottomLine()
                    }
                    
                } else { // everything else
                    item.drawBottomLine()
                }
            }
            
            current++
        }
        
        contentView.size = size
        materialize()
    }
    
    override func materialize () {
        addBorder(0.5, color: UIColor.CardBorderColor())
    }
    
    func shadowRadiusAnimation (to: CGFloat) {
        
        let radiusAnim = CABasicAnimation (keyPath: "shadowRadius")
        radiusAnim.fromValue = layer.shadowRadius
        radiusAnim.toValue = to
        radiusAnim.duration = rippleDuration
        radiusAnim.timingFunction = MaterialAnimationTimingFunction.SwiftEnterInOut.timingFunction()
        radiusAnim.autoreverses = true
        
        let offsetAnim = CABasicAnimation (keyPath: "shadowOffset")
        offsetAnim.fromValue = NSValue (CGSize: layer.shadowOffset)
        offsetAnim.toValue = NSValue (CGSize: layer.shadowOffset + CGSize (width: 0, height: to))
        offsetAnim.duration = rippleDuration
        offsetAnim.timingFunction = MaterialAnimationTimingFunction.SwiftEnterInOut.timingFunction()
        offsetAnim.autoreverses = true
        
        let anim = CAAnimationGroup ()
        anim.animations = [radiusAnim, offsetAnim]
        anim.duration = rippleDuration*2
        anim.timingFunction = MaterialAnimationTimingFunction.SwiftEnterInOut.timingFunction()
        
        layer.addAnimation(anim, forKey: "shadowAnimation")
    }
    
    override func addRipple(action: (() -> Void)?) {
        contentView.addRipple(
            appeareance.rippleColor,
            duration: appeareance.rippleDuration,
            location: .TouchLocation,
            withOverlay: false,
            action: { [unowned self] sender in
                self.shadowRadiusAnimation(6)
                action? ()
            })
    }
    
    
    
    // MARK: Add Cell
    
    func addHeader (title: String) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.headerBackgroundColor
        
        cell.addTitle(title)
        cell.h = max (cell.h, estimatedHeaderHeight)
        
        items.insert(cell, atIndex: 0)
        add(cell)
        
        hasHeader = true
    }
    
    func addHeaderView (view: UIView) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.headerBackgroundColor
        
        cell.addView(view)
        
        items.insert(cell, atIndex: 0)
        add(cell)
        
        hasHeader = true
    }
    
    func addNextHeader (title: String, action: (() -> Void)? = nil) {
        
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.headerBackgroundColor
        
        cell.addTitle(title)
        cell.h = max (cell.h, estimatedHeaderHeight)
        
        items.insert(cell, atIndex: 0)
        add(cell)
        
        let nextImage = UIImageView (image: UIImage (named: "nextGray.png")!)
        nextImage.right = cell.right - 20
        nextImage.center.y = cell.center.y
        cell.addSubview (nextImage)
        
        if let a = action {
            cell.addTapGestureWithOverlay({ (tap) -> Void in
                a ()
            })
        }
            
        hasHeader = true
    }
    
    
    func addFooter (title: String) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.headerBackgroundColor
        
        cell.addTitle(title)
        cell.h = max (cell.h, estimatedHeaderHeight)
        
        items.insert(cell, atIndex: items.count)
        add(cell)
        
        hasFooter = true
    }
    
    func addFooterView (view: UIView) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.headerBackgroundColor
        
        cell.addView(view)
        
        items.insert(cell, atIndex: items.count)
        add(cell)
        
        hasFooter = true
    }
    
    
    func addCell (text: String, action: (()->Void)? = nil) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.cellBackgroundColor
        
        cell.addText(text)
        cell.h = max (cell.h, estimatedRowHeight)
        
        if let act = action {
            cell.addRipple(
                appeareance.rippleColor,
                duration: appeareance.rippleDuration,
                location: .TouchLocation,
                withOverlay: true,
                action: act)
        }
        
        items.append(cell)
        add(cell)
    }
    
    func addCellView (view: UIView, action: (()->Void)? = nil) {
        let cell = MaterialCardCell (card: self)
        cell.backgroundColor = appeareance.cellBackgroundColor
        
        cell.addView(view)
        
        if let act = action {
            cell.addRipple(
                appeareance.rippleColor,
                duration: appeareance.rippleDuration,
                location: .TouchLocation,
                withOverlay: true,
                action: act)
        }
        
        items.append(cell)
        add(cell)
    }
    
    func addCell (cell: MaterialCardCell) {
        cell.backgroundColor = appeareance.cellBackgroundColor
        
        items.append(cell)
        add(cell)
    }
    
    
    private func add (cell: MaterialCardCell) {
        contentView.addSubview(cell)
        h += cell.h
        
        updateFrame()
    }
    
    
    
    // MARK: Remove Cell
    
    func removeCellAtIndex (index: Int) {
        if index < items.count {
            let cell = items[index]
            removeCell(cell)
        }
    }
    
    func removeCell (cell: MaterialCardCell) {
        cell.removeFromSuperview()
        items.removeObject(cell)
        
        h -= cell.h
        updateFrame()
    }
}
