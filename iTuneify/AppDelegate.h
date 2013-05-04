//
//  AppDelegate.h
//  iTuneify
//
//  Created by Hani Kazmi on 03/05/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSStatusItem *statusBar;

@property (weak) IBOutlet NSMenu *statusMenu;


@end
