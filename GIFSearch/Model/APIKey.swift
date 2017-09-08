//
//  APIKey.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/**
 
 There are three steps to getting this working:
 
 1. Get an API key from https://developers.giphy.com/dashboard/
 
 2. Before saving it here, you want to tell git to
    ignore future changes to this file, so you don't commit
    your API key back to your repository.
 
    Do that with this command:
 
    > cd /path/to/GiphyKit/
    > git update-index --assume-unchanged ./GIFSearch/Model/APIKey.swift
 
    Read more about how this works here: https://stackoverflow.com/a/18277622/224988
 
 3. Replace the placeholder token with your API key. 
 
 You should be all set!
 
 */
let APIKey = "<#Giphy API Key#>"

