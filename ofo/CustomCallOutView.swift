//
//  CustomCallOutView.swift
//  ofo
//
//  Created by Zhang, Frank on 16/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class CustomCallOutView: UIView {
    var title: String!
    var subtitle: String!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    let kArrorHeight: CGFloat = 5.0
    let kTitleWidth: CGFloat = 120.0
    let KTitleHeight: CGFloat = 15.0
    let kPortraitMargin: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        titleLabel = UILabel(frame: CGRect(x: kPortraitMargin, y: kPortraitMargin, width: kTitleWidth, height: KTitleHeight))
        titleLabel.font = UIFont(name: "boldSystemFontOfSize", size: 6)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.text = ""
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        subtitleLabel = UILabel(frame: CGRect(x: kPortraitMargin, y: kPortraitMargin * 2 + KTitleHeight, width: kTitleWidth, height: KTitleHeight))
        subtitleLabel.font = UIFont(name: "boldSystemFontOfSize", size: 6)
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.text = ""
        subtitleLabel.textAlignment = .center
        self.addSubview(subtitleLabel)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    override func draw(_ rect: CGRect) {
        self.drawInContext(context: UIGraphicsGetCurrentContext()!)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func drawInContext(context: CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.white.cgColor)
        self.getDrwaPath(context: context)
        context.fillPath()
    }
    func getDrwaPath(context: CGContext) {
        let rrect = self.bounds
        let radius: CGFloat = 6.0
        let minx = rrect.minX
        let midx = rrect.midX
        let maxx = rrect.maxX
        let miny = rrect.minY
        let maxy = rrect.maxY - kArrorHeight
        
        context.move(to: CGPoint(x: midx + kArrorHeight, y: maxy))
        context.addLine(to: CGPoint(x: midx, y: maxy + kArrorHeight))
        context.addLine(to: CGPoint(x: midx - kArrorHeight, y: maxy))
        
        context.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny), radius: radius)
        context.addArc(tangent1End: CGPoint(x: minx, y: minx), tangent2End: CGPoint(x: maxx, y: miny), radius: radius)
        context.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxx), radius: radius)
        context.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: radius)
        context.closePath()
        
    }
    
    
}
