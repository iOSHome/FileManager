//
//  FileManager.h
//  FileManager
//
//  Created by YouXianMing on 15/11/19.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class File;

@interface FileManager : NSObject

/**
 *  Get sharedInstance.
 *
 *  @return FileManager's sharedInstance.
 */
+ (FileManager *)sharedInstance;

#pragma mark - Sandbox File

/**
 *  Scan sandbox files.
 */
- (void)scanSandboxFiles;

/**
 *  Get sandbox root file. (When you want to get the newest root sandbox file tree system, you should run method 'scanSanboxFiles' before.)
 *
 *  @return Root file.
 */
- (File *)rootSandboxFile;

#pragma mark - Bundle File

/**
 *  Scan bundle files.
 */
- (void)scanBundleFiles;

/**
 *  Get bundle root file. (When you want to get the newest root bundle file tree system, you should run method 'scanBundleFiles' before.)
 *
 *  @return Root file.
 */
- (File *)rootBundleFile;

@end
