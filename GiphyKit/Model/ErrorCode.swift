//
//  ErrorCode.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/29/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation


/// An enum representing different error conditions that the GiphyAPIClient.swift.
///
/// - noDataInRespone: The URLSessionTask called the handler block with no data.
/// - failedToUnwrapJSONFromDataResponse: The data wasn't able to be understood by `NSJSONSerialization`.
public enum ErrorCode: Int
{
    case noDataInResponse
    case failedToUnwrapJSONFromDataResponse
    case failedToProcessGIF
    case couldNotGenerateEndpoint
}
