//
//  ApiDataFetch.swift
//  Vocab+
//
//  Created by William Logan on 11/20/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI

var foundWordsList = [WordStruct]()

let wordnikApiKey = "h92eq8jsnaitg1hid9navzros55w8o43n77lcbide02qh88jz"

let pexelsApiKey = "FTASW5mja3KwydYI7MCmGLVUFYcNKg0ygLdiHiXOyGGLAlyzL5aLjG9B"

let wordnikApiHeaders = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "api.wordnik.com"
    ]

let pexelsApiHeaders = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "Authorization" : "\(pexelsApiKey)",
        "connection": "keep-alive",
        "host": "api.pexels.com/v1/"
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
                    
                    /*
                     Process examples returns an array of atmost 5 examples with their corresponding author and source
                     but I'm not sure how to implement it with our current set up of word information
                     */
                    
                    //Process synonyms
                    synonyms = getSynonymFromApi(searchTerm: searchTerm)
                    
                    //Process picture info
                    let photoInfo = getImageInfoFromApi(searchTerm: searchTerm)
                    
                    imageUrl = photoInfo[0]
                    imageAuthor = photoInfo[1]
                    imageAuthorUrl = photoInfo[2]
                    
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

public func getImageInfoFromApi(searchTerm: String) -> [String] {
    //Photo info array will have 3 items
    var photoInfo = [String]()
    
    //The items below will go into index 0,1,2 respectivily
    var imageUrl = "Not Found"
    var imageAuthor = "Not Found"
    var imageAuthorUrl = "Not Found"
    
    //I'm doing returning photoInfo as array cause it was the only way I could think of to return multiple bits of information from one
    //function at the same time
    
    let apiUrlString = "https://api.pexels.com/v1/search?query=\(searchTerm)&per_page=1"
    
    
    
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: pexelsApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        print("Failure At Location: 1")
        return photoInfo
    }
    
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        print("Made it here")
        
        if let searchResults = jsonResponse as? [String : Any] {
            print("Succuesfully Converted to Dictionary: searchResults")
            if let photosList = searchResults["photos"] as? [Any] {
                print("Succuesfully Converted to array: photosList")
                for aPhoto in photosList {
                    if let photoInfoJson = aPhoto as? [String : Any] {
                        print("Succuesfully Converted to Dictionary: photoInfo")
                        //Process image author
                        if let author = photoInfoJson["photographer"] as? String {
                            print("Succuesfully found author")
                            imageAuthor = author
                        }
                        
                        //Process image author website
                        if let authorWebsite = photoInfoJson["photographer_url"] as? String {
                            print("Succuesfully found author website")
                            imageAuthorUrl = authorWebsite
                        }
                        
                        //Process image url
                        if let imageOptions = photoInfoJson["src"] as? [String: Any] {
                            print("Succuesfully Converted to Dictionary: imageOptions")
                            if let imageUrlFromJson = imageOptions["original"] as? String {
                                print("Succuesfully found image url")
                                imageUrl = imageUrlFromJson
                            }
                        }
                        
                    }
                }
            }
        }
    } catch {
        print("Failure At Location 2")
        return photoInfo
    }
    
    //Add relevent image info to the photoInfo array
    photoInfo.append(imageUrl)
    photoInfo.append(imageAuthor)
    photoInfo.append(imageAuthorUrl)
    
    return photoInfo
}

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
