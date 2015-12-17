//
//  SCIGoogleImage.h
//  PostVk
//
//  Created by Maxim Kolesnik on 15.12.15.
//  Copyright © 2015 Sugar And Candy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SCGoogleImageMime) {
    SCGoogleImageMimeJpeg,
    SCGoogleImageMimePng,
    SCGoogleImageMimeOther
};

@interface SCGoogleImage : NSObject

@property (nonatomic, assign) NSInteger byteSize;
@property (nonatomic, strong) NSString *contextLink;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) SCGoogleImageMime mime;
@property (nonatomic, strong) NSString *title;
@end
