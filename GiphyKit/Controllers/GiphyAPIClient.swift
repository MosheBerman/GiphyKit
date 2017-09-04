//
//  GiphyAPIClient.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

public class GiphyAPIClient: NSObject {
    
    // MARK: - URL Session
    
    /// A session we can use to interact with the API.
    private let session: URLSession
    
    // MARK: - The Client API Key
    
    /// Replace this with your API key.
    private(set) var apiKey: String
    
    
    // MARK: - Setting the Content Rating
    
    /// The rating to use for the requests.
    public var rating: Rating = .g
    
    
    // MARK: - Filtering by Region
    public var language: LanguageCode = .english
    
    
    // MARK: - Initializing the API Client
    
    public init(with key: String)
    {
        self.apiKey = key
        self.rootEndpoint = URL(string:"https://api.giphy.com/")!
        
        let configuration = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: configuration)
        self.session = session
    }
    
    
    // MARK: - Endpoints
    
    /// The GIPHY root endpoint.
    private var rootEndpoint: URL
    
    /// Returns URL components
    private var rootEndpointComponents: URLComponents?
    {
        let rootEndpointComponents = URLComponents(url: self.rootEndpoint, resolvingAgainstBaseURL: false)
        
        guard var components = rootEndpointComponents else
        {
            return nil
        }
        
        // Set up some default components to send with each request.
        components.queryItems = [
            URLQueryItem(name: "api_key", value: self.apiKey),
            URLQueryItem(name: "lang", value: self.language.rawValue),
            URLQueryItem(name: "rating", value: self.rating.rawValue),
        ]
        
        return components
    }
    
    /// The endpoint for trending
    private var trendingEndpoint: URL? {
        guard var components = self.rootEndpointComponents else
        {
            return nil
        }
        
        components.path = "/v1/gifs/trending"
        
        guard let url = components.url else
        {
            return nil
        }
        
        return url
    }
    
    /// Converts the supplied parameters into an endpoint for Search.
    ///
    /// - Parameters:
    ///   - query: The search term.
    ///   - limit: How many items to return.
    ///   - offset: The offset from the first result.
    /// - Returns: A URL based on the original endpoint.
    private func searchEndpoint(with query: String, limit: Int = 25, offset: Int?) -> URL?
    {
        var queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
    
        if let offset = offset
        {
            let offsetQuery = URLQueryItem(name: "offset", value: "\(offset)")
            queryItems.append(offsetQuery)
        }
        
        var components = self.rootEndpointComponents
        components?.path = "/v1/gifs/search"
        components?.queryItems?.append(contentsOf: queryItems)
        
        guard let url = components?.url else
        {
            return nil
        }
        
        return url
    }
    
    
    // MARK: - Getting Trending GIFs.
    
    /// Fetch the trending GIFs
    ///
    /// - Parameters:
    ///   - rating: The maximum filter rating to use with the request.
    ///   - completion: A completion handler to execute after downloading and processing the data.
    public func trending(with completion:(@escaping ([GIF]?, URL?, NSError?)->Void))
    {
        guard let endpoint = self.trendingEndpoint else
        {
            let error = NSError(domain: "com.mosheberman.giphykit.endpoint", code: ErrorCode.couldNotGenerateEndpoint.rawValue, userInfo: nil)
            completion(nil, nil, error)
            return
        }
        
        self.executeRequest(for: endpoint, with: completion)
    }
    
    
    // MARK: - Searching for a Specific GIF
    
    /// Searches the Giphy API and returns the results of the search
    ///
    /// - Parameters:
    ///   - term: The search term.
    ///   - limit: The number of results.
    ///   - offset: The offset in pagination.
    ///   - completion: The completion handler.
    public func search(for term:String, limit:Int = 25, offset:Int = 0,  with completion:(@escaping ([GIF]?, URL?, NSError?)->Void))
    {
        guard let endpoint = self.searchEndpoint(with: term, limit: limit, offset: offset) else
        {
            let error = NSError(domain: "com.mosheberman.giphykit.endpoint", code: ErrorCode.couldNotGenerateEndpoint.rawValue, userInfo: nil)
            completion(nil, nil, error)
            return
        }
        
        self.executeRequest(for: endpoint, with: completion)
    }
    
    // MARK: - Accessing an Object At a URL
    
    
    /// A method for downloading a block of data (i.e. a gif, or mp4.)
    ///
    /// - Parameters:
    ///   - url: The URL to access.
    ///   - completion: A handler to pass the data back in.
    public func item(at url: URL, with completion:@escaping (Data?)->Void)
    {
        let task = self.session.dataTask(with: url) { (data: Data?, response:URLResponse?, error:Error?) in
            completion(data)
        }
        
        task.resume()
    }
    
    
    // MARK: - Executing a Network Request
    
    /// Executes a network request and then calls the handler when finished.
    ///
    /// - Parameters:
    ///   - url: The URL to request from.
    ///   - completion: The completion handler to execute after downloading and processing data.
    private func executeRequest(for url: URL, with completion:@escaping ([GIF]?, URL?, NSError?)->Void)
    {
        let task = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var errorResponse: NSError? = nil
            var gifs: [GIF]? = nil
            
            if let data = data, error == nil
            {
                do
                {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                        let jsonOfGIFs = json["data"] as? [[String:AnyObject]]
                    {
                        gifs = []
                        for json in jsonOfGIFs
                        {
                            if let gif = GIF(with: json)
                            {
                                gifs?.append(gif)
                            }
                            else
                            {
                                print("\(self.self) : Failed to process GIF.")
                                errorResponse = NSError(domain: "com.mosheberman.giphykit.url-session-failure", code: ErrorCode.failedToProcessGIF.rawValue, userInfo: nil)
                            }
                        }
                    }
                    else
                    {
                        errorResponse = NSError(domain: "com.mosheberman.giphykit.url-session-failure", code: ErrorCode.failedToUnwrapJSONFromDataResponse.rawValue, userInfo: nil)
                    }
                    
                }
                catch
                {
                    errorResponse = NSError(domain: "com.mosheberman.giphykit.url-session-failure", code: ErrorCode.failedToUnwrapJSONFromDataResponse.rawValue, userInfo: nil)
                }
            }
            else
            {
                errorResponse = NSError(domain: "com.mosheberman.giphykit.url-session-failure", code: ErrorCode.noDataInResponse.rawValue, userInfo: nil)
            }
            
            completion(gifs, url, errorResponse)
        }
        
        
        task.resume()
    }
    
}
