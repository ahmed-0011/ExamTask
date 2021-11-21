//
//  ExamViewModel.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import Foundation

class ExamViewModel {
    
    var duration: TimeInterval
    var numberOfQuestionsPerPage: Int
    var eachQuestionWeight: Double
    var questionCellViewModels: [QuestionCellViewModel] = []
    var currentPage: Int = 0
    var lastPage: Int = 0
    var grade: Double {
        var marks = 0.0
        for questionCellViewModel in questionCellViewModels {
            marks += questionCellViewModel.mark
        }
        return marks
    }
    var currentPageString: String {
        return "Page: \(currentPage + 1)"
    }
    var timeRemainingString: String {
        duration -= 1
        let hours = Int(duration) / NUMBER_OF_SECONDS_IN_HOUR
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60

        let timeRemaining = hours != 0 ? String(format:" Time Remaining: %02i:%02i:%02i", hours, minutes, seconds) : String(format:" Time Remaining: %02i:%02i", minutes, seconds)
        return timeRemaining
    }
    var finalGradeString: String {
        return "\(String(grade) + "/" + String(eachQuestionWeight * Double(questionCellViewModels.count)))"
    }
    
    
    init(exam: Exam) {
        duration = (exam.duration ?? 0) * Double(NUMBER_OF_SECONDS_IN_HOUR)
        numberOfQuestionsPerPage = exam.numberOfQuestionsPerPage ?? 0
        eachQuestionWeight = exam.eachQuestionWeight ?? 0
        for question in exam.questions {
            questionCellViewModels.append(QuestionCellViewModel(question: question))
        }
        lastPage = Int(ceil(Double(questionCellViewModels.count / numberOfQuestionsPerPage))) - 1
    }
    
    func nextPage() {
        currentPage += 1
    }
    
    func previousPage() {
        currentPage -= 1
    }
}
