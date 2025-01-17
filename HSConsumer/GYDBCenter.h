//
//  GYDBCenter.h
//  IMXMPPPro
//
//  Created by liangzm on 15-1-15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYDBCenter : NSObject

/**
 *	实例化一个FMDatabase操作对象
 *
 *	@param 	fullName 	数据库文件的完整路径
 *
 *	@return	FMDatabase操作对象
 */
+ (FMDatabase *)getDBFromDBFullName:(NSString *)fullName;

/**
 *	判断文件是否存在
 *
 *	@param 	fileFullName 	文件的完整路径
 *
 *	@return	YES存在，NO不存在
 */
+ (BOOL)fileIsExists:(NSString *)fileFullName;

/**
 *	根据一个完整路径的文件名创建空文件,注意：如果文件已存在，会覆盖创建。
 *
 *	@param 	fileFullName 	文件的完整路径
 *
 *	@return	YES创建文件成功，NO创建文件失败
 */
+ (BOOL)createFile:(NSString *)fileFullName;

/**
 *	根据一个完整路径的文件名取到目录
 *
 *	@param 	fileFullName 	文件的完整路径
 *
 *	@return	目录
 */
+ (NSString *)getDirectoriesPathFromFileFullName:(NSString *)fileFullName;

/**
 *	根据用户名取得一个数据库文件名，返回格式如：/Library/Caches/im_liang/db.im
 *
 *	@param 	userName 	用户名
 *
 *	@return	数据库文件名
 */
+ (NSString *)getUserDBNameInDirectory:(NSString *)userName;

/**
 *	初始化IM数据库的表结构
 *
 *	@param 	db 	数据库操作对象
 *
 *	@return	YES/NO
 */
+ (BOOL)setDefaultTablesForImDB:(FMDatabase *)db;

/**
 *	取得保存历史聊天记录的表名
 *
 *	@return	表名
 */
+ (NSString *)getDefaultTableNameForMessageRecord;

+ (NSString *)getTableNameFroMsgType:(NSInteger)msgType;

+ (BOOL)deleteUserAllMessageWithUserAccount:(NSString *)user;

@end
