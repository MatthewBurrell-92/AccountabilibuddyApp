//
//  ViewAllGoalsView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/2/26.
//

import SwiftUI

struct ViewAllGoalsView: View {
   @EnvironmentObject var viewModel: GoalViewModel
   @State private var expandedGoalId: UUID? = nil // track which dropdown is open
   
   var body: some View {
      ScrollView {
         VStack(alignment: .leading, spacing: 12) {
            ForEach($viewModel.goals) { $goal in
               VStack(alignment: .leading) {
                  
                  // Goal name button
                  Button {
                     // toggle dropdown
                     if expandedGoalId == goal.id {
                        expandedGoalId = nil
                     } else {
                        expandedGoalId = goal.id
                     }
                  } label: {
                     HStack {
                        Text(goal.name)
                           .font(.headline)
                        Spacer()
                        Image(systemName: expandedGoalId == goal.id ? "chevron.down" : "chevron.right")
                           .foregroundColor(.gray)
                     }
                     .padding()
                     .background(Color.blue.opacity(0.1))
                     .cornerRadius(8)
                  }
                  
                  // Dropdown menu
                  if expandedGoalId == goal.id {
                     VStack(alignment: .leading, spacing: 4) {
                        
                        // Record Progress
                        NavigationLink(destination: RecordProgressView(goal: $goal)) {
                           Text("Record Progress")
                              .padding(.vertical, 4)
                        }
                        
                        // Edit Goal
                        NavigationLink(destination: EditGoalView(goal: $goal)) {
                           Text("Edit Goal")
                              .padding(.vertical, 4)
                        }
                        
                        // Delete Goal
                        Button("Delete Goal") {
                           viewModel.removeGoal(id: goal.id)
                           expandedGoalId = nil
                        }
                        .padding(.vertical, 4)
                        .foregroundColor(.red)
                     }
                     .padding(.leading, 16)
                     .transition(.opacity.combined(with: .slide))
                  }
               }
            }
         }
         .padding()
      }
      .navigationTitle("All Goals")
   }
}


struct ViewAllGoalsPreviewWrapper: View {
   @StateObject private var viewModelTest = GoalViewModel(testCases: true)
   
   var body: some View {
      ViewAllGoalsView()
         .environmentObject(viewModelTest)
         .onAppear {
            viewModelTest.goals = [
               Goal(id: UUID(), name: "Read a book", action: "Read 20 pages", frequency: .day, progress: [], type: .binary, sendEmail: .none),
               Goal(id: UUID(), name: "Poop", action: "Run 5 km", frequency: .week, progress: [], type: .quantitative(value: 5, unit: "km"), sendEmail: .none),
               Goal(id: UUID(), name: "Make my bed", action: "Make my bed", frequency: .day, progress: [], type: .binary, sendEmail: .none)
            ]
         }
         .previewLayout(.sizeThatFits)
   }
}

struct ViewAllGoalsView_Previews: PreviewProvider {
   static var previews: some View {
      // Use a wrapper view to hold a fresh ViewModel
      ViewAllGoalsPreviewWrapper()
   }
}




