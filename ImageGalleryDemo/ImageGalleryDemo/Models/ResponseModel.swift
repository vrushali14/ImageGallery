//
//  ResponseModel.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 24/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct ResponseModel : Codable {

        let data : [DataModel]?
        let status : Int?
        let success : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case status = "status"
                case success = "success"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([DataModel].self, forKey: .data)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
                success = try values.decodeIfPresent(Bool.self, forKey: .success)
        }

}
