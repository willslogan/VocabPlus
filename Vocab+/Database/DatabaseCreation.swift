//
//  DatabaseCreation.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import SwiftData



public func createVocabPlusDB() {
    var modelContainer: ModelContainer
    
    do {
        modelContainer = try ModelContainer(for: Word.self, User.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }

    // Create context where Words and User will be managed
    let modelContext = ModelContext(modelContainer)

    // Check to see if the Vocab+ database has already been created or not
    let userFetchDescriptor = FetchDescriptor<User>()
    
    var listOfUsers = [User]()
    
    do {
        // Obtain all of the drink objects from the database
        listOfUsers = try modelContext.fetch(userFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Drink objects from the database")
    }
    
    if !listOfUsers.isEmpty {
        print("DB has been Created")
        return
    }
    
    print("Creating DB now")
    // ************************************************************
    // Learned Words and Favorite Words NEED TO BE IMPLEMENTED HERE
    // ************************************************************
    
    // ************************************************************
    let user = User(firstName: "",
                    lastName: "",
                    profileImageName: "",
                    level: 1,
                    learnedWords: [],
                    favoriteWords: []
    )
    
    
    
    modelContext.insert(user)
    
    print("DB is now Created")
    
    
}
