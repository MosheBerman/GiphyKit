//
//  RenditionFileType+Keys.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

// MARK: - Adding Keys to Access File Sizes

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
}
