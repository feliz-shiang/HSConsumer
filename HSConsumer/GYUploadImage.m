//
//  GYUploadImage.m
//  HSConsumer
//
//  Created by apple on 15-2-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYUploadImage.h"

#import "UIImageView+WebCache.h"

@implementation GYUploadImage





-(void)uploadImg:(UIImage *)image WithParam :(NSMutableDictionary * )Param {
    self.imgUpload = image;

    [self postImageMethod:Param];
}


#define BOUNDARY @"ABC12345678"
-(void)postImageMethod:(NSMutableDictionary *)dict
 {

     NSString * s;
     //URL类型来自互动 个人头像修改
     if (self.urlType==1) {
         NSString * appendString=[NSString stringWithFormat:@"/hsim-img-center/upload/headPicUpload?type=%@&fileType=%@&id=%@&key=%@&mid=%@",@"default",@"image", [NSString stringWithFormat:@"%@_%@",[GlobalData shareInstance].IMUser.strCard,[GlobalData shareInstance].IMUser.strAccountNo],[GlobalData shareInstance].ecKey,[GlobalData shareInstance].midKey];
         s= [[GlobalData shareInstance].hdbizDomain  stringByAppendingString:appendString];
         NSLog(@"%@------s",s);
         
     }else if (self.urlType==3)
     {
         
        s = [NSString stringWithFormat:@"%@/easybuy/uploadIncludeSrcUrl?type=%@&fileType=%@",[GlobalData shareInstance].ecDomain,@"refund",@"image"];

     }else
     {
         
        s = [NSString stringWithFormat:@"%@/easybuy/uploadIncludeSrcUrl?type=%@&fileType=%@",[GlobalData shareInstance].ecDomain,@"refund",@"image"];
         
     }
     
     NSURL *url = [NSURL URLWithString:s];
     DDLogInfo(@"Post上传图片URL：%@", url);
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
     [request setHTTPMethod:@"POST"];


     s = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
     [request addValue:s
     forHTTPHeaderField:@"Content-Type"];

     NSMutableString *bodyString = [NSMutableString string];
     [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
     [bodyString appendString:@"Content-Disposition: form-data; name=\"Submit\"\r\n"];
     [bodyString appendString:@"\r\n"];
     [bodyString appendString:@"upload"];
     [bodyString appendString:@"\r\n"];

     [bodyString appendFormat:@"--%@\r\n", BOUNDARY];

     [bodyString appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"6.png\"\r\n"];
     [bodyString appendString:@"Content-Type: image/png\r\n"];
     [bodyString appendString:@"\r\n"];


     NSLog(@"bodyString == %@",bodyString);
     NSData *imgData = UIImageJPEGRepresentation(self.imgUpload, 0.5);

     NSMutableData *bodyData = [[NSMutableData alloc] init];
     NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

     [bodyData appendData:bodyStringData];

     [bodyData appendData:imgData];


     NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];

     NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
     [bodyData appendData:endData];

     NSString *len = [NSString stringWithFormat:@"%d", [bodyData length]];
     // 计算bodyData的总长度  根据该长度写Content-Lenngth字段

     [request addValue:len forHTTPHeaderField:@"Content-Length"];

     
     if (_fatherView) {
         hud = [[MBProgressHUD alloc] initWithView:_fatherView];
         hud.removeFromSuperViewOnHide = YES;
         hud.dimBackground = YES;
         [_fatherView addSubview:hud];
         hud.labelText = @"图片上传中...";
         [hud show:YES];
     }
     
   
     // 设置请求体
     [request setHTTPBody:bodyData];


     connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     [connection start];
 }

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (recvData == nil) {
        recvData = [[NSMutableData alloc] init];
    }
    recvData.length = 0;

}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recvData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"失败===================%@",error);
    if (_fatherView) {
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didFailUploadImg:withTag:)]) {
        [_delegate didFailUploadImg:error withTag:self.index];
    }
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSError * error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"Post上传图片URL结果：%@",[Utils dictionaryToString:dic]);
    if (_fatherView) {
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }

    if (!error)
    {
        if (kSaftToNSInteger(dic[@"retCode"]) != 200 &&
            _delegate && [_delegate respondsToSelector:@selector(didFailUploadImg:withTag:)])
        {
            [_delegate didFailUploadImg:[NSError errorWithDomain:@"图片上传失败" code:-100 userInfo:nil] withTag:self.index];
            return;
        }
        
        if (_delegate) {
            NSURL * url = [NSURL URLWithString:kSaftToNSString(dic[@"data"][@"source"])];
            NSString * picUrlString =[NSString stringWithFormat:@"%@",url];
            NSString * hsPicName =[picUrlString lastPathComponent];
             NSLog(@"%@-------hspic",hsPicName);

            switch (self.urlType) {
                case 1:   //互动里面修改头像 1
                {
                     NSURL * url2 = [NSURL URLWithString:dic[@"imgUrl"]];
                    
//                 [_delegate didFinishUploadImg:url2 withTag:self.index];
                    
                    [ _delegate  didFinishUploadImg:url2  withBigImg :[NSURL URLWithString:dic[@"imgBigUrl"] ] withTag: self.index];
                    
                    
                }
                    break;
                case 2:   //2：互生实名认证
                {
                    [_delegate didFinishUploadImg:[NSURL URLWithString:hsPicName] withTag:self.index];
                    
                    NSLog(@"%@-------hspic",hsPicName);
                    
                }
                    break;
                case 3:  // 轻松购 ：售后传图片
                {
                    if (kSaftToNSInteger(dic[@"retCode"]) == 200)//成功
                    {
                        [_delegate didFinishUploadImg:url withTag:self.index];
                    }else
                    {
                        if (_delegate && [_delegate respondsToSelector:@selector(didFailUploadImg:withTag:)])
                        {
                            [_delegate didFailUploadImg:[NSError errorWithDomain:@"com.didFailUploadImg.gy" code:-66 userInfo:nil] withTag:self.index];
                        }
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    
}

//解析传过来的 字典参数
-(NSString *)httpBodyWithParameters:(NSDictionary *)parameters
{
    if (!parameters) return @"";//防止解析空参数
    
    NSMutableArray *parametersArray = [NSMutableArray array];
    for (NSString * key in [parameters allKeys])
    {
        id value = [parameters objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key, [self serializeDictionary:value]]];
        }
        
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

//序列化GET请求体内部字典
-(NSString *)serializeDictionary :(NSDictionary *)dict
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString * key in [dict allKeys])
    {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    NSString * str =[NSString stringWithFormat:@"{%@}",[parametersArray componentsJoinedByString:@","]];
    
    return str;
    
    
    
}

@end
