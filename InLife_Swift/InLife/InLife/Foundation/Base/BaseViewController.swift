//
//  BaseViewController.swift
//  NewStoreSpace
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        resetNavBarBackButton()
        // Do any additional setup after loading the view.
    }

    func resetNavBarBackButton() {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationItem.setBackButton(target: self, action: #selector(BaseViewController.backButtonClicked))
        }
    }
    
    func backButtonClicked() -> Void {
       _ = self.navigationController?.popViewController(animated: true)
    }

    
    /*** 弹出加载框*/
    func showHud()
    {
        YXHudTool.share.showTextHud(text: LOAD_DEFAULT_TITLE, inView: self.view)
    }
    
    /*** 弹出提示框*/
    func showHudAndText(_ text:String)
    {
        YXHudTool.share.showOKHud(text: text, delay: DEFAULT_HIDE_DELAY, inView: self.view)
    }
    
    /*** 隐藏加载框*/
    func hideLoadHud()
    {
        YXHudTool.share.hideHud()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
