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
    private let apiClient: GiphySearchClient
    private let apiKey:String = APIKey // Replace APIKey with your API Key
    
    // MARK: - Accessing Data
    private(set) var gifs: [GIF] = []
    
    
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
    func setNeedsRefresh()
    {
        
    }
}
