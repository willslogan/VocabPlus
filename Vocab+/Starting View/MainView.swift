//
//  MainView.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State private var name = getUsersName()
    
    var body: some View {
        TabView {
            // TODO: When we implement profiles, the WOD should be able to get the current user's name without us passing it in
            WordOfTheDay(firstName: getUsersName())
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
//            RandomWord()
//                .tabItem {
//                    Label("Random Word", systemImage: "shuffle")
//                }
            
            
        }
        
        .onAppear {
           // Display TabView with opaque background
           let tabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithOpaqueBackground()
           UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
}


func getUsersName() -> String {
    
    for aUser in usersList {
        if !aUser.firstName.isEmpty {
            return aUser.firstName
        }
    }
    
    //Case for on start up
    return defaultUser.firstName
}

#Preview {
    MainView()
}
