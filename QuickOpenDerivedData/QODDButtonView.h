//
//  QODDButtonView.h
//  QuickOpenDerivedData
//
//  Created by Dallas Brown on 5/10/13.
//  Copyright (c) 2013 HashBang Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface QODDButtonView : NSView

@property (nonatomic, retain) NSButton *button;
@property (nonatomic, assign) NSInteger tag;

@end
