//
//  ImageDetailViewController.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 23/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var favouriteButton : UIButton!
    
    var selectedImage : ImageModel!
    var selectedData : DataModel!
    var isFavourite : Bool! = false
    
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        self.UIStyling()
        self.setData()
    }
    
    func UIStyling () {
        
        self.favouriteButton.layer.cornerRadius = 12.0
    }
    
    func setData () {
        self.titleLabel.text = selectedData.title
        self.imageView.load(url: URL(string:selectedImage.link ?? "")!)
        self.descriptionLabel.text = selectedImage.imageDescription
        self.displayDate()
    }
    
    func displayDate () {
        
        let date = Date(timeIntervalSince1970: selectedImage?.datetime ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        self.dateLabel.text = localDate
    }
    
    
    // MARK:- Action Events
    @IBAction func favouriteButtonTapped (sender : UIButton) {
        
        if isFavourite == true {
            self.favouriteButton.setImage(nil , for: .normal)
            self.favouriteButton.setTitle("Add to favourites", for: .normal)
            self.favouriteButton.backgroundColor = UIColor(red: 227/255, green: 44/255, blue: 52/255, alpha: 1.0)
            isFavourite = false
            
        } else {
            self.favouriteButton.setImage(UIImage(named: "fav-red.png") , for: .normal)
            self.favouriteButton.setTitle("", for: .normal)
            self.favouriteButton.backgroundColor = UIColor.white
            isFavourite = true
        }
    }
    
    

}
