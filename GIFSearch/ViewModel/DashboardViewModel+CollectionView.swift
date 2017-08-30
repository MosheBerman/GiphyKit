//
//  DashboardViewModel+CollectionView.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/29/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

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
    
}
