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
