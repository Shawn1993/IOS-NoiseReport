//
//  NCPLocationViewController.m
//  NoiseComplain
//
//  Created by mura on 11/29/15.
//  Copyright © 2015 sysu. All rights reserved.
//

#import "NCPLocationViewController.h"
#import "NCPComplainForm.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


#pragma mark - private interface
@interface NCPLocationViewController()
<
    BMKMapViewDelegate,
    BMKLocationServiceDelegate,
    BMKGeoCodeSearchDelegate,
    BMKSuggestionSearchDelegate,
    BMKPoiSearchDelegate,
    UISearchBarDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *updateLocationButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIImageView *pinView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 定位服务对象
@property (nonatomic) BMKLocationService *locationService;
/// 地理编码服务对象,可提供编码和反编码
@property (nonatomic) BMKGeoCodeSearch *geoCodeSearch;
/// 兴趣点搜索服务提供对象
@property (nonatomic) BMKPoiSearch *poiSearch;
/// 搜索建议服务提供对象
@property (nonatomic) BMKSuggestionSearch *suggestionSearch;
/// 判断第一次进入改视图时，图钉处地图是否使用定位地理坐标
@property (nonatomic, getter=isPinUseUserLocation) BOOL pinUseUserLocation;
/// 判断地图是否移动了
@property (nonatomic, getter=isMapRegionChange) BOOL mapRegionChange;
/// 定位地理坐标
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
/// 图钉地理坐标
@property (nonatomic) CLLocationCoordinate2D pinCoordinate;
/// 图钉地址信息
@property (nonatomic) NSString *pinAddress;
/// 图钉层次化地址信息
@property (nonatomic) BMKAddressComponent *pinAddressDetail;
/// 搜索建议结果
@property (nonatomic) BMKSuggestionResult *suggestionResult;
/// 兴趣点搜索结果
@property (nonatomic) BMKPoiResult *poiResult;
/// 判断是否使用搜索结果
@property (nonatomic,getter=isUsePoiResult) BOOL usePoiResult;

@end


#pragma mark - implementation
@implementation NCPLocationViewController


#pragma mark - 一些初始化
- (void)initBMKObject{
    self.locationService = [[BMKLocationService alloc] init];
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.poiSearch = [[BMKPoiSearch alloc] init];
    self.suggestionSearch = [[BMKSuggestionSearch alloc] init];
}

-(void)initData
{
    CLLocationDegrees latitude = [[[NCPComplainForm current] latitude] doubleValue];
    CLLocationDegrees longtitude = [[[NCPComplainForm current] longitude] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longtitude);
    self.pinUseUserLocation = (latitude==0&&longtitude==0);
    self.mapRegionChange = NO;
    self.pinAddress = [[NCPComplainForm current] address];
    
    if(!self.isPinUseUserLocation)
    {
        [self.mapView setCenterCoordinate:coordinate animated:YES];
        self.mapView.zoomLevel= 17;
        [self setPinCoordinate:coordinate];
    }
}

#pragma mark - Controller生命周期
-(void)viewDidLoad
{
    [self initBMKObject];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.searchBar.delegate = self;
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    self.geoCodeSearch.delegate = self;
    self.suggestionSearch.delegate = self;
    self.poiSearch.delegate = self;
    [self.locationService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.searchBar.delegate = nil;
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearch.delegate = nil;
    self.suggestionSearch = nil;
    self.poiSearch.delegate = nil;
    [self.locationService stopUserLocationService];
}

-(void)viewDidLayoutSubviews
{
    self.pinView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.pinView.center = self.mapView.center;
}

# pragma mark - setter and getter

-(void)setPinCoordinate:(CLLocationCoordinate2D)pinCoordinate
{
    _pinCoordinate = pinCoordinate;
    [self checkUpdateButtonIsNeedHide];
}

-(void)setLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate
{
    _locationCoordinate = locationCoordinate;
    [self checkUpdateButtonIsNeedHide];
}

-(void)checkUpdateButtonIsNeedHide
{
    BMKMapPoint locationPoint = BMKMapPointForCoordinate(self.locationCoordinate);
    BMKMapPoint pinPoint = BMKMapPointForCoordinate(self.pinCoordinate);
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(pinPoint,locationPoint);
    self.updateLocationButton.hidden = (fabs(distance)<1);
}

# pragma mark - 按钮响应
- (IBAction)doneButtonClick:(id)sender
{
    [NCPComplainForm current].latitude =[NSNumber numberWithDouble:[self pinCoordinate].latitude];
    [NCPComplainForm current].longitude =[NSNumber numberWithDouble:[self pinCoordinate].longitude];
    
    if((self.pinAddress && self.pinAddress.length )|| (!self.isMapRegionChange)){
        [NCPComplainForm current].address =self.pinAddress;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前位置不可用" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancleAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

- (IBAction)updateLocationButtonClick:(id)sender
{
    if(self.locationCoordinate.latitude&&self.locationCoordinate.longitude)
    {
        self.pinCoordinate = self.locationCoordinate;
        [self.mapView setCenterCoordinate:[self pinCoordinate] animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.tableView.hidden = NO;
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.tableView.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
        BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
        option.cityname = self.pinAddressDetail.city;
        option.keyword = searchText;
        [self.suggestionSearch suggestionSearch:option];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.city = self.pinAddressDetail.city;
//    NSLog(@"城市 %@",option.city);
    option.keyword = searchBar.text;
    [self.poiSearch poiSearchInCity:option];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isUsePoiResult) {
        return self.poiResult.currPoiNum;
    }else{
        return self.suggestionResult.keyList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    if(self.isUsePoiResult){
        BMKPoiInfo *poiInfo=  [self.poiResult.poiInfoList objectAtIndex:row];
        cell.textLabel.text = poiInfo.name;
        cell.detailTextLabel.text = poiInfo.address;
    }else{
        cell.textLabel.text = [self.suggestionResult.keyList objectAtIndex:row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    if (self.isUsePoiResult) {
        self.pinCoordinate = [[self.poiResult.poiInfoList objectAtIndex:row] pt];
    }else{
        CLLocationCoordinate2D coordinate;
        [[self.suggestionResult.ptList objectAtIndex:row] getValue:&coordinate];
        self.pinCoordinate = coordinate;
    }
    [self.mapView setCenterCoordinate:self.pinCoordinate animated:YES];
    self.tableView.hidden = YES;
}

#pragma mark - BMKSuggestionSearchDelegate
-(void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error{
    if(error == BMK_SEARCH_NO_ERROR){
        self.suggestionResult = result;
    }else{
        self.suggestionResult = nil;
    }
    self.usePoiResult = NO;
    [self.tableView reloadData];
    
}

#pragma mark - BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        self.poiResult = poiResult;
    }
    self.usePoiResult = YES;
    [self.tableView reloadData];
    
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.pinAddress = nil;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    [self setPinCoordinate:coordinate];
    
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = self.pinCoordinate;
    [self.geoCodeSearch reverseGeoCode:option];
    
    self.mapRegionChange =YES;
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(!userLocation)
        return;
    
    [self.mapView updateLocationData: userLocation];
    self.locationCoordinate =  userLocation.location.coordinate;
    
    if(self.isPinUseUserLocation){
        self.pinUseUserLocation = NO;
        self.pinCoordinate = self.locationCoordinate;
        [self.mapView setCenterCoordinate:self.pinCoordinate animated:YES];
        self.mapView.zoomLevel= 17;
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位错误");
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.pinAddress = result.address;
        self.pinAddressDetail = result.addressDetail;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
    
}



@end
