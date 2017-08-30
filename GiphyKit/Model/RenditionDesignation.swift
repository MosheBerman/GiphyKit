//
//  RenditionDesignation.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation


/// The different kinds of renditions offered by GIPHY.
///
/// - fixedHeight - Height set to 200px. Good for mobile use.
/// - fixedHeightStill - Static preview image for fixed_height
/// - fixedHeightDownsampled - Height set to 200px. Reduced to 6 frames to minimize file size to the lowest. Works well for unlimited scroll on mobile and as animated previews. See GIPHY.com on mobile web as an example.
/// - fixedWidth - Width set to 200px. Good for mobile use.
/// - fixedWidthStill - Static preview image for fixed_width
/// - fixedWidthDownsampled - Width set to 200px. Reduced to 6 frames. Works well for unlimited scroll on mobile and as animated previews.
/// - fixedHeightSmall - Height set to 100px. Good for mobile keyboards.
/// - fixedHeightSmallStill - Static preview image for fixed_height_small
/// - fixedWidthSmall - Width set to 100px. Good for mobile keyboards
/// - fixedWidthSmallStill - Static preview image for fixed_width_small
/// - preview - File size under 50kb. Duration may be truncated to meet file size requirements. Good for thumbnails and previews.
/// - previewGIF - The preview as a GIF.
/// - previewWebP - The preview in WebP format.
/// - downsizedSmall - File size under 200kb.
/// - downsized - File size under 2mb.
/// - downsizedMedium - File size under 5mb.
/// - downsizedLarge - File size under 8mb.
/// - downsizedStill - Static preview image for downsized
/// - original - Original file size and file dimensions. Good for desktop use.
/// - originalMP4 - The original, encoded as mp4.
/// - originalStill - Preview image for original
/// - looping - Duration set to loop for 15 seconds. Only recommended for this exact use case.
public enum RenditionDesignation: String {
    case fixedHeight = "fixed_height"
    case fixedHeightStill = "fixed_height_still"
    case fixedHeightDownsampled = "fixed_height_downsampled"
    case fixedWidth = "fixed_width"
    case fixedWidthStill = "fixed_width_still"
    case fixedWidthDownsampled = "fixed_width_downsampled"
    case fixedHeightSmall = "fixed_height_small"
    case fixedHeightSmallStill = "fixed_height_small_still"
    case fixedWidthSmall = "fixed_width_small"
    case fixedWidthSmallStill = "fixed_width_small_still"
    case preview = "preview"
    case previewGIF = "preview_gif"
    case previewWebP = "preview_webp"
    case downsizedSmall = "downsized_small"
    case downsizedMedium = "downsized_medium"
    case downsizedLarge = "downsized_large"
    case downsizedStill = "downsized_still"
    case original = "original"
    case originalStill = "original_still"
    case originalMP4 = "original_mp4"
    case looping = "looping"
    
}
