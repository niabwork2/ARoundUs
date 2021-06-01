//
//  data.swift
//  ARoundUs
//
//  Created by niab on May/31/21.
//

import Foundation
struct GetMemes: Codable {
    
    var data: DataAPI
    
    struct DataAPI: Codable {
        
        var memes: [memes]
    }
}

