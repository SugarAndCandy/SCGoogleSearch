//
//  SCGoogleSearch.h
//  PostVk
//
//  Created by Maxim Kolesnik on 14.12.15.
//  Copyright © 2015 Sugar And Candy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCGoogleImage,SCGooglePagination;

extern NSString * const SC_GS_KEY;
extern NSString * const SC_GS_CONTEXT;
extern NSString * const SC_GS_LIMIT;
extern NSString * const SC_GS_SEARCH_TYPE;
extern NSString * const SC_GS_QUERRY;
extern NSString * const SC_GS_PRESENTATION_TYPE;
extern NSString * const SC_GS_ALT;
extern NSString * const SC_GS_START;
extern NSString * const SC_GS_C2COFF;
extern NSString * const SC_GS_CR;
extern NSString * const SC_GS_CREF;
extern NSString * const SC_GS_DATE_RESTRICT;
extern NSString * const SC_GS_EXACT_TERMS;
extern NSString * const SC_GS_EXCLIDE_TERMS;
extern NSString * const SC_GS_FILE_TYPE;
extern NSString * const SC_GS_FILTER;

typedef void (^success)(NSArray <SCGoogleImage *> *objects,SCGooglePagination *pagination, NSError *failure);

/**
 *  Simpe implementation for Google Custom Search API
 *  @code //simple initialization
    SCGoogleSearch googleSearch = [[SCGoogleSearch alloc]initWithKey:YOUR_KEY_HERE withCx:YOUR_CX_HERE];
 *  @endcode
 *  @note this class help you to search images only (next version apply article, documents, pages)
 */
@interface SCGoogleSearch : NSObject

/**
 *  Your API key (using the key query parameter).
 */
@property (nonatomic, strong, readonly) NSString *key;

/**
 *  The search engine to use in your request (using either the cx query parameters)
 *  @discussion If both cx and cref are specified, the cx value is used.
 *  @note If both cx and cref are specified, the cx value is used.
 */
@property (nonatomic, strong, readonly) NSString *context;

/**
 *  simple SCGoogleSearch initialization
 *
 *  @param key       Your API key (using the key query parameter).
 *  @param context   The search engine to use in your request (using either the cx query parameters)
 *
 *  @return return initialization SCGoogleSearch object
 */
-(id)initWithKey:(NSString *)key withCx:(NSString *)context;

/**
 *  search pictures with name
 *
 *  @param name       request name
 *  @param complition complition block returns SCGoogleImage objects, SCGooglePagination pagination info and error
 */
-(void)loadPicturesWithName:(NSString *)name complition:(success)complition;

/**
 *  search pictures with name at page
 *
 *  @param name       request name
 *  @param startPage  page you want to found
 *  @param complition complition block returns SCGoogleImage objects, SCGooglePagination pagination info and error
 */
-(void)loadPicturesWithName:(NSString *)name withStart:(NSInteger)startPage complition:(success)complition;

/**
 *  load next page of query
 *  @warning you should use it after loadPicturesWithName:complition: or another
 *  @param complition complition block returns SCGoogleImage objects, SCGooglePagination pagination info and error
 */
-(void)loadNextPageWithComplition:(success)complition;

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

/********************************************************/
/*********************Optionals**************************/
/********************************************************/

/**
 *  Enables or disables Simplified and Traditional Chinese Search.
 *  The default value for this parameter is 0 (zero), meaning that the feature is enabled. Supported values are:
 *  true : Disabled
 *  false : Enabled (default)
 */
@property (nonatomic, assign) BOOL c2coff;

/**
 *  Restricts search results to documents originating in a particular country.
 *  Examples: cr=@"countryNZ"
 *  @see https://developers.google.com/custom-search/docs/xml_results#countryCollections
 */
@property (nonatomic, strong) NSString *cr;

/**
 *  The URL of a linked custom search engine specification to use for this request.
 *  @note If both cx and cref are specified, the cx value is used
 *  @warning Does not apply for Google Site Search
 *  @see https://cse.google.com/docs/cref.html
 */
@property (nonatomic, strong) NSString *cref;
/**
 *  Restricts results to URLs based on date. Supported values include:
 *  d[number]: requests results from the specified number of past days.
 *  w[number]: requests results from the specified number of past weeks.
 *  m[number]: requests results from the specified number of past months.
 *  y[number]: requests results from the specified number of past years.
   @code googleSearch.dateRestrict = @"d20";
   googleSearch.dateRestrict = @"y1";
   @endcode
 */
@property (nonatomic, strong) NSString *dateRestrict;

/**
 *  Identifies a phrase that all documents in the search results must contain
 */
@property (nonatomic, strong) NSString *exactTerms;

/**
 *  Identifies a word or phrase that should not appear in any documents in the search results.
 */
@property (nonatomic, strong) NSString *excludeTerms;

/**
 *  Restricts results to files of a specified extension. 
 *  A list of file types indexable by Google can be found in Webmaster Tools Help Center.
 *  @see https://support.google.com/webmasters/answer/35287?hl=en
 */
@property (nonatomic, strong) NSString *fileType;

/**
 *  Controls turning on or off the duplicate content filter.
 *  Acceptable values are:
 *  "0": Turns off duplicate content filter.
 *  "1": Turns on duplicate content filter.
 *  @note By default, Google applies filtering to all search results to improve the quality of those results.
 *  @see https://developers.google.com/custom-search/docs/xml_results#automaticFiltering
 */
@property (nonatomic, assign) BOOL filter;
@end
