//
//  QuestionTableViewCell.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var questionDetailsLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answersStackView: AnswersStackView!
    var questionCellViewModel: QuestionCellViewModel?
    var radioButtonViews: [RadioButtonView] {
        return answersStackView.subviews as! [RadioButtonView]
    }
    static let identifier = "QuestionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "\(QuestionCell.self)", bundle: nil)
    }

    func viewInit() {
        backgroundColor = .clear
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 3
        initLabels()
    }
    
    func initLabels() {
        questionDetailsLabel.layer.masksToBounds = true
        questionDetailsLabel.layer.cornerRadius = 6
        questionDetailsLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func prepareForReuse() {
        for radioButtonView in answersStackView.subviews {
            radioButtonView.removeFromSuperview()
        }
    }
    
    func configure() {
        viewInit()
        questionDetailsLabel.text = questionCellViewModel?.detailsTitle
        questionLabel.text = questionCellViewModel?.title
        answersStackView.addRadioButtons(owner: self, answers: questionCellViewModel?.answers ?? [], selectedAnswer: questionCellViewModel?.selectedAnswer ?? -1)
    }
    
    @objc @IBAction func didRadioButtonTapped(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        for radioButtonView in radioButtonViews {
            if radioButtonView.radioButton.tag != sender.tag {
                radioButtonView.radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        questionCellViewModel?.selectedAnswer = sender.tag
        questionCellViewModel?.updateMark()
    }
}
