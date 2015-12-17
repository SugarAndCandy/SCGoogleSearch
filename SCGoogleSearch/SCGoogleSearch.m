//
//  SCGoogleSearch.m
//  PostVk
//
//  Created by Maxim Kolesnik on 14.12.15.
//  Copyright © 2015 Sugar And Candy. All rights reserved.
//

#import "SCGoogleSearch.h"

#import "SCGoogleImage.h"
#import "SCGooglePagination.h"

#import <AFNetworking/AFNetworking.h>

NSString * const SC_GS_KEY = @"key";
NSString * const SC_GS_CONTEXT = @"cx";
NSString * const SC_GS_LIMIT = @"key";
NSString * const SC_GS_QUERRY = @"q";
NSString * const SC_GS_SEARCH_TYPE = @"searchType";
NSString * const SC_GS_PRESENTATION_TYPE = @"alt";
NSString * const SC_GS_ALT = @"alt";
NSString * const SC_GS_START = @"start";
NSString * const SC_GS_IMAGE = @"image";
NSString * const SC_GS_JSON = @"json";
NSString * const SC_GS_C2COFF = @"c2coff";
NSString * const SC_GS_CR = @"cr";
NSString * const SC_GS_CREF = @"cref";
NSString * const SC_GS_DATE_RESTRICT = @"dateRestrict";
NSString * const SC_GS_EXACT_TERMS = @"exactTerms";
NSString * const SC_GS_EXCLIDE_TERMS = @"excludeTerms";
NSString * const SC_GS_FILE_TYPE = @"fileType";
NSString * const SC_GS_FILTER = @"filter";

@interface SCGoogleSearch ()

@property (nonatomic, strong) SCGooglePagination *requestPagination;
@property (nonatomic, strong) SCGooglePagination *nextPagePagination;
@property (nonatomic, strong) SCGooglePagination *previousPagePagination;
@property (nonatomic, strong) NSString *searchTerms;

@end

@implementation SCGoogleSearch
-(void)loadNextPageWithComplition:(success)complition {
    [self loadPicturesWithName:self.searchTerms withStart:self.nextPagePagination.startIndex complition:complition];
}

-(void)loadPicturesWithName:(NSString *)name complition:(success)complition {
    self.requestPagination.startIndex = 1;
    [self loadPicturesWithName:name withStart:1 complition:complition];
}

