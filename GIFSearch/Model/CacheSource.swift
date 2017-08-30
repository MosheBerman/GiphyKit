//
//  CacheSource.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/30/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// The source that a data item was fetched from.
///
/// - memory: Used when the media cache finds a hit in the in-memory store.
/// - disk: The media cache had to look on disk.
/// - network: The in-memory and disk based caches both failed - we had to go to network.
enum CacheSource
{
    case memory
    case disk
    case network
}
