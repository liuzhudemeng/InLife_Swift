//
//  VSHomeCache.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

/**
 * @class VSHomeCache, 多tabVC缓存
 *
 */
class VSHomeCache: NSObject {
    var dic_:NSMutableDictionary?
    var lruKeyList_:NSMutableArray?
    var requestCache_:NSMutableDictionary?
    var capacity_:NSInteger = 0
    
    
     init(count:NSInteger){
        super.init()
        capacity_ = count
        dic_ = NSMutableDictionary(capacity: capacity_)
        lruKeyList_ = NSMutableArray(capacity: capacity_)
        requestCache_ = NSMutableDictionary(capacity: 0)
    }
//    func initWithCount(count:NSInteger) ->Any{
//        
//         capacity_ = count
//         dic_ = NSMutableDictionary(capacity: capacity_)
//        lruKeyList_ = NSMutableArray(capacity: capacity_)
//        requestCache_ = NSMutableDictionary(capacity: 0)
//        return self
//    }
    
    func removeAll(){
        dic_?.removeAllObjects()
        lruKeyList_?.removeAllObjects()
    }
    
    func setObject(objec:AnyObject,key:String){
        if !lruKeyList_!.contains(key)
        {
            if lruKeyList_!.count < capacity_ {
                dic_?.setValue(objec, forKey: key)
                lruKeyList_?.add(key)
            }else{
                let longTimeUnusedKey:String = lruKeyList_?.firstObject as! String
                let objToDispose:AnyObject = dic_?.object(forKey: longTimeUnusedKey) as AnyObject
                if objToDispose as! Bool && objToDispose.responds(to: #selector(requestResultCache)) {
                    let cache = objToDispose.perform(#selector(requestResultCache), with: nil)
                    requestCache_?.setValue(cache, forKey: longTimeUnusedKey )
                }
                dic_?.setValue(nil, forKey: longTimeUnusedKey)
                lruKeyList_?.removeObject(at: 0)
                
                dic_?.setValue(objec, forKey: key)
                lruKeyList_?.add(key)
            }
        }else{
            dic_?.setValue(objec, forKey: key)
            lruKeyList_?.remove(key)
            lruKeyList_?.add(key)
        }
    }
    
    
    func objectForKey(key:String) -> Any?{
        if lruKeyList_!.contains(key) {
            lruKeyList_?.remove(key)
            lruKeyList_?.add(key)
            return dic_?.object(forKey: key)
        }else{
            return nil
        }
    }
    
    func cacheForKey(key:String) -> Any {
        return requestCache_?.object(forKey: key)
    }
    
    func requestResultCache(){
        
    }
}
