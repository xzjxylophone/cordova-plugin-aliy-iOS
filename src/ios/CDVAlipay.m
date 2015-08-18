//
//  CDVAlipay.m
//  X5
//
//  Created by 007slm on 12/8/14.
//
//

#import "CDVAlipay.h"
#import "AlipayOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation CDVAlipay
-(void)handleOpenURL:(NSNotification *)notification{
    NSURL* url = [notification object];
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if (url!=nil && [url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]];
             [self.commandDelegate sendPluginResult:result callbackId:self.currentCallbackId];
             [self endForExec];
         }];
    }
}


-(void)pluginInitialize{
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    self.partner = [viewController.settings objectForKey:@"partner"];
    self.alipayScheme = [viewController.settings objectForKey:@"alipay_scheme"];
    self.rsa_private = [viewController.settings objectForKey:@"rsa_private"];
    self.rsa_public = [viewController.settings objectForKey:@"rsa_public"];
}


-(void) prepareForExec:(CDVInvokedUrlCommand *)command{
    self.currentCallbackId = command.callbackId;
    
}


-(void) endForExec{
    self.currentCallbackId = nil;
}


- (void)pay:(CDVInvokedUrlCommand*)command{
    [self prepareForExec:command];
    NSString *orderString = [command.arguments objectAtIndex:0];
    
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString != nil) {
        NSLog(@"orderString = %@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]];
            [self.commandDelegate sendPluginResult:result callbackId:self.currentCallbackId];
            [self endForExec];
        }];
    }
}

@end
