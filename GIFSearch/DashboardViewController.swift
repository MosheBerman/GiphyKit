//
//  DashboardViewController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    internal let viewModel = DashboardViewModel()
    private let speechController = SpeechController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureViewModel()
        self.configureCollectionView()
        self.configureSearchBar()
        self.viewModel.setNeedsRefresh()
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
        self.collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = CGSize(width: 144.0, height: 144.0)
        
        self.collectionView.contentInset = .zero
        self.collectionView.collectionViewLayout = layout
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    // MARK: - 
    
    func configureSearchBar()
    {
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("Type to Search Giphy", comment: "A string with search instructions.")
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
                
                strongSelf.collectionView.performBatchUpdates({
                    let itemIndexSet = IndexSet(integer: 0)
                    strongSelf.collectionView.reloadSections(itemIndexSet)
                })
                
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
        
        if let hashtags = self.viewModel.hashtags(for: indexPath)
        {
            cell.hashtags.text = hashtags
            cell.hashtags.alpha = 1.0
        }
        else
        {
            cell.hashtags.alpha = 0.0
        }
        
        let _ = self.viewModel.gif(for: indexPath) { [weak collectionView = collectionView](data: Data?, originalIndexPath: IndexPath) in
            DispatchQueue.main.async {
                if indexPath == originalIndexPath
                {
                    if let cell = collectionView?.cellForItem(at: originalIndexPath) as? GIFCollectionViewCell
                    {
                        if let data = data
                        {
                            cell.staticImageView.image = UIImage.gif(from: data)
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

