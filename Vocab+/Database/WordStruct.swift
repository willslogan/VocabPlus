//
//  WordStruct.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//

import SwiftUI

struct WordStruct: Decodable {
    var word: String
    var definitions: [DefinitionStruct] // List of definitions associated with the word
    var audioUrl: String
    var imageUrl: String
    var imageAuthor: String
    var imageAuthorUrl: String
    var synonyms: [String]
}

struct DefinitionStruct: Decodable {
    var definition: String
    var partOfSpeech: String
    var example: String
}
