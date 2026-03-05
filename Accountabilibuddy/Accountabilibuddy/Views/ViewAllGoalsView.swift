//
//  ViewAllGoalsView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/2/26.
//

import SwiftUI

struct ViewAllGoalsView: View {
   
   @EnvironmentObject var viewModel: GoalViewModel
   //   @State var selectedGoal: Goal?
   @State private var expandedGoalId: UUID? = nil
   @State var selectedGoalId: UUID = UUID()
   @State var showRecordProgress: Bool = false
   
   var body: some View {
      NavigationStack {
         ScrollView {
            
            VStack(alignment: .leading, spacing: 12) {
               ForEach(viewModel.goals) { goal in
                  
                  VStack(alignment: .leading) {
                     
                     
                     // Goal name button
                     Button(action: {
                        // Toggle expansion
                        if expandedGoalId == goal.id {
                           expandedGoalId = nil
                        } else {
                           expandedGoalId = goal.id
                        }
                     }) {
                        HStack {
                           Text(goal.name)
                              .font(.headline)
                           Spacer()
                           Image(systemName: expandedGoalId == goal.id ? "chevron.down" : "chevron.left")
                              .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                     }
                     
                     
                     // Only show these if this goal is expanded
                     if expandedGoalId == goal.id {
                        VStack(alignment: .leading, spacing: 4) {
                           Button("Record Progress") {
                              selectedGoalId = goal.id
                              showRecordProgress = true
                           }
                           
                           Button("Edit Goal") {
                              // handle edit
                           }
                           
                           Button("Show Past Progress") {
                              // handle history
                           }
                           
                           Button("Delete Goal") {
                              viewModel.removeGoal(id: goal.id)
                           }
                        }
                        .padding(.leading, 16)
                     }
                  }
                  .padding(.vertical, 4)
                  .background(Color.gray.opacity(0.05))
                  .cornerRadius(8)
                  .animation(.easeInOut, value: expandedGoalId) // smooth expand/collapse
               }
            }
            .padding()
         }
         
      }
      .navigationDestination(for: Goal.self) { goal in
         if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
            RecordProgressView(goal: $viewModel.goals[index])
         }
      }
   }
}


//struct ViewAllGoalsView_Previews: PreviewProvider {
//   static var previews: some View {
//      
//      // Create a ViewModel with sample goals
//      let viewModel = GoalViewModel()
//      viewModel.goals = [
//         Goal(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
//            name: "Read a book",
//            action: "Read 20 pages",
//            frequency: .day,
//            progress: [],
//            type: .binary
//         ),
//         Goal(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
//            name: "Poop",
//            action: "Run 5 km",
//            frequency: .week,
//            progress: [],
//            type: .quantitative(value: 5, unit: "km")
//         ),
//         Goal(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
//            name: "Make my bed",
//            action: "Make my bed",
//            frequency: .day,
//            progress: [],
//            type: .binary
//         )
//      ]
//      
//      // Inject the ViewModel into the environment
//      return ViewAllGoalsView()
//         .environmentObject(viewModel)
//   }
//}

struct ViewAllGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        // Use a wrapper view to hold a fresh ViewModel
        ViewAllGoalsPreviewWrapper()
    }
}

struct ViewAllGoalsPreviewWrapper: View {
    @StateObject private var viewModelTest = GoalViewModel()

    init() {
        viewModelTest.goals = [
            Goal(id: UUID(), name: "Read a book", action: "Read 20 pages", frequency: .day, progress: [], type: .binary),
            Goal(id: UUID(), name: "Poop", action: "Run 5 km", frequency: .week, progress: [], type: .quantitative(value: 5, unit: "km")),
            Goal(id: UUID(), name: "Make my bed", action: "Make my bed", frequency: .day, progress: [], type: .binary)
        ]
    }

    var body: some View {
        ViewAllGoalsView()
            .environmentObject(viewModelTest)
            .previewLayout(.sizeThatFits)
    }
}

//#Preview {
//   // Wrap setup in a closure returning the view
//   let viewModel = GoalViewModel()
//   
//   
//   // Return the view
//   ViewAllGoalsView()
//      .environmentObject(viewModel)
//}
