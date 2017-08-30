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
public class GIF: NSObject {
    
    /// The type of result. Usually `gif`.
    public let type: String
    
    /// The GIF's identifier. Used to access the asset on GIPHY.com.
    public let identifier: String
    
    // MARK: - Renditions of the GIF
    
    public var renditions: [RenditionDesignation: Rendition]
    
    // MARK: - Accessing the Image on Giphy
    
    /// The GIPHY slug
    public let slug: String
    
    /// A URL to access the asset
    public var url: URL? {
        let address = "https://giphy.com/gifs/\(self.slug)"
        return URL(string: address)
    }
    
    // MARK: - Sorting/Filtering the GIF
    
    // The rating of the asset.
    public var rating: Rating
    
    /// A list of tags assigned to the GIF
    public var tags: [String]?
    
    /// A list of featured tags assigned to the GIF.
    public var featuredTags: [String]?
    
    // MARK: - Sharing the GIF
    
    /// The Bit.ly URL for the gif.
    public var bitlyURL: URL?
    
    // MARK: - Embedding the GIF
    
    /// The URL used to embed in a webpage.
    public var embedURL: URL?
    
    // MARK: - Attributing a GIF
    
    /// The URL of the webpage on which this GIF was found.
    public var source: URL?
    
    /// The TLD of the website on which this GIF was found.
    public var sourceTLD: URL?
    
    /// The URL of the post in which this GIF was found.
    public var sourcePost: URL?
    
    /// The username associated with the GIF.
    public var username: String
    
    // MARK: - Determining the Age of the GIF
    
    /// A timestamp when the images was added to the Giphy database.
    public var createTimestamp: Date?
    
    /// A timestamp when the GIF was updated.
    public var updateTimestamp: Date?
    
    /// A timestamp when the GIF was updated.
    public var trendingTimestamp: Date?
    
    /// A timestamp of when the GIF was imported
    public var importTimestamp: Date?
    
    // MARK: - Unused Properties
    
    /// The Giphy Docs say this is unused.
    public var contentURL: String? = nil
    
    // MARK: - Initializing a Result
    
    /// Optional initializer, per https://developer.apple.com/swift/blog/?id=37
    public init?(with json: [String: Any])
    {
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY-MM-dd HH:mm:ss")
        
        guard let type = json["type"] as? String else
        {
            return nil
        }
        
        guard let id = json["id"] as? String else
        {
            return nil
        }
        
        guard let slug = json["slug"] as? String else
        {
            return nil
        }
        
        guard let rating = json["rating"] as? String else
        {
            return nil
        }
        
        guard let bitly = json["bitly_url"] as? String else
        {
            return nil
        }
        
        guard let embed = json["embed_url"] as? String else
        {
            return nil
        }
        
        guard let sourceTLDAddress = json["source_tld"] as? String else
        {
            return nil
        }
        
        guard let sourcePage = json["source_post_url"] as? String else
        {
            return nil
        }
        
        guard let source = json["source"] as? String else
        {
            return nil
        }
        
        guard let username = json["username"] as? String else
        {
            return nil
        }
        
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
        self.tags = json["tags"] as? [String]
        self.featuredTags = json["featured_tags"] as? [String]
        
        // Attribution
        self.username = username
        
        // Timestamps
        if let updateTimestamp = json["update_datetime"] as? String
        {
            self.updateTimestamp = dateFormatter.date(from: updateTimestamp)
        }
        
        if let createTimestamp = json["create_datetime"] as? String
        {
            self.createTimestamp = dateFormatter.date(from: createTimestamp)
        }
        
        if let trendingTimestamp = json["trending_datetime"] as? String
        {
            self.trendingTimestamp = dateFormatter.date(from: trendingTimestamp)
        }
        
        if let importTimestamp = json["import_datetime"] as? String
        {
            self.importTimestamp = dateFormatter.date(from: importTimestamp)
        }
        
        
        
        // Renditions
        var transformedRenditions: [RenditionDesignation : Rendition] = [:]
        
        if let renditions = json["images"] as? [String: [String:String]]
        {
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
        }
        self.renditions = transformedRenditions
        
        super.init()
    }
}
