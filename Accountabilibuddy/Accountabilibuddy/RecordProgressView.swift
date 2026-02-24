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
   @State private var showProgAlert: Bool = false
   
   @State private var binaryRecordShow: Bool = true

   
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
                   Text("You have recorded \(calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
                }
                else if (goal.frequency == .week)
                {
                   // total recorded for the week
                   Text("You have recorded \(calculateWeeklyTotalProgress(goal: goal), specifier: "%.1f") today.")
                }
                else if (goal.frequency == .month)
                {
                   // total recorded for the month
                   Text("You have recorded \(calculateMonthlyTotalProgress(goal: goal), specifier: "%.1f") today.")
                }
                else if (goal.frequency == .year)
                {
                   // total recorded for the year
                   Text("You have recorded \(calculateYearlyTotalProgress(goal: goal), specifier: "%.1f") today.")
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
                   Picker(unit, selection: $selectedDouble){
                      ForEach(1..<100) {number in
                         Text("\(number)") .tag(number)
                      }
                   } .pickerStyle(.wheel)
                }
                
                Button("Record") {
                   let newProgress = Progress(
                     date: dateValue,
                     value: Double(selectedDouble)
                     )
                   goal.progress.append(newProgress)
//                   showProgAlert = true
//                }.alert("Progress", isPresented: $showProgAlert) {
//                   Button("OK", role: .cancel) { }
//                } message: {
//                   Text("total porgress:\(goal.progress.last?.value)")
                }
             } else {
                switch goal.frequency {
                case .day:
                   if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.day))
                   {
                      Text("You already recorded progress for today").onAppear{ binaryRecordShow=false}
                   }
                   else{
                      Text("Did you \(goal.action) today?")
                   }
                case .week:
                   if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.week))
                   {
                      Text("You already recorded progress for this week").onAppear{ binaryRecordShow=false}
                   }
                   else{
                      Text("Did you \(goal.action) this week?")
                   }
                case .month:
                   if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.month))
                   {
                      Text("You already recorded progress for this month").onAppear{ binaryRecordShow=false}
                   }
                   else{
                      Text("Did you \(goal.action) this month?")
                   }
                case .year:
                   if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.year))
                   {
                      Text("You already recorded progress for this year.").onAppear{ binaryRecordShow=false}
                   }
                   else{
                      Text("Did you \(goal.action) this year?")
                   }
                }
                if (binaryRecordShow){
                   Button("Yes") {
                      let newProgress = Progress(
                         date: dateValue,
                         value: Double(selectedNumber)
                         )
                         goal.progress.append(newProgress)
                      }
                   }
                }
               
//                Button {
//                   showAlert = true
//                } label: {
//                   Image(systemName: "questionmark.circle")
//                      .font(.title2) // adjust size
//                }
//                .alert("Helpful Tip", isPresented: $showAlert) {
//                   Button("OK", role: .cancel) { }
//                } message: {
//                   Text("day of week: \(Calendar.current.component(.weekday, from: Date()))")
//                }

          }
       }
        .padding()
    }
}

// show alert: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-alert

// date/calendar stuff: https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day



func calculateDailyTotalProgress(goal: Goal) -> Double {
   let calendar = Calendar.current
   var dailyProgress: Double = 0.0
   for progress in goal.progress.reversed() {
      if calendar.isDate(progress.date, inSameDayAs: Date()){
         dailyProgress += progress.value
      }
      else {
         return dailyProgress
      }
   }
   return dailyProgress
}

func calculateWeeklyTotalProgress(goal: Goal) -> Double {
    let calendar = Calendar.current
    var weeklyProgress: Double = 0.0
    
    // Get the start of the current week (Sunday)
    guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
        return 0.0
    }
    
    for progress in goal.progress.reversed() {
        if progress.date >= startOfWeek {
            weeklyProgress += progress.value
        } else {
            // Stop once we reach a progress outside this week
            break
        }
    }
    
    return weeklyProgress
}

func calculateMonthlyTotalProgress(goal: Goal) -> Double {
    let calendar = Calendar.current
    var monthlyProgress: Double = 0.0
    
    // Start of the current month
    guard let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start else {
        return 0.0
    }
    
    for progress in goal.progress.reversed() {
        if progress.date >= startOfMonth {
            monthlyProgress += progress.value
        } else {
            break
        }
    }
    
    return monthlyProgress
}

func calculateYearlyTotalProgress(goal: Goal) -> Double {
    let calendar = Calendar.current
    var yearlyProgress: Double = 0.0
    
    // Start of the current year
    guard let startOfYear = calendar.dateInterval(of: .year, for: Date())?.start else {
        return 0.0
    }
    
    for progress in goal.progress.reversed() {
        if progress.date >= startOfYear {
            yearlyProgress += progress.value
        } else {
            break
        }
    }
    
    return yearlyProgress
}

func checkForRecord(goal: Goal, timeUnit: GoalUnitTime) -> Bool {
   let calendar = Calendar.current
   
   if timeUnit == .day {
      if let lastProgress = goal.progress.last {
         if calendar.isDate(lastProgress.date, inSameDayAs: Date()) {
            return true
         }
      }
   }
   
   if timeUnit == .week {
      guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
         return false
      }
      for progress in goal.progress.reversed() {
          if progress.date >= startOfWeek {
              return true
          }
         else {
            return false
         }
      }

   }
   
   if timeUnit == .month {
      guard let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start else {
          return false
      }
      
      for progress in goal.progress.reversed() {
         if progress.date >= startOfMonth {
            return true
         } else {
            return false
         }
      }
   }
   
   if timeUnit == .year {
      guard let startOfYear = calendar.dateInterval(of: .year, for: Date())?.start else {
          return false
      }
      
      for progress in goal.progress.reversed() {
          if progress.date >= startOfYear {
              return true
          } else {
              return false
          }
      }
   }
   
   return false
}

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
   

#Preview {
   RecordProgressView_PreviewWrapper()
}
