//
//  DashboardViewController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    internal let viewModel = DashboardViewModel()
    private let speechController = SpeechController()
    private let ratingController = RatingController()
    private let languageController = LanguageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureViewModel()
        self.configureCollectionView()
        self.configureSearchBar()
        self.viewModel.setNeedsRefresh()
        self.configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuring the Collection View
    func configureCollectionView()
    {
        self.configure(collectionView: self.collectionView)
        self.configure(collectionView: self.backgroundCollectionView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    func configure(collectionView: UICollectionView)
    {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = GiphyLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let height = collectionView.bounds.size.height / 3.0
        let width = collectionView.bounds.size.width / 3.0
        
        layout.itemSize = CGSize(width: width, height: height)
        collectionView.contentInset = .zero
        
        collectionView.collectionViewLayout = layout
        
    }
    
    // MARK: - Configuring the Search Bar
    
    /// Set up the search bar.
    func configureSearchBar()
    {
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("Type to Search Giphy", comment: "A string with search instructions.")
    }
    
    // MARK: - Configuring UIBarButtonItems
    
    func configureButtons()
    {
        let speakButton = UIBarButtonItem(title: "💬🎧", style: .plain, target: self, action: #selector(speak))
        self.navigationItem.rightBarButtonItem = speakButton
        
        let settingsButton = UIBarButtonItem(title: "⚙️", style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.leftBarButtonItems = [settingsButton]
    }
    
    // MARK: - Configuring Our Response to ViewModel Updates
    
    /// Sets a refresh handler that is executed whenever the
    /// ViewModel refreshes its data.
    func configureViewModel()
    {
        self.viewModel.refreshHandler = { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                
                strongSelf.title = strongSelf.viewModel.title
                
                strongSelf.collectionView.performBatchUpdates({
                    let itemIndexSet = IndexSet(integer: 0)
                    strongSelf.collectionView.reloadSections(itemIndexSet)
                }) { (complete: Bool) in
                    strongSelf.backgroundCollectionView.reloadData()
                }
                
                strongSelf.collectionView.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    // MARK: - Manually Refreshing
    
    func refresh()
    {
        self.collectionView.refreshControl?.beginRefreshing()
        self.viewModel.setNeedsRefresh()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.mosheberman.cell", for: indexPath) as! GIFCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! GIFCollectionViewCell 
        
        if collectionView == self.collectionView
        {
            if let hashtags = self.viewModel.hashtags(for: indexPath)
            {
                cell.hashtags.text = hashtags
                cell.hashtagsPanel.alpha = 1.0
            }
            else
            {
                cell.hashtagsPanel.alpha = 0.0
            }
        }
        
        let _ = self.viewModel.gif(for: indexPath) { (data: Data?, originalIndexPath: IndexPath) in
            DispatchQueue.main.async {
                if indexPath == originalIndexPath
                {
                    if let data = data
                    {
                        let image =  UIImage.gif(from: data)
                        if let cell = collectionView.cellForItem(at: originalIndexPath) as? GIFCollectionViewCell
                        {
                            
                            cell.staticImageView.image = image
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView
        {
            self.backgroundCollectionView.contentOffset = self.collectionView.contentOffset
        }
    }
    
    // MARK: - Speak
    
    /// This is a requirement 🙄
    func speak()
    {
        self.speechController.pronounce(text: "This app uses UICollectionView, NSURLSession, and Swift, to display trending images from Giphy.com. You can search using the search bar. Per the requirement, I am supposed to tell you how to pronounce GIF. There.")
    }
    
    // MARK: - Showing Settings

    /// Show the settings menu.
    /// For now, just skip to ratings.
    func showSettings()
    {
        self.showRatings()
    }
    
    func showRatings()
    {
        self.ratingController.apiClient = self.viewModel.apiClient
        
        let alertController = self.ratingController.alertController
        self.present(alertController, animated: true, completion: nil)
    }
    
}

