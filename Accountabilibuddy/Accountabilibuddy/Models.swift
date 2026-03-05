//
//  Models.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/4/26.
//

import Foundation

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
   var goalID: UUID
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
