//
//  ContentView.swift
//  Vocab+
//
//  Created by William Logan on 11/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var userFirstTimeCompleted = userHasBeenCreated()
    
    var body: some View {
        if userFirstTimeCompleted {
            MainView()
        } else {
            ZStack {
                FirstTimeUser(canOpenApp: $userFirstTimeCompleted)
            }
        }
    }

    
}

#Preview {
    ContentView()
}
