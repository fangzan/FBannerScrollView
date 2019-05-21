//
//  ViewController.m
//  FBannerScrollView
//
//  Created by AoChen on 2019/5/21.
//  Copyright © 2019 Ac. All rights reserved.
//

#import "ViewController.h"
#import "FBannerScrollView-Swift.h"
#import "FSPageView/FSPagerViewObjcCompat.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate>
@property (strong, nonatomic) NSArray<NSString *> *sectionTitles;
@property (strong, nonatomic) NSArray<NSString *> *configurationTitles;
@property (strong, nonatomic) NSArray<NSString *> *decelerationDistanceOptions;
@property (strong, nonatomic) NSArray<NSString *> *transformerNames;
@property (assign, nonatomic) NSInteger typeIndex;
@property (strong, nonatomic) NSArray<NSString *> *pageControlStyles;
@property (strong, nonatomic) NSArray<NSString *> *pageControlAlignments;
@property (assign, nonatomic) NSInteger styleIndex;
@property (assign, nonatomic) NSInteger alignmentIndex;
@property (strong, nonatomic) NSArray<NSString *> *scrollDirections;
@property (assign, nonatomic) NSInteger scrollDirectionType;

@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@property (assign, nonatomic) NSInteger numberOfItems;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) FSPagerView* pagerView;
@property (nonatomic, strong) FSPageControl* pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTitles = @[@"Configurations", @"Deceleration Distance", @"Item Size", @"Interitem Spacing", @"Number Of Items",@"Transformers",@"Style", @"Item Spacing", @"Interitem Spacing", @"Horizontal Alignment",@"ScrollDirection"];
    self.configurationTitles = @[@"Automatic sliding", @"Infinite",@"IsPositive"];
    self.decelerationDistanceOptions = @[@"Automatic", @"1", @"2"];
    self.imageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"];
    self.transformerNames = @[@"cross fading", @"zoom out", @"depth", @"linear", @"overlap", @"ferris wheel", @"inverted ferris wheel", @"coverflow", @"cubic"];
    self.pageControlStyles = @[@"Default", @"Ring", @"UIImage", @"UIBezierPath - Star", @"UIBezierPath - Heart"];
    self.pageControlAlignments = @[@"Right", @"Center", @"Left"];
    self.scrollDirections = @[@"DirectionHorizontal", @"DirectionVertical"];
    self.typeIndex = 0;
    self.numberOfItems = 7;
    
    [self.view addSubview:self.pagerView];
    [self.pagerView addSubview:self.pageControl];
    [self.view addSubview:self.tableView];
}

