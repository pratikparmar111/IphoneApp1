//
//  SeachPicViewController.swift
//  manageImages
//
//  Created by Pratik Anilkumar Parmar on 2/11/17.
//  Copyright © 2017 Pratik Anilkumar Parmar. All rights reserved.
//

import UIKit
import CoreData

enum selectedScope:Int {
    case Name = 0
    case Location = 1
    case Date = 2
}
// need for date converter to string
var dateFormat = DateFormatter();


class SeachPicViewController: UITableViewController,UISearchBarDelegate
{
    var initialDataArray:[PhotoLibraryDb] = [];// for intial data Array
    var dataArray:[PhotoLibraryDb] = [];
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get Data as PhotoLibraryDb
        let del = UIApplication.shared.delegate as! AppDelegate
        let context = del.persistentContainer.viewContext
        let request : NSFetchRequest<PhotoLibraryDb> = PhotoLibraryDb.fetchRequest();
        
        request.returnsObjectsAsFaults = false
        do{
            //instially putting data to arrey
            initialDataArray = try context.fetch(request)
            // make default data as instal data
            dataArray = initialDataArray
            self.tableView.reloadData()

           
            //print(initialDataAry);
        }
        catch {
            print("Errror in fetching data");
        }
        // put search bar in page programetically
        self.searchBarSetup()
        
    }
  //MARK: refered from 
   // refered form //https://github.com/SheldonWangRJT/iOS-SearchBar-in-TableView-Demo
    func searchBarSetup() {
        
        //setting up property for search bar
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Title","Country","Date"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        searchBar.text="";        
    
        self.tableView.tableHeaderView = searchBar
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if( searchText.isEmpty || searchText.characters.count == 0)
        {
            dataArray = initialDataArray
            self.tableView.reloadData()
        }
        else
        {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    
    func filterTableView(ind:Int,text:String) {
        //switch case to take name location and date to be select
        
        switch ind {
        case selectedScope.Name.rawValue:
            dataArray = initialDataArray.filter({ (mod) -> Bool in
                //checking in lowered and compare to make all suggesstion
                return (mod.name?.lowercased().contains(text.lowercased()))!
            })
            self.tableView.reloadData()
            
        case selectedScope.Location.rawValue:
            dataArray = initialDataArray.filter({ (mod) -> Bool in
                //print("location\(mod.location)");
                return (mod.location?.lowercased().contains(text.lowercased()))!
            })
            self.tableView.reloadData()
            
        case selectedScope.Date.rawValue:
            
            dataArray = initialDataArray.filter({ (mod) -> Bool in
                // refered from 
                //https://stackoverflow.com/questions/6546859/how-to-convert-nsdate-to-nsstring
                //make data formate to string
                let date = mod.date! as Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium;
                
                let dateString = dateFormatter.string(from: date as Date)
               
                //print("dateString\(dateString)");
                return (dateString.lowercased().contains(text.lowercased()))
            })
            self.tableView.reloadData()
        default:
            print("no type")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        
        let model = dataArray[indexPath.row]
        
        cell.nameLabel.text = model.name
        cell.imgView.image = UIImage(data: model.pic! as Data)
        cell.locationlabel.text = model.location
        print(dateFormat.string(from: model.date! as Date));
      
        //date format convert
        let date = model.date! as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium;
        
        let dateString = dateFormatter.string(from: date as Date)
        cell.dateLabel.text = dateString
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return dataArray.count
    }
    //making sure one section for serach bar
     override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
