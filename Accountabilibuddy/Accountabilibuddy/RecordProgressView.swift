//
//  RecordProgressView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/3/26.
//


import SwiftUI

struct RecordProgressView: View {
   @Binding var goal: Goal
   @State var goalName: String = ""
   @State var selectedNumber: Int = 1
   @State var selectedDouble: Double = 1.0
   @State var dateValue: Date = Date()
   
   let format = DateFormatter()
   
   let calendar = Calendar.current
   
   @State private var showAlert: Bool = false

   
//   var goalProgress: goal.progress
//   @State var goals: [Goal] = []
//   @Environment(\.dismiss) private var dismiss
    var body: some View {
       ZStack(alignment: .topLeading) {

          
             
          
          VStack {
             Text(goal.name).font(.title)
//             Text("How many " + goal.unit + " did you " + goal.action + "?")
//             switch goal.type {
//             case .binary:
//                 Text("Did you \(goal.action)?")
//             case .quantitative(_, let unit):
//                 Text("How many \(unit) did you \(goal.action)?")
//             }
             if let unit = goal.unitString {
                Text("How many \(unit) did you \(goal.action)?")
                if goal.frequency == .day {
                   Text("You have recorded \(calculateDailyTotalProgress(goal: <#T##Goal#>)) today.")
                }
                else if (goal.frequency == .week)
                {
                   // total recorded for today
                }
                else if (goal.frequency == .month)
                {
                   // total recorded for today
                }
                else if (goal.frequency == .year)
                {
                   // total recorded for today
                }
                let value = goal.valueDouble ?? 0.0
                if (value < 10.0)
                {
                   Picker(unit, selection: $selectedDouble) {
                       ForEach(10..<100) { value in
                           let doubleValue = Double(value) / 10.0
                           Text(String(format: "%.1f", doubleValue))
                               .tag(doubleValue)
                       }
                   }
                   .pickerStyle(.wheel)
                }
                else{
                   Picker(unit, selection: $selectedNumber){
                      ForEach(1..<100) {number in
                         Text("\(number)") .tag(number)
                      }
                   } .pickerStyle(.wheel)
                }
                
                Button("Record") {
                   let newProgress = Progress(
                     date: dateValue,
                     value: Double(selectedNumber)
                     )
                   goal.progress.append(newProgress)
                }
             } else {
                if (goal.progress.last?.date == dateValue)
                {
                   Text("You already recorded progress for today.")
                }
                else{
                   switch goal.frequency {
                   case .day:
                      Text("Did you \(goal.action) today?")
                   case .week:
                      Text("Did you \(goal.action) this week?")
                   case .month:
                      Text("Did you \(goal.action) this month?")
                   case .year:
                      Text("Did you \(goal.action) this year?")
                   }
                   //                 Text("Did you \(goal.action)?")
                   Button("Yes") {
                      let newProgress = Progress(
                        date: dateValue,
                        value: Double(selectedNumber)
                      )
                      goal.progress.append(newProgress)
                   }
                }
                Button {
                   showAlert = true
                } label: {
                   Image(systemName: "questionmark.circle")
                      .font(.title2) // adjust size
                }
                .alert("Helpful Tip", isPresented: $showAlert) {
                   Button("OK", role: .cancel) { }
                } message: {
                   Text("day of week: \(Calendar.current.component(.weekday, from: Date()))")
                }
             }
             
             
          }
       }
        .padding()
    }
}

// show alert: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-alert

// date/calendar stuff: https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day

struct RecordProgressView_PreviewWrapper: View {

    @State private var goal = Goal(
        id: UUID(),
        name: "Read BoM",
        action: "read",
        frequency: .day,
        progress: [],
//        type: .quantitative(value: 5.0, unit: "pages")
        type: .binary
    )

    var body: some View {
       RecordProgressView(goal: $goal)
    }
}

func calculateDailyTotalProgress(goal: Goal) -> Double {
   var dailyProgress: Double = 0.0
   for progress in goal.progress.reversed() {
      if progress.date == Date() {
         dailyProgress += progress.value
      }
      else {
         return dailyProgress
      }
   }
   return dailyProgress
   
   
   // old version, taken from inside view
//   var dailyProgress: Double = 0.0
//   for progressItem in goal.progress {
//        let progressWeekday = calendar.component(.weekday, from: progressItem.date)
//        if progressWeekday == calendar {
//            dailyProgress += progressItem.value
//        }
//    }
}
   

#Preview {
   RecordProgressView_PreviewWrapper()
}
