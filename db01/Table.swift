//
//  Table.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/23.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import RealmSwift

class Table: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Item List"

        self.navigationController?.isNavigationBarHidden = false
         navigationItem.rightBarButtonItem = editButtonItem
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let realm = try! Realm()
        let todo = realm.objects(Test.self)
        return todo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let realm = try! Realm()
        let todo = realm.objects(Test.self)
        cell.textLabel?.text = todo[indexPath.row].name
        cell.detailTextLabel?.text = String(todo[indexPath.row].age)

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let realm = try! Realm()
            let todo = realm.objects(Test.self)
            let item = todo[indexPath.row]
            try! realm.write() {
                realm.delete(item)
            }
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
   
    //cellの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    // cellが選択された時に呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath)")
        // タップ後すぐ非選択状態にするには下記メソッドを呼び出します．
         tableView.deselectRow(at: indexPath, animated: true)
    }
    // 各indexPathのcellが横にスワイプされスワイプメニューが表示される際に呼ばれます．
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        print("willBeginEditingRow: \(indexPath)")
    }
    // 各indexPathのcellのスワイプメニューが非表示になった際に呼ばれます．
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("didEndEditingRow: \(String(describing: indexPath))")
    }
    
    
    //MARK: - tableView編集モード
    // 各indexPathのcellが編集モード中に移動できるか指定します．
    //なお，cellがスワイプされ，スワイプメニューが表示された際に呼ばれます．また，tableViewが編集モードに入った際にも呼ばれます．
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: 入れ替え時の処理を実装する（データ制御など）
    }
    // tableViewが編集モードになった際に各indexPathのcell(の左側)に表示するボタンのスタイルを指定します．
    // .insertを指定すると + ボタンが表示され，それがタップされるとtableView(_:commit:forRowAt:)が呼び出されます．
    // .deleteを指定すると - ボタンが表示され，それがタップされるとスワイプメニューが表示されます．
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    // 各indexPathのcellのスワイプメニューに表示するデフォルトの削除ボタンのタイトルを指定します．
    // nilを指定するとデフォルトの文字列が表示されます．
    // tableView(_:editActionsForRowAt:)でスワイプメニューをカスタマイズしている際には本メソッドは呼ばれません．
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    /*
     * tableViewが編集モードでcellを移動している際にどのcellをずらすか指定します．
     * proposedDestinationIndexPathには移動中のcellの真下(裏)にあるcellのindexPathが渡されます．
     */
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
    }
    /*
     * 各indexPathのcellをロングタップした際にアクションメニューを表示するか指定します．
     * アクションメニューとは，テキストを選択している際に表示される[Cut | Copy]のようなメニューです．
     */
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
     *tableView(_:shouldShowMenuForRowAt:)がtrueとなっている各indexPathのcellで，どのアクションメニューを表示するか指定します．
     * この場合は[Select All]アクションのみを表示します
     */
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if NSStringFromSelector(action) == "selectAll:" {
            return true
        }

        return false
    }
    // 各indexPathのアクションメニューのうちいずれかのアクションがタップされた際の挙動を指定します．
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        print("performAction: \(action), \(indexPath), \(String(describing: sender))")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
