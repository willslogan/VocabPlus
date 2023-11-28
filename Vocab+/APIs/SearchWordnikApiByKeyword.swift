//
//  SearchWordnikApiByKeyword.swift
//  Vocab+
//
//  Created by Anthony Laraway on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

//import Foundation
//
//// Global variable to contain the API search results
//var wordFound = Word(word: "", definition: "", partOfSpeech: "", sourceName: "", audioUrl: "", imageUrl: "", imageAuthor: "", imageAuthorUrl: "", example: "", exampleAuthor: "", exampleAuthorUrl: "", synonyms: "", pointsUntilLearned: 0)
// 
//fileprivate var previousSearch = ""
//
///*
// ================================================
// |   Fetch and Process JSON Data from the API   |
// |   for a Word with its name given             |
// ================================================
//*/
//public func getWordFromWordnik(word: String) {
//   
//    // Avoid executing this function if already done for the same word
//    if word == previousSearch {
//        return
//    } else {
//        previousSearch = word
//    }
//   
//    // Initialize the global variable to contain the API search results
//    wordFound = Word(word: "", definition: "", partOfSpeech: "", sourceName: "", audioUrl: "", imageUrl: "", imageAuthor: "", imageAuthorUrl: "", example: "", exampleAuthor: "", exampleAuthorUrl: "", synonyms: "", pointsUntilLearned: 0)
//    
//    /*
//     ***************************************
//     *   Obtaining API Search URL String   *
//     ***************************************
//     */
//    
//    
//    let apiUrlString = "https://developer.nps.gov/api/v1/parks?q=a&limit=500&fields=images&api_key=\(myApiKey)"
//
//    /*
//    ***************************************************
//    *   Fetch JSON Data from the API Asynchronously   *
//    ***************************************************
//    */
//    var jsonDataFromApi: Data
//    
//    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: npsApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
//    
//    if let jsonData = jsonDataFetchedFromApi {
//        jsonDataFromApi = jsonData
//    } else {
//        return
//    }
//                                       
//    /*
//    **************************************************
//    *   Process the JSON Data Fetched from the API   *
//    **************************************************
//    */
//    do {
//        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
//                          options: JSONSerialization.ReadingOptions.mutableContainers)
//
//        /*
//         -----------------------------------------------------
//         |   National Park Service API JSON File Structure   |
//         -----------------------------------------------------
//         
//         To search by full park name with photo images, we obtain the data for all 460 national parks
//         and then check if the park name = parkName given as input parameter to find the searched park.
//         The API returns the JSON file below for the following query.
//         
//         https://developer.nps.gov/api/v1/parks?q=a&limit=500&fields=images&api_key=myApiKey
//         
//         {                      <== Top Level JSON Object
//             "total":"460",     <== Data obtained for all of the 460 national parks
//             "limit":"500",
//
//             ✅"data":
//             [                  <== Array of JSON Objects representing national parks
//                 {
//                     ✅"states":"AZ",
//                     "directionsInfo":"South Rim: Open all year, ... from the Utah border.",
//                     "directionsUrl":"http:\/\/www.nps.gov\/grca\/planyourvisit\/directions.htm",
//                     ✅"url":"https:\/\/www.nps.gov\/grca\/index.htm",
//                     "weatherInfo":"This weather varies ... variety in this region.",
//                     "name":"Grand Canyon",
//                     ✅"latLong":"lat:36.17280161, long:-112.6836024",
//                     ✅"description":"Unique combinations of geologic ... for the 2020 season.",
//                     ✅"images":
//                     [
//                         {
//                             "credit":"NPS\/M.Quinn",
//                             "altText":"The canyon glows orange as people ... that juts into Grand Canyon",
//                             "title":"Grand Canyon Mather Point Sunset on the South Rim",
//                             "id":"448",
//                             ✅"caption":"People come from all over the world to view Grand Canyon's sunset",
//                             ✅"url":"https:\/\/www.nps.gov\/common\/uploads\/structured_data\/3C7B12D1-1DD8-B71B-0BCE0712F9CEA155.jpg"
//                         },
//                         {
//                             "credit":"NPS\/M.Quinn",
//                             "altText":"The Cape Royal viewpoint curves ... into the canyon.",
//                             "title":"Grand Canyon National Park: View from Cape Royal on the North Rim",
//                             "id":"449",
//                             ✅"caption":"A popular outdoor site for ... the North Rim developed area.",
//                             ✅"url":"https:\/\/www.nps.gov\/common\/uploads\/structured_data\/3C7B143E-1DD8-B71B-0BD4A1EF96847292.jpg"
//                         },
//                         {
//                             "credit":"NPS\/M.Quinn",
//                             "altText":"The Desert View Watchtower ... view of the canyon.",
//                             "title":"Grand Canyon National Park: Desert View Watchtower (South Rim)",
//                             "id":"450",
//                             ✅"caption":"The Watchtower is located at ... Grand Canyon National Park.",
//                             ✅"url":"https:\/\/www.nps.gov\/common\/uploads\/structured_data\/3C7B15A4-1DD8-B71B-0BFADECB506765CC.jpg"
//                         },
//                         {
//                             "credit":"NPS\/M.Quinn",
//                             "altText":"Tall canyon walls frame the wide Colorado river weaving back and forth.",
//                             "title":"Looking down the Colorado River from Nankoweap at river mile 53",
//                             "id":"451",
//                             ✅"caption":"A view down the Colorado river from Nankoweap in Marble canyon.",
//                             ✅"url":"https:\/\/www.nps.gov\/common\/uploads\/structured_data\/3C7B1720-1DD8-B71B-0B74DCF6F887A960.jpg"
//                         }
//                     ],
//                     "designation":"National Park",
//                     "parkCode":"grca",
//                     "id":"B7FF43E5-3A95-4C8E-8DBE-72D8608D6588",
//                     ✅"fullName":"Grand Canyon National Park"
//                 }
//             ],
//             "limit":"50",
//             "start":"1"
//         }
//         */
//        
//        //-----------------------------
//        // Obtain Top Level JSON Object
//        //-----------------------------
//        
//        var jsonDataDictionary = [String: Any]()
//        
//        if let jsonObject = jsonResponse as? [String: Any] {
//            jsonDataDictionary = jsonObject
//        } else {
//            // nationalParkFound will have empty values
//            return
//        }
//       
//        //-----------------------------------------------------
//        // Obtain the JSON Array for the Attribute / Key 'data'
//        //-----------------------------------------------------
//       
//        var arrayOfNationalParksJsonObjects = [Any]()
//        
//        if let jArray = jsonDataDictionary["data"] as? [Any] {
//            arrayOfNationalParksJsonObjects = jArray
//        } else {
//            // nationalParkFound will have empty values
//            return
//        }
//        
//        /*
//         API returns the following for invalid national park name
//         {"total":"0","data":[],"limit":"50","start":"1"}
//         */
//        if arrayOfNationalParksJsonObjects.isEmpty {
//            // nationalParkFound will have empty values
//            return
//        }
//        
//        // Iterate over all of the national parks returned
//        for park in arrayOfNationalParksJsonObjects {
//            
//            var nationalPark = [String: Any]()
//            
//            if let parkJsonObject = park as? [String: Any] {
//                nationalPark = parkJsonObject
//            }
//
//            //-------------------------------
//            // Obtain National Park Full Name
//            //-------------------------------
// 
//            var fullName = ""
//            
//            if let name = nationalPark["fullName"] as? String {
//                fullName = name
//            }
//            
//            // We want the park whose name = input parameter parkName
//            if fullName != parkName {
//                continue
//            }
//            
//            // fullName = parkName. The park name searched for is found.
//           
//            //----------------------------------------
//            // Obtain State Names of the National Park
//            //----------------------------------------
//           
//            var states = ""
//            
//            if let stateNames = nationalPark["states"] as? String {
//                states = stateNames
//            }
//           
//            //---------------------------------
//            // Obtain National Park Website URL
//            //---------------------------------
//            
//            var websiteUrl = ""
//            
//            if let rawUrl = nationalPark["url"] as? String {
//                
//                // Remove all occurrences of backslash in national park website URL
//                let cleanedUrl = rawUrl.replacingOccurrences(of: "\\", with: "")
//                websiteUrl = cleanedUrl
//            }
//            
//            //---------------------------------
//            // Obtain National Park Geolocation
//            //---------------------------------
//
//            var latitude  = 0.0, longitude = 0.0
//            
//            if let latLong = nationalPark["latLong"] as? String {
//                
//                if !latLong.isEmpty {
//                    // "latLong":"lat:36.17280161, long:-112.6836024"
//                    
//                    let latLongArray = latLong.components(separatedBy: ",")
//                    // latLongArray[0] = "lat:36.17280161"
//                    // latLongArray[1] = "long:-112.6836024"
//                    
//                    let latArray = latLongArray[0].components(separatedBy: ":")
//                    // latArray[0] = "lat"
//                    // latArray[1] = "36.17280161"
//
//                    if let lat = Double(latArray[1]) {
//                        latitude = lat
//                    }
//                    
//                    let longArray = latLongArray[1].components(separatedBy: ":")
//                    // longArray[0] = "long"
//                    // longArray[1] = "-112.6836024"
//                    
//                    if let long = Double(longArray[1]) {
//                        longitude = long
//                    }
//                }
//            }
//            
//            //---------------------------------
//            // Obtain National Park Description
//            //---------------------------------
//
//            var description = ""
//            
//            if let parkDescription = nationalPark["description"] as? String {
//                description = parkDescription
//            }
//
//            //----------------------------
//            // Obtain National Park Photos
//            //----------------------------
//            
//            var parkPhotoArray = [ParkPhoto]()
//            
//            if let arrayOfNationalParkPhotos = nationalPark["images"] as? [Any] {
//                
//                // Iterate over Array of National Park Photos
//                for aParkPhoto in arrayOfNationalParkPhotos {
//                    
//                    var photoJasonObject = [String: Any]()
//
//                    if let jsonObject = aParkPhoto as? [String: Any] {
//                        photoJasonObject = jsonObject
//                    } else { continue }
//                    
//                    var photoUrl = "", photoCaption = ""
//
//                    if let rawPhotoUrl = photoJasonObject["url"] as? String {
//                        // Remove all occurrences of backslash in national park photo URL
//                        photoUrl = rawPhotoUrl.replacingOccurrences(of: "\\", with: "")
//                    } else { continue }
//                    
//                    if let caption = photoJasonObject["caption"] as? String {
//                        photoCaption = caption
//                    } else { continue }
//                    
//                    // Create an Instance of ParkPhoto struct and append it to parkPhotoArray
//                    let parkPhotoImage = ParkPhoto(url: photoUrl, caption: photoCaption)
//                    parkPhotoArray.append(parkPhotoImage)
//                    
//                }   // End of for loop
//  
//            }   // End of if statement
//               
//            //--------------------------------------------------------------------------------
//            // Create an instance of NationalPark struct, dress it up with the values obtained
//            // from the API, and set its id to the global variable nationalParkFound
//            //--------------------------------------------------------------------------------
//            nationalParkFound = NationalParkStruct(fullName: fullName, states: states, websiteUrl: websiteUrl, latitude: latitude, longitude: longitude, description: description, parkPhotos: parkPhotoArray)
//            
//        }   // End of the for loop
//           
//    } catch {
//        // nationalParkFound will have empty values
//        return
//    }
//       
//}
// 
// 
//
