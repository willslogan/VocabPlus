//
//  userUtilities.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import Foundation
import SwiftData

let defaultUser = User(firstName: "",
                lastName: "",
                profileImageName: "",
                level: 1,
                learnedWords: [Word](),
                favoriteWords: [Word]()
)

var usersList = [User]()
var userGlobal = defaultUser

func userHasBeenCreated() -> Bool {
    //Create Model Container and Model Context
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage Book and Photo
        modelContainer = try ModelContainer(for: Word.self, User.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the variable to hold the database search results
    usersList = [User]()
    
    let userFetchDescriptor = FetchDescriptor<User>()
    
    do {
        // Obtain all objects satisfying the search criterion (Predicate)
        usersList = try modelContext.fetch(userFetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }
    
    if usersList.count == 1 {
        print("Gets To First Time User")
        return false
    }
    
    return true
    
}
