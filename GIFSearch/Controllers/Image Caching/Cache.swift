//
//  Cache.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/30/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// This class caches data objects by URL so we can access them later.
class Cache: NSObject {

    /// An in memory cache.
    private var inMemoryCache: [URL: Data] = [:]
    private var diskCache: [URL: URL] = [:]
    
    // MARK: - Accessing Media
    
    /// Fetches a data object and returns it via a completion block.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch
    ///   - completion: A completion handler to access and utilize the data.
    func data(at url: URL, with completion:@escaping (_ data: Data?, _ source: CacheSource?)->Void)
    {
        let key = url
        
        if let inMemory = self.inMemoryCache[key]
        {
            completion(inMemory, .memory)
        }
        else if let diskURL = self.diskCache[key]
        {
            // Fetch from disk, and call the completion when we're done.
            self.fetch(mediaAt: diskURL, from: .disk) { [weak self] (data: Data?) in
                
                // Don't always return here, because disk-cache misses 
                // should be ignored in favor of hitting the network first.
                if let data = data
                {
                    completion(data, .disk)
                }
                
                // If  we don't have data on disk, try the network.
                else if let strongSelf = self
                {
                    strongSelf.fetch(mediaAt: url, from: .network) { (data: Data?) in
                        completion(data, .network)
                    }
                }
            }
        }
        else
        {
            // Fetch from disk, and call the completion when we're done.
            self.fetch(mediaAt: url, from: .network) {  (data: Data?) in
                completion(data, .network)
            }
        }
    }
    
    // MARK: - Accessing the Network
    
    /// Downloads a block of data.
    ///
    /// - Parameters:
    ///   - url: A URL pointing to the data.
    ///   - completion: A completion handler to retrieve the data.
    private func fetch(mediaAt url: URL, from source: CacheSource = .network, with completion:@escaping (Data?)->Void)
    {
        let urlSessionTask = URLSession.shared.dataTask(with: url) { [weak self] (data:Data?, response:URLResponse?, error: Error?) in
            completion(data)
            
            self?.inMemoryCache[url] = data
        }
        
        urlSessionTask.resume()
    }
    
    // MARK: -
    
    // MARK: - Manually Purging the Cache
    
    /// Manually purge the cache, for handling low-memory conditions
    func purge()
    {
        // CONSIDER: Do we want to write to disk here?
        self.inMemoryCache.removeAll()
        self.diskCache.removeAll()
    }
}
