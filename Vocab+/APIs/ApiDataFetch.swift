//
//  ApiDataFetch.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

var foundWord = Word(word: "", audioUrl: "", imageUrl: "", imageAuthor: "", imageAuthorUrl: "", synonyms: [], pointsUntilLearned: 10, definitions: [])

let wordnikApiKey = "h92eq8jsnaitg1hid9navzros55w8o43n77lcbide02qh88jz"

let pexelsApiKey = "FTASW5mja3KwydYI7MCmGLVUFYcNKg0ygLdiHiXOyGGLAlyzL5aLjG9B"

let wordnikApiHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "api.wordnik.com"
]




// ************************
// Currently Not being used
// ************************
//let linguaRobotApiHeaders = [
//        "accept": "application/json",
//        "cache-control": "no-cache",
//        "X-RapidAPI-Key": "96ab1aa338mshdcd4ce184c23e06p167659jsn0e94ce040ac3",
//        "X-RapidAPI-Host": "lingua-robot.p.rapidapi.com",
//        "connection": "keep-alive",
//        "host": "api.wordnik.com"
//    ]


/*
 This function first makes multiple API calls to build a Word object
 */
public func getFoundWordFromApi(searchTerm: String) {
    // Retrieve definitions
    let definitions = getDefinitionsFromApi(searchTerm: searchTerm)
    
    // Retrieve audio URL
    let audioUrl = getAudioFileFromApi(searchTerm: searchTerm)
            
    // Retrieve synonyms
    let synonyms = getSynonymsFromApi(searchTerm: searchTerm)
    print("HERE\n")
    //Create Word Struct
    foundWord = Word(word: searchTerm,
                     audioUrl: audioUrl,
                     imageUrl: "",
                     imageAuthor: "",
                     imageAuthorUrl: "",
                     synonyms: synonyms,
                     pointsUntilLearned: 10, // TODO: Good starting value?
                     definitions: definitions)
            
    // Retrieve pexels image
    fetchImageFromPexels(word: searchTerm) { pexelsPhoto in
        if let pexelsPhoto = pexelsPhoto {
            foundWord.imageUrl = pexelsPhoto.imageUrl
            foundWord.imageAuthor = pexelsPhoto.authorName
            foundWord.imageAuthorUrl = pexelsPhoto.authorUrl
        } else {
            print("Failed to fetch image from Pexels")
        }
    }
    // Now the foundWord variable should be set.
}

/*
 Function to retrieve definition list from the API
 */
private func getDefinitionsFromApi(searchTerm: String) -> [Definition] {
    // Get a list of definitions
    let apiUrlDefString = "https://api.wordnik.com/v4/word.json/\(searchTerm)/definitions?limit=5&includeRelated=false&useCanonical=false&includeTags=false&api_key=\(wordnikApiKey)"
        
    var jsonDataFromApi: Data
    
    // Make API call for list of definitions
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: wordnikApiHeaders, apiUrl: apiUrlDefString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return []
    }
    
    // Parse json response
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        var definitions = [Definition]()
        
        if let definitionsList = jsonResponse as? [Any] {
            for anIndividualDefinition in definitionsList {
                //Initialize All definition attributes from definition search
                var definition = ""
                var partOfSpeech = ""
                var example = ""
                
                if let definitionDictionary = anIndividualDefinition as? [String: Any] {
                    
                    //Process the definition
                    if let theDefinition = definitionDictionary["text"] as? String {
                        
                    } else {
                        // If the definition does not have "text" then it is invalid and we skip it.
                        continue
                    }
                    
                    //Process part of speech
                    if let thePartOfSpeech = definitionDictionary["partOfSpeech"] as? String {
                        partOfSpeech = thePartOfSpeech
                    }
                    
                    //Process source name
                    if let examples = definitionDictionary["exampleUses"] as? [String] {
                        if examples.count > 0 {
                            example = examples[0]
                        }
                    }
                    
                    // Add the definition to the definitions list
                    definitions.append(Definition(definition: definition, partOfSpeech: partOfSpeech, example: example))
                    
                }
            }
            return definitions
        } else {
            return []
        }
    } catch {
        return []
    }
}

