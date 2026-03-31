//
//  RecordProgressView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/3/26.
//


import SwiftUI

struct RecordProgressView: View {
   @EnvironmentObject var viewModel: GoalViewModel
   @Binding var goal: Goal
   @State var goalName: String = ""
   @State var selectedNumber: Int = 1
   @State var selectedDouble: Double = 1.0
   @State var dateValue: Date = Date()
   
   @Binding var path: [GoalRoute]
   
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
            
            switch goal.type {
            case .quantitative:
               if let unit = goal.unitString {
                  Text("How many \(unit) did you \(goal.action)?")
                  switch goal.frequency {
                  case .day:
                     Text("You have recorded \(goal.calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
                  case .week:
                     Text("You have recorded \(goal.calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
                     Text("You have recorded \(goal.calculateWeeklyTotalProgress(goal: goal), specifier: "%.1f") this week.")
                  case .month:
                     Text("You have recorded \(goal.calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
                     Text("You have recorded \(goal.calculateMonthlyTotalProgress(goal: goal), specifier: "%.1f") this month.")
                  case .year:
                     Text("You have recorded \(goal.calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
                     Text("You have recorded \(goal.calculateYearlyTotalProgress(goal: goal), specifier: "%.1f") this year.")
                  }
                  
                  // Picker for small or large values
                  let value = goal.valueDouble ?? 0.0
                  if value < 10.0 {
                     Picker(unit, selection: $selectedDouble) {
                        ForEach(10..<100) { value in
                           let doubleValue = Double(value) / 10.0
                           Text(String(format: "%.1f", doubleValue)).tag(doubleValue)
                        }
                     }
                     .pickerStyle(.wheel)
                  } else {
                     Picker(unit, selection: $selectedDouble) {
                        ForEach(1..<100) { number in
                           Text("\(number)").tag(Double(number))
                        }
                     }
                     .pickerStyle(.wheel)
                  }
                  
                  Button("Record") {
                     let newProgress = Progress(
                        goalID: goal.id,
                        date: dateValue,
                        value: Double(selectedDouble)
                     )
//                     goal.progress.append(newProgress)
//                     viewModel.recordProgress(newProgress: newProgress)
                     let updatedGoal = goal.addProgress(newProgress)
                     viewModel.updateGoal(goal: updatedGoal)
                     
                     path = []
                  }
               }
               
            case .binary:
               let result = goal.binaryMessageAndFlag(goal: goal)
               Text(result.message)
               
               if result.showButton {
                  Button("Yes") {
                     let newProgress = Progress(
                        goalID: goal.id,
                        date: dateValue,
                        value: 1.0
                     )
//                     goal.progress.append(newProgress)
//                     viewModel.recordProgress(newProgress: newProgress)
                     
                     let updatedGoal = goal.addProgress(newProgress)
                     viewModel.updateGoal(goal: updatedGoal)
                     
                     path = []
                  }
               }
               
            case .non_recurring:
               // Non-recurring goal logic: only record how much was done
               Text("You have recorded \(goal.calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
               Text("You have recorded \(goal.calculateWeeklyTotalProgress(goal: goal), specifier: "%.1f") this week.")
               Text("You have recorded \(goal.calculateTotalProgress(goal: goal), specifier: "%.1f") since creating this goal.")
               HStack(spacing: 4) {
                  Text("I completed")
                  TextField("1", value: $selectedDouble, format: .number)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     .frame(minWidth: 30, maxWidth: 80)
                  if let unit = goal.unitString {
                     Text(unit)
                  }
               }
               .padding()
               .background(Color.white)
               .cornerRadius(8)
               
               Button("Record") {
                  let newProgress = Progress(
                     goalID: goal.id,
                     date: dateValue,
                     value: selectedDouble
                  )
                  let updatedGoal = goal.addProgress(newProgress)
                  viewModel.updateGoal(goal: updatedGoal)
                  
                  path = []
               }
               .buttonStyle(.borderedProminent)
            }
         }
         .padding()
      }
   }
   //   var body: some View {
   //      ZStack(alignment: .topLeading) {
   //
   //         VStack {
   //            Text(goal.name).font(.title)
   //
   //            if let unit = goal.unitString {
   //               Text("How many \(unit) did you \(goal.action)?")
   //               if goal.frequency == .day {
   //                  Text("You have recorded \(calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
   //               }
   //               else if (goal.frequency == .week)
   //               {
   //                  // total recorded for the week
   //                  Text("You have recorded \(calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
   //                  Text("You have recorded \(calculateWeeklyTotalProgress(goal: goal), specifier: "%.1f") this week.")
   //               }
   //               else if (goal.frequency == .month)
   //               {
   //                  // total recorded for the month
   //                  Text("You have recorded \(calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
   //                  Text("You have recorded \(calculateMonthlyTotalProgress(goal: goal), specifier: "%.1f") this month.")
   //               }
   //               else if (goal.frequency == .year)
   //               {
   //                  // total recorded for the year
   //                  Text("You have recorded \(calculateDailyTotalProgress(goal: goal), specifier: "%.1f") today.")
   //                  Text("You have recorded \(calculateYearlyTotalProgress(goal: goal), specifier: "%.1f") this year.")
   //               }
   //               let value = goal.valueDouble ?? 0.0
   //               if (value < 10.0)
   //               {
   //                  Picker(unit, selection: $selectedDouble) {
   //                     ForEach(10..<100) { value in
   //                        let doubleValue = Double(value) / 10.0
   //                        Text(String(format: "%.1f", doubleValue))
   //                           .tag(doubleValue)
   //                     }
   //                  }
   //                  .pickerStyle(.wheel)
   //               }
   //               else{
   //                  Picker(unit, selection: $selectedDouble){
   //                     ForEach(1..<100) {number in
   //                        Text("\(number)").tag(Double(number))
   //                     }
   //                  } .pickerStyle(.wheel)
   //               }
   //
   //               Button("Record") {
   //                  let newProgress = Progress(
   //                     goalID: goal.id,
   //                     date: dateValue,
   //                     value: Double(selectedDouble)
   //                  )
   //                  goal.progress.append(newProgress)
   //                  viewModel.recordProgress(newProgress: newProgress)
   //                  //                   showProgAlert = true
   //                  //                }.alert("Progress", isPresented: $showProgAlert) {
   //                  //                   Button("OK", role: .cancel) { }
   //                  //                } message: {
   //                  //                   Text("total porgress:\(goal.progress.last?.value)")
   //               }
   //            } else {
   //               switch goal.frequency {
   //               case .day:
   //                  if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.day))
   //                  {
   //                     Text("You already recorded progress for today").onAppear{ binaryRecordShow=false}
   //                  }
   //                  else{
   //                     Text("Did you \(goal.action) today?")
   //                  }
   //               case .week:
   //                  if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.week))
   //                  {
   //                     Text("You already recorded progress for this week").onAppear{ binaryRecordShow=false}
   //                  }
   //                  else{
   //                     Text("Did you \(goal.action) this week?")
   //                  }
   //               case .month:
   //                  if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.month))
   //                  {
   //                     Text("You already recorded progress for this month").onAppear{ binaryRecordShow=false}
   //                  }
   //                  else{
   //                     Text("Did you \(goal.action) this month?")
   //                  }
   //               case .year:
   //                  if (checkForRecord(goal: goal, timeUnit: GoalUnitTime.year))
   //                  {
   //                     Text("You already recorded progress for this year.").onAppear{ binaryRecordShow=false}
   //                  }
   //                  else{
   //                     Text("Did you \(goal.action) this year?")
   //                  }
   //               }
   //               if (binaryRecordShow){
   //                  Button("Yes") {
   //                     let newProgress = Progress(
   //                        goalID: goal.id,
   //                        date: dateValue,
   //                        value: Double(selectedNumber)
   //                     )
   //                     print("Binary progress")
   //                     goal.progress.append(newProgress)
   //                     viewModel.recordProgress(newProgress: newProgress)
   //                  }
   //               }
   //            }
   //
   //         }
   //      }
   //      .padding()
   //   }
}

// show alert: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-alert

// date/calendar stuff: https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day




struct RecordProgressView_PreviewWrapper: View {
   
   @State private var goal = Goal(
      id: UUID(),
      user: "Test",
      name: "Read BoM",
      action: "read",
      frequency: .week,
      progress: [],
      type: .binary,
      sendEmail: []
   )
   
   @StateObject private var viewModel = GoalViewModel()
   
   var body: some View {
      RecordProgressView(goal: $goal, path: .constant([]))
         .environmentObject(viewModel)
   }
}


#Preview {
   RecordProgressView_PreviewWrapper()
}

