//
//  DashboardViewModel+CollectionView.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/29/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import GiphyKit

extension DashboardViewModel
{
    /// How many sections?
    var numberOfSections: Int {
        return 1
    }
    
    
    /// The number of items in a section.
    ///
    /// - Parameter section: The section.
    /// - Returns: The # of cells we want to show.
    func numberOfItems(in section: Int) ->Int
    {
        var count = 0
        
        if let gifs = self.gifs
        {
            count = gifs.count
        }
        
        return count
    }
    
    // MARK: - Accessing Hashtags for a GIF
    
    func hashtags(for indexPath: IndexPath) -> String?
    {
        guard let gifs = self.gifs else
        {
            return nil
        }
        
        guard indexPath.row < gifs.count else
        {
            return nil
        }
        
        let gif = gifs[indexPath.row]
        
        var hashtags:String? = nil
        
        if let featured = gif.featuredTags
        {
            hashtags = featured.joined(separator: " #")
        }
        else if let tags = gif.tags
        {
            hashtags = tags.joined(separator: " #")
        }
        
        return hashtags
    }
    
    // MARK: - Accessing GIF Data
    
    /// Looks up the gif corresponding to a given index path. If one exists, returns it.
    ///
    /// - Parameter indexPath: The indexpath to display the GIF at.
    /// - Returns: A GIF, if one exists, otherwise `nil`.
    func gif(for indexPath: IndexPath, with completion:@escaping (Data?, IndexPath)->Void)
    {
        guard let gifs = self.gifs else
        {
            completion(nil, indexPath)
            return
        }
        
        guard indexPath.row < gifs.count else
        {
            completion(nil, indexPath)
            return
        }
        
        let gif = gifs[indexPath.row]
        
        let renditionDesignation = self.bestAvailableRenditionDesignation(for: gif)
        
        guard let rendition = gif.renditions[renditionDesignation] else
        {
            completion(nil, indexPath)
            return
        }
        
        guard let file = rendition.files[.gif] else {
            completion(nil, indexPath)
            return
        }
        
        self.apiClient.item(at: file.url) { (data: Data?) in
            completion(data, indexPath)
        }
    }
    
    // MARK: - Choosing the Appropriate Rendition
    
    /// We want to display the GIF as quickly as possible, and then load
    /// a higher quality animated version for rendering.
    ///
    /// - Parameter gif: The GIF to inspect.
    /// - Returns: The best designation to quickly load the image.
    private func bestAvailableRenditionDesignation(for gif:GIF) -> RenditionDesignation
    {
        let designationToReturn: RenditionDesignation = .previewGIF
        
        // See README.md for more about this method. It doesn't do much in the demo
        // implementation of the app.
        
        return designationToReturn
    }
    
}
