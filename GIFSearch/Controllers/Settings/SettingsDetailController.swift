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
    
    /// The alert controller that the settings details are presented in.
    var viewController:UIViewController { get }
    
    /// The title of the view controller
    var title: String? { get }
}
