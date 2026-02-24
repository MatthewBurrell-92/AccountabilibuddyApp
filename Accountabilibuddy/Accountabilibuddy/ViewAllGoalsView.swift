//
//  ViewAllGoalsView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/2/26.
//

import SwiftUI

struct ViewAllGoalsView: View {
   @Binding var goals: [Goal]
   //   @State var goals: [Goal] = []
   @State var show: Bool = false
   @State var selectedGoal: Goal?
   var body: some View {
      NavigationStack {
         ScrollView {
            VStack(alignment: .leading, spacing: 12) {
               ForEach(goals) { goal in
                  VStack(alignment: .leading) {
                     
                     Button(goal.name) {
                        selectedGoal = goal
                     }
                     .font(.headline)
                     
                     Button("Record Progress") {
                        selectedGoal = goal
                     }
                     
                     Button("Edit Goal") {
                        // handle edit
                     }
                     
                     Button("Show Past Progress") {
                        // handle history
                     }
                     
                     Button("Delete Goal") {
                        do {
                           try deleteGoal(withId: goal.id)
                           goals.removeAll { $0.id == goal.id }
                        } catch {
                           print("Failed to delete goal:", error)
                        }
                     }
                  }
               }
            }
            .padding()
         }
         .navigationDestination(for: Goal.self) { goal in
             if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                 RecordProgressView(goal: $goals[index])
             }
         }
      }
   }
}
//      ScrollView {
//         VStack(alignment: .leading, spacing: 12) {
//            ForEach(goals) { goal in
////               Button(goal.name) {
////                  
////               }
//               Button(action: {show.toggle()},
//                      label : {Text(goal.name)})
//                  .font(.headline)
//               if show {
//                  Button("Record Progress") {
//                     // Allows the user to record event.
//                     // Go to different view?
//                  }
//                  Button("Edit Goal") {
//                     // Allows the user to edit/delete the goal
//                     // Different view? Probably.
//                  }
//                  Button("Show Past Progress") {
//                     
//                  }
//                  Button("Delete Goal") {
//                      do {
//                          try deleteGoal(withId: goal.id)
//                         goals.removeAll { $0.id == goal.id }
//                      } catch {
//                          print("Failed to delete goal:", error)
//                      }
//                  }
//               }
//            }
//         }
//         .padding()
//         .background(Color.gray.opacity(0.1))
//      }
//   }
//}

//func 

struct ViewAllGoalsGoalView_PreviewWrapper: View {
   // This is necessary because the #Preview
   // would not allow the goals parameter,
   // because it is out of scope. Or whatever.
    @State private var goals: [Goal] = []

    var body: some View {
       ViewAllGoalsView(goals: $goals)
    }
}

func deleteGoal(withId id: UUID) throws {
    var goals = try loadGoals()
    
    goals.removeAll { $0.id == id }
    
    try saveGoals(goals)
}

#Preview {
   ViewAllGoalsGoalView_PreviewWrapper()
}
