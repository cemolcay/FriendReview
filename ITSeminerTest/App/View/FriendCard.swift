//
//  FriendCard.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class FriendCard: MaterialCardView {
    
    init (data: FacebookFriend, action: (fbId: String)->Void) {
        super.init(x: 10, y: 0, w: UIScreen.ScreenWidth - 20)
        
        let cell = UIView (x: 0, y: 0, w: w, h: 0)
        
        let imageView = UIImageView (x: 10, y: 10, w: 30, h: 30)
        imageView.backgroundColor = UIColor.FBBorderColor()
        imageView.imageWithUrl(data.imageUrl)
        imageView.setCornerRadius(imageView.w/2)
        cell.addSubview(imageView)
        
        let nameLabel = UILabel (
            x: imageView.rightWithOffset(10),
            y: imageView.y,
            text: data.firstName + " " + data.lastName,
            textColor: UIColor.TitleColor(),
            textAlignment: .Left,
            font: UIFont.TitleFont())
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
        
        addCellView(cell, action: { () -> Void in
            action (fbId: data.id)
        })
        
        
        let infoLabel = UILabel (
            x: 10,
            y: 0,
            width: cell.w - 20,
            padding: 5,
            text: "Reviews: 0 Comments: 0",
            textColor: UIColor.TitleColor(),
            textAlignment: .Left,
            font: UIFont.TextFont())
        
        data.getUserReviewsCount { (reviewCount, commentCount) -> Void in
            infoLabel.text = "Reviews: \(reviewCount) Comments: \(commentCount)"
        }
        
        addFooterView(infoLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}