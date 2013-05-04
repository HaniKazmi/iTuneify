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

static NSString *const REVEAL_SONG = @"RevealSong";
static NSString *const DISPLAY_NOTIFICATIONS = @"DisplayNotifications";

- (void) awakeFromNib {
    
    // Create statusbar item
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // Set image
    NSString* statusBarImageName = [[NSBundle mainBundle]pathForResource:@"applet" ofType:@"icns"];;
    NSImage* statusBarImage = [[NSImage alloc] initWithContentsOfFile:statusBarImageName];
    [statusBarImage setSize:NSSizeFromString(@"17x17")];
    self.statusBar.image = statusBarImage;
    
    // Add quit menu
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    
    // Start observing iTunes
    NSDistributedNotificationCenter* itunesDNC = [NSDistributedNotificationCenter defaultCenter];
    [itunesDNC addObserver:self selector:@selector(updateInfo:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], DISPLAY_NOTIFICATIONS,
                                 [NSNumber numberWithBool:YES], REVEAL_SONG,
                                 nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (void) updateInfo:(NSNotification *)notification
{
    // Create scripting bridge to iTunes
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    if ( [iTunes isRunning] ) {
        
        NSDictionary *information = [notification userInfo];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ( [[information valueForKey:@"Player State"]isEqualToString:@"Playing"]) {
            
            // Reveal currently playing track
            if ( [defaults boolForKey:REVEAL_SONG]) {
                [[iTunes currentTrack] reveal];
            }
            
            // Display current song notification
            if ( [defaults boolForKey:DISPLAY_NOTIFICATIONS]) {
                [self showNotification:information];
            }
        }
    }
    
}

- (void)showNotification:(NSDictionary *)information{
    NSUserNotification* notification = [[NSUserNotification alloc] init];
    notification.title = [information valueForKey:@"Name"];
    notification.subtitle = [information valueForKey:@"Artist"];
    notification.informativeText = [information valueForKey:@"Album"];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}


@end
