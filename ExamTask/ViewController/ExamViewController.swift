//
//  ViewController.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import UIKit

class ExamViewController: UIViewController {

    @IBOutlet var examView: ExamView!
    @IBOutlet var examResultView: ExamResultView!
    @IBOutlet var examGradeLabel: UILabel!
    let exam = ExamParser.shared.parse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        examView.delegate = self
        examView.examViewModel = ExamViewModel(exam: exam)
    }
    
    @IBAction func didTryAgainTapped(_ sender: Any) {
        examView.examViewModel = ExamViewModel(exam: exam)
        examView.tryAgain()
        examResultView.removeFromSuperview()
    }
}

extension ExamViewController: ExamViewDelegate {
   
    func showExamResultView(finalGradeString: String) {
        examGradeLabel.text = finalGradeString
        examView.addSubView(examResultView, constrainedTo: examView)
    }
}
