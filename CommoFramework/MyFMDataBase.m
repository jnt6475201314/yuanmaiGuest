//
//  MyFMDataBase.m
//  FMDataBaseDemo
//
//  Created by 黄嘉宏 on 15/9/6.
//  Copyright (c) 2015年 黄嘉宏. All rights reserved.
//

#import "MyFMDataBase.h"

@interface MyFMDataBase ()

//全局声明数据库dataBase
@property(nonatomic,strong)FMDatabase *dataBase;

@end

static MyFMDataBase *sigleton = nil;

@implementation MyFMDataBase

+ (MyFMDataBase *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sigleton = [[MyFMDataBase alloc] init];
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [array objectAtIndex:0];
        NSString *dataBasePath = [path stringByAppendingPathComponent:@"goHiking.db"];
        [sigleton createDataBaseWithFilePath:dataBasePath];
    });
    return sigleton;
    //return 0;
}

#pragma mark - 创建一个数据库
-(void)createDataBaseWithFilePath:(NSString *)filePath{
    //获取沙盒路径
    //确定数据库路径
    NSLog(@"%@",filePath);
    
    //创建数据库
    /*
     如果该文件路径已经有这个db，那么就直接打开
     如果没有db，那么就创建一个新的db，然后打开
     */
    self.dataBase = [[FMDatabase alloc]initWithPath:filePath];
    
    //把数据库打开
    if (self.dataBase.open) {
//        NSLog(@"数据库打开成功");
    }
    else{
        NSLog(@"数据库打开失败");
    }
}

#pragma mark - 创建一个表单
-(void)createTableWithTableName:(NSString *)tableName tableArray:(NSArray *)tableArray{
    //通过sql语句创建表单
    //sql语句后接表单的名称(studentInfo)
    //表单名后面接表单结构
    
    //首先把结构体的字符串拼出来
    NSString *scutureString = @"";
    
    for (NSString *stringKey in tableArray) {
        scutureString = [NSString stringWithFormat:@"%@%@ string,",scutureString,stringKey];
    }
    
    NSString *scutureString2 = [scutureString substringToIndex:scutureString.length - 1];
    
//    NSLog(@"%@",scutureString2);
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,scutureString2];
    
    
//    NSLog(@"%@",sql);
    
    //通过dataBase使用sql语句
    BOOL isCreate = [self.dataBase executeUpdate:sql];
    
    if (isCreate) {
//        NSLog(@"创建表单成功");
    }
    else{
        NSLog(@"创建表单失败");
    }
}

#pragma mark - insert插入数据
-(void)insertDataWithTableName:(NSString *)tableName insertDictionary:(NSDictionary *)insertDictionary{
    //sql插入语句INSERT INTO
    //sql语句后接表单名(studentInfo)
    //设置插入语句的表单结构
    //设置表单结构的值(value)
    
    //字段名字符串
    NSString *scutureString = @"";
    
    for (NSString *keyString in insertDictionary.allKeys) {
        scutureString = [NSString stringWithFormat:@"%@,%@",scutureString,keyString];
    }
    NSString *scutureString2 = [scutureString substringFromIndex:1];
    
//    NSLog(@"%@",scutureString2);
    
    //值字符串
    //字段名字符串
    NSString *valueString = @"";
    
    for (NSString *keyString in insertDictionary.allKeys) {
        
        NSString *changeValueString = [NSString stringWithFormat:@"%@",insertDictionary[keyString]];
        
        valueString = [NSString stringWithFormat:@"%@,'%@'",valueString,changeValueString];
    }
    NSString *valueString2 = [valueString substringFromIndex:1];
    
//    NSLog(@"%@",valueString2);
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",tableName,scutureString2,valueString2];
    
//    NSLog(@"%@",sql);
    
//    NSString *sql = @"INSERT INTO studentInfo(sid,name,age,gender)VALUES(?,?,?,?)";
    
    BOOL isInsert = [self.dataBase executeUpdate:sql];
    
    if (isInsert) {
//        NSLog(@"插入sql数据成功");
    }
    else{
        NSLog(@"插入sql数据失败");
    }
}

