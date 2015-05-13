//
//  FriendCard.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FriendCard: MaterialCardView {
    
    init (data: FRUser, action: () -> Void) {
        super.init(x: 10, y: 0, w: UIScreen.ScreenWidth - 20)
        
        let cell = UIView (x: 0, y: 0, w: w, h: 0)
        
        let imageView = UIImageView (x: 10, y: 10, w: 30, h: 30)
        imageView.backgroundColor = UIColor.FBBorderColor()
        imageView.setCornerRadius(imageView.w/2)
        cell.addSubview(imageView)

        data.getImage { (image) -> Void in
            imageView.image = image
        }
        
        let nameLabel = UILabel (
            x: imageView.rightWithOffset(10),
            y: imageView.y,
            attributedText: NSAttributedString(text: data.getName()!, color: UIColor.TitleColor(), font: UIFont.TitleFont()),
            textAlignment: NSTextAlignment.Left)
        cell.addSubview(nameLabel)
        
        cell.h = max (imageView.bottomWithOffset(10), nameLabel.bottomWithOffset(10))

        if imageView.h > nameLabel.h {
            nameLabel.center.y = cell.center.y
        }
        
        let next = UIImageView (frame: CGRect (origin: CGPointZero, size: CGSize(width: 15, height: 15)))
        next.image = UIImage (named: "next.png")
        next.center.y = cell.center.y
        next.right = cell.right - 10
        cell.addSubview(next)
        
        addCellView(cell, action: action)
        
        
        let infoLabel = UILabel (
            x: 10,
            y: 0,
            width: cell.w - 20,
            padding: 5,
            text: "Reviews: 0",
            textColor: UIColor.TitleColor(),
            textAlignment: .Left,
            font: UIFont.TextFont())
        infoLabel.alpha = 0
        
        data.getReviews { (reviews) -> Void in
            infoLabel.text = "Reviews: \(reviews.count)"
            infoLabel.animate({ () -> Void in
                infoLabel.alpha = 1
            })
        }
                
        addFooterView(infoLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}