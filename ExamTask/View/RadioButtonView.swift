//
//  RadioButtonView.swift
//  ExamTask
//
//  Created by ahmed on 15/11/2021.
//

import UIKit

protocol RadioButtonViewDelegate {
    func setupRadioButtons(selectedRadioButton: UIButton)
}

class RadioButtonView: UIView {
    
    @IBOutlet var radioButton: UIButton!
    @IBOutlet var radioButtonLabel: UILabel!
    var delegate: RadioButtonViewDelegate?
    
    @IBAction func didRadioButtonTapped(_ selectedRadioButton: UIButton) {
        delegate?.setupRadioButtons(selectedRadioButton: selectedRadioButton)
    }
}
