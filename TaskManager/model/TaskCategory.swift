//
//  TaskCategory.swift
//  TaskManager
//
//  Created by Beto Toro on 12/01/23.
//

import SwiftUI

enum Category: String, CaseIterable {
  case general = "General"
  
  var color: Color {
    switch self {
      case .general:
      return Color(.gray)
    }
  }
}
