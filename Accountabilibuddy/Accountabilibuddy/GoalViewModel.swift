//
//  GoalViewModel.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/4/26.
//

import Foundation
import Combine

import FirebaseFirestore


class GoalViewModel: ObservableObject {
   @Published var goals: [Goal] = []
   @Published var progress: [Progress] = []
   
   private let repository = GoalRepository()
   
   //    var totalProgress: Int {
   //        progress.reduce(0) { $0 + $1.amount }
   //    }
   
   //   init() {
   //      fetchGoals()
   //   }
   
   init(testCases: Bool = false) {
      if !testCases {
         repository.listenToGoals { [weak self] goals in
            DispatchQueue.main.async {
               self?.goals = goals
            }
         }
         repository.testConnection()
      }
   }
   
   // MARK: - Goal CRUD
   func addGoal(name: String, action: String, frequency: GoalUnitTime, type: GoalType, email: EmailProgress) {
      let newGoal = Goal(user: "Test", name: name, action: action, frequency: frequency, progress: [], type: type, sendEmail: email)
      repository.addGoal(newGoal)
      fetchGoals()
      print(GoalType.self)
   }
   
   func removeGoal(id: UUID) {
      repository.removeGoal(withId: id)
   }
   
   func updateGoal(goal : Goal) {
      repository.updateGoal(goal)
   }
   
   //   func removeGoal(id: UUID) {
   //        goals.removeAll { $0.id == id }
   //        progress.removeAll { $0.goalID == id }
   //    }
   
   //   func addGoal(_ goal: Goal) {
   //           repository.addGoal(goal)
   //           fetchGoals()
   //       }
   
   // MARK: - Persistence
   //   private func goalsURL() -> URL {
   //      FileManager.default
   //         .urls(for: .documentDirectory, in: .userDomainMask)[0]
   //         .appendingPathComponent("goals.json")
   //   }
   
   //   func loadGoals() throws -> [Goal] {
   //      let url = goalsURL()
   //      guard FileManager.default.fileExists(atPath: url.path) else { return [] }
   //      let data = try Data(contentsOf: url)
   //      return try JSONDecoder().decode([Goal].self, from: data)
   //   }
   
   
   //   func saveGoals() throws {
   //      let data = try JSONEncoder().encode(goals)
   //      try data.write(to: goalsURL())
   //   }
   
   //   func saveGoalsSilently() {
   //      // Optional helper to save without throwing errors to UI
   //      do { try saveGoals() } catch { print("Failed to save goals:", error) }
   //   }
   
   //   func addGoal(
   //       name: String,
   //       action: String,
   //       frequency: GoalUnitTime,
   //       type: GoalType,
   //       progress: [Progress] = []
   //   ) {
   //       let newGoal = Goal(
   //           name: name,
   //           action: action,
   //           frequency: frequency,
   //           progress: progress,
   //           type: type
   //       )
   //       goals.append(newGoal)
   //
   //   }
   
   func recordProgress(newProgress: Progress) {
//      let newProgress = Progress(id: UUID(), goalID: goalID, date: Date(), value: value)
      progress.append(newProgress)
      repository.addProgress(newProgress, toGoal: newProgress.goalID)
   }
   
   func fetchGoals() {
      repository.fetchGoals { [weak self] goals in
         DispatchQueue.main.async {
            self?.goals = goals
         }
      }
   }
}



class GoalRepository {
   private let db = Firestore.firestore()
   private let collection = "goals"
   
   func fetchGoals(completion: @escaping ([Goal]) -> Void) {
      db.collection(collection).getDocuments { snapshot, error in
         if let documents = snapshot?.documents {
            let goals = documents.compactMap { try? $0.data(as: Goal.self) }
            completion(goals)
         }
      }
   }
   
   func addGoal(_ goal: Goal) {
      try? db.collection(collection).document(goal.id.uuidString).setData(from: goal)
   }
   
   func addProgress(_ progress: Progress, toGoal: UUID) {
       let goalRef = db.collection(collection).document(toGoal.uuidString)
      print("hit addProgress.")
       
       // Fetch the goal first
       goalRef.getDocument { snapshot, error in
           if let error = error {
               print("Error fetching goal: \(error)")
               return
           }
           
           guard let snapshot = snapshot, snapshot.exists else {
               print("Goal does not exist")
               return
           }
           
           do {
               var goalData = try snapshot.data(as: Goal.self)
               goalData.progress.append(progress) // append locally
               
               // Write back to Firestore
               try goalRef.setData(from: goalData)
           } catch {
               print("Error updating goal progress: \(error)")
           }
       }
   }
   
   func removeGoal(withId id: UUID) {
      db.collection(collection).document(id.uuidString).delete()
   }
   
   func updateGoal(_ goal: Goal) {
      try? db.collection(collection)
         .document(goal.id.uuidString)
         .setData(from: goal) { error in
            if let error = error {
               print("Error updating goal in Firestore: \(error)")
            } else {
               print("Goal updated successfully: \(goal.name)")
            }
         }
   }
   
   func listenToGoals(completion: @escaping ([Goal]) -> Void) {
      db.collection(collection).addSnapshotListener { snapshot, error in
         if let documents = snapshot?.documents {
            let goals = documents.compactMap { try? $0.data(as: Goal.self) }
            completion(goals)
         }
      }
   }
   
   func testConnection() {
      db.collection("test").document("ping").setData(["ok": true]) { err in
         if let err = err {
            print("Error writing document: \(err)")
         } else {
            print("Success!")
         }
      }
   }
   
}
