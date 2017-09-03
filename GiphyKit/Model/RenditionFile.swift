//
//  RenditionFile.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// This class represents a specific rendition of the GIF. 
public class RenditionFile: NSObject {
    
    /// The format of the file.
    public let fileType: RenditionFileType
    
    /// The URL for the file.
    public let url: URL
    
    /// How large the file is, in bytes.
    public let sizeInBytes: NSInteger
    
    /// The height of the image.
    public let height: Int?
    
    
    /// The width of the image.
    public let width: Int?
    
    // MARK: - Initializing a Rendition
    
    public init?(of type: RenditionFileType, with json: [String: Any])
    {
        guard let sizeString = json[type.sizeKey] as? String,
            let sizeNumber = numberFormatter.number(from: sizeString),
            let address = json[type.urlKey] as? String,
            let url = URL(string: address)
            else
        {
            return nil
        }
        
        self.fileType = type
        self.sizeInBytes = sizeNumber.intValue
        self.url = url
        
        if let height = json["height"] as? String
        {
            self.height = numberFormatter.number(from: height)?.intValue
        }
        else
        {
            self.height = nil
        }
        
        if let width = json["width"] as? String
        {
            self.width = numberFormatter.number(from: width)?.intValue
        }
        else
        {
            self.width = nil
        }
        
        super.init()
    }
    
}
