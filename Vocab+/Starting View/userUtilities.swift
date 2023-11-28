//
//  userUtilities.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import Foundation
import SwiftData

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
    var databaseResults = [User]()
    
    let userFetchDescriptor = FetchDescriptor<User>()
    
    do {
        // Obtain all objects satisfying the search criterion (Predicate)
        databaseResults = try modelContext.fetch(userFetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }
    
    if databaseResults.count == 1 {
        print("Gets To First Time User")
        return false
    }
    
    return true
    
}
