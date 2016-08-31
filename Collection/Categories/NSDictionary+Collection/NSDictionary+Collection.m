//
//  NSDictionary+Collection.m
//  Collection
//
//  Created by Jordi Puigdellívol on 10/8/16.
//  Copyright © 2016 Revo. All rights reserved.
//

#import "NSDictionary+Collection.h"

@implementation NSDictionary (Collection)

//===================================
#pragma mark - Converters
//===================================
+(NSDictionary*)fromData:(NSData*)data{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}

-(NSString*)toString{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&err];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//===================================
#pragma mark - Collection
//===================================
- (void)each:(void(^)(id key, id object))operation{
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        operation(key, obj);
    }];
}

- (NSDictionary*)filter:(BOOL (^)(id key, id object))condition{
    
    NSSet *keys = [self keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return condition(key,obj);
    }];
    return [self dictionaryWithValuesForKeys:keys.allObjects];
}

- (NSDictionary*)reject:(BOOL (^)(id key, id object))condition{
    
    NSSet *keys = [self keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return ! condition(key,obj);
    }];
    return [self dictionaryWithValuesForKeys:keys.allObjects];
}

- (NSDictionary*)map:(id (^)(id key, id object))callback{
    NSMutableDictionary* newDictionary = [NSMutableDictionary new];
    [self each:^(id key, id object) {
        newDictionary[key] = callback(key,object);
    }];
    return newDictionary;
}
@end
