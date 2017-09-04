//
//  LanguageCode.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/29/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation


/// Represents the languages that the API supports. 
/// The doumentation states that the format is 
/// 2-letter ISO 639-1 language code. Listed in the order 
/// that these appear on the Giphy website.
///
/// Cool trick: I copied this list of languages from Giphy's
/// documentation and used Regexr to convert to case statements
/// for enums, using Regexr's "List" tool: http://regexr.com/3gl4t
///
/// - English
/// - Spanish
/// - Portuguese
/// - Indonesian
/// - French
/// - Arabic
/// - Turkish
/// - Thai
/// - Vietnamese
/// - German
/// - Italian
/// - Japanese
/// - Russian
/// - Korean
/// - Polish
/// - Dutch
/// - Romanian
/// - Hungarian
/// - Swedish
/// - Czech
/// - Hindi
/// - Bengali
/// - Danish
/// - Farsi
/// - Filipino
/// - Finnish
/// - Hebrew
/// - Malay
/// - Norwegian
/// - Ukrainian
public enum LanguageCode: String
{
    case english = "en"
    case spanish = "es"
    case portuguese = "pt"
    case indonesian = "id"
    case french = "fr"
    case arabic = "ar"
    case turkish = "tr"
    case thai = "th"
    case vietnamese = "vi"
    case german = "de"
    case italian = "it"
    case japanese = "ja"
    case russian = "ru"
    case korean = "ko"
    case polish = "pl"
    case dutch = "nl"
    case romanian = "ro"
    case hungarian = "hu"
    case swedish = "sv"
    case czech = "cs"
    case hindi = "hi"
    case bengali = "bn"
    case danish = "da"
    case farsi = "fa"
    case filipino = "tl"
    case finnish = "fi"
    case hebrew = "iw"
    case malay = "ms"
    case norwegian = "no"
    case ukrainian = "uk"
    

}
