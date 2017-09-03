//
//  DashboardViewController+Search.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/3/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

extension DashboardViewController : UISearchBarDelegate
{
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {    
        self.viewModel.searchTerm = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchTerm = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
