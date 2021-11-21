//
//  AnswersStackView.swift
//  ExamTask
//
//  Created by ahmed on 16/11/2021.
//

import UIKit

@IBDesignable
class AnswersStackView: UIStackView {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        let testAnswers: [Answer] = [Answer(title: "answer1", id: 0),
                                     Answer(title: "answer2", id: 1),
                                     Answer(title: "answer3", id: 2),
                                     Answer(title: "answer4", id: 3),
                                     Answer(title: "answer5", id: 4)]
        addRadioButtons(answers: testAnswers, selectedAnswer: -1)
    }
    
    func addRadioButtons(owner: Any? = nil, answers: [Answer], selectedAnswer: Int) {
        
        let nib = UINib(nibName: "\(RadioButtonView.self)", bundle: Bundle(for: RadioButtonView.self))
        for answer in answers {
            let radioButtonView = nib.instantiate(withOwner: owner).first as! RadioButtonView
            radioButtonView.radioButtonLabel.text = answer.title ?? ""
            radioButtonView.radioButton.tag = answer.id ?? -1
            if radioButtonView.radioButton.tag == selectedAnswer {
                radioButtonView.radioButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }
            addArrangedSubview(radioButtonView)
        }
    }
}
