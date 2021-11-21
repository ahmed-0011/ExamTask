//
//  UIView.swift
//  ExamTask
//
//  Created by ahmed on 16/11/2021.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubView(_ subview: UIView, constrainedTo anchorsView: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([subview.centerXAnchor.constraint(equalTo: anchorsView.centerXAnchor),
                                     subview.centerYAnchor.constraint(equalTo: anchorsView.centerYAnchor),
                                     subview.widthAnchor.constraint(equalTo: anchorsView.widthAnchor),
                                     subview.heightAnchor.constraint(equalTo: anchorsView.heightAnchor)])
    }
}
