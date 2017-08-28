//
//  GIF.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// Each instance of `GIF` is a single search result from the GIPHY API.
///
/// The structure of this object is based closely on the
/// documentation outlined at https://developers.giphy.com/docs/.
///
/// The order of the properties differs from the Giphy documentation 
/// to better document the purpose of each field, and some of the types 
/// have been changed from `String` to better match Swift/Cocoa convention.
class GIF: NSObject {

    /// The type of result. Usually `gif`.
    let type: String
    
    /// The GIF's identifier. Used to access the asset on GIPHY.com.
    let identifier: String
    
    // MARK: - Renditions of the GIF
    
    var renditions: [RenditionDesignation: Rendition]
    
    // MARK: - Accessing the Image on Giphy
    
    /// The GIPHY slug
    let slug: String
    
    /// A URL to access the asset
    var url: URL? {
        let address = "https://giphy.com/gifs/\(self.slug)"
        return URL(string: address)
    }
    
    // MARK: - Sorting/Filtering the GIF
    
    // The rating of the asset.
    var rating: Rating
    
    /// A list of tags assigned to the GIF
    var tags: [String]
    
    /// A list of featured tags assigned to the GIF.
    var featuredTags: [String]
    
    // MARK: - Sharing the GIF
    
    /// The Bit.ly URL for the gif.
    var bitlyURL: URL?
    
    // MARK: - Embedding the GIF
    
    /// The URL used to embed in a webpage.
    var embedURL: URL?
    
    // MARK: - Attributing a GIF
    
    /// The URL of the webpage on which this GIF was found.
    var source: URL?
    
    /// The TLD of the website on which this GIF was found.
    var sourceTLD: URL?
    
    /// The URL of the post in which this GIF was found.
    var sourcePost: URL?
    
    /// The username associated with the GIF.
    var username: String
    
    // MARK: - Determining the Age of the GIF
    
    /// A timestamp when the images was added to the Giphy database.
    var createTimestamp: Date
    
    /// A timestamp when the GIF was updated.
    var updateTimestamp: Date?
    
    /// A timestamp when the GIF was updated.
    var trendingTimestamp: Date?
    
    // MARK: - Unused Properties
    
    /// The Giphy Docs say this is unused.
    var contentURL: String? = nil
    
    // MARK: - Initializing a Result
    
    /// Optional initializer, per https://developer.apple.com/swift/blog/?id=37
    init?(json: [String: Any])
    {
        guard let type = json["type"] as? String,
            let id = json["id"] as? String,
            let slug = json["slug"] as? String,
            let rating = json["rating"] as? String,
            let bitly = json["bitly_url"] as? String,
            let embed = json["embed_url"] as? String,
            let sourceTLDAddress = json["source_tld"] as? String,
            let sourcePage = json["source_post_url"] as? String,
            let source = json["source"] as? String,
            let username = json["username"] as? String,
            let createTimestamp = json["create_datetime"] as? String,
            let createdAt = dateFormatter.date(from: createTimestamp),
            let updateTimestamp = json["update_datetime"] as? String,
            let tags = json["tags"] as? [String],
            let featuredTags = json["featured_tags"] as? [String],
            let renditions = json["images"] as? [String:[String:Any]]
            else
        {
            return nil
        }
        
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY-MM-dd hh:mm:ss")
        
        self.type = type
        self.identifier = id
        self.slug = slug
        
        // Attribution
        self.bitlyURL = URL(string: bitly)
        self.embedURL = URL(string: embed)
        self.source = URL(string: source)
        self.sourceTLD = URL(string: sourceTLDAddress)
        self.sourcePost = URL(string: sourcePage)
        
        // Search / Filter
        self.rating = Rating(rawValue:rating) ?? .unrated
        self.tags = tags
        self.featuredTags = featuredTags
        
        // Attribution
        self.username = username
        
        // Timestamps
        self.createTimestamp = createdAt
        self.updateTimestamp = dateFormatter.date(from: updateTimestamp)
        
        
        // Renditions
        var transformedRenditions: [RenditionDesignation : Rendition] = [:]
        
        for (key, json) in renditions
        {
            guard let designation = RenditionDesignation(rawValue: key) else
            {
                continue
            }
            
            guard let rendition = Rendition(with: designation, and: json) else
            {
                continue
            }
            
            transformedRenditions[designation] = rendition
        }
        
        self.renditions = transformedRenditions
        
        super.init()
    }
}
