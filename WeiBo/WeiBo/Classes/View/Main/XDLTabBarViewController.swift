//
//  XDLTabBarViewController.swift
//  WeiBo
//
//  Created by DalinXie on 16/9/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class XDLTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = XDLTabBar()
        
        self.setValue(tabBar, forKey: "tabBar")

        if XDLUserAccountViewModel.shareModel.userlogin{
            
            let composeClosure = {[weak self] in
                
                print("-----ClickComposeButton\(self)")
                
                let v = XDLComposeView()
                UIView.animate(withDuration: 5, animations: {
                    v.show(target: self!)
                })
            }
             tabBar.composeButtonClosure = composeClosure
        }else{
            
             tabBar.composeButton.isEnabled = false
        }
    
        addChildViewController()
    }
    
    func addChildViewController(){
    
        addChildViewController(vc:XDLHomeViewController() , title: "Home", imageName:"tabbar_home")
        addChildViewController(vc:XDLMessageViewController() , title: "Message", imageName: "tabbar_message_center")
        addChildViewController(vc:XDLDiscoverViewController() , title: "Discover", imageName: "tabbar_discover")
        addChildViewController(vc:XDLProfileViewController(), title: "Mine", imageName:"tabbar_profile")
        
    }
    
    func addChildViewController(vc:UIViewController, title: String, imageName: String)
    {
        
        vc.title = title
        
        vc.tabBarItem.image = UIImage(named: imageName)
        
        vc.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: UIControlState.selected)
        
        let navVc = XDLNavigationViewController(rootViewController: vc)
        
        addChildViewController(navVc)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
