//
//  RenditionFile.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

class RenditionFile: NSObject {
    
    /// The format of the file.
    let fileType: RenditionFileType
    
    /// The URL for the file.
    let url: URL
    
    /// How large the file is, in bytes.
    let sizeInBytes: NSInteger
    
    // MARK: - Initializing a rendition.
    
    init?(of type: RenditionFileType, with json: [String: Any])
    {
        guard let sizeString = json[type.sizeKey] as? String,
            let sizeNumber = numberFormatter.number(from: sizeString),
            let address = json[type.rawValue] as? String,
            let url = URL(string: address)
            else
        {
            return nil
        }
        
        self.fileType = type
        self.sizeInBytes = sizeNumber.intValue
        self.url = url
        
        super.init()
    }
    
}
