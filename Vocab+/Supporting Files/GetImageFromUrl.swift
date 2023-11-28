//
//  GetImageFromUrl.swift
//  BooksPhotos
//
//  Created by Osman Balci on 9/17/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

struct GetImageFromUrl: View {
    
    // Input Parameters
    let stringUrl: String
    let maxWidth: Double
    
    var body: some View {
        
        AsyncImage(url: URL(string: stringUrl)) { imageLoadingState in
            
            switch imageLoadingState {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: maxWidth)
                
            case .failure(_):
                Image("ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: maxWidth)
                
            case .empty:
                ProgressView()
                
            @unknown default:
                Image("ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: maxWidth)
            }
        }
    }
}
