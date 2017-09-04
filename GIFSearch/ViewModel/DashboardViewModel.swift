//
//  DashboardViewModel.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import GiphyKit

class DashboardViewModel: NSObject {

    // MARK: - The API Client
    
    /// The API Client
    internal let apiClient: GiphySearchClient
    
    /// The API Key
    private let apiKey:String = APIKey // Replace APIKey with your API Key
    
    
    // MARK: - Accessing Data
    
    /// The gifs loaded by the most recent API client operation.
    /// Offline/caching were not requirements.
    private(set) var gifs: [GIF]? = nil
    
    /// MARK: - Searching
    var searchTerm: String? = nil {
        didSet {
            self.setNeedsRefresh()
        }
    }
    
    // MARK: - Title
    
    public var title:String
    {
        var title = NSLocalizedString("Giphy Trending", comment: "A title for the demo app.")
        
        if let term = self.searchTerm, term.characters.count > 0
        {
            title = NSLocalizedString("Giphy Results for \(term)", comment: "")
        }
        
        return title
    }
    
    // MARK: - Responding to Data Changes
    
    /// A callback that view controllers can use
    /// to be notified of changes.
    var refreshHandler:(()->Void)? = nil
    
    // MARK: - Initializing the ViewModel
    
    override init() {
        
        self.apiClient = GiphySearchClient(with: self.apiKey)
        super.init()
    }
    
    
    // MARK: - Refreshing the View Model
    
    /// Use this method in the view controller
    /// to explicitly ask the view model to update.
    @objc func setNeedsRefresh()
    {
        if let term = searchTerm, term.characters.count > 0
        {
            self.refreshSearchResults()
        }
        else
        {
            self.refreshTrending() // No search, show trending
        }
    }
    
    // MARK: - Displaying Results of a Search
    
    /// Invokes the search API if there's a search term.
    /// Otherwise does nothing.
    func refreshSearchResults()
    {
        guard let searchTerm = self.searchTerm else
        {
            return
        }
        
        // When the search term changes we fire off a new search request.
        // When the search returns, the UI may reflect a new serch term, so
        // we need to check that the search term that fired off the request
        // is still visible in the UI.
        self.apiClient.search(for: searchTerm) { [weak self] (results:[GIF]?, url: URL?, error: NSError?) in
            guard let strongSelf = self else
            {
                // The view model is gone for some reason.
                return
            }
            
            guard let url = url else
            {
                return
            }
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else
            {
                return
            }
            
            guard let currentSearchTerm = strongSelf.searchTerm else
            {
                return
            }
            
            
            let queryItemAsItWouldBeBasedOnCurrentUI = URLQueryItem(name: "q", value: currentSearchTerm)
            let searchTermIsStillRelevant = components.queryItems?.contains(queryItemAsItWouldBeBasedOnCurrentUI) ?? false
            
            if searchTermIsStillRelevant
            {
                strongSelf.gifs = results
                
                if let callback = strongSelf.refreshHandler
                {
                    callback()
                }
            }
        }
    }
    
    // MARK: - Displaying Trending GIFs
    
    /// The method loads trending images and then calls the refresh handler.
    func refreshTrending()
    {
        self.apiClient.trending { [weak self] (results:[GIF]?, url: URL?, error: NSError?) in
            
            guard let strongSelf = self else
            {
                // The view model is gone for some reason.
                return
            }
            
            strongSelf.gifs = results
            
            if let callback = strongSelf.refreshHandler
            {
                callback()
            }
        }
    }

}
