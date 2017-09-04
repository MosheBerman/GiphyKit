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
    
    private(set) var title:String? = NSLocalizedString("Content Rating", comment: "The title for the rating picker.")
    
    // MARK: - Listing Ratings
    
    /// Returns a list of ratings
    private let ratings: [Rating] = [.g, .pg, .pg13, .r]
    
    // MARK: - Generating an Alert Controller
    
    /// Returns an alert controller, ready to display the rating prompt.
    var viewController: UIViewController
    {
        // We use this to display the UI a little better.
        let currentSetting = Preferences.shared.preference(for: .rating)
        
        var message = NSLocalizedString("Choose the content rating you wish to see.", comment: "A message for the content picker.")
        
        if let current = currentSetting, let rating = Rating(rawValue: current)
        {
            message.append(" \(NSLocalizedString("You're looking currently looking at content rated", comment: "")) \(rating.displayName).")
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        
        for rating in self.ratings
        {
            let title = rating.displayName
            
            var style: UIAlertActionStyle = .default
            
            if let current = currentSetting, rating == Rating(rawValue: current)
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
