//
//  NSLayoutConstraint+Helper.swift
//  Github Top 30
//
//  Created by Kiran Kumar on 16/11/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    @discardableResult class func constraintWRTSuperView(subview: UIView, constraintTop: Bool, topConstant: CGFloat, constraintBottom: Bool, bottomConstant: CGFloat, constraintLeft: Bool, leftConstant: CGFloat, constraintRight: Bool, rightConstant: CGFloat) -> [String: NSLayoutConstraint]? {
        guard let superview = subview.superview else {
            return nil
        }
        
        var constraintsDict = [String: NSLayoutConstraint]()
        
        if constraintTop {
            let constraint = NSLayoutConstraint(item: superview, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .top, multiplier: 1.0, constant: topConstant)
            constraintsDict[ConstTopConstraint] = constraint
        }
        
        if constraintBottom {
            let constraint = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: subview, attribute: .bottom, multiplier: 1.0, constant: bottomConstant)
            constraintsDict[ConstBotConstraint] = constraint
        }
        
        if constraintLeft {
            let constraint = NSLayoutConstraint(item: superview, attribute: .leading, relatedBy: .equal, toItem: subview, attribute: .leading, multiplier: 1.0, constant: leftConstant)
            constraintsDict[ConstLeftConstraint] = constraint
        }
        
        if constraintRight {
            let constraint = NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: rightConstant)
            constraintsDict[ConstRightConstraint] = constraint
        }
        
        return constraintsDict
    }
    
    @discardableResult class func constraintToSuperView(subView: UIView) -> [String: NSLayoutConstraint]? {
        return constraintWRTSuperView(subview: subView, constraintTop: true, topConstant: 0, constraintBottom: true, bottomConstant: 0, constraintLeft: true, leftConstant: 0, constraintRight: true, rightConstant: 0)
    }

    @discardableResult class func constraint(view: UIView, constraintHeight: Bool, heightConstant: CGFloat, constraintWidth: Bool, widthConstant: CGFloat) -> [String: NSLayoutConstraint]? {
        var constraintsDict = [String: NSLayoutConstraint]()
        
        if constraintHeight {
            let constraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: heightConstant)
            constraintsDict[ConstHeightConstraint] = constraint
        }
        
        if constraintWidth {
            let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthConstant)
            constraintsDict[ConstWidthConstraint] = constraint
        }
        
        return constraintsDict
    }
    
}
