//
//  XDLVisitorTableViewController.swift
//  WeiBo
//
//  Created by DalinXie on 16/9/12.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class XDLVisitorTableViewController: UITableViewController {

    var userlogin = XDLUserAccountViewModel.shareModel.userlogin
    
    var clickLoginClosure:(()->())?
    
    override func loadView() {
        if userlogin{
            
            super.loadView()
            
        }else{
            
            setupVisitorView()
        
        }
        
    }
    func setupVisitorView(){
        
        let v = visitorView
        
        self.view = v
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", target: self, action: #selector(registerButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", target: self, action: #selector(visitorViewWillLogin))
        
        v.delegateLoginClosure = { [weak self] in
            
            print("Login")
            
            let vc = XDLNavigationViewController(rootViewController: XDLOAuthViewController())
            
            self?.present(vc, animated: true, completion: nil)
        
        }
       
       
    
    }
    lazy var visitorView : XDLVisitorView = {()-> XDLVisitorView in
        
       let visitorView = XDLVisitorView()
    
       return visitorView
   
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @objc private func registerButtonClick() {
        
        print("register")
    }
    
    // MARK: - HMVisitorViewDelegate
    
  @objc private func visitorViewWillLogin() {
       // print(#function)
       print("Login")
    
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
