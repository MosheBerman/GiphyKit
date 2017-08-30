//
//  DashboardViewController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/27/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel = DashboardViewModel()
    private let speechController = SpeechController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureViewModel()
        self.configureCollectionView()
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
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
                strongSelf.collectionView.reloadData()
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
        
        if let gif = self.viewModel.gif(for: indexPath)
        {
            
        }
        
        return cell
    }
}

