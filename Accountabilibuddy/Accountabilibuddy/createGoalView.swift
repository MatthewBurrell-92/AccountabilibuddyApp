//
//  createGoalView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 1/31/26.
//


import SwiftUI

struct createGoalView: View {
   @Binding var goals: [Goal]
   @State var goalName: String = ""
   @State var goalAction: String = ""
   @State var goalValue: Double?
   @State var goalUnit: String = ""
   @State var goalFreq: GoalUnitTime = .day
//   @State var goals: [Goal] = []
   @Environment(\.dismiss) private var dismiss
    var body: some View {
       ZStack(alignment: .topLeading) {
//          Color.indigo
//              .ignoresSafeArea()
          
             
          
          VStack {
//             HStack { // Unnecessary
//                Button("Back") {
//                   dismiss()
//                }
//                .background((Color.white))
//                    Spacer()
//             }
//             .padding()

              Text("What do you want to call this goal?")
                .background(Color.white)
             TextField(" ", text: $goalName)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
             
//             HStack(spacing: 4) {
//                 Text("This is a")
//
//                 Picker("", selection: $goalFreq) {
//                     ForEach(GoalUnitTime.allCases, id: \.self) { freq in
//                         Text(freq.rawValue)
//                             .tag(freq)
//                     }
//                 }
//                 .pickerStyle(.menu)
//
//                 Text("goal")
//                
//             }
//             .font(.headline)
//             .padding()
//             .background(Color.white)
//             .cornerRadius(8)
             
//             if $goalFreq.wrappedValue == .daily {
//                Text("Daily goals are meant to be done every day.")
//             }
//             else if $goalFreq.wrappedValue == .weekly {
//                Text("Weekly goals reset every Sunday.")
//                Text("Record progress by recording the value of the unit performed.")
//                Text("For example, after walking a mile, you would record 1 for the number of miles walked.")
//             }
             
//             Text("What is the action you want to do?")
//               .background(Color.white)
//             Text("Examples: Read")
//             TextField(" ", text: $goalAction)
//                 .textFieldStyle(RoundedBorderTextFieldStyle())
//                 .padding()
             
//             Text("How many of that action?")
//               .background(Color.white)
//             TextField(" ", text: $goalAction)
//                 .textFieldStyle(RoundedBorderTextFieldStyle())
//                 .padding()
             
             HStack(spacing: 4) {
                 Text("I want to")
                
                TextField("run, read, workout", text: $goalAction)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
                
                
             }
             .font(.headline)
             .padding()
             .background(Color.white)
             .cornerRadius(8)
             
             HStack(spacing: 4) {
                TextField("1, 3, 5", value: $goalValue, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 30, maxWidth: 80)
//                    .padding()
                TextField("miles, pages, hours", text: $goalUnit)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
             }
             .font(.headline)
             .padding()
             .background(Color.white)
             .cornerRadius(8)
             
             HStack(spacing: 4) {
                Text("every")
                 Picker("", selection: $goalFreq) {
                     ForEach(GoalUnitTime.allCases, id: \.self) { freq in
                         Text(freq.rawValue)
                             .tag(freq)
                     }
                 }
                 .pickerStyle(.menu)

//                 Text("goal")
                
             }
             .font(.headline)
             .padding()
             .background(Color.white)
             .cornerRadius(8)
             
             
             
             
             
             Button("Create Goal") {
                 let newGoal = Goal(
                  name: goalName,
                  value: goalValue ?? 0,
                  unit: goalUnit,
                  frequency: goalFreq
                 )
                 goals.append(newGoal)

                 do {
                     try saveGoals(goals)
                     goalName = ""
                 } catch {
                     print("Failed to save goals:", error)
                 }
             }
             .buttonStyle(.borderedProminent)
//             .background(.black)
          }
       }
        
        .padding()

    }
       
   }



func saveGoals(_ goals: [Goal]) throws {
   let url = FileManager.default
           .urls(for: .documentDirectory, in: .userDomainMask)[0]
           .appendingPathComponent("goals.json")
   
   let data = try JSONEncoder().encode(goals)
   try data.write(to: url)
      
}

struct CreateGoalView_PreviewWrapper: View {
   // This is necessary because the #Preview
   // would not allow the goals parameter,
   // because it is out of scope. Or whatever.
    @State private var goals: [Goal] = []

    var body: some View {
        createGoalView(goals: $goals)
    }
}

struct DropdownView: View {
    @State private var selectedOption = "Select Option"
    let options = ["Daily", "Weekly", "Monthly", "Yearly"]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selectedOption = option
                }
            }
        } label: {
            Text(selectedOption)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
   

#Preview {
    CreateGoalView_PreviewWrapper()
}
