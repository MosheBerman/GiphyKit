//
//  Rating.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// The ratings filters for GIPHY's API.
///
/// - g: Represents the G rating.
/// - pg: Represents the PG rating.
/// - pg13: Represents the PG-13 rating.
/// - r: Represents the R rating.
/// - unrated: Represents a situation where the client can't parse a rating.
enum Rating: String {
    case g = "G"
    case pg = "PG"
    case pg13 = "PG-13"
    case r = "R"
    case unrated = "?"
}
