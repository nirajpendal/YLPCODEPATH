//
//  FilterViewController.swift
//  YLPCodePath
//
//  Created by Niraj Pendal on 4/6/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    
    let offeringCategories = [YelpCategory(name: "Offering a Deal", isOn: false)]
    
    let cuisines = [YelpCategory(name: "Afgan", isOn: false), YelpCategory(name: "African", isOn: false), YelpCategory(name: "American", isOn: false)]
    
    var filterCategories:[Int:[Any]]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.estimatedRowHeight = 50

        filterCategories = [0: self.offeringCategories, 1: self.cuisines]
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped(_:)))
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelTapped(_ sender: Any) {
        print("Cancel Tapped")
    }
    
    func saveTapped(_ sender: Any) {
        print("Save Tapped")
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
    func yelpCategoryValueChanged(cell:SwitchCell, yelpCategory: YelpCategory) {
        
        
        
        let indexPath = self.filterTableView.indexPath(for: cell)!
        
        var categories = self.filterCategories?[indexPath.section]! as? [YelpCategory]
        categories?[indexPath.row] = yelpCategory
        
        print("Before " )
        print( self.filterCategories?[indexPath.section]! ?? "test")
        
        print("From Cell " + yelpCategory.name + yelpCategory.isOn.description )
        
        self.filterCategories?[indexPath.section] = categories
        
        print("After " )
        print(self.filterCategories?[indexPath.section]!.description ?? "test" )
        
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        let sectionArray = filterCategories[indexPath.section] as! [YelpCategory]
        cell.category = sectionArray[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionArray = filterCategories[section]! as [Any]
        return sectionArray.count
    }
}
