//
//  DashboardViewController+Preferences.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import GiphyKit

extension DashboardViewController
{
    
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
                    self.viewModel.apiClient.language = language
                }
                
                if let ratingString = userInfo[PreferencesKey.rating] as? String,
                    let rating = Rating(rawValue: ratingString)
                {
                    self.viewModel.apiClient.rating = rating
                }
                
                self.viewModel.setNeedsRefresh()
            }
        }
    }
}