-(void)loadPicturesWithName:(NSString *)name withStart:(NSInteger)startPage complition:(success)complition {
    NSParameterAssert(name);
    NSParameterAssert(name.length > 0);
    self.searchTerms = name;
    NSParameterAssert(startPage > 0);
    self.requestPagination.startIndex = startPage;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.key forKey:SC_GS_KEY];
    [parameters setObject:self.context forKey:SC_GS_CONTEXT];
    [parameters setObject:name forKey:SC_GS_QUERRY];
    [parameters setObject:SC_GS_IMAGE forKey:SC_GS_SEARCH_TYPE];
    [parameters setObject:SC_GS_JSON forKey:SC_GS_ALT];
    [parameters setObject:@(self.requestPagination.startIndex) forKey:SC_GS_START];
    
    NSDictionary *optionalParameters = [self applyOptionalParameters];
    NSArray *optionalKeys = [optionalParameters allKeys];
    for (NSString *key in optionalKeys) {
        [parameters setObject:[optionalParameters objectForKey:key] forKey:key];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://www.googleapis.com/"]];
    [manager GET:@"customsearch/v1"
      parameters:[NSDictionary dictionaryWithDictionary:parameters]
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSMutableArray *googleImages = [NSMutableArray array];
             //NSLog(@"%@",responseObject);
             NSDictionary *responce = responseObject;
             NSLog(@"%@",[responce objectForKey:@"items"]);
             NSArray *items = [responce objectForKey:@"items"];
             for (NSDictionary *item in items) {
                 NSLog(@"%@",item);
                 SCGoogleImage *googleImage = [[SCGoogleImage alloc]init];
                 googleImage.link = [item objectForKey:@"link"];
                 NSLog(@"%@",[item objectForKey:@"link"]);
                 googleImage.title = [item objectForKey:@"title"];
                 if ([[item objectForKey:@"title"] isEqualToString:@"image/jpeg"]) {
                     googleImage.mime = SCGoogleImageMimeJpeg;
                 } else if ([[item objectForKey:@"title"] isEqualToString:@"image/png"]) {
                     googleImage.mime = SCGoogleImageMimePng;
                 } else {
                     googleImage.mime = SCGoogleImageMimeOther;
                 }
                 NSDictionary *image = [item objectForKey:@"image"];
                 googleImage.byteSize = [[image objectForKey:@"byteSize"] integerValue];
                 googleImage.contextLink = [image objectForKey:@"byteSize"];
                 googleImage.size = CGSizeMake([[image objectForKey:@"width"] integerValue],
                                               [[image objectForKey:@"height"] integerValue]);
                 [googleImages addObject:googleImage];
             }
             
             NSDictionary *queries = [responce objectForKey:@"queries"];
             
             NSDictionary *nextPage = [[queries objectForKey:@"nextPage"] firstObject];
             NSDictionary *request = [[queries objectForKey:@"request"] firstObject];
             NSDictionary *previousPage = [[queries objectForKey:@"previousPage"] firstObject];
             
             SCGooglePagination *nextPagePagination = [[SCGooglePagination alloc]init];
             nextPagePagination.paginationType = SCGooglePaginationTypeNextPage;
             nextPagePagination.startIndex = [[nextPage objectForKey:@"startIndex"] integerValue];
             nextPagePagination.count = [[nextPage objectForKey:@"count"] integerValue];
             self.nextPagePagination = nextPagePagination;
             
             SCGooglePagination *requestPagination = [[SCGooglePagination alloc]init];
             requestPagination.paginationType = SCGooglePaginationTypeRequest;
             requestPagination.startIndex = [[request objectForKey:@"startIndex"] integerValue];
             requestPagination.count = [[nextPage objectForKey:@"count"] integerValue];
             self.requestPagination = requestPagination;
             
             SCGooglePagination *previousPagePagination = [[SCGooglePagination alloc]init];
             previousPagePagination.paginationType = SCGooglePaginationTypePreviosPage;
             previousPagePagination.startIndex = [[previousPage objectForKey:@"startIndex"] integerValue];
             previousPagePagination.count = [[nextPage objectForKey:@"count"] integerValue];
             self.previousPagePagination = previousPagePagination;
             
             if (complition) {
                 complition([NSArray arrayWithArray:googleImages], self.requestPagination, nil);
             }
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             if (complition) {
                 complition(nil, nil, error);
             }
             NSLog(@"%@",error.userInfo);
         }];
}

-(NSDictionary *)applyOptionalParameters {
    
    NSMutableDictionary *optionalParameters = [NSMutableDictionary dictionary];
    
    [optionalParameters setObject:@(self.c2coff) forKey:SC_GS_C2COFF];
    [optionalParameters setObject:@(self.filter) forKey:SC_GS_FILTER];
    
    if (self.cr) {
        [optionalParameters setObject:self.cr forKey:SC_GS_CR];
    }
    if (self.cref) {
        [optionalParameters setObject:self.cref forKey:SC_GS_CREF];
    }
    if (self.dateRestrict) {
        [optionalParameters setObject:self.dateRestrict forKey:SC_GS_DATE_RESTRICT];
    }
    if (self.exactTerms) {
        [optionalParameters setObject:self.exactTerms forKey:SC_GS_EXACT_TERMS];
    }
    if (self.excludeTerms) {
        [optionalParameters setObject:self.excludeTerms forKey:SC_GS_EXCLIDE_TERMS];
    }
    if (self.fileType) {
        [optionalParameters setObject:self.fileType forKey:SC_GS_FILE_TYPE];
    }
    return [NSDictionary dictionaryWithDictionary:optionalParameters];
}

-(id)initWithKey:(NSString *)key withCx:(NSString *)context{
    self = [super init];
    if (self) {
        _key = key;
        _context = context;
        self.c2coff = NO;
        self.filter = YES;
        self.requestPagination = [[SCGooglePagination alloc]init];
        self.requestPagination.startIndex = 1;
        self.requestPagination.count = 10;
        
        self.nextPagePagination = [[SCGooglePagination alloc]init];
        self.nextPagePagination.startIndex = 0;
        self.nextPagePagination.count = 10;
        
        self.previousPagePagination = [[SCGooglePagination alloc]init];
        self.previousPagePagination.startIndex = 0;
        self.previousPagePagination.count = 10;
        
    }
    return self;
}


@end
