//
//  FLOViewController.m
//  ResizeUICollectionViewCell
//
//  Created by Justin on 4/18/14.
//  Copyright (c) 2014 Stackoverflow. All rights reserved.
//

#import "FLOViewController.h"

@interface FLOViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSCache *cellHeightCache;
@end

@implementation FLOViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.cellHeightCache = [NSCache new];
    }
    return self;
}

#pragma mark - Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self cellForIndexPath:indexPath collectionView:collectionView];
    return cell;
}

#pragma mark - Flow Layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get collection view usable width
    UIEdgeInsets sectionInsets = ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset;
    CGFloat width = CGRectGetWidth(collectionView.frame) - sectionInsets.left - sectionInsets.right;
    
    // Get height from cache
    CGFloat height = [[self.cellHeightCache objectForKey:indexPath] floatValue];
    
    // If none, default to 60
    if (!height) {
        height = 60;
    }
    
    return CGSizeMake(width, height);
}

#pragma mark - Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self cellForIndexPath:indexPath collectionView:collectionView];
    
    // Get cached (overridden) cell height
    CGFloat height = [[self.cellHeightCache objectForKey:indexPath] floatValue];
    
    // Toggle cell height
    if (height) {
        [self.cellHeightCache removeObjectForKey:indexPath];
    } else {
        [self.cellHeightCache setObject:@(200) forKey:indexPath];
    }
    
    // New cell frame
    CGRect newFrame = cell.frame;
    newFrame.size.height = height;
    
    // Invalidate layout (disables animation)
    // [collectionView.collectionViewLayout invalidateLayout];
    
    // Animate cell changes
    [collectionView performBatchUpdates:^{
        cell.frame = newFrame;
    } completion:nil];
    
}

#pragma mark - Utility

- (UICollectionViewCell *)cellForIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView
{
    NSString *cellIdentifier = [indexPath item] == 0 ? @"targetCell" : @"otherCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
