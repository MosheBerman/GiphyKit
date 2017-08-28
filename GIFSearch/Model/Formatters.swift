//
//  Formatters.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/28/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation

// We create a single instance of the formatters we need, 
// since creating them is relatively expensive (in terms of time.)
internal let dateFormatter = DateFormatter()
internal let numberFormatter = NumberFormatter()
