//
//  ParsingManager.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import Foundation

class ExamParser: NSObject, XMLParserDelegate {
    
    static let shared = ExamParser()
    var exam = Exam()
    var currentQuestion: Question?
    let examURL = Bundle.main.url(forResource: "ExamXML", withExtension: "xml")

    private override init() {}
    
    func getExam() -> Exam {
        
        if let url = examURL {
            let parser = XMLParser(contentsOf: url)
            parser?.delegate = self
            let success = parser?.parse() ?? false
            
            if success {
                print("Done parsing exam.")
            } else {
                print("error \(String(describing: parser?.parserError))")
            }
        }
        return exam
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "settings" {
            exam.duration = Double(attributeDict["examDuration"] ?? "0")
            exam.numberOfQuestionsPerPage = Int(attributeDict["numberOfQuestionsPerPage"] ?? "0")
            exam.eachQuestionWeight = Double(attributeDict["eachQuestionWeight"] ?? "0")
        }
        if elementName == "question" {
            currentQuestion = Question()
            currentQuestion?.id = Int(attributeDict["id"] ?? "-1")
            currentQuestion?.title = attributeDict["title"]
            currentQuestion?.answerID = Int(attributeDict["answerID"] ?? "-1")
            currentQuestion?.weight = exam.eachQuestionWeight
        }
        
        if elementName == "option" {
            let id = Int(attributeDict["id"] ?? "-1")
            let title = attributeDict["title"]
            let answer = Answer(title: title, id: id)
            currentQuestion?.answers.append(answer)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "question" {
            if let currentQuestion = currentQuestion {
                exam.questions.append(currentQuestion)
            }
        }
    }
}
