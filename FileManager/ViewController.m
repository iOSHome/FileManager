//
//  ViewController.m
//  FileManager
//
//  Created by YouXianMing on 15/11/19.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "FileManager.h"
#import "File.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[FileManager sharedInstance] scanBundleFiles];
    [[FileManager sharedInstance] scanSandboxFiles];
    
    File *file1 = [[FileManager sharedInstance] rootBundleFile];
    File *file2 = [[FileManager sharedInstance] rootSandboxFile];
    
    // Bundle Files
    for (File *file in file1.allFiles) {
        
        NSLog(@"isDirectory[%@] fileName:%@        path:%@", @(file.isDirectory), file.fileName, file.filePath);
    }
    
    NSLog(@"");
    NSLog(@"");
    NSLog(@"");
    NSLog(@"");
    
    // Sandbox Files
    for (File *file in file2.allFiles) {
        
        NSLog(@"isDirectory[%@] fileName:%@        path:%@", @(file.isDirectory), file.fileName, file.filePath);
    }
}

@end
