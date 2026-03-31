//
//  ViewAllGoalsView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/2/26.
//

import SwiftUI

struct ViewAllGoalsView: View {
   @EnvironmentObject var viewModel: GoalViewModel
   @State private var expandedGoalId: UUID? = nil
   @Binding var path: [GoalRoute]
   
   var body: some View {
      ScrollView {
         VStack(alignment: .leading, spacing: 12) {
            ForEach($viewModel.goals) { $goal in
               VStack(alignment: .leading) {
                  // Goal name button
                  Button {
                     expandedGoalId = (expandedGoalId == goal.id) ? nil : goal.id
                  } label: {
                     HStack {
                        Text(goal.name)
                           .font(.headline)
                           .foregroundColor(goal.active ? .primary : .gray)
                        Spacer()
                        Image(systemName: expandedGoalId == goal.id ? "chevron.down" : "chevron.right")
                           .foregroundColor(.gray)
                     }
                     .padding()
                     .background(goal.active ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                     .cornerRadius(8)
                  }
                  
                  // Dropdown menu
                  if expandedGoalId == goal.id {
                     GoalDropdownView(goal: $goal, viewModel: viewModel, path: $path) {
                        expandedGoalId = nil
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

struct GoalDropdownView: View {
   @Binding var goal: Goal
   @ObservedObject var viewModel: GoalViewModel
   @Binding var path: [GoalRoute]
   var collapse: () -> Void
   
   var body: some View {
      VStack(alignment: .leading, spacing: 4) {
         if goal.active {
//            NavigationLink(destination: RecordProgressView(goal: $goal, path: .constant([]))) {
//               Text("Record Progress").padding(.vertical, 4)
//            }
            
            Button("Record Progress") {
               path.append(.recordProgress(goal.id))
            }
            
//            NavigationLink(destination: EditGoalView(goal: $goal)) {
//               Text("Edit Goal").padding(.vertical, 4)
//            }
            
            Button("Edit Goal") {
               path.append(.editGoal(goal.id))
            }
            
            Button("Set to Inactive") {
               let updatedGoal = goal.setInactive()
               viewModel.updateGoal(goal: updatedGoal)
               collapse()
            }
            .padding(.vertical, 4)
            .foregroundColor(.red)
            
            Button("Delete Goal") {
               viewModel.removeGoal(id: goal.id)
               collapse()
            }
            .padding(.vertical, 4)
            .foregroundColor(.red)
         } else {
            Button("Reactivate") {
               let updatedGoal = goal.setActive()
               viewModel.updateGoal(goal: updatedGoal)
               collapse()
            }
            .padding(.vertical, 4)
            .foregroundColor(.green)
            
            Button("Delete Goal") {
               viewModel.removeGoal(id: goal.id)
               collapse()
            }
            .padding(.vertical, 4)
            .foregroundColor(.red)
         }
      }
   }
}


struct ViewAllGoalsPreviewWrapper: View {
   @StateObject private var viewModelTest = GoalViewModel(testCases: true)
   
   var body: some View {
      ViewAllGoalsView(path: .constant([]))
         .environmentObject(viewModelTest)
         .onAppear {
            viewModelTest.goals = [
               Goal(id: UUID(), user: "Test", name: "Read a book", action: "Read 20 pages", frequency: .day, progress: [], type: .binary, sendEmail: [], active: true),
               Goal(id: UUID(), user: "Test", name: "Poop", action: "Run 5 km", frequency: .week, progress: [], type: .quantitative(value: 5, unit: "km"), sendEmail: [], active: true),
               Goal(id: UUID(), user: "Test", name: "Make my bed", action: "Make my bed", frequency: .day, progress: [], type: .binary, sendEmail: [], active: true),
               Goal(id: UUID(), user: "Test", name: "Eat too much", action: "Make my bed", frequency: .day, progress: [], type: .binary, sendEmail: [], active: false)
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




