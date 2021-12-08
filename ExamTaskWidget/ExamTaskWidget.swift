//
//  ExamTaskWidget.swift
//  ExamTaskWidget
//
//  Created by ahmed on 06/12/2021.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    let sampleExamResult = ExamResult(finalGrade: "---/---", numberOfQuestions: "--", submitTime: "--/--/--, --:--")
    
    
    func getExamResult() -> ExamResult {
        @AppStorage(USER_DEFAULTS_KEY, store: UserDefaults(suiteName: SUITE_NAME))
        var data: Data = Data()
        
        do {
            let decoder = JSONDecoder()
            let examResult = try decoder.decode(ExamResult.self, from: data)
            return examResult
        }
        catch {
            print("Unable to decode exam result. (\(error))")
        }
        return sampleExamResult
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), examResult: sampleExamResult)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), examResult: sampleExamResult)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let examResult = getExamResult()
       // WidgetCenter.shared.reloadTimelines(ofKind: "ExamTaskWidget")
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let entryDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, examResult: examResult)
        let entries: [SimpleEntry] = [entry]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let examResult: ExamResult
}

struct ExamTaskWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(spacing: 5) {
            Text("Final Grade: ")
                .fontWeight(.medium)
                .padding(.top, 8)
                .lineLimit(1)
                .font(.largeTitle)
                .minimumScaleFactor(0.2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(entry.examResult.finalGrade)
                .lineLimit(1)
                .font(.system(size: 100, weight: .bold))
                .minimumScaleFactor(0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            if family != .systemSmall {
                Text("Number of questions: \(entry.examResult.numberOfQuestions)")
                    .padding(.leading, 4)
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("submitted at: \(entry.examResult.submitTime)")
                    .padding(.leading, 4)
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("WidgetBackground"))
    }
}

@main
struct ExamTaskWidget: Widget {
    let kind: String = "ExamTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ExamTaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Exam Task")
        .description("View the the result of the last submitted exam.")
    }
}

struct ExamTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = ExamTaskWidgetEntryView(entry: SimpleEntry(date: Date(), examResult: Provider().sampleExamResult))
        view.previewContext(WidgetPreviewContext(family: .systemSmall))
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
        view.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
