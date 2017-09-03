//
//  gcd.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/3/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

/// Use Euclid's algorithm, describe here: https://en.wikipedia.org/wiki/Greatest_common_divisor#Other_methods
/// 
/// Note that we account for absolute values
/// by dropping negative signs, which is allowed.
///
/// See this page for more: https://math.stackexchange.com/questions/37806/extended-euclidean-algorithm-with-negative-numbers
///
/// - Parameters:
///   - a: The larger number.
///   - b: The smaller number.
/// - Returns: The greatest common divisor.
public func gcd(a: Int, b: Int) -> Int
{
    if b > a
    {
        return gcd(a: b, b: a)
    }
    
    if b == 0
    {
        return a
    }
    
    let remainder = abs(a) % abs(b)
    
    return gcd(a: abs(b), b: abs(remainder))
}
