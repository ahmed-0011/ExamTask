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
    var numberOfPages: Int {
        return Int(ceil(Double(questionCellViewModels.count) / Double(numberOfQuestionsPerPage)))
    }
    var startTime: TimeInterval
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
        
        return hours != 0 ? String(format:" Time Remaining: %02i:%02i:%02i", hours, minutes, seconds) : String(format:" Time Remaining: %02i:%02i", minutes, seconds)
    }
    var finalGradeString: String {
        let examWeight = eachQuestionWeight * Double(questionCellViewModels.count)
        let format = (grade == examWeight || grade == 0) ? "%.f / 100" : "%.2f / 100"
        return String(format: format, (100.0 / examWeight) * grade)
    }
    var finishTimeString: String {
        let finishTime = startTime - duration

        let hours = Int(finishTime) / NUMBER_OF_SECONDS_IN_HOUR
        let minutes = Int(finishTime) / 60 % 60
        let seconds = Int(finishTime) % 60
        return "You have finished the exam in \(hours == 0 ? String(format: "%2i minutes and %2i seconds", minutes, seconds) : String(format: "%2i hours, %2i minutes and %2i seconds", hours, minutes, seconds))"
    }
    
    
    init(exam: Exam) {
        duration = (exam.duration ?? 0) * Double(NUMBER_OF_SECONDS_IN_HOUR)
        startTime = duration
        numberOfQuestionsPerPage = exam.numberOfQuestionsPerPage ?? 0
        eachQuestionWeight = exam.eachQuestionWeight ?? 0
        for question in exam.questions {
            questionCellViewModels.append(QuestionCellViewModel(question: question))
        }
        
        if numberOfQuestionsPerPage > 0 {
            lastPage = numberOfPages - 1
        } else {
            numberOfQuestionsPerPage = -1 // set to -1 to prevent division by zero
        }
    }
    
    func nextPage() {
        currentPage += 1
    }
    
    func previousPage() {
        currentPage -= 1
    }
    
    func setPage(_ pageNumber: Int) {
        currentPage = pageNumber
    }
}
