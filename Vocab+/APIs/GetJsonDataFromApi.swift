//
//  GetJsonDataFromApi.swift
//  Vocab+
//
//  Created by Osman Balci on 10/4/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import Foundation

// File private variable to be returned containing the JSON data
fileprivate var jsonDataFromApi = Data()

/*
****************************************
*   Get JSON Data from a RESTful API   *
****************************************
*/
public func getJsonDataFromApi(apiHeaders: [String: String], apiUrl: String, timeout: Double) -> Data? {
    /*
     apiHeaders: is a dictionary of Key-Value pairs defined as, for example:
                 let tmdbApiHeaders = [
                     "accept": "application/json",
                     "cache-control": "no-cache",
                     "connection": "keep-alive",
                     "host": "api.themoviedb.org"  <-- The host server of the API
                 ]
     
     apiUrl:     String type of the API URL with which to fetch the JSON data file
     timeout:    The timeout interval for the request, in seconds.
     */

    //-----------
    // Initialize
    //-----------
    jsonDataFromApi = Data()
    
    /*
     **************************************
     *   Obtaining API Query URL Struct   *
     **************************************
     */
    var apiQueryUrlStruct: URL?
   
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return nil
    }
        
    /*
     ***********************************
     *   Setting Up HTTP Get Request   *
     ***********************************
     */
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: timeout)
   
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = apiHeaders
   
    /*
     ******************************************************
     *  Setting Up a URL Session to Fetch the JSON File   *
     *  from the API in an Asynchronous Manner            *
     ******************************************************
     */
   
    /*
     Create a semaphore to control fetching API data in an Asynchronous Manner.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched
         in an asynchronous manner. After the file is fetched, 'data', 'response', 'error'
         are returned as the input parameter values of this Completion Handler Closure.
         */
       
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
       
        /*
         ---------------------------------------------------------
         🔴 Any 'return' used within the completionHandler Closure
         exits the Closure; not the public function it is in.
         ---------------------------------------------------------
         */
       
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let dataObtained = data else {
            semaphore.signal()
            return
        }
        
        jsonDataFromApi = dataObtained
        
        semaphore.signal()
    }).resume()
   
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
    
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 'timeout' seconds expires.
     */
   
    _ = semaphore.wait(timeout: .now() + timeout)
    
    return jsonDataFromApi
}


