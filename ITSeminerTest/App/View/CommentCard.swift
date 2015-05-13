//
//  CommentCard.swift
//  ITSeminerTest
//
//  Created by Cem Olcay on 24/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class CommentCard: MaterialCardView {

    init (data: FRComment) {
        super.init(x: 10, y: 0, w: UIScreen.ScreenWidth - 20)
        appeareance.textColor = UIColor.TitleColor()
        
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
        
        addCellView(cell)
        addCell(data.text)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
