//
//  ViewController.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/5/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class BusinessSearchViewController: UIViewController,UISearchBarDelegate {
    
    var businesses: [Business] = []
    
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        doSearch(searchTerm: "Thai")
        
        self.searchTableView.rowHeight = UITableViewAutomaticDimension
        self.searchTableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        
        let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")
        self.navigationController?.present(targetVC!, animated: true, completion: nil)
            
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func doSearch(searchTerm: String) {
        Business.searchWithTerm(term:searchTerm , completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses!
            self.searchTableView.reloadData()
        }
        )
    }
    
}

extension BusinessSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.business = self.businesses[indexPath.row]
        
        return cell

    }
}

extension BusinessSearchViewController {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchQueryString = searchBar.text {
            doSearch(searchTerm: searchQueryString)
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//    }
    
}

