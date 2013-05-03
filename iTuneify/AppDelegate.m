//
//  AppDelegate.m
//  iTuneify
//
//  Created by Hani Kazmi on 03/05/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>
#import "iTunes.h"
#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusBar = _statusBar;
@synthesize statusMenu = _statusMenu;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSString* imageName = [[NSBundle mainBundle]pathForResource:@"applet" ofType:@"icns"];
    NSImage* image = [[NSImage alloc] initWithContentsOfFile:imageName];
    [image setSize:NSSizeFromString(@"17x17")];
    self.statusBar.image = image;
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    NSDistributedNotificationCenter* DNC = [NSDistributedNotificationCenter defaultCenter];
    [DNC addObserver:self selector:@selector(updateInfo:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) updateInfo:(NSNotification *)notification
{
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    NSDictionary *information = [notification userInfo];
    NSLog(@"track information: %@", [information allKeys]);
    [[iTunes currentTrack] reveal];
    
}


@end
