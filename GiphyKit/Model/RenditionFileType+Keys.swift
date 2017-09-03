//
//  RenditionFileType+Keys.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

// MARK: - Adding Keys to Access Rendition Files

extension RenditionFileType
{
    /// The key to access the size
    /// of the file matching this file type.
    var sizeKey: String
    {
        switch self
        {
        case .gif:
            return "size"
        case .mp4:
            return "mp4_size"
        case .webp:
            return "webp_size"
        }
    }
    
    var urlKey: String
    {
        switch self {
        case .gif:
            return "url"
        case .mp4:
            return "mp4"
        case .webp:
            return "webp"
        }
    }
}