- (FSPagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[FSPagerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [_pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
        _pagerView.scrollDirection = ScrollDirectionVertical;
        _pagerView.itemSize = FSPagerViewAutomaticSize;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
    }
    return _pagerView;
}

- (FSPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(self.pagerView.frame))];
        _pageControl.numberOfPages = self.imageNames.count;
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return _pageControl;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pagerView.frame), CGRectGetWidth(self.view.frame), self.view.frame.size.height - CGRectGetMaxY(self.pagerView.frame))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.configurationTitles.count;
        case 1:
            return self.decelerationDistanceOptions.count;
        case 2:
        case 3:
        case 4:
            return 1;
        case 5:
            return self.transformerNames.count;
        case 6:
            return self.pageControlStyles.count;
        case 7:
        case 8:
            return 1;
        case 9:
            return self.pageControlAlignments.count;
        case 10:
            return self.scrollDirections.count;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            // Configurations
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = self.configurationTitles[indexPath.row];
            if (indexPath.row == 0) {
                // Automatic Sliding
                cell.accessoryType = self.pagerView.automaticSlidingInterval > 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            } else if (indexPath.row == 1) {
                // IsInfinite
                cell.accessoryType = self.pagerView.isInfinite ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            } else if (indexPath.row == 2) {
                cell.accessoryType = self.pagerView.isPositive ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
            return cell;
        }
        case 1: {
            // Decelaration Distance
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = self.decelerationDistanceOptions[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    // Hardcode like '-1' is bad for readability, but there haven't been a better solution to export a swift constant to objective-c yet.
                    cell.accessoryType = self.pagerView.decelerationDistance == FSPagerViewAutomaticDistance ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                case 1:
                    cell.accessoryType = self.pagerView.decelerationDistance == 1 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                case 2:
                    cell.accessoryType = self.pagerView.decelerationDistance == 2 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                default:
                    break;
            }
            return cell;
        }
        case 2: {
            // Item Spacing
            FATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            if (!cell) {
                cell = [[FATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slider_cell"];
            }
            [cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.slider.tag = 1;
            cell.slider.value = ({
                CGFloat scale = self.pagerView.itemSize.width/self.pagerView.frame.size.width;
                CGFloat value = (0.5-scale)*2;
                value;
            });
            cell.slider.continuous = YES;
            return cell;
        }
        case 3: {
            // Interitem Spacing
            FATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            if (!cell) {
                cell = [[FATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slider_cell"];
            }
            [cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.slider.tag = 2;
            cell.slider.value = self.pagerView.interitemSpacing / 20.0;
            cell.slider.continuous = YES;
            return cell;
        }
        case 4: {
            // Number Of Items
            FATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            if (!cell) {
                cell = [[FATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slider_cell"];
            }
            [cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.slider.tag = 3;
            cell.slider.value = self.numberOfItems / 7.0;
            cell.slider.minimumValue = 1.0 / 7;
            cell.slider.maximumValue = 1.0;
            cell.slider.continuous = NO;
            return cell;
        }
        case 5:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = self.transformerNames[indexPath.row];
            cell.accessoryType = indexPath.row == self.typeIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
        case 6: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = self.pageControlStyles[indexPath.row];
            cell.accessoryType = self.styleIndex==indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
        case 7: {
            FATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            if (!cell) {
                cell = [[FATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slider_cell"];
            }
            [cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.slider.tag = 4;
            cell.slider.value = (self.pageControl.itemSpacing-6.0)/10.0;
            return cell;
        }
        case 8: {
            FATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            if (!cell) {
                cell = [[FATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slider_cell"];
            }
            [cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.slider.tag = 5;
            cell.slider.value = (self.pageControl.interitemSpacing-6.0)/10.0;
            return cell;
        }
        case 9: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = self.pageControlAlignments[indexPath.row];
            cell.accessoryType = self.alignmentIndex==indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
        case 10: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = self.scrollDirections[indexPath.row];
            cell.accessoryType = self.scrollDirectionType==indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 9 || indexPath.section == 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                // Automatic Sliding
                self.pagerView.automaticSlidingInterval = 3.0 - self.pagerView.automaticSlidingInterval;
            } else if (indexPath.row == 1) {
                // IsInfinite
                self.pagerView.isInfinite = !self.pagerView.isInfinite;
            } else if (indexPath.row == 2) {
                self.pagerView.isPositive = !self.pagerView.isPositive;
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0:
                    self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
                    break;
                case 1:
                    self.pagerView.decelerationDistance = 1;
                    break;
                case 2:
                    self.pagerView.decelerationDistance = 2;
                    break;
                default:
                    break;
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 5: {
            self.typeIndex = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 6: {
            self.styleIndex = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 9: {
            self.alignmentIndex = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 10: {
            self.scrollDirectionType = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 40 : 20;
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView
{
    return self.numberOfItems;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@(index),@(index)];
    return cell;
}

#pragma mark - FSPagerView Delegate

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
}

- (void)pagerViewWillEndDragging:(FSPagerView *)pagerView targetIndex:(NSInteger)targetIndex
{
    self.pageControl.currentPage = targetIndex;
}

- (void)pagerViewDidEndScrollAnimation:(FSPagerView *)pagerView
{
    self.pageControl.currentPage = pagerView.currentIndex;
}

#pragma mark - Target actions
- (void)sliderValueChanged:(UISlider *)sender
{
    switch (sender.tag) {
        case 1: {
            CGFloat scale = 0.5 * (1 + sender.value); // [0.5 - 1.0]
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, CGAffineTransformMakeScale(scale, scale));
            break;
        }
        case 2: {
            self.pagerView.interitemSpacing = sender.value * 20; // [0 - 20]
            break;
        }
        case 3: {
            self.numberOfItems = roundf(sender.value * 7);
            self.pageControl.numberOfPages = self.numberOfItems;
            [self.pagerView reloadData];
            break;
        }
        case 4: {
            self.pageControl.itemSpacing = 6.0 + sender.value*10.0; // [6 - 16]
            // Redraw UIBezierPath
            if (self.styleIndex == 3 || self.styleIndex == 4) {
                self.styleIndex = self.styleIndex;
            }
            break;
        }
        case 5: {
            self.pageControl.interitemSpacing = 6.0 + sender.value*10.0; // [6 - 16]
            break;
        }
        default:
            break;
    }
}

- (void)setScrollDirectionType:(NSInteger)scrollDirectionType{
    _scrollDirectionType = scrollDirectionType;
    self.pagerView.scrollDirection = scrollDirectionType;
}

- (void)setTypeIndex:(NSInteger)typeIndex
{
    _typeIndex = typeIndex;
    FSPagerViewTransformerType type;
    switch (typeIndex) {
        case 0: {
            type = FSPagerViewTransformerTypeCrossFading;
            break;
        }
        case 1: {
            type = FSPagerViewTransformerTypeZoomOut;
            break;
        }
        case 2: {
            type = FSPagerViewTransformerTypeDepth;
            break;
        }
        case 3: {
            type = FSPagerViewTransformerTypeLinear;
            break;
        }
        case 4: {
            type = FSPagerViewTransformerTypeOverlap;
            break;
        }
        case 5: {
            type = FSPagerViewTransformerTypeFerrisWheel;
            break;
        }
        case 6: {
            type = FSPagerViewTransformerTypeInvertedFerrisWheel;
            break;
        }
        case 7: {
            type = FSPagerViewTransformerTypeCoverFlow;
            break;
        }
        case 8: {
            type = FSPagerViewTransformerTypeCubic;
            break;
        }
        default:
            type = FSPagerViewTransformerTypeZoomOut;
            break;
    }
    self.pagerView.transformer = [[FSPagerViewTransformer alloc] initWithType:type];
    switch (type) {
        case FSPagerViewTransformerTypeCrossFading:
        case FSPagerViewTransformerTypeZoomOut:
        case FSPagerViewTransformerTypeDepth: {
            self.pagerView.itemSize = CGSizeZero;
            self.pagerView.decelerationDistance = 1;
            break;
        }
        case FSPagerViewTransformerTypeLinear:
        case FSPagerViewTransformerTypeOverlap: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.6, 0.75);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
            break;
        }
        case FSPagerViewTransformerTypeFerrisWheel:
        case FSPagerViewTransformerTypeInvertedFerrisWheel: {
            self.pagerView.itemSize = CGSizeMake(180, 140);
            self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
            break;
        }
        case FSPagerViewTransformerTypeCoverFlow: {
            self.pagerView.itemSize = CGSizeMake(220, 170);
            self.pagerView.decelerationDistance = FSPagerViewAutomaticDistance;
            break;
        }
        case FSPagerViewTransformerTypeCubic: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            self.pagerView.decelerationDistance = 1;
            break;
        }
        default:
            break;
    }
}

- (void)setAlignmentIndex:(NSInteger)alignmentIndex
{
    _alignmentIndex = alignmentIndex;
    switch (alignmentIndex) {
        case 0: {
            self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        }
        case 1: {
            self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;
        }
        case 2: {
            self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        }
        default:
            break;
    }
}

- (void)setStyleIndex:(NSInteger)styleIndex
{
    _styleIndex = styleIndex;
    // Clean up
    [self.pageControl setStrokeColor:nil forState:UIControlStateNormal];
    [self.pageControl setStrokeColor:nil forState:UIControlStateSelected];
    [self.pageControl setFillColor:nil forState:UIControlStateNormal];
    [self.pageControl setFillColor:nil forState:UIControlStateSelected];
    [self.pageControl setImage:nil forState:UIControlStateNormal];
    [self.pageControl setImage:nil forState:UIControlStateSelected];
    [self.pageControl setPath:nil forState:UIControlStateNormal];
    [self.pageControl setPath:nil forState:UIControlStateSelected];
    switch (styleIndex) {
        case 0: {
            // Default
            break;
        }
        case 1: {
            // Ring
            [self.pageControl setStrokeColor:[UIColor greenColor] forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:[UIColor greenColor] forState:UIControlStateSelected];
            [self.pageControl setFillColor:[UIColor greenColor] forState:UIControlStateSelected];
            break;
        }
        case 2: {
            // UIImage
            [self.pageControl setImage:[UIImage imageNamed:@"icon_footprint"] forState:UIControlStateNormal];
            [self.pageControl setImage:[UIImage imageNamed:@"icon_cat"] forState:UIControlStateSelected];
            break;
        }
        case 3: {
            // UIBezierPath - Star
            [self.pageControl setStrokeColor:[UIColor yellowColor] forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [self.pageControl setFillColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [self.pageControl setPath:self.starPath forState:UIControlStateNormal];
            [self.pageControl setPath:self.starPath forState:UIControlStateSelected];
            break;
        }
        case 4: {
            // UIBezierPath - Heart
            UIColor *color = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:255/255.0 alpha:1.0];
            [self.pageControl setStrokeColor:color forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:color forState:UIControlStateSelected];
            [self.pageControl setFillColor:color forState:UIControlStateSelected];
            [self.pageControl setPath:self.heartPath forState:UIControlStateNormal];
            [self.pageControl setPath:self.heartPath forState:UIControlStateSelected];
            break;
        }
        default:
            break;
    }
    
}

// ⭐️
- (UIBezierPath *)starPath
{
    CGFloat width = self.pageControl.itemSpacing;
    CGFloat height = self.pageControl.itemSpacing;
    UIBezierPath *starPath = [[UIBezierPath alloc] init];
    [starPath moveToPoint:CGPointMake(width*0.5, 0)];
    [starPath addLineToPoint:CGPointMake(width*0.677, height*0.257)];
    [starPath addLineToPoint:CGPointMake(width*0.975, height*0.345)];
    [starPath addLineToPoint:CGPointMake(width*0.785, height*0.593)];
    [starPath addLineToPoint:CGPointMake(width*0.794, height*0.905)];
    [starPath addLineToPoint:CGPointMake(width*0.5, height*0.8)];
    [starPath addLineToPoint:CGPointMake(width*0.206, height*0.905)];
    [starPath addLineToPoint:CGPointMake(width*0.215, height*0.593)];
    [starPath addLineToPoint:CGPointMake(width*0.025, height*0.345)];
    [starPath addLineToPoint:CGPointMake(width*0.323, height*0.257)];
    [starPath closePath];
    return starPath;
}

// ❤️
- (UIBezierPath *)heartPath
{
    CGFloat width = self.pageControl.itemSpacing;
    CGFloat height = self.pageControl.itemSpacing;
    UIBezierPath *heartPath = [[UIBezierPath alloc] init];
    [heartPath moveToPoint:CGPointMake(width*0.5, height)];
    [heartPath addCurveToPoint:CGPointMake(0, height*0.25)
                 controlPoint1:CGPointMake(width*0.5, height*0.75)
                 controlPoint2:CGPointMake(0, height*0.5)];
    [heartPath addArcWithCenter:CGPointMake(width*0.25, height*0.25)
                         radius:width*0.25
                     startAngle:M_PI
                       endAngle:0
                      clockwise:YES];
    [heartPath addArcWithCenter:CGPointMake(width*0.75, height*0.25)
                         radius:width*0.25
                     startAngle:M_PI
                       endAngle:0
                      clockwise:YES];
    [heartPath addCurveToPoint:CGPointMake(width*0.5, height)
                 controlPoint1:CGPointMake(width, height*0.5)
                 controlPoint2:CGPointMake(width*0.5, height*0.75)];
    [heartPath closePath];
    return heartPath;
}

@end

@implementation FATableViewCell

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
    }
    return _slider;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.slider];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.slider.frame = CGRectMake(30, 0, self.frame.size.width - 60, self.frame.size.height);
}


@end
