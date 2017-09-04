//
//  RatingController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import GiphyKit

class RatingController: NSObject {

    // A weak reference to the giphy client.
    let giphyClient: GiphyAPIClient? = nil
    
    // MARK: - Listing Ratings
    
    /// Returns a list of ratings
    var ratings: [Rating] {
        return [.g, .pg, .pg13, .r]
    }
    
    // MARK: -
}
