//
//  QuickOpenDerivedData.m
//  QuickOpenDerivedData
//
//  Created by Dallas Brown on 5/10/13.
//  Copyright (c) 2013 HashBang Industries. All rights reserved.
//

#import "QuickOpenDerivedData.h"
#import "QODDButtonView.h"
#import "QODDDerivedDataHandler.h"


#define QODD_BUTTON_CONTAINER_TAG 974
#define QODD_MAX_CONTAINER_WIDTH  128.f
#define QODD_BUTTON_OFFSET_FROM_R 22 // position of button relative to the right edge of the window

#define kQODDShowButtonInTitleBar	@"QODDShowButtonInTitleBar"


@interface NSObject (IDEKit)
+ (id) workspaceWindowControllers;
- (id) derivedDataLocation;
@end


@interface QuickOpenDerivedData()

- (QODDButtonView*)QODDButtonContainerForWindow:(NSWindow*)window;
- (void)updateTitleBarsFromPreferences;

@end


@implementation QuickOpenDerivedData

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidEndLiveResize:) name:NSWindowDidEndLiveResizeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitleBarsFromPreferences) name:NSWindowDidBecomeKeyNotification object:nil];
		
        NSMenuItem *viewMenuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
        if (viewMenuItem) {
            [[viewMenuItem submenu] addItem:[NSMenuItem separatorItem]];
			
            NSMenuItem *clearItem = [[NSMenuItem alloc] initWithTitle:@"Open Derived Data for Project" action:@selector(openDerivedDataForKeyWindow) keyEquivalent:@"h"];
            [clearItem setKeyEquivalentModifierMask: NSShiftKeyMask | NSCommandKeyMask];
            [clearItem setTarget:self];
            [[viewMenuItem submenu] addItem:clearItem];
            [clearItem release];
			
            NSMenuItem *clearAllItem = [[NSMenuItem alloc] initWithTitle:@"Open Derived Data Container" action:@selector(openDerivedDataContainer) keyEquivalent:@""];
            [clearAllItem setTarget:self];
            [[viewMenuItem submenu] addItem:clearAllItem];
            [clearAllItem release];

            NSMenuItem *toggleButtonInTitleBarItem = [[NSMenuItem alloc] initWithTitle:@"Quick Open Derived Data in Title Bar" action:@selector(toggleButtonInTitleBar:) keyEquivalent:@""];
            [toggleButtonInTitleBarItem setTarget:self];
            [[viewMenuItem submenu] addItem:toggleButtonInTitleBarItem];
            [toggleButtonInTitleBarItem release];
        }
		
    }
	
    return self;
}

#pragma mark -
#pragma mark DerivedData Management

- (void)openDerivedDataForKeyWindow
{
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];

    for (id controller in workspaceWindowControllers)
	{
        if ([[controller valueForKey:@"window"] isKeyWindow])
		{
            id workspace = [controller valueForKey:@"_workspace"];

			[QODDDerivedDataHandler openDerivedDataForProject:[workspace valueForKey:@"name"]];
        }
    }
}

- (void)openDerivedDataContainer
{
    [QODDDerivedDataHandler openDerivedDataContainer];
}

#pragma mark - GUI Management

- (void)toggleButtonInTitleBar:(id)sender
{
    [self setButtonEnabled:![self isButtonEnabled]];
    [self updateTitleBarsFromPreferences];
}

- (void)updateTitleBarsFromPreferences
{
    @try {
        NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];
        
		for (NSWindow *window in [workspaceWindowControllers valueForKey:@"window"])
		{
            QODDButtonView *buttonView = [self QODDButtonContainerForWindow:window];
	
            if (buttonView)
				[buttonView setHidden:![self isButtonEnabled]];
        }
    }
    @catch (NSException *exception) { }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(toggleButtonInTitleBar:))
	{
        [menuItem setState:[self isButtonEnabled] ? NSOnState : NSOffState];
    }
    return YES;
}

- (QODDButtonView*)QODDButtonContainerForWindow:(NSWindow*)window
{
    if ([window isKindOfClass:NSClassFromString(@"IDEWorkspaceWindow")])
	{
		NSView *windowFrameView = [[window contentView] superview];
		QODDButtonView *container = [windowFrameView viewWithTag:QODD_BUTTON_CONTAINER_TAG];
		
        if (!container) {
            CGFloat containerWidth = QODD_MAX_CONTAINER_WIDTH;
            container = [[[QODDButtonView alloc] initWithFrame:NSMakeRect(window.frame.size.width - containerWidth - QODD_BUTTON_OFFSET_FROM_R, windowFrameView.bounds.size.height - 22, containerWidth, 20)] autorelease];
            container.tag = QODD_BUTTON_CONTAINER_TAG;
            container.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin | NSViewWidthSizable;
			
            container.button.target = self;
            container.button.action = @selector(openDerivedDataForKeyWindow);
            
            [container setHidden:![self isButtonEnabled]];
            [windowFrameView addSubview:container];
        }
        return container;
    }
    return nil;
}

- (void)windowDidEndLiveResize:(NSNotification *) notification
{
    NSWindow *window = [notification object];
    NSView *button = [self QODDButtonContainerForWindow:window].button;

    if (button)
	{
        double delayInSeconds   = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [button setHidden:![self isButtonEnabled]];
        });
    }
}

#pragma mark -
#pragma mark Preferences

- (BOOL)isButtonEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kQODDShowButtonInTitleBar];
}

- (void) setButtonEnabled: (BOOL) enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kQODDShowButtonInTitleBar];
}

#pragma mark -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}

@end
