//
//  GiphyViewController.swift
//  GiphyTest
//
//  Created by Alexander on 13/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Reachability
import FLAnimatedImage
import SDWebImage

class GiphyViewController: UIViewController {
    //! Collection view with images
    @IBOutlet weak var collectionView: UICollectionView!
    
    //! Search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    //! Internet connection status button
    @IBOutlet weak var navBarButton: UIBarButtonItem!
    
    //! Search results and observer
    var resultsNT:NotificationToken? { didSet { oldValue?.invalidate() }}
    var search:GiphySearch? {
        didSet {
            resultsNT = search?.items.observe({[weak self] (changes) in
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates({
                }, completion: { (finished) in
                    //! If images height is too small, could be more than 20 images on screen.
                    //! This will load next padge to fill screen
                    self?.checkNextPage()
                })
            })
        }
    }
    
    //! Network status
    var reachability = Reachability()
    
    //! Threshold search timer
    var searchTimer:Timer?
    
    //! Default search string (for deep link support)
    var defaultSearchKey:String?
    
    deinit {
        print("deinit " + String(describing: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //! Custom layout delegate
        if let collectionViewLayout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout {
            collectionViewLayout.delegate = self
        }
        
        //! Start network listner
        startListningReachability()
        
        //! Search object contains search results and logic
        search = GiphySearch.safeFindOrCreateObject(primaryKey: "search")
        //! Clear on start
        search?.clear()
        
        //! Start default search if necessary
        if let searchKey = defaultSearchKey {
            searchBar.text = searchKey
            startSearchTimer()
        }
    }
}

//! Search timer and logic
extension GiphyViewController {
    
    func cancelSearchTimer() {
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    //! TODO: Move time interval to Constants
    func startSearchTimer() {
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self] (timer) in
            self?.startSearch()
        })
    }
    
    func startSearch() {
        //! Depend on connection status search online or in cache
        if reachability?.connection == Reachability.Connection.none {
            search?.find(searchKey: searchBar.text ?? "", onlyFromCache: true)
        } else {
            search?.find(searchKey: searchBar.text ?? "")
        }
    }
}

//! Reachability listner and logic
extension GiphyViewController {
    func startListningReachability() {
        
        reachability?.whenReachable = {[weak self] reachability in
            print("Reachable via \(reachability.connection.description)")
            self?.startSearchTimer()
            self?.updateNetworkStatusUI()
        }
        
        reachability?.whenUnreachable = {[weak self] _ in
            print("Not reachable")
            self?.startSearchTimer()
            self?.updateNetworkStatusUI()
        }
        
        do {
            try reachability?.startNotifier()
        } catch let error {
            print(error)
        }
    }
    
    
    //! TODO: Add locolized strings
    //! Update nav bar button
    func updateNetworkStatusUI() {
        if reachability?.connection == Reachability.Connection.none {
            navBarButton.title = "Off Line"
        } else {
            navBarButton.title = "On Line"
        }
    }
}

// MARK: - Collection DataSource
extension GiphyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiphyImageCell", for: indexPath) as! GiphyImageCell
        
        //! Image URL
        let item = search!.items[indexPath.row]
        let url = URL(string: item.url)

        //! Load image
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imageView?.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkNextPage()
    }
    
    //! Load next page if necessary
    func checkNextPage() {
        if collectionView.contentOffset.y + collectionView.bounds.height + 300 > collectionView.contentSize.height {
            search?.loadMore()
        }
    }
}

// MARK: - LayoutDelegate
extension GiphyViewController: SwiftyGiphyGridLayoutDelegate {
    
    public func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        
        //! Get image ratio for item
        let item = search!.items[indexPath.row]
        var ratio:Float = 1
        if item.heigth > 0 {
            ratio = item.width / item.heigth
        }
        
        //! Image height base on ratio
        return withWidth / CGFloat(ratio)
    }
}

// MARK: - UISearchBarDelegate
extension GiphyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        //! Restart search timer
        cancelSearchTimer()
        startSearchTimer()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

