//
//  FilterViewController.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/6/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func searchForUdpatedFilter(searchCriteria: SearchCriteria?)
}

class FilterViewController: UIViewController {

    var filterCreteria : SearchCriteria!
    
    static let dealsSection = 0
    static let restaurantCategoriesSection = 1
    
    @IBOutlet weak var filterTableView: UITableView!
    let categories = Business.getRestaurantCategories()
    let offeringModel = [FilterModel(name: "Offering a Deal", isOn: false)]
    
    //let cuisines = [FilterModel(name: "Afgan", isOn: false), FilterModel(name: "African", isOn: false), FilterModel(name: "American", isOn: false)]
    
    var filterCategories:[Int:[Any]]!
    weak var delegate: FilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.estimatedRowHeight = 50

        self.filterCreteria = SearchCriteria(term: "", sort: .bestMatched, categories: [], deals: false)
        
        var restaurantCategories:[FilterModel] = []
        
        for category in categories {
            restaurantCategories.append(FilterModel(name: category.title, isOn: false))
        }
        
        filterCategories = [FilterViewController.dealsSection: self.offeringModel, FilterViewController.restaurantCategoriesSection: restaurantCategories]
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        print("Cancel Tapped")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func searchTapped(_ sender: Any) {
        //print("Save Tapped")
        
        let restaurantCategories = self.filterCategories?[FilterViewController.restaurantCategoriesSection] as? [FilterModel]
        
        let onCategories = restaurantCategories?.filter({ (filterModel) -> Bool in
            return filterModel.isOn
        })
        
        for category in onCategories ?? [FilterModel](){
            print(category.name)
            let selectedCategories = categories.filter({ (restuarantCategory) -> Bool in
                return category.name == restuarantCategory.title
            })
            
            filterCreteria.categories.append(selectedCategories.first!.alias)
        }
        
        delegate?.searchForUdpatedFilter(searchCriteria: filterCreteria)
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterViewController : SwitchCellDelegate {
    func yelpCategoryValueChanged(cell:SwitchCell, filterModel: FilterModel) {
        
        var indexPath = self.filterTableView.indexPath(for: cell)!
        
        if indexPath.section == FilterViewController.dealsSection {
            filterCreteria.deals = filterModel.isOn
        }
        
        var categories = self.filterCategories?[indexPath.section]! as? [FilterModel]
        categories?[indexPath.row] = filterModel
        self.filterCategories?[indexPath.section] = categories
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        let sectionArray = filterCategories[indexPath.section] as! [FilterModel]
        cell.model = sectionArray[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionArray = filterCategories[section]! as [Any]
        return sectionArray.count
    }
}
