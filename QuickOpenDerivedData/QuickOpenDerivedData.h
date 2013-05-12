//
//  QuickOpenDerivedData.h
//  QuickOpenDerivedData
//
//  Created by Dallas Brown on 5/10/13.
//  Copyright (c) 2013 HashBang Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface QuickOpenDerivedData : NSObject

- (void)openDerivedDataContainer;
- (void)openDerivedDataForKeyWindow;
- (void)toggleButtonInTitleBar:(id) sender;

@end
