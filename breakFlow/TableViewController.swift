//
//  TableViewController.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 2/24/19.
//  Copyright © 2019 Viktor Gordienko. All rights reserved.
//

import UIKit

let defaults = UserDefaults(suiteName: "com.breakFlow")

class TableViewController: UITableViewController {

    @IBOutlet weak var addRowButton: UIBarButtonItem!
    
    //var tableMoves = ["Топ Рок","Индиан Степ","Сальса Степ","Флор рок (мини промокашка)","Циркуль","3 степ","4 степ","Бейби лав","6 степ на локтях","6 степ олдскул","Скрэмбл","Мини-свайп","Мини-свайп через К","Зулу спин","Зулу спин через К","Зулу спин нога на коленке","Питер Пэн","Кувырок","Ножницы","Голень слайд","СС","СС на спине","СС обратный","СС с проворотом","СС с киком","Кик двумя ногами","Шафл степ","Рашн степс","Свайп нога на коленке","Вэб","Гелик","Свайп","Свайп на двух ногах","Бочка","Тартл","Джекхаммер","Бэкспин","Флаер","99","Хедспин","Бейби фриз","Чеир","Эир бейби","Бэк/полубэк","Фриз на плече","Фриз на локте","Фриз на руках","Фриз на руке","Фриз на голове"]
    
    var tableMoves = ["top rock", "indian step", "shuffle step", "6 step", "4 step", "3 step", "baby swipe", "CC", "baby love", "zulu spin", "backspin", "windmill", "swipe", "turtle", "munchmill", "baby freeze", "chair", "air baby", "handstand"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = getData()
        
        //custom background image for the tableView and dark top bar
        tableView.backgroundView = UIImageView(image: UIImage(named: "stardust.png"))
        
        print("Вот набор движений на viewDidLoad:")
        print(tableMoves)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = NSLocalizedString("tableMovesTitle", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        _ = getData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        storeData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableMoves.count
    }

    //fill the table with array items
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moves", for: indexPath)
        cell.textLabel?.text = tableMoves[indexPath.row]
        //custom style for the cells in tableView
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.textLabel?.textColor = UIColor.white
        tableView.separatorColor = UIColor(red: 0.68, green: 0.67, blue: 0.73, alpha: 0)
        return cell
    }
    
    //rearrange cells by drag & move
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = tableMoves[sourceIndexPath.item]
        tableMoves.remove(at: sourceIndexPath.item)
        tableMoves.insert(movedObjTemp, at: destinationIndexPath.item)
        
        storeData()
    }
    
    //editing the table view.
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableMoves.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            print("Движение удалено, новый набор:")
            print(self.tableMoves)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        //storeData when item is deleted from the table - added that as well
        storeData()
    }
 */
    
    //make it possible to edit the table items
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //editing the table view (also editing single cells)
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: NSLocalizedString("tableMovesTitleEdit", comment: ""), handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: NSLocalizedString("editMoveName", comment: ""), preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.tableMoves[indexPath.row]
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("editMoveNameUpdate", comment: ""), style: .default, handler: { (updateAction) in
                self.tableMoves[indexPath.row] = alert.textFields!.first!.text!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                
                self.storeData()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("editMoveNameCancel", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: NSLocalizedString("tableMovesTitleDelete", comment: ""), handler: { (action, indexPath) in
            self.tableMoves.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
        storeData()
        
        return [deleteAction, editAction]
        
    }
    
    @IBAction func newRowPressed(_ sender: Any) {
        addTableRow()
    }
    
    func addTableRow() {
        //create UI alert
        let alert = UIAlertController(title: NSLocalizedString("addMoveTitle", comment: ""), message: NSLocalizedString("addMoveComment", comment: ""), preferredStyle: .alert)
        //add text field to alert
        alert.addTextField { (TextField) in
            TextField.placeholder = NSLocalizedString("addMovePlaceholder", comment: "")
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("addMoveButton", comment: ""), style: .default, handler: { [weak alert] (_) in
            let text = alert?.textFields![0]
            self.tableMoves.append((text?.text)!)
            self.tableView.reloadData()
            self.storeData()
            print("Движение добавлено, новый набор:")
            print(self.tableMoves)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("editMoveNameCancel", comment: ""), style: .cancel, handler: nil))

        
        //present pop up alert
        self.present(alert, animated:true, completion: nil)
        //moved storeData() from here up 5 lines with "self" in order to storeData on "confirm" instead of when plus button is pressed
    }
    
    //Storing app data
    func storeData() {
        print("storeData сработала")
        defaults?.set(tableMoves, forKey: "savedData")
        defaults?.synchronize()
    }
    
    //Getting app data
    func getData() -> Array<Any> {
        print("getData сработала")
        let data = defaults?.value(forKey: "savedData")
        if data != nil {
            tableMoves = data as! [String]
        } else {}

        return tableMoves
    }
}
