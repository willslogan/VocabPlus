//
//  ContentView.swift
//  Vocab+
//
//  Created by William Logan on 11/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        TabView {
            WordOfTheDay(firstName: "name")
                .tabItem {
                    Label("WOTD", systemImage: "sun.max")
                }
            VocabList()
                .tabItem {
                    Label("Vocab List", systemImage: "list.bullet")
                }
            VocabQuiz()
                .tabItem {
                    Label("Vocab Quiz", systemImage: "brain.head.profile")
                }
            SearchVocab()
                .tabItem {
                    Label("Search Word", systemImage: "magnifyingglass")
                }
            RandomWord()
                .tabItem {
                    Label("Random Word", systemImage: "shuffle")
                }
            
        }
        
        .onAppear {
           // Display TabView with opaque background
           let tabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithOpaqueBackground()
           UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

   
}

#Preview {
    ContentView()
}
