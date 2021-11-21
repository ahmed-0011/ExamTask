//
//  QuestionCellViewModel.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import Foundation

class QuestionCellViewModel {
    
    var id: Int
    var title: String
    var detailsTitle: String
    var answerID: Int
    var answers: [Answer]
    var numOfAnswers: Int
    var selectedAnswer: Int = -1
    var weight: Double
    var mark: Double = 0
    
    init(question: Question) {
        id = question.id ?? -1
        title = question.title ?? ""
        answerID = question.answerID ?? -1
        answers = question.answers
        numOfAnswers = question.answers.count
        weight = question.weight ?? 0
        detailsTitle = "  Question \(id) (Marked out of \(weight))"
    }
    
    func updateMark() {
        mark = selectedAnswer == answerID ? weight : 0
    }
}
