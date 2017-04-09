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
    
    static let dealsSection = 0
    static let distanceSection = 1
    static let sortSection = 2
    static let restaurantCategoriesSection = 3
    
    @IBOutlet weak var filterTableView: UITableView!
    
    var filterCreteria : SearchCriteria!
    let categories = Business.getRestaurantCategories()
    
    let offeringModel = [FilterDealsModel(name: "Offering a Deal", isOn: false)]
    let sortByFilterModel = [
        FilterSortByModel(name: YelpSortMode.bestMatched.description, isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true),
        FilterSortByModel(name: YelpSortMode.highestRated.description, isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true),
        FilterSortByModel(name: YelpSortMode.distance.description, isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true)]
    
    let distanceFilterModel = [//FilterDistanceModel(name: "Auto", isOn: false, isExpanded: false, isExpandable: true, additionalRows: 4, isVisible: false),
        FilterDistanceModel(name: "Auto", isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true),
        FilterDistanceModel(name: "0.3 miles", isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true),
        FilterDistanceModel(name: "1 mile", isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true),
        FilterDistanceModel(name: "5 miles", isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true),
        FilterDistanceModel(name: "20 miles", isOn: false, isExpanded: false, isExpandable: false, additionalRows: 4, isVisible: true)]
    
    var filterCategories:[Int:[Any]]!
    
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.dataSource = self
        filterTableView.delegate = self
        
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.estimatedRowHeight = 50
        
        self.filterCreteria = SearchCriteria(term: "", sort: .bestMatched, categories: [], deals: false)
        
        var restaurantCategories:[FilterCategoriesModel] = []
        
        for category in categories {
            restaurantCategories.append(FilterCategoriesModel(name: category.title, isOn: false))
        }
        
        filterCategories = [FilterViewController.dealsSection: self.offeringModel, FilterViewController.distanceSection: distanceFilterModel, FilterViewController.sortSection:sortByFilterModel, FilterViewController.restaurantCategoriesSection: restaurantCategories]
        
        
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
    
    func getYelpSortEnum(descriptionString: String) -> YelpSortMode {
        switch descriptionString {
        case "Best Matched":
            return YelpSortMode.bestMatched
        case "Distance":
            return YelpSortMode.distance
        case "HighestRated":
            return YelpSortMode.highestRated
        default:
            return YelpSortMode.bestMatched
        }
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
        } else if indexPath.section == FilterViewController.sortSection {
            //filterCreteria.sort = filterModel.
            
        }
        
        var categories = self.filterCategories?[indexPath.section]! as? [FilterModel]
        categories?[indexPath.row] = filterModel
        self.filterCategories?[indexPath.section] = categories
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case FilterViewController.dealsSection:
            return "Deals"
        case FilterViewController.restaurantCategoriesSection:
            return "Categories"
        case FilterViewController.distanceSection:
            return "Distance"
        case FilterViewController.sortSection:
            return "Sort"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case FilterViewController.sortSection:
            
            let sectionArray = (filterCategories[indexPath.section]! as? [FilterModel])?.filter { (filterModel) -> Bool in
                return filterModel.isVisible
            }
            
            guard let sectionArrayNotNil = sectionArray else {
                return
            }
            
            var selectedFilter:FilterModel = sectionArrayNotNil[indexPath.row]
            selectedFilter.isOn = true
            
            
            filterCreteria.sort = self.getYelpSortEnum(descriptionString: selectedFilter.name)
            
            var sectionCopyArray:[FilterModel] = []
            
            
            for filter in sectionArrayNotNil {
                var currentFilter = filter
                currentFilter.isOn = false
                sectionCopyArray.append(currentFilter)
            }
            
            sectionCopyArray[indexPath.row] = selectedFilter
            
            filterCategories[indexPath.section] = sectionCopyArray
            let sectionIndex = IndexSet(integer: indexPath.section)
            
            tableView.reloadSections(sectionIndex, with: .none)
            
        default:
            return
        }
    }
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     if let selectedFilter = filterCategories[indexPath.section]?[indexPath.row] as? FilterModel {
     // Check if Cell is expandable
     if selectedFilter.isExpandable {
     print("this is an expandable cell")
     var shouldExpandAndShowSubRows = false
     
     // If its not expda
     if (selectedFilter.isExpanded == false) {
     shouldExpandAndShowSubRows = true
     }
     
     // Set to expanded
     var selectedCopyFilter = selectedFilter
     selectedCopyFilter.isExpanded = shouldExpandAndShowSubRows
     filterCategories[indexPath.section]?[indexPath.row] = selectedCopyFilter
     
     // Set all other cells for the section to visible
     }
     }
     
     */
    
    
    //        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
    //
    //        if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpandable"] as! Bool == true {
    //            var shouldExpandAndShowSubRows = false
    //            if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] as! Bool == false {
    //                shouldExpandAndShowSubRows = true
    //            }
    //
    //            cellDescriptors[indexPath.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
    //
    //            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow]["additionalRows"] as! Int)) {
    //                cellDescriptors[indexPath.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
    //            }
    //        }
    //
    //        getIndicesOfVisibleRows()
    //        tblExpandable.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    
    //    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case FilterViewController.dealsSection, FilterViewController.restaurantCategoriesSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            let sectionArray = (filterCategories[indexPath.section]! as? [FilterModel])?.filter { (filterModel) -> Bool in
                return filterModel.isVisible
            }
            
            cell.model = sectionArray![indexPath.row]
            cell.delegate = self
            return cell
            
        case FilterViewController.distanceSection, FilterViewController.sortSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTableViewCell", for: indexPath) as! RadioTableViewCell
            let sectionArray = (filterCategories[indexPath.section]! as? [FilterModel])?.filter { (filterModel) -> Bool in
                return filterModel.isVisible
            }
            
            cell.model = sectionArray![indexPath.row]
            //cell.delegate = self
            return cell
        default:
            fatalError()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionArray = (filterCategories[section]! as? [FilterModel])?.filter { (filterModel) -> Bool in
            return filterModel.isVisible
        }
        return sectionArray?.count ?? 0
    }
}
