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
    
    // MARK: - Accessing GIF Data
    
    
    /// Looks up the gif corresponding to a given index path. If one exists, returns it.
    ///
    /// - Parameter indexPath: The indexpath to display the GIF at.
    /// - Returns: A GIF, if one exists, otherwise `nil`.
    func gif(for indexPath: IndexPath) -> GIF?
    {
        var gif: GIF? = nil
        
        guard let gifs = self.gifs else
        {
            return gif
        }
        
        if indexPath.row < gifs.count
        {
            gif = gifs[indexPath.row]
        }
        
        return gif
    }
    
}
