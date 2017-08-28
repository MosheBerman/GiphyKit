//
//  RenditionFile.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// These describe the file formats offered by the renditions API.
///
/// - gif: The GIF format.
/// - mp4: The MP4 file format.
/// - webp: The webp file format.
enum RenditionFileType {
    case gif
    case mp4
    case webp
}
