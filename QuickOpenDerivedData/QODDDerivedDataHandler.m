//
//  QODDDerivedDataHandler.m
//  QuickOpenDerivedData
//
//  Created by Dallas Brown on 5/10/13.
//  Copyright (c) 2013 HashBang Industries. All rights reserved.
//

#import "QODDDerivedDataHandler.h"


@interface NSObject (IDEKit)
+ (id) workspaceWindowControllers;
- (id) derivedDataLocation;
@end


@implementation QODDDerivedDataHandler

+ (void)openDerivedDataForProject:(NSString*)projectName
{
    NSString *projectPrefix = [projectName stringByReplacingOccurrencesOfString:@" " withString:@"_"];

    for (NSString *subdirectory in [self derivedDataSubdirectoryPaths])
	{
        if ([[[subdirectory pathComponents] lastObject] hasPrefix:projectPrefix])
		{
            [self openDirectoryAtPath:subdirectory];
        }
    }
}

+ (void)openDerivedDataContainer
{
    NSString *folder = [self derivedDataLocation];

	[self openDirectoryAtPath:folder];
}

#pragma mark - Private

+ (NSString*)derivedDataLocation
{
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];

    if (workspaceWindowControllers.count < 1) return nil;
	
    id workspace = [workspaceWindowControllers[0] valueForKey:@"_workspace"];
    id workspaceArena = [workspace valueForKey:@"_workspaceArena"];

    return [[workspaceArena derivedDataLocation] valueForKey:@"_pathString"];
}

+ (NSArray*)derivedDataSubdirectoryPaths
{
    NSMutableArray *workspaceDirectories = [NSMutableArray array];

    NSString *derivedDataPath  = [self derivedDataLocation];

    if (derivedDataPath)
	{
        NSError *error = nil;

        NSArray *directories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:derivedDataPath error:&error];

        if (error)
		{
            NSLog(@"QODD: Error while fetching derived data subdirectories: %@", derivedDataPath);
        }
		else
		{
            for (NSString *subdirectory in directories)
			{
                NSString *removablePath = [derivedDataPath stringByAppendingPathComponent:subdirectory];
                [workspaceDirectories addObject:removablePath];
            }
        }
    }

    return workspaceDirectories;
}

+ (void)openDirectoryAtPath:(NSString*)path
{
	NSURL *folderURL = [NSURL fileURLWithPath:path];

	[[NSWorkspace sharedWorkspace] openURL:folderURL];
}

@end
