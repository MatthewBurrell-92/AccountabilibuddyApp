//
//  EditGoalView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/6/26.
//
import SwiftUI

struct EditGoalView: View {

   @Binding var goal: Goal
   
   var body: some View {
      Text(goal.name).font(.title)
   }
}


struct EditGoalView_PreviewWrapper: View {

    @State private var goal = Goal(
        id: UUID(),
        name: "Read BoM",
        action: "read",
        frequency: .week,
        progress: [],
        type: .quantitative(value: 5.0, unit: "pages"),
        sendEmail: .none
//        type: .binary
    )

    var body: some View {
       EditGoalView(goal: $goal)
    }
}
   

#Preview {
   EditGoalView_PreviewWrapper()
}
