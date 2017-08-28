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
class Rendition: NSObject {
    
    /// The kind of rendition.
    let designation: RenditionDesignation
    
    // MARK: - The Dimensions of the Rendition
    
    /// The size of the rendition.
    let dimensions: CGSize
    
    
    
    // MARK: - Initializing a Rendition
    
    /// Creates a model wrapper for a rendition.
    ///
    /// - Parameters:
    ///   - designation: The designation of the rendition
    ///   - json: A JSON dictionary containing rendition information
    init?(with designation: RenditionDesignation, and JSON: [String: Any])
    {
        self.designation = designation
        
        guard let widthString = JSON["width"] as? String,
            let heightString = JSON["height"] as? String,
            let width = numberFormatter.number(from: widthString),
            let height = numberFormatter.number(from: heightString)
            else
        {
            return nil
        }
        
        self.dimensions = CGSize(width: width.intValue, height: height.intValue)
        
        super.init()
    }
}