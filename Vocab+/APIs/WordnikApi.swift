//
//  WordnikApi.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

var foundWordsList = [WordStruct]()

let wordnikApiHeaders = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "api.wordnik.com"
    ]

let linguaRobotApiHeaders = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "X-RapidAPI-Key": "96ab1aa338mshdcd4ce184c23e06p167659jsn0e94ce040ac3",
        "X-RapidAPI-Host": "lingua-robot.p.rapidapi.com",
        "connection": "keep-alive",
        "host": "api.wordnik.com"
    ]

let wordnikApiKey = "h92eq8jsnaitg1hid9navzros55w8o43n77lcbide02qh88jz"

public func getFoundWordsFromApi(searchTerm: String) {
    let apiUrlDefString = "https://api.wordnik.com/v4/word.json/\(searchTerm)/definitions?limit=5&includeRelated=false&useCanonical=false&includeTags=false&api_key=\(wordnikApiKey)"
    
    //var apiUrlExamples = ""
    print(apiUrlDefString)
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: wordnikApiHeaders, apiUrl: apiUrlDefString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let wordsList = jsonResponse as? [Any] {
            for anIndividualWordJson in wordsList {
                //Initialize All word attributes from definition search
                var word = searchTerm
                var definition = ""
                var partOfSpeech = ""
                var sourceName = ""
                var audioUrl = ""
                var imageUrl = ""
                var imageAuthor = ""
                var imageAuthorUrl = ""
                var example = ""
                var exampleAuthor = ""
                var exampleAuthorUrl = ""
                var synonyms = ""
                
                if let wordDictionary = anIndividualWordJson as? [String: Any] {
                    
                    //Process the definition
                    if let theDefinition = wordDictionary["text"] as? String {
                        definition = theDefinition
                    } else {
                        continue
                    }
                    
                    //Process part of speech
                    if let thePartOfSpeech = wordDictionary["partOfSpeech"] as? String {
                        partOfSpeech = thePartOfSpeech
                    }
                    
                    //Process source name
                    if let theSourceName = wordDictionary["attributionText"] as? String {
                        sourceName = theSourceName
                    }
                    
                    //Process audio url
                    audioUrl = getAudioFileFromApi(searchTerm: searchTerm)
                    
                    //Process examples
                    
                    //Process synonyms
                    synonyms = getSynonymFromApi(searchTerm: searchTerm)
                    
                    //Process picture info
                    
                    
                    //Create Word Struct
                    var foundWord = WordStruct(word: word,
                                               definition: definition,
                                               partOfSpeech: partOfSpeech,
                                               sourceName: sourceName,
                                               audioUrl: audioUrl,
                                               imageUrl: imageUrl,
                                               imageAuthor: imageAuthor,
                                               imageAuthorUrl: imageAuthorUrl,
                                               example: example,
                                               exampleAuthor: exampleAuthor,
                                               exampleAuthorUrl: exampleAuthorUrl,
                                               synonyms: synonyms)
                    
                    //Add word to Found word lists
                    foundWordsList.append(foundWord)
                }
            }
        } else {
            return
        }
    } catch {
        return
    }
}

public func getAudioFileFromApi(searchTerm: String) -> String {
    let apiUrlString = "https://api.wordnik.com/v4/word.json/\(searchTerm)/audio?useCanonical=false&limit=1&api_key=\(wordnikApiKey)"
    
    var audioFileUrl = ""
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: wordnikApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return audioFileUrl
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let pronounciationList = jsonResponse as? [Any] {
            for aPronounciation in pronounciationList {
                if let pronounciationInfo = aPronounciation as? [String: Any] {
                    if let pronounciationFileUrl = pronounciationInfo["fileUrl"] as? String {
                        audioFileUrl = pronounciationFileUrl
                    }
                }
            }
        }
        
    } catch {
        return audioFileUrl
    }
    
    return audioFileUrl
}

//All Example information is put into array and individual components will be extracted in the main getFoundWordsFromApi
public func getExamplesFromApi(searchTerm: String) -> [String] {
    let apiUrlString = "https://api.wordnik.com/v4/word.json/\(searchTerm)/examples?includeDuplicates=false&useCanonical=false&limit=5&api_key=\(wordnikApiKey)"
    
    var exampleInfo = [String]()
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: wordnikApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return exampleInfo
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let examplesDictionary = jsonResponse as? [String: Any] {
            if let examplesArr = examplesDictionary["examples"] as? [Any] {
                for anExample in examplesArr {
                    //To catch edge cases where maybe some data is missing
                    var exampleText = ""
                    var exampleAuthor = ""
                    var exampleUrl = ""
                    
                    if let currExampleInfo = anExample as? [String: Any] {
                        
                        //process url of example
                        if let currUrl = currExampleInfo["url"] as? String {
                            exampleUrl = currUrl
                        }
                        
                        //process text of example
                        if let currText = currExampleInfo["text"] as? String {
                            exampleText = currText
                        }
                        
                        //process author of example
                        if let currAuthor = currExampleInfo["author"] as? String {
                            exampleAuthor = currAuthor
                        }
                    }
                    
                    exampleInfo.append(exampleText)
                    exampleInfo.append(exampleAuthor)
                    exampleInfo.append(exampleUrl)
                }
            }
        }
    } catch {
        return exampleInfo
    }
    
    return exampleInfo
    
}

public func getSynonymFromApi(searchTerm: String) -> String {
    let apiUrlString = "https://api.wordnik.com/v4/word.json/\(searchTerm)/relatedWords?useCanonical=true&relationshipTypes=synonym&limitPerRelationshipType=1&api_key=\(wordnikApiKey)"
    
    var synonyms = "Not Found"
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: wordnikApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return synonyms
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let synonymsList = jsonResponse as? [Any] {
            for aSynonymGroup in synonymsList {
                if let synonymGroupInfo = aSynonymGroup as? [String: Any] {
                    if let theSynonyms = synonymGroupInfo["words"] as? [String] {
                        synonyms = ""
                        for aSynonym in theSynonyms {
                            synonyms.append("\(aSynonym), ")
                        }
                        
                        //Remove the extra ", "
                        if synonyms.count > 2 {
                            synonyms = String(synonyms.dropLast(2))
                        }
                    }
                }
            }
        }
    } catch {
        return synonyms
    }
    
    
    return synonyms
}
