//
//  MyFMDataBase.h
//  FMDataBaseDemo
//
//  Created by 黄嘉宏 on 15/9/6.
//  Copyright (c) 2015年 黄嘉宏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>

@interface MyFMDataBase : NSObject
#pragma mark - 单例
+ (MyFMDataBase *)shareInstance;
#pragma mark - 创建一个数据库
-(void)createDataBaseWithFilePath:(NSString *)filePath;
#pragma mark - 创建一个表单
-(void)createTableWithTableName:(NSString *)tableName tableArray:(NSArray *)tableArray;
#pragma mark - insert插入数据
-(void)insertDataWithTableName:(NSString *)tableName insertDictionary:(NSDictionary *)insertDictionary;
#pragma mark - 修改表单中的数据
-(void)updateDataWithTableName:(NSString *)tableName updateDictionary:(NSDictionary *)updateArray whereArray:(NSDictionary *)whereArray;
#pragma mark - deleteData删除所有操作
-(void)deleteAllDataWithTableName:(NSString *)tableName;
#pragma mark - deleteData删除操作
-(void)deleteDataWithTableName:(NSString *)tableName delegeteDic:(NSDictionary *)delegeteDic;
#pragma mark - 查询数据表中的数据
-(NSMutableArray *)selectDataWithTableName:(NSString *)tableName scutureArray:(NSArray *)scutureArray;
#pragma mark - 关闭数据库
-(void)closeDataBase;
@end
