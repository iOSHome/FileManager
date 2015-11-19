//
//  FileManager.m
//  FileManager
//
//  Created by YouXianMing on 15/11/19.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "FileManager.h"
#import "File.h"

static FileManager *_sharedSingleton = nil;

@interface FileManager ()

@property (nonatomic, strong) File  *theRootSandboxFile;
@property (nonatomic, strong) File  *theRootBundleFile;

@end

@implementation FileManager

- (instancetype)init {
    
    [NSException raise:@"ScanSandboxManager"
                format:@"Cannot instantiate singleton using init method, sharedInstance must be used."];
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    
    [NSException raise:@"ScanSandboxManager"
                format:@"Cannot copy singleton using copy method, sharedInstance must be used."];
    
    return nil;
}

+ (FileManager *)sharedInstance {
    
    if (self != [FileManager class]) {
        
        [NSException raise:@"ScanSandboxManager"
                    format:@"Cannot use sharedInstance method from subclass."];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedSingleton = [[FileManager alloc] initInstance];
    });
    
    return _sharedSingleton;
}

- (id)initInstance {
    
    if (self = [super init]) {
        
        // Init sandbox root file.
        NSString *sandboxRootPath           = NSHomeDirectory();
        self.theRootSandboxFile             = [[File alloc] init];
        self.theRootSandboxFile.fileName    = @"RootSandboxFile";
        self.theRootSandboxFile.name        = @"RootSandboxFile";
        self.theRootSandboxFile.level       = 0;
        self.theRootSandboxFile.isDirectory = YES;
        self.theRootSandboxFile.filePath    = sandboxRootPath;
        self.theRootSandboxFile.fileUrl     = [[NSURL alloc] initFileURLWithPath:sandboxRootPath isDirectory:YES];
        
        // Init bundle root file.
        NSString *bundleRootPath           = [[NSBundle mainBundle] bundlePath];
        self.theRootBundleFile             = [[File alloc] init];
        self.theRootBundleFile.fileName    = @"RootBundleFile";
        self.theRootBundleFile.name        = @"RootBundleFile";
        self.theRootBundleFile.level       = 0;
        self.theRootBundleFile.isDirectory = YES;
        self.theRootBundleFile.filePath    = bundleRootPath;
        self.theRootBundleFile.fileUrl     = [[NSURL alloc] initFileURLWithPath:bundleRootPath isDirectory:YES];
    }
    
    return self;
}

- (void)scanSandboxFiles {

    [self.theRootSandboxFile.subFiles removeAllObjects];
    
    [self scanDir:self.theRootSandboxFile.filePath rootFile:self.theRootSandboxFile];
}

- (File *)rootSandboxFile {

    return self.theRootSandboxFile;
}

- (void)scanBundleFiles {

    [self.theRootBundleFile.subFiles removeAllObjects];
    
    [self scanDir:self.theRootBundleFile.filePath rootFile:self.theRootBundleFile];
}

- (File *)rootBundleFile {
    
    return self.theRootBundleFile;
}

- (void)scanDir:(NSString *)dirPath rootFile:(File *)rootFile {
    
    NSFileManager *localFileManager = [[NSFileManager alloc] init];
    NSArray       *array            = [localFileManager contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *relatedPath in array) {
        
        NSString *fullPath = [rootFile.filePath stringByAppendingPathComponent:relatedPath];
        
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
        
        File *file        = [[File alloc] init];
        file.filePath     = fullPath;
        file.fileName     = relatedPath;
        file.isDirectory  = isDirectory;
        file.level        = rootFile.level + 1;
        file.fileUrl      = [[NSURL alloc] initFileURLWithPath:fullPath isDirectory:isDirectory];
        
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
        file.attributes   = dic;
        
        NSArray *componentsStrings = [file.fileName componentsSeparatedByString:@"."];
        if (componentsStrings.count >= 2) {
            
            NSString *lastString   = componentsStrings.lastObject;
            file.name              = [file.fileName substringWithRange:NSMakeRange(0, file.fileName.length - lastString.length - 1)];
            file.filenameExtension = lastString;
            
        } else {
            
            file.name = file.fileName;
        }
        
        if (file.isDirectory) {
            
            [self scanDir:file.filePath rootFile:file];
        }
        
        [rootFile.subFiles addObject:file];
    }
}

@end
