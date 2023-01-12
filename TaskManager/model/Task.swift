//
//  Task.swift
//  TaskManager
//
//  Created by Beto Toro on 12/01/23.
//

import SwiftUI

struct Task: Identifiable {
  var id: UUID = .init()
  var dateAdded: Date
  var taskName: String
  var taskDescription: String
  var taskCatgory: Category
}

var sampleTask: [Task] = [
  .init(dateAdded: Date(), taskName: "lavar la loza", taskDescription: "lavar rápido", taskCatgory: .general)
]
