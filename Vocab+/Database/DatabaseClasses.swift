//
//  DatabaseClasses.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//

import SwiftUI
import SwiftData

@Model
final class Word: Hashable, Equatable {
    var word: String
    var audioUrl: String
    var imageUrl: String
    var imageAuthor: String
    var imageAuthorUrl: String
    var synonyms: [String]
    var pointsUntilLearned: Int
    
    // If Word is deleted, cascade that deletion for all definitions too
    @Relationship(deleteRule: .cascade) var definitions: [Definition]?
    // One-to-Many Relationship: ONE Word can belong to MANY Definitions
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.word == rhs.word
    }
    
    init(word: String, audioUrl: String, imageUrl: String, imageAuthor: String, imageAuthorUrl: String, synonyms: [String], pointsUntilLearned: Int, definitions: [Definition]? = nil) {
        self.word = word
        self.audioUrl = audioUrl
        self.imageUrl = imageUrl
        self.imageAuthor = imageAuthor
        self.imageAuthorUrl = imageAuthorUrl
        self.synonyms = synonyms
        self.pointsUntilLearned = pointsUntilLearned
        self.definitions = definitions
    }
}

@Model
final class Definition: Hashable {
    var definition: String
    var partOfSpeech: String
    var example: String
    
//    // If Word is deleted, nullify Word
//    @Relationship(deleteRule: .nullify) var word: Word?
//    // One-to-One Relationship: ONE Definition can belong to ONE Word
    
    init(definition: String, partOfSpeech: String, example: String) {
        self.definition = definition
        self.partOfSpeech = partOfSpeech
        self.example = example
//        self.word = word
    }
}

//@Model
//final class User {
//    var firstName: String
//    var lastName: String
//    var profileImageName: String
//    var level: Int
//    var experience: Int
//    var quizzesTaken: Int
//    var quizzesPoints: [Int]
//    
//    @Relationship(deleteRule: .nullify) var learnedWords: [Word]?
//    @Relationship(deleteRule: .nullify) var favoriteWords: [Word]?
//    
//    init(firstName: String, lastName: String, profileImageName: String, level: Int, experience: Int, quizzesTaken: Int, quizzesPoints: [Int], learnedWords: [Word]? = nil, favoriteWords: [Word]? = nil) {
//        self.firstName = firstName
//        self.lastName = lastName
//        self.profileImageName = profileImageName
//        self.level = level
//        self.experience = experience
//        self.quizzesTaken = quizzesTaken
//        self.quizzesPoints = quizzesPoints
//        self.learnedWords = learnedWords
//        self.favoriteWords = favoriteWords
//    }
//    
//}

@Model
final class User {
    var firstName: String
    var lastName: String
    var profileImageName: String
    var level: Int
    var experience: Int
    var quizzesTaken: Int
    var quizzesPoints: [Int]
    
    @Relationship(deleteRule: .nullify) var learnedWords: [Word]?
    @Relationship(deleteRule: .nullify) var favoriteWords: [Word]?
    
    init(firstName: String, lastName: String, profileImageName: String, level: Int, experience: Int, quizzesTaken: Int, quizzesPoints: [Int], learnedWords: [Word], favoriteWords: [Word]) {
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageName = profileImageName
        self.level = level
        self.experience = experience
        self.quizzesTaken = quizzesTaken
        self.quizzesPoints = quizzesPoints
        self.learnedWords = learnedWords
        self.favoriteWords = favoriteWords
    }
}
