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
    let wordFetchDescriptor = FetchDescriptor<Word>()
    
//    var listOfUsers = [User]()
//    
//    do {
//        // Obtain all of the drink objects from the database
//        listOfUsers = try modelContext.fetch(userFetchDescriptor)
//    } catch {
//        fatalError("Unable to fetch Drink objects from the database")
//    }
//    
//    if !listOfUsers.isEmpty {
//        print("DB has been Created")
//        return
//    }
        var listOfWords = [Word]()
    
        do {
            // Obtain all of the drink objects from the database
            listOfWords = try modelContext.fetch(wordFetchDescriptor)
        } catch {
            fatalError("Unable to fetch Drink objects from the database")
        }
    
        if !listOfWords.isEmpty {
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
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content in DatabaseInitialContent.json   |
     ----------------------------------------------------------
     */
    
    var arrayOfWordStructs = [WordStruct]()
        arrayOfWordStructs = decodeJsonFileIntoArrayOfStructs(fullFilename: "DatabaseInitialContent.json", fileLocation: "Main Bundle")
    
        for aWordStruct in arrayOfWordStructs {
            
            var definitions = [Definition]()
            var newDefinition = Definition(definition: aWordStruct.definitions[0].definition, partOfSpeech: aWordStruct.definitions[0].partOfSpeech, example: aWordStruct.definitions[0].example)
            definitions.append(newDefinition)
            
            // Create a new Word object from aWordStruct
            // Assigning default values for properties not present in the JSON
            let newWord = Word(word: aWordStruct.word,
                               audioUrl: aWordStruct.audioUrl,
                               imageUrl: aWordStruct.imageUrl,
                               imageAuthor: aWordStruct.imageAuthor,
                               imageAuthorUrl: aWordStruct.imageAuthorUrl,
                               synonyms: aWordStruct.synonyms,
                               pointsUntilLearned: 10, 
                               definitions: definitions)

            // Insert it into the database context
            modelContext.insert(newWord)
            
            // Debug statement to print the word being added
            print("Added word to DB: \(newWord.word)")
        }
    
    /*
     =================================
     |   Save All Database Changes   |
     =================================
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    print("DB is now Created")
}
