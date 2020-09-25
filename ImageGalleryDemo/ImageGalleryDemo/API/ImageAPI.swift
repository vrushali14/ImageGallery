//
//  ImageAPI.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 20/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

protocol ImageAPIDelegate : class  {
    
    func recievedImages(result: ResponseModel)
    func requestFailed(message: String)
    
}

var clientId = "c20a12a71fad168"
var baseURL = "https://api.imgur.com/3/gallery/"


class ImageAPI : NSObject {
    
    weak var imageAPIDelegate : ImageAPIDelegate?
    
    func getGalleryImages() {
        
        let session = URLSession.shared
        let requestURL = URL(string:"\(baseURL)hot/viral/day/1")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("Client-ID \(clientId)", forHTTPHeaderField:"Authorization")
        

        //Call API and store response
        let dataTask = session.dataTask(with:request as URLRequest, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data else {
                print(error as Any)
                return
            }
             
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
            
            do {
                
                let jsonDecoder: JSONDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(ResponseModel.self, from: data)
                print(result)
                if self.imageAPIDelegate != nil {
                    self.imageAPIDelegate?.recievedImages(result: result)
                }
                
            } catch {
                
                print(error.localizedDescription)
                if self.imageAPIDelegate != nil {
                    self.imageAPIDelegate?.requestFailed(message: error.localizedDescription)
                }
            }
            
        })
        dataTask.resume()
    }
    
    func searchImageByTag(tag: String, page: String) {
        
        let session = URLSession.shared
        let requestURL = URL(string:"\(baseURL)search/hot/viral/\(page)?q=\(tag)")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("Client-ID \(clientId)", forHTTPHeaderField:"Authorization")
        

        //Call API and store response
        let dataTask = session.dataTask(with:request as URLRequest, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data else {
                print(error as Any)
                return
            }
             
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
            
            do {
                
                let jsonDecoder: JSONDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(ResponseModel.self, from: data)
                print(result)
                if self.imageAPIDelegate != nil {
                    self.imageAPIDelegate?.recievedImages(result: result)
                }
                
            } catch {
                
                print(error.localizedDescription)
                if self.imageAPIDelegate != nil {
                    self.imageAPIDelegate?.requestFailed(message: error.localizedDescription)
                }
            }
            
        })
        dataTask.resume()
    }
}
