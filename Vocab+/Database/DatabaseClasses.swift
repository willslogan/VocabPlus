//
//  DatabaseClasses.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//

import SwiftUI
import SwiftData

@Model
final class Word {
    var word: String
    var definition: String
    var partOfSpeech: String
    var sourceName: String
    var audioUrl: String
    var imageUrl: String
    var imageAuthor: String
    var imageAuthorUrl: String
    var example: String
    var exampleAuthor: String
    var exampleAuthorUrl: String
    var synonyms: String
    var pointsUntilLearned: Int
    
    init(word: String, definition: String, partOfSpeech: String, sourceName: String, audioUrl: String, imageUrl: String, imageAuthor: String, imageAuthorUrl: String, example: String, exampleAuthor: String, exampleAuthorUrl: String, synonyms: String, pointsUntilLearned: Int) {
        self.word = word
        self.definition = definition
        self.partOfSpeech = partOfSpeech
        self.sourceName = sourceName
        self.audioUrl = audioUrl
        self.imageUrl = imageUrl
        self.imageAuthor = imageAuthor
        self.imageAuthorUrl = imageAuthorUrl
        self.example = example
        self.exampleAuthor = exampleAuthor
        self.exampleAuthorUrl = exampleAuthorUrl
        self.synonyms = synonyms
        self.pointsUntilLearned = pointsUntilLearned
    }
}

@Model
final class User {
    var firstName: String
    var lastName: String
    var profileImageName: String
    var level: Int
    
    @Relationship(deleteRule: .nullify) var learnedWords: [Word]?
    @Relationship(deleteRule: .nullify) var favoriteWords: [Word]?
    
    init(firstName: String, lastName: String, profileImageName: String, level: Int, learnedWords: [Word]? = nil, favoriteWords: [Word]? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageName = profileImageName
        self.level = level
        self.learnedWords = learnedWords
        self.favoriteWords = favoriteWords
    }
}
