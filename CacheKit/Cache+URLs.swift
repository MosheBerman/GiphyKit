//
//  Cache+URLs.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/30/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

extension Cache
{
    // MARK: - Generating Disk URLs from Network URLs.
    
    
    /// Return the URL we need to access the document.
    private var cachesDirectory: URL?
    {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        return url
    }
}
