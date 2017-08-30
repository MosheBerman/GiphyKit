//
//  GiphySearchClient.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

public class GiphySearchClient: NSObject {
    
    // MARK: - The Client API Key
    
    /// Replace this with your API key.
    private(set) var apiKey: String
    
    // MARK: - Setting the Content Rating
    
    /// The rating to use for the requests.
    public var rating: Rating = .g
    
    
    // MARK: - Filtering by Region
    public var language: LanguageCode = .unitedStates
    
    // MARK: - Endpoints
    
    /// The GIPHY root endpoint.
    private var rootEndpoint: URL
    
    private var rootEndpointComponents: URLComponents?
    {
        return URLComponents(url: self.rootEndpoint, resolvingAgainstBaseURL: false)
    }
    
    /// The endpoint for trending
    private var trendingEndpoint: URL? {
        var components = self.rootEndpointComponents
        components?.path = "trending"
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: self.apiKey),
            URLQueryItem(name: "lang", value: self.language.rawValue),
            URLQueryItem(name: "rating", value: self.rating.rawValue)
        ]
        
        guard let url = components?.url else
        {
            return nil
        }
        
        return url
    }
    
    // MARK: - Initializing the API Client
    
    public init(with key: String)
    {
        self.apiKey = key
        self.rootEndpoint = URL(string:"https://api.giphy.com/v1")!
    }
    
    // MARK: - Getting Trending GIFs.
    
    /// Fetch the trending GIFs
    ///
    /// - Parameters:
    ///   - rating: The maximum filter rating to use with the request.
    ///   - completion: A completion handler to execute after downloading and processing the data.
    public func trending(with completion:(@escaping ([GIF]?, NSError?)->Void))
    {
        guard let endpoint = self.trendingEndpoint else
        {
            let error = NSError(domain: "com.gifyclient.endpoint", code: 1, userInfo: nil)
            completion(nil, error)
            return
        }
        
        self.executeRequest(for: endpoint, with: completion)
    }
    
    
    /// Executes a network request and then calls the handler when finished.
    ///
    /// - Parameters:
    ///   - url: The URL to request from.
    ///   - completion: The completion handler to execute after downloading and processing data.
    private func executeRequest(for url: URL, with completion:@escaping ([GIF]?, NSError?)->Void)
    {
        let task = URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var errorResponse: NSError? = nil
            var gifs: [GIF]? = nil
            
            if let data = data, error == nil
            {
                do
                {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                        let jsonOfGIFs = json["data"] as? [[String:String]]
                    {
                        for json in jsonOfGIFs
                        {
                            if let gif = GIF(with: json)
                            {
                                gifs?.append(gif)
                            }
                            else
                            {
                                print("\(self.self) : Failed to process GIF for JSON: \(json)")
                            }
                        }
                    }
                    else
                    {
                        errorResponse = NSError(domain: "com.gifyclient.url-session-failure", code: ErrorCode.failedToUnwrapJSONFromDataResponse.rawValue, userInfo: nil)
                    }
                    
                }
                catch
                {
                    errorResponse = NSError(domain: "com.gifyclient.url-session-failure", code: ErrorCode.failedToUnwrapJSONFromDataResponse.rawValue, userInfo: nil)
                }
            }
            else
            {
                errorResponse = NSError(domain: "com.gifyclient.url-session-failure", code: ErrorCode.noDataInResponse.rawValue, userInfo: nil)
            }
            
            completion(gifs, errorResponse)
        }
        
        
        task.resume()
    }
    
}
