//
//  ViewController.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 20/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImageAPIDelegate, ImageDownloadedTaskDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    var imagelinkArray : [ImageModel] = []
    var dataArray : [DataModel] = []
    var selectedImage : ImageModel!
    var selectedData : DataModel!
    
    var pageNumber : Int!
    var searchText : String = ""
    
    var imageTasks = [Int: ImageDownloadTask]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Gallery"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "fav-white"), style: .plain, target: self, action: #selector(rightBarButtonTapped))

        
        self.getGalleryImages()
    }
    
    //MARK:-
    @objc func rightBarButtonTapped () {
        
        self.performSegue(withIdentifier: "FavouritesSegue", sender: self)
    }

    
    func getImageDetails() {
        
        for data in dataArray {
            
            let matchedData = data.images?.filter({ (image) -> Bool in
                return image.id == selectedImage.id
            })
            
            if (matchedData?.count ?? 0) > 0 {
                self.selectedData = data
                break
            }
        }
        
    }

    // Load more
    func loadMoreData() {
        self.pageNumber += 1
        self.callSearchAPI()
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ImageDetailSegue" {
            let destinationVC = segue.destination as! ImageDetailViewController
            destinationVC.selectedImage = self.selectedImage
            destinationVC.selectedData = self.selectedData
        } else {
            
        }
        
    }
    
    //MARK:- API Calls
    func getGalleryImages() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        let imageAPI = ImageAPI()
        imageAPI.imageAPIDelegate = self as ImageAPIDelegate
        imageAPI.getGalleryImages()
    }
    
    func callSearchAPI () {
        
        let imageAPI = ImageAPI()
        imageAPI.imageAPIDelegate = self as ImageAPIDelegate
        imageAPI.searchImageByTag(tag: self.searchText, page: "\(self.pageNumber!)")
    }
    
    
    //MARK:- API Delegate
    func recievedImages(result: ResponseModel) {
        
        
        var startIndex = 0
        if self.searchText != "" { //search API
            if self.pageNumber == 1 {
                dataArray = result.data ?? []
                startIndex = 0
            } else {
                startIndex = dataArray.count
                dataArray.append(contentsOf: result.data ?? [])
                
            }
        } else {
            //gallery API
            dataArray = result.data ?? []
            startIndex = 0
        }
        
        let imageArray = dataArray.map { ($0.images ?? []) }
        let linkArray = imageArray.flatMap { $0 }
        imagelinkArray = linkArray.filter { ($0.type?.hasPrefix("image"))! }
        print(imagelinkArray)
        self.setupImageTasks(totalImages: imagelinkArray.count, startIndex:startIndex)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.collectionView.reloadData()
        }
        
        
    }
    
    func requestFailed(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    //MARK:- Image downloading
    private func setupImageTasks(totalImages: Int, startIndex: Int) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        for i in startIndex..<totalImages {
            let image = imagelinkArray[i]
            let url = URL(string: image.link ?? "")!
            let task = ImageDownloadTask(index: i, url: url, session: session, delegate: self)
            imageTasks[i] = task
        }
    }
    
    func imageDownloaded(index: Int) {
        self.collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])

    }
    
    
    // MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.imagelinkArray.count
        }

        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            imageTasks[indexPath.row]?.resume()
        }
        
        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            imageTasks[indexPath.row]?.pause()
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let imageViewCell: ImageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
            
            let image = imageTasks[indexPath.row]?.image
            imageViewCell.setCellImage(image: image)
            
            //Load more data for search functionality
            if self.searchText != "" {
                if indexPath.item == imagelinkArray.count - 1 {
                    self.loadMoreData()
                }
            }
            
            return imageViewCell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            self.selectedImage = self.imagelinkArray[indexPath.item]
            self.getImageDetails()
            self.performSegue(withIdentifier: "ImageDetailSegue", sender: self)
            
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 3 - 50 / 3
        print(width)
        return CGSize(width: width, height: width)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    //MARK:- Search
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
     
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
             
        if (searchBar.text!.isEmpty) {
            self.searchText = ""
            self.pageNumber = 1
        } else {
            self.pageNumber = 1
            self.searchText = searchBar.text!
            self.callSearchAPI()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.endEditing(true)
        self.searchText = ""
        self.pageNumber = 1
        self.getGalleryImages()
    }
}