/*
 Function to retreive audio file url as a string from wordnik api
 */
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

/*
 Currently not in use, but we could maybe use it in the future. Some definitions have examples, which we already fetch - we can double down on them with this endpoint if we need to.
 */
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

/*
 Function to retrieve a list of synonyms as strings from the wordnik api
 Currently we look for 10 synonyms max, and they will be received in alphabetical order.
 */
public func getSynonymsFromApi(searchTerm: String) -> [String] {
    let apiUrlString = "https://api.wordnik.com/v4/word.json/\(searchTerm)/relatedWords?useCanonical=true&relationshipTypes=synonym&limitPerRelationshipType=10&api_key=\(wordnikApiKey)"
    
    var synonyms = [String]()
    
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
                        // Return list of synonyms
                        return theSynonyms
                    }
                }
            }
        }
    } catch {
        return synonyms
    }
    
    return synonyms
}

/*
 Function to retrieve a random word from the wordnik api
 */
func getRandomWordFromApi() -> Word? {
    var jsonDataFromApi: Data
    
    var randomWord = ""

    var apiUrlString = "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=\(wordnikApiKey)"
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: wordnikApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        print("Failure Here 1")
        return nil
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        print("Response Obtained")
        
        if let randomWordDictionary = jsonResponse as? [String: Any] {
            print("Dictionary conversion completed")
            //Process word
            if let randomWordObtained = randomWordDictionary["word"] as? String {
                print("Random Word Found")
                // Set random word
                randomWord = randomWordObtained
            }
        }
        
        if randomWord == "" {
            return nil
        }
        
        // Retrieve definitions of the random word
        let definitions = getDefinitionsFromApi(searchTerm: randomWord)
        
        // Retrieve audio URL
        let audioUrl = getAudioFileFromApi(searchTerm: randomWord)
                
        // Retrieve synonyms
        let synonyms = getSynonymsFromApi(searchTerm: randomWord)
        
        //Create Word Struct
        var randomWordToReturn = Word(word: randomWord,
                             audioUrl: audioUrl,
                             imageUrl: "",
                             imageAuthor: "",
                             imageAuthorUrl: "",
                             synonyms: synonyms,
                             pointsUntilLearned: 10, // TODO: Good starting value?
                             definitions: definitions)
                
        // Retrieve pexels image
        fetchImageFromPexels(word: randomWord) { pexelsPhoto in
            if let pexelsPhoto = pexelsPhoto {
                randomWordToReturn.imageUrl = pexelsPhoto.imageUrl
                randomWordToReturn.imageAuthor = pexelsPhoto.authorName
                randomWordToReturn.imageAuthorUrl = pexelsPhoto.authorUrl
            } else {
                print("Failed to fetch image from Pexels")
            }
        }
        
        return randomWordToReturn
        
    } catch {
        return nil
    }
    
}

/*
 Function to retrieve pexels image
 */
func fetchImageFromPexels(word: String, completion: @escaping (PexelsPhoto?) -> Void) {
    var toReturn: PexelsPhoto?
    
    let query = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "https://api.pexels.com/v1/search?query=\(query)&per_page=1"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.addValue(pexelsApiKey, forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching image: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received from Pexels API")
            completion(nil)
            return
        }
        
        if let decodedResponse = try? JSONDecoder().decode(PexelsResponse.self, from: data) {
            if let firstPhoto = decodedResponse.photos.first {
                DispatchQueue.main.async {
                    toReturn = PexelsPhoto(
                        imageUrl: firstPhoto.src.medium,
                        authorName: firstPhoto.photographer,
                        authorUrl: firstPhoto.photographer_url
                    )
                    completion(toReturn)
                }
            } else {
                print("No photos found in response")
                completion(nil)
            }
        } else {
            print("Failed to decode response from Pexels API")
            completion(nil)
        }
    }.resume()
}

struct PexelsResponse: Codable {
    var photos: [Photo]
}

struct Photo: Codable {
    var src: Source
    var photographer: String
    var photographer_url: String
}

struct Source: Codable {
    var medium: String
}

struct PexelsPhoto {
    var imageUrl: String
    var authorName: String
    var authorUrl: String
}
