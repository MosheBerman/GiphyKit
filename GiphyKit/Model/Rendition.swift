//
//  AssetRepresentation.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import CoreGraphics

/// Each rendition of a GIF is a modified version to have a specific size, scale, etc.
/// The name rendition comes from the Giphy documentation.
public class Rendition: NSObject {
    
    /// The kind of rendition.
    public let designation: RenditionDesignation
    
    // MARK: - The Dimensions of the Rendition
    
    /// The size of the rendition.
    public let dimensions: CGSize
    
    public let files: [RenditionFileType:RenditionFile]
    
    // MARK: - Initializing a Rendition
    
    /// Creates a model wrapper for a rendition.
    ///
    /// - Parameters:
    ///   - designation: The designation of the rendition
    ///   - json: A JSON dictionary containing rendition information
    public init?(with designation: RenditionDesignation, and json: [String: Any])
    {
        self.designation = designation
        
        guard let widthString = json["width"] as? String,
            let heightString = json["height"] as? String,
            let width = numberFormatter.number(from: widthString),
            let height = numberFormatter.number(from: heightString)
            else
        {
            return nil
        }
        
        self.dimensions = CGSize(width: width.intValue, height: height.intValue)
        
        var files: [RenditionFileType:RenditionFile] = [:]
        let types: [RenditionFileType] = [.gif, .mp4, .webp]
        
        for fileType in types
        {
            if let renditionFile = RenditionFile(of: fileType, with: json)
            {
                files[fileType] = renditionFile
            }
        }
        
        self.files = files
        
        super.init()
    }
}
