//
//  RadioButtonSuperview.swift
//  ExamTask
//
//  Created by ahmed on 16/11/2021.
//

import UIKit

class RadioButtonSuperview: UIView {
    
    @IBAction func didRadioButtonTapped(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
    }
}
