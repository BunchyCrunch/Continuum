//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Josh Sparks on 10/16/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
