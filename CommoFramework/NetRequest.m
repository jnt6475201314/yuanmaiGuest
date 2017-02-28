//
//  NetRequest.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

+(AFHTTPSessionManager *)AFManager{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    // 超过时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}


+ (void)getDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    AFHTTPSessionManager *manager = [self AFManager];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error.localizedDescription);
    }];
    //    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        successBlock(responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        failBlock(error.localizedFailureReason);
    //    }];
}

+ (void)postDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    AFHTTPSessionManager *manager = [self AFManager];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"%@", responseObject);
        //        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSLog(@"responseString: %@", responseString);
        //        NSMutableString * str = [NSMutableString stringWithString:responseString];
        //        NSString * dicStr = [NSString stringWithFormat:@"%@}",[[str componentsSeparatedByString:@"}"]  firstObject]];
        //        NSLog(@"responseStr: %@", str);
        successBlock(jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error.localizedDescription);
    }];
    //    [manager POST:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        successBlock(responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        failBlock(error.localizedFailureReason);
    //    }];
}

/* 检查是否异地登陆的操作 */
+ (void)checkOtherPlaceLoginWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    
    AFHTTPSessionManager *manager = [self AFManager];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error.localizedDescription);
    }];
    
}

+ (void)AF_RegisterByPostWithUrlString:(NSString *)urlString params:(NSDictionary *)params image:(UIImage *)image success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    AFHTTPSessionManager * manager = [self AFManager];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@.png",@"photo"];
        UIImage * image1 = image;
        NSData *data =UIImageJPEGRepresentation(image1, 1.0);
        
        /******** 1.上传已经获取到的img *******/
        // 把图片转换成data
        //        NSData *data = UIImagePNGRepresentation(image);
        // 拼接数据到请求题中
        [formData appendPartWithFileData:data name:@"file" fileName:@"headimage.png" mimeType:@"image/png"];
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 打印上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonObj);
        NSLog(@"%@", responseObject);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString: %@", responseString);
        NSMutableString * str = [NSMutableString stringWithString:responseString];
        NSString * dicStr = [NSString stringWithFormat:@"%@}",[[str componentsSeparatedByString:@"}"]  firstObject]];
        NSLog(@"responseStr: %@", str);
        successBlock(jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error.localizedDescription);
    }];
    
}


@end
