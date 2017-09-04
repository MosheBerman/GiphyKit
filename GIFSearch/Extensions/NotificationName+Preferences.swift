//
//  NotificationName+Preferences.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation


// MARK: - Extending NSNotificationCenter for Preferences
extension Notification.Name
{
    
    /// Dispatched when the preferences changed.
    static let PreferencesChanged = Notification.Name("com.mosheberman.giphy.preferences-changed")
}
