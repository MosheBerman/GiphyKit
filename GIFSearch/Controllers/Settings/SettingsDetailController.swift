//
//  SettingsDetailController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import GiphyKit

protocol SettingsDetailController {
    
    
    /// The API client that the details view uses to modify settings.
    weak var apiClient: GiphyAPIClient? { get set }
    
    /// The alert controller that the settings details are presented in.
    var viewController:UIViewController { get }
}
