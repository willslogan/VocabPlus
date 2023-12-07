//
//  WordStruct.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//

import SwiftUI

struct WordStruct: Decodable {
    var word: String
    var audioUrl: String
    var imageUrl: String
    var imageAuthor: String
    var imageAuthorUrl: String
    var synonyms: [String]
    var pointsUntilLearned: Int
    var definitions: [DefinitionStruct]
}

struct DefinitionStruct: Decodable, Hashable {
    var definition: String
    var partOfSpeech: String
    var example: String
}
