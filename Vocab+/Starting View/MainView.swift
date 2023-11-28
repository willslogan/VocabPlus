//
//  MainView.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            WordOfTheDay()
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
    MainView()
}
