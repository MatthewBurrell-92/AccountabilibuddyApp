//
//  ContentView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 1/31/26.
//

import SwiftUI

struct ContentView: View {
//   @EnvironmentObject var viewModel: GoalViewModel
//   @State private var goals: [Goal] = []
   @StateObject private var viewModel = GoalViewModel()
   
    var body: some View {
       VStack{
          NavigationStack
          {
             NavigationLink(destination: createGoalView()) {
                Text("Create a new Goal")
             }
             NavigationLink(destination: ViewAllGoalsView()) {
                Text("View All Goals")
             }
             NavigationLink(destination: ViewAllGoalsView()) {
                Text("Record goal progress")
             }
             
             
//             .navigationTitle("Home")
          }
//          .onAppear {
//              do {
//                 viewModel.goals = try loadGoals()
//              } catch {
//                  goals = []
//              }
//          }
       }
    }
}

struct GoalListView: View {
    @EnvironmentObject var viewModel: GoalViewModel

    var body: some View {
        List(viewModel.goals) { goal in
           Text(goal.name)
        }
    }
}

// String makes the cases in the enum strings,
// making it easier to use in displays

// Codable makes the values easier to use in JSON encode/decode

// CaseIterable = automatically gives list of all cases
//enum GoalUnitTime: String, Codable, CaseIterable {
//   case daily
//   case weekly
//   case monthly
//   case yearly
//   case custom
//}



// two different kinds of goal?
// binary (make your bed every day)
// quantifiable (run 3 miles a day)
// Parent goal with name
// child binary, child quantifiable

//class GoalClass {
//   var id: UUID = UUID()
//   var name: String
//   var action: String
//   var frequency: GoalUnitTime
//   var progress: [Progress]
//   
//   init(name: String, action: String, frequency: GoalUnitTime) {
//      self.name = name
//      self.action = action
//      self.frequency = frequency
//      self.progress = []
//   }
//}
//
//class BinaryGoal : GoalClass{
//   
//}
//
//class QuantitativeGoal : GoalClass{
//   var value: Double
//   var unit: String
//   
//   init(value: Double, unit: String) {
//      super.init(name: "", action: "", frequency: .day)
//      self.value = value
//      self.unit = unit
//   }
//}

//func loadGoals() throws -> [Goal] {
//    let url = FileManager.default
//        .urls(for: .documentDirectory, in: .userDomainMask)[0]
//        .appendingPathComponent("goals.json")
//
//    guard FileManager.default.fileExists(atPath: url.path) else {
//        return []
//    }
//
//    let data = try Data(contentsOf: url)
//    return try JSONDecoder().decode([Goal].self, from: data)
//}

#Preview {
    ContentView()
}

