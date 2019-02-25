//
//  UIView+AutoLayout.swift
//  Common Reusable
//  Last updated: Feb 24, 2019
//
//  Created by Jerry Yu on 2016-07-31.
//  Copyright © 2016 Jerry Yu. All rights reserved.
//

import UIKit

extension UIView {

	@discardableResult
    public func pin(attributes: [NSLayoutConstraint.Attribute], to otherView: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
		let constraints = attributes.map({ (attribute) -> NSLayoutConstraint in
			NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: otherView, attribute: attribute, multiplier: multiplier, constant: constant)
		})

        self.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
		return constraints
	}

	@discardableResult
	public func pin(width: CGFloat?, height: CGFloat?) -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()

		if let width = width {
			constraints.append(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
		}
		if let height = height {
			constraints.append(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
		}

        self.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
		return constraints
	}

    @discardableResult
    public func pinToSuperviewEdges() -> [NSLayoutConstraint] {
        return self.pin(attributes: [.top, .right, .bottom, .left], to: self.superview!)
    }
}
