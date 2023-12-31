//
//  RPSSZipArchive.h
//  RPSSZipArchive
//
//  Created by Sam Soffes on 7/21/10.
//  Copyright © Sam Soffes 2010-2015. All rights reserved.
//

#ifndef _RPSSZipArchive_H
#define _RPSSZipArchive_H

#import <Foundation/Foundation.h>
#include "RPSSZipCommon.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RPSSZipArchiveDelegate;

@interface RPSSZipArchive : NSObject

// Password check
+ (BOOL)isFilePasswordProtectedAtPath:(NSString *)path;

// Unzip
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination delegate:(nullable id<RPSSZipArchiveDelegate>)delegate;

+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(nullable NSString *)password error:(NSError * *)error;
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(nullable NSString *)password error:(NSError * *)error delegate:(nullable id<RPSSZipArchiveDelegate>)delegate NS_REFINED_FOR_SWIFT;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
     preserveAttributes:(BOOL)preserveAttributes
              overwrite:(BOOL)overwrite
               password:(nullable NSString *)password
                  error:(NSError * *)error
               delegate:(nullable id<RPSSZipArchiveDelegate>)delegate;

+ (BOOL)unzipFileAtPath:(NSString *)path
    toDestination:(NSString *)destination
    progressHandler:(void (^)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
    completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler;

+ (BOOL)unzipFileAtPath:(NSString *)path
    toDestination:(NSString *)destination
    overwrite:(BOOL)overwrite
    password:(nullable NSString *)password
    progressHandler:(void (^)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
    completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler;

// Zip

// without password
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray *)paths;
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath;

+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath keepParentDirectory:(BOOL)keepParentDirectory;

// with password, password could be nil
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray *)paths withPassword:(nullable NSString *)password;
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath withPassword:(nullable NSString *)password;
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath keepParentDirectory:(BOOL)keepParentDirectory withPassword:(nullable NSString *)password;

- (instancetype)initWithPath:(NSString *)path;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL open;
- (BOOL)writeFile:(NSString *)path withPassword:(nullable NSString *)password;
- (BOOL)writeFolderAtPath:(NSString *)path withFolderName:(NSString *)folderName withPassword:(nullable NSString *)password;
- (BOOL)writeFileAtPath:(NSString *)path withFileName:(nullable NSString *)fileName withPassword:(nullable NSString *)password;
- (BOOL)writeData:(NSData *)data filename:(nullable NSString *)filename withPassword:(nullable NSString *)password;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL close;

@end

@protocol RPSSZipArchiveDelegate <NSObject>

@optional

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo;
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath;

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath unzippedFilePath:(NSString *)unzippedFilePath;

- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total;
- (void)zipArchiveDidUnzipArchiveFile:(NSString *)zipFile entryPath:(NSString *)entryPath destPath:(NSString *)destPath;

@end

NS_ASSUME_NONNULL_END

#endif /* _RPSSZipArchive_H */
