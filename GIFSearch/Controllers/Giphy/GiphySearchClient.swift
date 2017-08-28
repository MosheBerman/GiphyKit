//
//  GiphySearchClient.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

class GiphySearchClient: NSObject {
    
    /// The GIPHY root endpoint.
    private var rootEndpoint: String = "https://api.giphy.com/v1/gifs/search"
    
    /// Replace this with your API key.
    private let apiKey: String = APIKey
    
    // MARK: - Getting Trending GIFs.
    
    /// Fetch the trending GIFs
    ///
    /// - Parameters:
    ///   - rating: The maximum filter rating to use with the request.
    ///   - completion: A completion handler to execute after downloading and processing the data.
    public func trending(for rating: Rating = .g, with completion:())
    {
        
    }
}
