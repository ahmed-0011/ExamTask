//
//  DataManager.swift
//  ExamTask
//
//  Created by ahmed on 07/12/2021.
//

import Foundation

class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    private init() {}
    
    func saveExamResult(examResult: ExamResult) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(examResult)
            
            guard let userDefaults =  UserDefaults(suiteName: SUITE_NAME) else { return }
            userDefaults.set(data, forKey: USER_DEFAULTS_KEY)
            userDefaults.synchronize()
        }
        catch {
            print("Unable to encode exam result. (\(error))")
        }
    }
    
    func getExamResult() -> ExamResult? {

        if let data = UserDefaults(suiteName: SUITE_NAME)?.data(forKey: USER_DEFAULTS_KEY) {
            do {
                let decoder = JSONDecoder()
                let examResult = try decoder.decode(ExamResult.self, from: data)
                return examResult
            }
            catch {
                print("Unable to decode exam result. (\(error))")
            }
        }
        return nil
    }
}
