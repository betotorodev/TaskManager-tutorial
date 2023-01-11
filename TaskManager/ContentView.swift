//
//  ContentView.swift
//  TaskManager
//
//  Created by Beto Toro on 10/01/23.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    Home()
      .preferredColorScheme(.light)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
