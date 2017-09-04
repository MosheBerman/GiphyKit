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
    private let ratings: [Rating] = [.g, .pg, .pg13, .r]
    
    // MARK: -
    
    var alertController: UIAlertController
    {
        let title = NSLocalizedString("Content Rating", comment: "The title for the rating picker.")
        let message = NSLocalizedString("Choose the content rating you wish to see.", comment: "A message for the content picker.")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for rating in self.ratings
        {
            let title = rating.displayName
            
            let actionItem = UIAlertAction(title: title, style: .default, handler: { [weak self](action:UIAlertAction) in
                self?.giphyClient?.rating = rating
            })
            
            alertController.addAction(actionItem)
        }
        
        return alertController
    }
}
