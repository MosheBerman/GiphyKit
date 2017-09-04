//
//  DashboardViewController+Preferences.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import GiphyKit

extension DashboardViewModel
{
    // MARK: - Loading Preferences On Launch
    
    func loadPreferences()
    {
        if let language = Preferences.shared.preference(for: .language)
        {
            self.apiClient.language = LanguageCode(rawValue: language)!
        }
        
        if let rating = Preferences.shared.preference(for: .rating)
        {
            self.apiClient.rating = Rating(rawValue: rating)!
        }
    }
    
    // MARK: - Handling Preference Changes
    
    /// Handle preference changes.
    ///
    /// - Parameter notification: The notification.
    func handlePreferencesChanged(notification: Notification)
    {
        if notification.name == .PreferencesChanged
        {
            if let userInfo = notification.userInfo
            {
                if let languageString = userInfo[PreferencesKey.language] as? String,
                    let language = LanguageCode(rawValue: languageString)
                {
                    self.apiClient.language = language
                }
                
                if let ratingString = userInfo[PreferencesKey.rating] as? String,
                    let rating = Rating(rawValue: ratingString)
                {
                    self.apiClient.rating = rating
                }
                
                self.setNeedsRefresh()
            }
        }
    }
}
