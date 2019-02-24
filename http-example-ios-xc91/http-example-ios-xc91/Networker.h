//
//  Networker.h
//  http-example-ios
//
//  Created by Patrick Madden on 2/23/19.
//  Copyright © 2019 Binghamton University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Networker : NSObject
@property (nonatomic, strong) NSString *baseURL;
-(void)push:(NSString *)url keys:(NSDictionary *)keys file:(NSString *)file completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
