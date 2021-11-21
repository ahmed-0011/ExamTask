//
//  ExamHeaderView.swift
//  ExamTask
//
//  Created by ahmed on 19/11/2021.
//

import UIKit

@IBDesignable
class ExamHeaderView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

}
