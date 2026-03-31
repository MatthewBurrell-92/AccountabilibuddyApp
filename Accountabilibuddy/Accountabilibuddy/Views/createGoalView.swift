//
//  createGoalView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 1/31/26.
//


import SwiftUI

struct createGoalView: View {
   @EnvironmentObject var viewModel: GoalViewModel
   //   @Binding var goals: [Goal]
   @State var goalName: String = ""
   @State var goalAction: String = ""
   @State var goalValue: Double?
   @State var goalUnit: String = ""
   @State var goalFreq: GoalUnitTime = .day
   @State var timeValue: Int?
   
   @State private var binary: Bool? = nil
   @State private var showPrompts: Bool = false
   @State private var recurring: Bool? = nil
   
   @State private var showAlert: Bool = false
   //   @State var goals: [Goal] = []
   @Environment(\.dismiss) private var dismiss
   var body: some View {
      ZStack(alignment: .topLeading) {
//                   Color.indigo
//                       .ignoresSafeArea()
         
         VStack {
            Text("What do you want to call this goal?")
               .background(Color.white)
            TextField(" ", text: $goalName)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding()
            
            HStack{
               Text("Is this a non-recurring goal?")
               Button {
                  showAlert = true
               } label: {
                  Image(systemName: "questionmark.circle")
                     .font(.title2) // adjust size
               }
               .alert("Helpful Tip", isPresented: $showAlert) {
                  Button("OK", role: .cancel) { }
               } message: {
                  Text("A recurring goal is something that is completed everyday or week or month. A non-recurring goal is something that is completed only once over a specified period of time. An example of a non-recurring goal is to lose 20 pounds over six months.")
               }
            }
            
            HStack {
               Button("Yes") {
                  recurring = true
                  showPrompts = true
               }
               .buttonStyle(.borderedProminent)
               .tint(recurring == true ? .green : .gray.opacity(0.3))
               
               Button("No") {
                  recurring = false
                  showPrompts = true
               }
               .buttonStyle(.borderedProminent)
               .tint(recurring == false ? .green : .gray.opacity(0.3))
            }
            
            if (recurring == true && showPrompts) {
                
                HStack(spacing: 4) {
                    Text("I want to")
                    
                    TextField("run, read, workout", text: $goalAction)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                HStack(spacing: 4) {
                    TextField("1, 3, 5", value: $goalValue, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 30, maxWidth: 80)
                    
                    TextField("miles, pages, hours", text: $goalUnit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                // ⬇️ Time constraint (uses goalFreq now)
                HStack(spacing: 4) {
                   Text("within")
                   
                   TextField("1", value: $timeValue, format: .number)
                      .textFieldStyle(RoundedBorderTextFieldStyle())
                      .frame(minWidth: 30, maxWidth: 60)
                   
                   Picker("", selection: $goalFreq) {
                      ForEach(GoalUnitTime.allCases, id: \.self) { freq in
                         Text(freq.displayName(for: timeValue ?? 0)).tag(freq)
                      }
                   }
                   .pickerStyle(.menu)
                }
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                Button("Create Goal") {
                    let goalType = GoalType.non_recurring(
                        value: goalValue ?? 0,
                        unit: goalUnit,
                        timeValue: timeValue ?? 0
                    )
                    
                    viewModel.addGoal(
                        name: goalName,
                        action: goalAction,
                        frequency: goalFreq, // now serves as time unit
                        type: goalType,
                        email: []
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            
            else if (recurring == false && showPrompts) {
               
               HStack {
                  Text("Is this a binary goal?")
                  
                  Button {
                     showAlert = true
                  } label: {
                     Image(systemName: "questionmark.circle")
                        .font(.title2)
                  }
                  .alert("Helpful Tip", isPresented: $showAlert) {
                     Button("OK", role: .cancel) { }
                  } message: {
                     Text("A binary goal is something completed at one time.")
                  }
               }
               
               HStack {
                  Button("Yes") {
                     binary = true
                  }
                  .buttonStyle(.borderedProminent)
                  .tint(binary == true ? .green : .gray.opacity(0.3))
                  
                  Button("No") {
                     binary = false
                  }
                  .buttonStyle(.borderedProminent)
                  .tint(binary == false ? .green : .gray.opacity(0.3))
               }
               
               if (binary == true)
               {
                  HStack(spacing: 4) {
                     Text("I want to")
                     
                     TextField("make my bed, wake up early", text: $goalAction)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                     
                     
                  }
                  .font(.headline)
                  .padding()
                  .background(Color.white)
                  .cornerRadius(8)
                  .onAppear {
                     print("Binary here")
                  }
                  
                  HStack(spacing: 4) {
                     Text("every")
                     Picker("", selection: $goalFreq) {
                        ForEach(GoalUnitTime.allCases, id: \.self) { freq in
                           Text(freq.rawValue)
                              .tag(freq)
                        }
                     }
                     .pickerStyle(.menu)
                     
                  }
                  .font(.headline)
                  .padding()
                  .background(Color.white)
                  .cornerRadius(8)
                  
                  // binary goal create
                  Button("Create Goal") {
                     print("binary")
                     viewModel.addGoal(
                        name: goalName,
                        action: goalAction,
                        frequency: goalFreq,
                        type: .binary,
                        email: []
                     )
                     print("binary?")
                     
                  }
                  .buttonStyle(.borderedProminent)
               }
               else if (binary != true && showPrompts)
               {
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
                  
                  // quantitative
                  Button("Create Goal") {
                     let goalType = GoalType.quantitative(value: goalValue ?? 0, unit: goalUnit)
                     
                     viewModel.addGoal(
                        name: goalName,
                        action: goalAction,
                        frequency: goalFreq,
                        type: goalType,
                        email: []
                     )
                     print("here")
                     
                     do {
                        goalName = ""
                        goalAction = ""
                        goalValue = nil
                        goalUnit = ""
                        goalFreq = .day
                        
                     }
                  }
                  .buttonStyle(.borderedProminent)
               }
            }
         }
      }
      
      .padding()
      
   }
   
}



//func saveGoals(_ goals: [Goal]) throws {
//   let url = FileManager.default
//           .urls(for: .documentDirectory, in: .userDomainMask)[0]
//           .appendingPathComponent("goals.json")
//
//   let data = try JSONEncoder().encode(goals)
//   try data.write(to: url)
//
//}

struct CreateGoalView_PreviewWrapper: View {
   // This is necessary because the #Preview
   // would not allow the goals parameter,
   // because it is out of scope. Or whatever.
   @State private var goals: [Goal] = []
   
   var body: some View {
      createGoalView()
   }
}

#Preview {
   createGoalView()
}
