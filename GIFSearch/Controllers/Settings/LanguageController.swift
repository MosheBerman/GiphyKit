//
//  LanguageController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/4/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import GiphyKit

class LanguageController: NSObject, SettingsDetailController {
    
    // A weak reference to the giphy client.
    var apiClient: GiphyAPIClient? = nil
    
    /// All of the languages
    private let languages: [LanguageCode] = [.arabic, .bengali, .czech, .danish, .dutch, .english, .farsi, .filipino, .finnish, .french, .german, .hebrew, .indonesian, .italian, .japanese, .korean, .malay, .norwegian, .polish, .romanian, .russian, .spanish, .swedish, .thai, .turkish, .ukrainian, .vietnamese]
    
    // The alert controller
    var viewController: UIViewController
    {
        let title = NSLocalizedString("Language", comment: "The title for the language picker.")
        let message = NSLocalizedString("Choose your preferred language region.", comment: "A message for the language picker.")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for language in self.languages
        {
            
            var title = language.rawValue
            
            let locale = NSLocale(localeIdentifier: language.rawValue)
            
            if let languageName = locale.localizedString(forLanguageCode: language.rawValue)
            {
                title = languageName
            }
            
            var style: UIAlertActionStyle = .default
            
            if language == self.apiClient?.language
            {
                style = .cancel
            }
            
            let actionItem = UIAlertAction(title: title, style: style, handler: { [weak self](action:UIAlertAction) in
                self?.apiClient?.language = language
            })
            
            alertController.addAction(actionItem)
        }
        
        return alertController

        
    }
    
}
