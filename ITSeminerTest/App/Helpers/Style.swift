//
//  Style.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit


extension UIColor {
    
    class func FBBorderColor () -> UIColor! {
        return UIColor (red:56/255.0, green:69/255.0, blue:112/255.0, alpha:1)
    }

    class func FBBackgroundColor () -> UIColor! {
        return UIColor (red:255/255.0, green:242/255.0, blue:248/255.0, alpha:1)
    }

    class func FBPink () -> UIColor! {
        return UIColor (red:238/255.0, green:232/255.0, blue:255/255.0, alpha:1)
    }

    class func FBTextColor () -> UIColor! {
        return UIColor (red:65/255.0, green:73/255.0, blue:99/255.0, alpha:1)
    }

    class func FBTitleColor () -> UIColor! {
        return UIColor (red:42/255.0, green:52/255.0, blue:82/255.0, alpha:1)
    }
}

extension NSAttributedString {
    
    class func Title (string: String) -> NSAttributedString {
        return NSAttributedString (text: string, color: UIColor.TitleColor(), font: UIFont.TitleFont(), style: .plain)
    }
    
    class func Text (string: String) -> NSAttributedString {
        return NSAttributedString (text: string, color: UIColor.TextColor(), font: UIFont.TextFont(), style: .plain)
    }
}


extension UIColor {
    
    class func CardHeaderColor () -> UIColor {
        return Gray(242)
    }
    
    class func CardCellColor () -> UIColor {
        return Gray(249)
    }
    
    class func CardBorderColor () -> UIColor {
        return Gray(200)
    }
    
    
    class func RippleColor () -> UIColor {
        return UIColor.Gray(51, alpha: 0.1)
    }
    
    class func ShadowColor () -> UIColor {
        return UIColor.Gray(51)
    }
    
    
    class func TitleColor () -> UIColor {
        return Gray(51)
    }
    
    class func TextColor () -> UIColor {
        return Gray(144)
    }
}

extension UIFont {
    
    class func TitleFont () -> UIFont {
        return AvenirNextDemiBold(14)
    }
    
    class func TextFont () -> UIFont {
        return AvenirNextRegular(13)
    }
}
