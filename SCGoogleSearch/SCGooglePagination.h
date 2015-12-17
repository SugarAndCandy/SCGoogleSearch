//
//  SCGooglePagination.h
//  PostVk
//
//  Created by Maxim Kolesnik on 15.12.15.
//  Copyright © 2015 Sugar And Candy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SCGooglePaginationType) {
    SCGooglePaginationTypePreviosPage,
    SCGooglePaginationTypeNextPage,
    SCGooglePaginationTypeRequest,
};
@interface SCGooglePagination : NSObject

@property (nonatomic, assign) SCGooglePaginationType paginationType;
@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, assign) NSInteger count;

@end
