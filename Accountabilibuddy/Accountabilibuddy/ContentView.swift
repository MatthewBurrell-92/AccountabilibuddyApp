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

enum GoalUnitTime: String, Codable, CaseIterable {
   case day
   case week
   case month
   case year
}

struct Goal: Codable, Identifiable {
   var id: UUID = UUID()
   var name: String
//   var action: String
   var value: Double
   var unit: String
   var frequency: GoalUnitTime
}

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

