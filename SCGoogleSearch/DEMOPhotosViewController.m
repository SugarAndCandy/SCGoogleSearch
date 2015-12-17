//
//  SCPhotosViewController.m
//  PostVk
//
//  Created by Maxim Kolesnik on 13.12.15.
//  Copyright © 2015 Sugar And Candy. All rights reserved.
//

#import "DEMOPhotosViewController.h"
#import "DEMOImageCollectionViewCell.h"

#import "SCGoogleSearch.h"
#import "SCGoogleImage.h"

#import <SDWebImage/UIImageView+WebCache.h>

//#define KEY2 @"AIzaSyDd1g4NBEFs6HDTM_sIiCNBZ6xgWhXG-8c"
#define KEY2 @"AIzaSyAtqssK4pLcAzGAqbEFFxUworMvHrjB1r4"
#define CX2 @"012427825985234021561:6gtfp1fax-a"

@interface DEMOPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SCGoogleSearch *search;

@end

@implementation DEMOPhotosViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    self.search = [[SCGoogleSearch alloc]initWithKey:KEY2 withCx:CX2];
    [self.search loadPicturesWithName:@"большие Корабли" complition:^(NSArray<SCGoogleImage *> *objects, SCGooglePagination *pagination, NSError *failure) {
        self.data = [NSMutableArray arrayWithArray:objects];
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DEMOImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    SCGoogleImage *image = [self.data objectAtIndex:indexPath.row];
    [cell.googleImage sd_setImageWithURL:[NSURL URLWithString:image.link]
                        placeholderImage:nil];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%lu",(unsigned long)self.data.count);
    NSLog(@"%lu",(unsigned long)indexPath.row);

//    if (self.data.count == indexPath.row + 1) {
//        
//        [self.search loadNextPageWithComplition:^(NSArray<SCGoogleImage *> *objects, SCGooglePagination *pagination, NSError *failure) {
//            [self.data addObjectsFromArray:objects];
//            [self.collectionView reloadData];
//
//        }];
//    }
}


@end
