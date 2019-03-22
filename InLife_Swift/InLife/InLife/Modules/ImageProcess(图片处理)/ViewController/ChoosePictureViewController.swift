//
//  ChoosePictureViewController.swift
//  InLife
//
//  Created by apple on 17/7/31.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class ChoosePictureViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "INLIFE"
        buildUI()
        // Do any additional setup after loading the view.
    }

    
    override func resetNavBarBackButton() {
        self.navigationItem.setPreCloseButton(target: self, action: #selector(BaseViewController.backButtonClicked))
    }
    
    override func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func buildUI(){
        self.view.addSubview(imgV)
        self.view.addSubview(chooseBtn)
        imgV.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(chooseBtn.snp.top)
        }
        chooseBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(60)
            make.bottom.equalTo(self.view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  toChoosePicture(sender:UIButton){
        let sheet = YXCameraSheet.shared
        sheet.OpenMorePhotoController(toController: self, dismissed: {[weak self] (image) in
             self?.toNextPressVC(image: image)
        }) { (error) in
            
        }
//        let sheet = YXCameraSheet()
//        sheet.cameraSheet().camera(with: self, editing: NOEditing, select: isSigle, isOriginal: true, onDismiss: {[weak self] (image) in
//            HHLog("原图片\(ImageTools.getImageKB(image:image!))")
//            self?.toNextPressVC(image: image)
//        }) { (error) in
//
//        }
    }
    
    
    //到下一个页面处理照片
    func toNextPressVC(image:UIImage?){
        let vc = ImageProcessViewController()
        vc.originImage = image
        self.navigationController?.pushViewController(vc, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private lazy var imgV:UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleToFill
        object.image = UIImage(named: "bgImage")
        return object
    }()
    
    
    private lazy var chooseBtn:UIButton = {
        let object = UIButton()
        object.backgroundColor = UIColor.white
        object.setTitle("选择照片", for: .normal)
        object.setTitleColor(UIColor.black, for: .normal)
        object.titleLabel?.font = systemFont(14)
        object.tag = 1
        object.addTarget(self, action: #selector(toChoosePicture(sender:)), for: .touchUpInside)
        return object
    }()

}
