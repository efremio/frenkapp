//
//  LaunchAtLoginManager.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 01/06/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

class LaunchAtLoginManager {
    
    static func applicationIsInStartUpItems() -> Bool {
        return (itemReferencesInLoginItems().existingReference != nil)
    }
    
    static func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?) {
        let itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.alloc(1)
        if let appUrl : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
            let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
                ).takeRetainedValue() as LSSharedFileListRef?
            if loginItemsRef != nil {
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                print("There are \(loginItems.count) login items")
                if(loginItems.count > 0)
                {
                    let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as! LSSharedFileListItemRef
                    for i in 0 ..< loginItems.count {
                        let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(i) as! LSSharedFileListItemRef
                        if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr {
                            if let urlRef: NSURL =  itemUrl.memory?.takeRetainedValue() {
                                print("URL Ref: \(urlRef.lastPathComponent)")
                                if urlRef.isEqual(appUrl) {
                                    return (currentItemRef, lastItemRef)
                                }
                            }
                        }
                        else {
                            print("Unknown login application")
                        }
                    }
                    //The application was not found in the startup list
                    return (nil, lastItemRef)
                }
                else
                {
                    let addatstart: LSSharedFileListItemRef = kLSSharedFileListItemBeforeFirst.takeRetainedValue()
                    return(nil,addatstart)
                }
            }
        }
        return (nil, nil)
    }
    
    static func setLaunchAtStartup(launchAtStartup: Bool) {
        //save the preference
        KeychainManager.setLaunchAtLogin(launchAtStartup)
        
        let itemReferences = itemReferencesInLoginItems()
        let alreadyExists = (itemReferences.existingReference != nil)
        
        
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        
        if loginItemsRef != nil {
            
            if launchAtStartup {
                if !alreadyExists {
                    if let appUrl : CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
                        LSSharedFileListInsertItemURL(
                            loginItemsRef,
                            itemReferences.lastReference,
                            nil,
                            nil,
                            appUrl,
                            nil,
                            nil
                        )
                        print("Application was added to login items")
                    }
                } else {
                    print("Cannot add app to login items, already exists!")
                }
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                    print("Application was removed from login items")
                }
            }
            
            
        }
    }
    
}