#pragma mark - 修改表单中的数据
-(void)updateDataWithTableName:(NSString *)tableName updateDictionary:(NSDictionary *)updateArray whereArray:(NSDictionary *)whereArray{
    //制作一个修改name的sql语句
    //使用SQL修改语句UPDATE
    //SQL语句后跟表单名
    //SET设置需要修改的属性
    //WHERE提供筛选的条件
    //sid条件使用的字段名(当sid等于某个值的时候，就进行更换)
    
    //拼接需要改变的字段名
    NSString *setString = @"";
    int i = 0;
    for (NSString *keyString in updateArray.allKeys) {
        setString = [NSString stringWithFormat:@"%@ = '%@',",keyString,updateArray[updateArray.allKeys[i]]];
        i++;
    }
    NSString *setString2 = [setString substringToIndex:setString.length - 1];
    
//    NSLog(@"%@",setString2);
    
    //拼接条件字段名
    NSString *whereString = @"";
    int j = 0;
    for (NSString *keyString in whereArray.allKeys) {
        whereString = [NSString stringWithFormat:@"%@ = '%@',",keyString,whereArray[whereArray.allKeys[j]]];
        j++;
    }
    NSString *whereString2 = [whereString substringToIndex:whereString.length - 1];
    
//    NSLog(@"%@",whereString2);
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,setString2,whereString2];
    
//    NSLog(@"%@",sql);
    
    //修改某个数据
    BOOL isUpdate = [self.dataBase executeUpdate:sql];
    
    if (isUpdate) {
//        NSLog(@"修改数据成功");
    }
    else{
        NSLog(@"修改数据失败");
    }
}

#pragma mark - deleteData删除某条操作
-(void)deleteDataWithTableName:(NSString *)tableName delegeteDic:(NSDictionary *)delegeteDic{
    //制作一个删除操作的sql语句
    //sql语句后跟随表单名
    //WHERE添加删除的条件
    //当sid等于某个值的时候，删除掉
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",tableName,delegeteDic.allKeys[0],delegeteDic[delegeteDic.allKeys[0]]];
    
//    NSLog(@"%@",sql);
    
//    NSString *sql = @"DELETE FROM studentInfo WHERE sid = ?";
    
    BOOL isDelete = [self.dataBase executeUpdate:sql,@"1"];
    
    if (isDelete) {
//        NSLog(@"删除该数据成功");
    }
    else{
        NSLog(@"删除该数据失败");
    }
}

#pragma mark - 查询数据表中的数据
-(NSMutableArray *)selectDataWithTableName:(NSString *)tableName scutureArray:(NSArray *)scutureArray{
    //sql的查询语句
//    NSString *sql = @"SELECT * FROM studentInfo";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    
    //通过FMResultSet获取查询回来的数据
    //FMResultSet是一个集合
    FMResultSet *result = [self.dataBase executeQuery:sql];
    
    //获取result集合中的下一个元素作为判断条件
    //相当于是一个for循环把result中的所有元素都获取出来
    NSMutableArray *mutArray = [NSMutableArray array];
    
    //[result next]功能
    /*
     1.查询下一条数据是否存在
     2.在result集合中指定某条数据
     */
    while ([result next]) {
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < scutureArray.count; i++) {
//            NSLog(@"%@",scutureArray[i]);
            
            NSString *string = [result stringForColumn:scutureArray[i]];
            
            if (string) {
                [mDic setObject:string forKey:scutureArray[i]];
            }
        }
        
        [mutArray addObject:mDic];
        //....
    }
    
    return mutArray;
}

#pragma mark - deleteData删除所有操作
-(void)deleteAllDataWithTableName:(NSString *)tableName{
    //制作一个删除操作的sql语句
    //sql语句后跟随表单名
    //WHERE添加删除的条件
    //当sid等于某个值的时候，删除掉
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    
//    NSLog(@"%@",sql);
    
    //    NSString *sql = @"DELETE FROM studentInfo WHERE sid = ?";
    
    BOOL isDelete = [self.dataBase executeUpdate:sql];
    
    if (isDelete) {
//        NSLog(@"删除该数据成功");
    }
    else{
        NSLog(@"删除该数据失败");
    }
}

#pragma mark - 关闭数据库
-(void)closeDataBase{
    //关闭数据库
    BOOL isClose = [self.dataBase close];
    
    if (isClose) {
//        NSLog(@"关闭数据库成功");
    }
    else{
        NSLog(@"关闭数据库失败");
    }
}


@end
