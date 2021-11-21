//
//  Exam.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import Foundation

struct Exam {
    var duration: Double?
    var questions: [Question] = []
    var numberOfQuestionsPerPage: Int?
    var eachQuestionWeight: Double?
}

struct Question {
    var title: String?
    var id: Int?
    var answerID: Int?
    var answers: [Answer] = []
    var weight: Double?
}

struct Answer {
    var title: String?
    var id: Int?
}
