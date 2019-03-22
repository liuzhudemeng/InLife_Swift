//
//  YXLoadBgAPI.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/24.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

private let  kIndicatorId = 9876
private let kMsgId = 6666
public enum YXEmptyViewType : Int {
    case Order
    case NoGoods         //没有货物
    case NoMointor        //没有监控
    case NoApply          //没有申请记录(wms)
    case NoApplyBill      //没有申请单（查看监控申请）
    case LocationFail
    case NetworkError
}

public enum  YXShowSubViewType:Int{
    case Default      //默认的，标题、图片、按钮都显示
    case ButtonNone       //没有按钮，
    case ImageNone        //没有图片，
    case Image        //只有图片
    case Title          //只有标题
    case TitleNone      //没有标题
}
extension UIView {
    
    public func YX_Loading() {
        self.YX_RemoveLoadView()
        YX_LoadBgWithFrame(frame: nil)
    }
    
    //显示加载view
    public func YX_LoadBgWithFrame(frame:CGRect?) ->Void{
        DispatchQueue.main.async { 
             let view: UIView = self.getLoadBgBaseView(frame: frame)
             let msgV = self.getMsgView()
             msgV.showActivityLoading(view: view, title: "请稍后...")
        }
    }
    
    public func YX_LoadEmpty(type:YXEmptyViewType) ->Void{
        self.YX_LoadEmpty(type: type, frame: nil)
    }
    
    
    public func YX_LoadEmpty(type:YXEmptyViewType, frame:CGRect?) ->Void{
         self.YX_RemoveLoadView()
        DispatchQueue.main.async {
            let view = self.getLoadBgBaseView(frame: frame)
            view.createEmptyViewWithType(type: type)
        }
    }
    
    public func YX_RemoveLoadView(){
        DispatchQueue.main.async { 
            let view = self.viewWithTag(kIndicatorId)
            let msgV = self.viewWithTag(kMsgId) as?YXLoadingMsg
            YXTools.cATransitionAnimation(toView: self, typeIndex: 0, subTypeIndex: 0, duration: 0.25, animation: {
                msgV?.hideActivityLoading()
                view?.removeFromSuperview()
            })
            
        }
    }
    
    
    private func getLoadBgBaseView(frame:CGRect?) -> YXLoadMsgView {
        var viewFrame = frame
        if frame == nil {
            viewFrame = self.bounds
        }
        let view = YXLoadMsgView(frame: viewFrame!)
        view.tag = kIndicatorId
        self.addSubview(view)
        return view
    }
    
    private func getMsgView() -> YXLoadingMsg{
        let view = YXLoadingMsg()
        view.tag = kMsgId
        self.addSubview(view)
        return view
    }
    
    public func btnClickedBlock(clickedBlock:(() -> ())?) -> Void{
        DispatchQueue.main.async {
            let view = self.viewWithTag(kIndicatorId) as!YXLoadMsgView
            view.btnClickedBlock = clickedBlock
        }
    }
    
}
