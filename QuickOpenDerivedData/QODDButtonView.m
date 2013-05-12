//
//  QODDButtonView.m
//  QuickOpenDerivedData
//
//  Created by Dallas Brown on 5/10/13.
//  Copyright (c) 2013 HashBang Industries. All rights reserved.
//

#import "QODDButtonView.h"

#define QODD_DEFAULT_BUTTON_WIDTH 118.f
#define QODD_CONTAINER_MARGIN     2.f

@implementation QODDButtonView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
	if (self)
	{
        _button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, [self buttonWidthRelativeToFrame], 20)];
        _button.autoresizingMask = NSViewWidthSizable;
		
        [_button setBezelStyle:NSTexturedRoundedBezelStyle];
        [[_button cell] setControlSize:NSSmallControlSize];
        [_button setFont:[NSFont systemFontOfSize:11.0]];
        [_button setTitle:@"Open DerivedData"];
        [self addSubview:_button];
    }
	
    return self;
}

- (BOOL)isOpaque
{
    return NO;
}

- (float) buttonWidthRelativeToFrame
{
    return MAX(MIN(QODD_DEFAULT_BUTTON_WIDTH, self.frame.size.width - QODD_CONTAINER_MARGIN * 2), 0);
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    float buttonWidth = [self buttonWidthRelativeToFrame];

    self.button.frame = CGRectMake(self.frame.size.width - buttonWidth - QODD_CONTAINER_MARGIN, self.button.frame.origin.y, buttonWidth, self.button.frame.size.height);
}

- (void)dealloc
{
    [_button release];

    [super dealloc];
}

@end
