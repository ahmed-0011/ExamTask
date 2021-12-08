//
//  ViewController.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import UIKit
import WidgetKit

class ExamViewController: UIViewController {

    @IBOutlet var examView: ExamView!
    @IBOutlet var examResultView: ExamResultView!
    @IBOutlet var examGradeLabel: UILabel!
    @IBOutlet var examFinishedAt: UILabel!
    let exam = ExamParser.shared.getExam()
    
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
    
    
// MARK: - Exam View Delegate
extension ExamViewController: ExamViewDelegate {
   
    func showExamResultView(finalGradeString: String, finishTimeString: String, numberOfQuestions: String) {
        examGradeLabel.text = finalGradeString
        examFinishedAt.text = finishTimeString
        examView.addSubView(examResultView, constrainedTo: examView)
     
        let examResult = ExamResult(finalGrade: finalGradeString, numberOfQuestions: numberOfQuestions, submitTime: Date().formatted())
        DataManager.shared.saveExamResult(examResult: examResult)
        WidgetCenter.shared.reloadTimelines(ofKind: "ExamTaskWidget")
    }
    
    func showExamDurationEndedDialog() {
        let examDurationEndedAlert = UIAlertController(title: "Exam duration ended.", message: "exam duration has ended.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
            self.examView.showExamResultView()
        }
        examDurationEndedAlert.addAction(okButton)
        present(examDurationEndedAlert, animated: true)
    }
}
