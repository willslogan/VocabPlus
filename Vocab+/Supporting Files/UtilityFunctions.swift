//
//  UtilityFunctions.swift
//  Vocab+
//
//  Created by William Logan on 11/27/23.
//  Copyright © 2023 IOS Team 7. All rights reserved.
//

import SwiftUI
import SwiftData

let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

/*
******************************************************************
MARK: - Copy Image File from Assets.xcassets to Document Directory
******************************************************************
*/
public func copyImageFileFromAssetsToDocumentDirectory(filename: String, fileExtension: String) {
   
    /*
     UIImage(named: filename)   gets image from Assets.xcassets as UIImage
     Image("filename")          gets image from Assets.xcassets as Image
     */
   
    //--------------
    // PNG File Copy
    //--------------
   
    if fileExtension == "png" {
        if let imageInAssets = UIImage(named: filename) {
           
            // pngData() returns a Data object containing the specified image in PNG format
            if let pngImageData = imageInAssets.pngData() {
                let fileUrlInDocDir = documentDirectory.appendingPathComponent("\(filename).png")
                do {
                    try pngImageData.write(to: fileUrlInDocDir)
                } catch {
                    print("Unable to write file \(filename).png to document directory!")
                }
            } else {
                print("Image file \(filename).png cannot be converted to PNG data format!")
            }
        } else {
            print("Image file \(filename).png does not exist in Assets.xcassets!")
        }
    }
   
    //---------------
    // JPEG File Copy
    //---------------
   
    if fileExtension == "jpg" {
        if let imageInAssets = UIImage(named: filename) {
            /*
             jpegData() returns a Data object containing the specified image
             in JPEG format with 100% compression quality
             */
            if let jpegImageData = imageInAssets.jpegData(compressionQuality: 1.0) {
                let fileUrlInDocDir = documentDirectory.appendingPathComponent("\(filename).jpg")
                do {
                    try jpegImageData.write(to: fileUrlInDocDir)
                } catch {
                    print("Unable to write file \(filename).jpg to document directory!")
                }
            } else {
                print("Image file \(filename).jpg cannot be converted to JPEG data format!")
            }
        } else {
            print("Image file \(filename).jpg does not exist in Assets.xcassets!")
        }
    }
   
}

/*
 ***********************************************
 MARK: Decode JSON file into an Array of Structs
 ***********************************************
 */
public func decodeJsonFileIntoArrayOfStructs<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T {
    
    /*
     T.self defines the struct type T into which each JSON object will be decoded.
     exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Main Bundle")
     or
     exampleStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "exampleFile.json", fileLocation: "Document Directory")
     The left hand side of the equation defines the struct type T into which JSON objects will be decoded.
     
     This function returns an array of structs of type T representing the JSON objects in the input JSON file.
     In Swift, an Array stores values of the same type in an ordered list. Therefore, the structs will keep their order.
     */
    
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
    
    if fileLocation == "Main Bundle" {
        // Obtain URL of the JSON file in main bundle
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
        
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        // Obtain URL of the JSON file in document directory on user's device
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
        
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
    
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
    
    do {
        // Instantiate an object from the JSONDecoder class
        let decoder = JSONDecoder()
        
        // Use the decoder object to decode JSON objects into an array of structs of type T
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFilename)!")
    }
    
    // Return the array of structs of type T
    return arrayOfStructs!
}
