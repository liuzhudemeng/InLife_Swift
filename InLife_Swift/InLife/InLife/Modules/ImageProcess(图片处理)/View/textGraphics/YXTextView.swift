//
//  YXTextView.swift
//  InLife
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class YXTextView: UIView {
    var data = [String]()
    weak var  delegate:YXTextViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BgViewColor
        setData()
        buildUI()
    }
    func setData(){
        let familyNames = UIFont.familyNames
        for familyName in familyNames {
            data.append(familyName)
        }
        data.sort()
    }
    
    func buildUI(){
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var tableView:UITableView = {
       let objcect = UITableView()
        objcect.delegate = self
        objcect.dataSource = self
        objcect.backgroundColor = UIColor.clear
        return objcect
    }()
}

extension YXTextView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell =  UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = data[indexPath.row]
        let font = UIFont.init(name: data[indexPath.row], size: 18)
        cell?.textLabel?.font = font
        cell?.textLabel?.textColor = UIColor.black
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.viewIsSelectedFont(fontName: data[indexPath.row])
    }

}

@objc protocol YXTextViewDelegate:NSObjectProtocol{
    func viewIsSelectedFont(fontName:String)
}
