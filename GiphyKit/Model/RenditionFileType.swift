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
/// - gif: The GIF format. See https://en.wikipedia.org/wiki/GIF for more.
/// - mp4: The MP4 file format. See https://en.wikipedia.org/wiki/MPEG-4_Part_14 for more.
/// - webp: A file format by Google. See https://developers.google.com/speed/webp/ for more.
public enum RenditionFileType: String {
    case gif = "gif"
    case mp4 = "mp4"
    case webp = "webp"
}

