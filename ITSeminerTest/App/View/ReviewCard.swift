//
//  ReviewCard.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ReviewCard: MaterialCardView {
    
    init (
        data: FRReview,
        action: (() -> Void)? = nil,
        authorPressed: (() -> Void)? = nil,
        drawFooter: Bool = true) {
            
        super.init(x: 10, y: 0, w: UIScreen.ScreenWidth - 20)
        appeareance.textColor = UIColor.TitleColor()
            
        // Author View
        
        let cell = UIView (x: 0, y: 0, w: w, h: 0)
        
        let imageView = UIImageView (x: 10, y: 10, w: 30, h: 30)
        imageView.backgroundColor = UIColor.FBBorderColor()
        imageView.setCornerRadius(imageView.w/2)
        cell.addSubview(imageView)

        data.author.getImage { (image) -> Void in
            imageView.image = image
        }
        
        let nameLabel = UILabel (
            x: imageView.rightWithOffset(10),
            y: imageView.y,
            attributedText: NSAttributedString.withAttributedStrings({ (att) -> () in
                att.appendAttributedString (NSAttributedString.Title(data.author.getName()!))
                att.appendAttributedString (NSAttributedString.Text("\n"+data.date))
            }),
            textAlignment: .Left)

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
        
        
        addCellView(cell, action: authorPressed)
        addCell(data.text, action: action)
        
        
        // Footer view
        
        if !drawFooter {
            return
        }
        
        let footer = UIView (x: 0, y: 0, w: w, h: 0)

        let likeCountLabel = UILabel (
            x: 20,
            y: 5,
            attributedText: NSAttributedString.Text("0"),
            textAlignment: .Left)
        footer.addSubview(likeCountLabel)

        let likeImage = UIImageView (
            frame: CGRect (
                x: likeCountLabel.rightWithOffset(5),
                y: likeCountLabel.y,
                width: likeCountLabel.h,
                height: likeCountLabel.h),
            image: UIImage (named: "likeGray.png")!)
        footer.addSubview(likeImage)
        
        let commentCountLabel = UILabel (
            x: likeImage.rightWithOffset(10),
            y: likeCountLabel.y,
            attributedText: NSAttributedString.Text("0"),
            textAlignment: .Left)
        footer.addSubview(commentCountLabel)

        let commentImage = UIImageView (
            frame: CGRect (
                x: commentCountLabel.rightWithOffset(5),
                y: likeCountLabel.y,
                width: commentCountLabel.h,
                height: commentCountLabel.h),
            image: UIImage (named: "commentGray.png")!)
        footer.addSubview(commentImage)
        
        footer.h = commentImage.bottomWithOffset(5)
        
        data.getComments { (comments) -> Void in
            commentCountLabel.attributedText = NSAttributedString.Text("\(comments.count)")
            data.getLikes({ (likes, didLike) -> Void in
                likeCountLabel.attributedText = NSAttributedString.Text("\(likes.count)")
                
                if didLike {
                    likeImage.image = UIImage (named: "didLikeGray.png")
                    likeImage.userInteractionEnabled = false
                } else {
                    likeImage.addTapGesture(1, action: { (tap) -> () in
                        data.likeReview({
                            likeImage.userInteractionEnabled = false
                            likeImage.image = UIImage (named: "didLikeGray.png")
                            
                            let likeCount = likeCountLabel.text!.toInt()!
                            likeCountLabel.attributedText = NSAttributedString.Text("\(likeCount + 1)")
                        })
                    })
                }
            })
        }
        
        addFooterView(footer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
