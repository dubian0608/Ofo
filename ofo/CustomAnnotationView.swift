//
//  CustomAnnotationView.swift
//  ofo
//
//  Created by Zhang, Frank on 16/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import Foundation
import UIKit

class CustomAnnotationView: MAPinAnnotationView {
    var customCallOut: CustomCallOutView!
    var title: String = "好像没算出来"
    var subtitle: String = "好像要走好远"
    let KCallOutWidth: CGFloat = 130
    let KCallOutHeigth: CGFloat = 50
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected{
            return
        }
        if selected{
            if self.customCallOut == nil {
                self.customCallOut = CustomCallOutView(frame: CGRect(x: 0, y: 0, width: KCallOutWidth, height: KCallOutHeigth))
                self.customCallOut.center = CGPoint(x: self.bounds.width/2 + self.calloutOffset.x, y: -self.bounds.height/2 + self.calloutOffset.y)
            }
            
            self.customCallOut.titleLabel.text = self.title
            self.customCallOut.subtitleLabel.text = self.subtitle
            self.addSubview(customCallOut)
        }
        else{
            customCallOut.removeFromSuperview()
        }
//        super.setSelected(selected, animated: animated)
    }
}

