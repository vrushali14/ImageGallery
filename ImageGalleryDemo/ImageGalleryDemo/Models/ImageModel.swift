//
//  ImageModel.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 21/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct ImageModel: Codable {

    let link : String?
    let type : String?
    let id : String?
    let title : String?
    let imageDescription : String?
    let datetime : Double?
    
    enum CodingKeys: String, CodingKey {
        case link = "link"
        case type = "type"
        case id = "id"
        case title
        case imageDescription = "description"
        case datetime = "datetime"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        imageDescription = try values.decodeIfPresent(String.self, forKey: .imageDescription)
        datetime = try values.decodeIfPresent(Double.self, forKey: .datetime)
    }
    
}
 
