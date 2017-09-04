//
//  RatingController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import GiphyKit

class RatingController: NSObject, SettingsDetailController {

    // A weak reference to the giphy client.
    var apiClient: GiphyAPIClient? = nil
    
    private(set) var title:String? = NSLocalizedString("Content Rating", comment: "The title for the rating picker.")
    
    // MARK: - Listing Ratings
    
    /// Returns a list of ratings
    private let ratings: [Rating] = [.g, .pg, .pg13, .r]
    
    // MARK: - Generating an Alert Controller
    
    /// Returns an alert controller, ready to display the rating prompt.
    var viewController: UIViewController
    {
        var message = NSLocalizedString("Choose the content rating you wish to see.", comment: "A message for the content picker.")
        
        if let client = self.apiClient
        {
            message.append(" \(NSLocalizedString("You're looking currently looking at content rated", comment: "")) \(client.rating.displayName).")
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for rating in self.ratings
        {
            let title = rating.displayName
            
            var style: UIAlertActionStyle = .default
            
            if rating == self.apiClient?.rating
            {
                style = .cancel
            }
            
            let actionItem = UIAlertAction(title: title, style: style, handler: { (action:UIAlertAction) in
                Preferences.shared.set(preference: rating.rawValue, for: .rating)
            })
            
            alertController.addAction(actionItem)
        }
        
        return alertController
    }
}
