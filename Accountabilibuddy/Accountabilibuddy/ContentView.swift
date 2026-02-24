//
//  ContentView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 1/31/26.
//

import SwiftUI

struct ContentView: View {
   @State private var goals: [Goal] = []
   
    var body: some View {
       VStack{
          NavigationStack
          {
             NavigationLink(destination: createGoalView(goals: $goals)) {
                Text("Create a new Goal")
             }
             NavigationLink(destination: ViewAllGoalsView(goals: $goals)) {
                Text("View All Goals")
             }
             NavigationLink(destination: ViewAllGoalsView(goals: $goals)) {
                Text("Record goal progress")
             }
             
             
//             .navigationTitle("Home")
          }
          .onAppear {
              do {
                  goals = try loadGoals()
              } catch {
                  goals = []
              }
          }
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

enum GoalType: Codable, Hashable {
    case binary
    case quantitative(value: Double, unit: String)
}

enum GoalUnitTime: String, Codable, CaseIterable {
   case day
   case week
   case month
   case year
}

struct Progress: Codable, Identifiable, Hashable {
   var id: UUID = UUID()
   var date: Date
   var value: Double
}

struct Goal: Codable, Identifiable, Hashable {
   var id: UUID = UUID()
   var name: String
   var action: String
//   var value: Double
//   var unit: String
   var frequency: GoalUnitTime
   var progress: [Progress]
   var type: GoalType
}

extension Goal {
    var unitString: String? {
        guard case let .quantitative(_, unit) = type else { return nil }
        return unit
    }

    var valueDouble: Double? {
        guard case let .quantitative(value, _) = type else { return nil }
        return value
    }
}

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

func loadGoals() throws -> [Goal] {
    let url = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("goals.json")

    guard FileManager.default.fileExists(atPath: url.path) else {
        return []
    }

    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([Goal].self, from: data)
}

#Preview {
    ContentView()
}

