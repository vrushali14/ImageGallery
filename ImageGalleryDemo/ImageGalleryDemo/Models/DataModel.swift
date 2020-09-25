//
//  DataModel.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 24/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct DataModel : Codable {

        let images : [ImageModel]?
        let title: String?
    
        enum CodingKeys: String, CodingKey {
            case images = "images"
            case title = "title"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            images = try values.decodeIfPresent([ImageModel].self, forKey: .images)
            title = try values.decodeIfPresent(String.self, forKey: .title)
        }

}
