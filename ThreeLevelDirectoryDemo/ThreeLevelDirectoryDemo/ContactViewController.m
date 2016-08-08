//
//  ContactViewController.m
//  KCBuinessKey
//
//  Created by eddy on 16/5/31.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactsHeadView.h"
#import "ContactCellModel.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContactCell.h"
#import "DeptCell.h"
#import "DeptService.h"
#import "StaffService.h"
#import "DeptEnity.h"
#import "KCChatUser.h"
#import "UIViewController+HUD.h"
#import "APIManagerHelper.h"
#import "KCDataBaseOperation.h"
@interface ContactViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

{
    //NSArray * dataArray;
    UIWebView *webview;
    //KCChatUser *chatUserInfo;
    int page;
}

@property (nonatomic) BOOL isSearch;
@property (nonatomic)  UISearchBar *searchBar;

@property (nonatomic)  UITableView *searchListView;

@property (nonatomic) UITableView *tableview;

@property (nonatomic) NSMutableArray *searchListArray;

@property (nonatomic) ContactsHeadView *headView;

@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSMutableArray *staffArray;

@end

NSString *const DIC_EXPANDED = @"expanded";
NSString *const DIC_ARRAY = @"array";
NSString *const DIC_TITLE = @"title";
NSString *const DIC_LEVEL = @"level";

NSString *const RESULTCODE = @"result_code";
NSString *const DEPARTMENT_INFO = @"department_info";
NSString *const DEPT_NAME = @"dpt_name";
NSString *const DEPT_ID = @"id";
NSString *const COMPANYID = @"company_id";
NSString *const PARENT_ID = @"parent_id";

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联系人";
    
    _isSearch = YES;
    _dataArray = [NSMutableArray array];
    _searchListArray = [NSMutableArray array];
    
    _headView = [[ContactsHeadView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, 144.0f)];
    
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchListView];
    self.searchListView.hidden = YES;
    [self.view addSubview:self.tableview];
    
    [_headView.chatGroupBtn addTarget:self action:@selector(chatGroupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.guestBtn addTarget:self action:@selector(guestBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.refreshBtn addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _headView.searchBar.delegate = self;

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorColor = [UIColor clearColor];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"contactCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DeptCell" bundle:nil] forCellReuseIdentifier:@"deptCell"];

    webview=[[UIWebView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:webview];
    
    //[self.tableView reloadData];
    NSArray *deptArray = [[DeptService shareDeptService] getAllDepts];
    if (deptArray.count > 0) {
        //添加一级部门
        for (DeptEnity *dept in deptArray) {
            if (dept.parentID == 1) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[],DIC_ARRAY,dept,DEPARTMENT_INFO,@0,DIC_EXPANDED, nil];
                [_dataArray addObject:dic];
            }
        }
        
        //添加2级部门
        for (NSDictionary *dic in _dataArray) {
            DeptEnity *parentDept = dic[DEPARTMENT_INFO];
            NSMutableArray *array = [NSMutableArray array];
            for (DeptEnity *dept in deptArray) {
                if (dept.parentID == parentDept.deptID) {
                    ContactCellModel *model = [[ContactCellModel alloc] init];
                    model.name =  dept.deptName;
                    model.modelID = [NSString stringWithFormat:@"%ld",dept.deptID];
                    model.parentModelID = [NSString stringWithFormat:@"%ld",dept.parentID];
                    model.isOpened = NO;
                    model.level = 1;
                    [array addObject:model];
                }
            }
            [dic setValue:array forKey:DIC_ARRAY];
        }
        NSLog(@"_dataArray = : %@",_dataArray);
    }
    else{
        [self loadOneLevelDept];
    }
    //[self setupForDismissKeyboard];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - getter
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 108) style:UITableViewStyleGrouped];
        
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0)];
        _searchBar.backgroundColor = [UIColor clearColor];
        [_searchBar sizeToFit];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_title"]];
        [_searchBar insertSubview:imageView atIndex:1];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - 加载一级部门
- (void)loadOneLevelDept{
    // 设置返回格式
    NSDictionary*pramars=@{@"userid":[NSString stringWithFormat:@"%d",1]};
    [self showHudInView:self.view hint:@"加载中..."];
    __weak ContactViewController *weakSelf = self;
    [[APIManagerHelper shareAPIManagerHelper] POST:@"" parameters:pramars success:^(NSDictionary *jsonDic) {
        [weakSelf hideHud];
        if (!jsonDic) {
            [weakSelf showHint:@"服务器异常"];
            return ;
        }
        if ([jsonDic[@"result_code"]integerValue] == 0) {
            NSArray * companyArray=[jsonDic objectForKey:DEPARTMENT_INFO];
            for (NSDictionary*userDic in companyArray) {
                DeptEnity *dept=[[DeptEnity alloc]init];
                dept.deptName=[userDic objectForKey:DEPT_NAME];
                dept.deptID=[[userDic objectForKey:DEPT_ID] integerValue];
                dept.parentID = [[userDic objectForKey:PARENT_ID] integerValue];
                dept.companyID = [[userDic objectForKey:COMPANYID] integerValue];
                dept.level = 0;
                if (![[DeptService shareDeptService] getDeptNameByDeptID:dept.deptID]) {
                    [[DeptService shareDeptService] addDept:dept];
                }

                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[],DIC_ARRAY,dept,DEPARTMENT_INFO,@0,DIC_EXPANDED, nil];
                [weakSelf.dataArray addObject:dic];
            }
            [weakSelf.tableview reloadData];
        }
    } failureFeedBack:^(NSError *error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络不给力"];
    }];
}
#pragma mark - 加载二级部门
- (void)loadTwoLevelDept:(NSInteger)parentID index:(NSInteger)index{
    [self showHudInView:self.view hint:@"加载中..."];
    // 设置返回格式
    NSDictionary*pramars=@{@"userid":@1,PARENT_ID:@2};
    
    __weak ContactViewController *weakSelf = self;
    [[APIManagerHelper shareAPIManagerHelper] POST:@"" parameters:pramars success:^(NSDictionary *jsonDic) {
        [weakSelf hideHud];
        if (!jsonDic) {
            [weakSelf showHint:@"服务器异常"];
            return ;
        }
        if ([jsonDic[@"result_code"]integerValue] == 0) {
            NSArray * companyArray=[jsonDic objectForKey:DEPARTMENT_INFO];
            NSMutableArray *deptArray = [NSMutableArray array];
            for (NSDictionary*userDic in companyArray) {
                DeptEnity *dept=[[DeptEnity alloc]init];
                dept.deptName=[userDic objectForKey:DEPT_NAME];
                dept.deptID=[[userDic objectForKey:DEPT_ID] integerValue];
                dept.parentID = [[userDic objectForKey:PARENT_ID] integerValue];
                dept.companyID = [[userDic objectForKey:COMPANYID] integerValue];
                dept.level = 1;
                if (![[DeptService shareDeptService] getDeptNameByDeptID:dept.deptID]) {
                    [[DeptService shareDeptService] addDept:dept];
                }
                ContactCellModel *model = [[ContactCellModel alloc] init];
                model.name =  [userDic objectForKey:DEPT_NAME];
                model.modelID = [userDic objectForKey:DEPT_ID] ;
                model.parentModelID = [userDic objectForKey:PARENT_ID];
                model.isOpened = NO;
                model.refresh = YES;
                model.level = 1;
                [deptArray addObject:model];
            }
            NSDictionary *deptDic = [_dataArray objectAtIndex:index];
            [deptDic setValue:deptArray forKey:DIC_ARRAY];
            [deptDic setValue:@1 forKey:DIC_EXPANDED];
            [weakSelf.tableview reloadData];
        }
        else{
            [weakSelf showHint:jsonDic[@"result_msg"]];
        }
    } failureFeedBack:^(NSError *error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络不给力"];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)chatGroupBtnClicked:(UIButton *)btn{

}
- (void)addBtnClicked:(UIButton *)btn{

}

- (void)guestBtnClicked:(UIButton *)btn{

}

- (void)refreshBtnClicked:(UIButton *)btn{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell= (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    //cell.contactinfo=info;
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DeptCell *deptCell = (DeptCell *)[tableView dequeueReusableCellWithIdentifier:@"deptCell"];
    if (deptCell == nil) {
        deptCell = [[DeptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deptCell"];
    }
    deptCell.backgroundColor = [UIColor clearColor];
    deptCell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    deptCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *array = [[_dataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARRAY];
    ContactCellModel *model = [array objectAtIndex:indexPath.row];
    if (model.level  == 1) {
        if (model.isOpened) {
            deptCell.imageArrow.image = [UIImage imageNamed:@"mark_down"];
        }
        else{
            deptCell.imageArrow.image = [UIImage imageNamed:@"mark_up"];
        }
        //deptCell.textLabel.textColor = [UIColor whiteColor];
        deptCell.deptNameLabel.text = model.name;
        return deptCell;
    }
    else{
        //[UIImage imageNamed:@"chatListCellHead"];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
        [cell.telBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageBtn addTarget:self action:@selector(callChat:) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.text = model.name;
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableview) {
        return _dataArray.count;
    }
    else{
        return 1;
    }
}
#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
        NSArray *array = [dic objectForKey:DIC_ARRAY];
        if ([[dic objectForKey:DIC_EXPANDED] integerValue]) {
            return array.count;
        }
        else{
            return 0;
        }
    }
    else{
        return _searchListArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    label.backgroundColor = [UIColor clearColor];
    return label;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0)];
    hView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    hView.userInteractionEnabled = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, kScreenWidth, 44.0)];
    [btn addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.tag = section + 100;
    hView.tag = section + 300;
    
    //设置加载图片
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16.5, 11, 11)];
    imageView.tag = 200 + section;
    if ([self isExpanded:section]) {
        imageView.image = [UIImage imageNamed:@"mark_down"];
    }
    else{
        imageView.image = [UIImage imageNamed:@"mark_up"];
    }
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 11, kScreenWidth - CGRectGetMaxX(imageView.frame) , 22)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    NSDictionary *deptDic = [_dataArray objectAtIndex:section];
    DeptEnity * dept = [deptDic objectForKey:DEPARTMENT_INFO];
    [titleLabel setText:dept.deptName];
    
    //下显示线
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-0.5, hView.frame.size.width,0.5f)];
    
    label.backgroundColor=[UIColor clearColor];
    
    [hView addSubview:label];
    
    [hView addSubview:imageView];
    
    [hView addSubview:titleLabel];
    
    [hView addSubview: btn];
    
    return hView;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击进入联系人详情
    [_searchBar resignFirstResponder];
    _searchBar.text = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    
    NSMutableArray *staffArray = [dic objectForKey:DIC_ARRAY];
    ContactCellModel *model = [staffArray objectAtIndex:indexPath.row];
    NSMutableIndexSet * indexSets = [[NSMutableIndexSet alloc]init];
    if (model.level == 1) {
        if (model.isOpened) {
            model.isOpened = NO;
            //[staffDic setValue:@0 forKey:DIC_EXPANDED];
            [staffArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContactCellModel  * modelX = [staffArray objectAtIndex:idx];
                //NSInteger parentModelID = indexPath.section *10 +indexPath.row;
                if (modelX.level ==2 && modelX.parentModelID == model.modelID) {
                    [indexSets addIndex:idx];
                }
            }];
            [staffArray removeObjectsAtIndexes:indexSets];
            [_tableview reloadData];
        }
        else{
            model.isOpened = YES;
            if (model.refresh) {
                [self loadDeptStaffInfo:model.modelID indexPath:indexPath];
            }
            else{
                NSArray *deptStaffs = [[StaffService shareStaffService] getStaffsByDeptID:[model.modelID integerValue]];
                int i = 0;
                if (deptStaffs.count > 0) {
                    for (KCChatUser *staff in deptStaffs) {
                        
                        ContactCellModel *childModel = [[ContactCellModel alloc] init];
                        childModel.name =  staff.realName;
                        childModel.headImage = staff.imageUrl.absoluteString;
                        childModel.modelID = [NSString stringWithFormat:@"%ld",staff.userId] ;
                        childModel.parentModelID = model.modelID;
                        childModel.telNum = staff.userPhone;
                        childModel.easeMobName = staff.easemobName;
                        childModel.isOpened = @0;
                        childModel.level = 2;
                        
                        [staffArray insertObject:childModel atIndex:indexPath.row + 1 + i];
                        i ++;
                    }
                    [self.tableview reloadData];
                }else{
                    [self loadDeptStaffInfo:model.modelID indexPath:indexPath];
                }
            }
        }
    }
    else{
        NSLog(@"staff");
       
    }
}

#pragma mark - UISearchDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    if (!searchBar.text.length) {
        [self showHint:@"输入汉字拼音"];
        [self hideHud];
    }
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for (UIView *searchbuttons in [searchBar subviews]){
        for (UIView *ndLevelSubview in searchbuttons.subviews) {
            if ([ndLevelSubview isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                // 修改文字颜色
                [cancelButton setTintColor:[UIColor whiteColor]];
            }
        }
    }

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    self.tableview.hidden = NO;
    self.searchListView.hidden = YES;
    [self.view bringSubviewToFront:self.tableview];
    [self.tableview reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchBar.text.length == 0) {
        [searchBar resignFirstResponder];
        self.tableview.hidden = NO;
        self.searchListView.hidden = YES;
        [self.view bringSubviewToFront:self.tableview];
        [self.tableview reloadData];
    }
    else{
        [self.searchListArray removeAllObjects];
        self.searchListView.hidden = NO;
        [self.view bringSubviewToFront:self.searchListView];
        self.tableview.hidden = YES;
        [self.searchListView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
        NSArray *array = [[_dataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARRAY];
        ContactCellModel *model = [array objectAtIndex:indexPath.row];
        if (model.level == 1) {
            return 44.0f;
        }
        return 60.0f;
    }
    else{
        return 60.0f;
    }
}
-(void)getInfomation:(UIButton*)btn
{
    CGPoint point = [btn convertPoint:CGPointZero toView:_searchListView];
    NSIndexPath *indexPath = [_searchListView indexPathForRowAtPoint:point];
    KCChatUser *chatUser = [_searchListArray objectAtIndex:indexPath.row];
    
}

#pragma mark - 发消息
- (void)callChat:(UIButton *)btn
{
    CGPoint point = [btn convertPoint:CGPointZero toView:_tableview];
    NSIndexPath *indexPath = [_tableview indexPathForRowAtPoint:point];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    
    NSMutableArray *staffArray = [dic objectForKey:DIC_ARRAY];
    ContactCellModel *model = [staffArray objectAtIndex:indexPath.row];
    
    if (![model.easeMobName isEqual:[NSNull null]] && model.easeMobName) {
       
    }
}
#pragma mark - 打电话
-(void)callPhone:(UIButton*)btn
{
    CGPoint point = [btn convertPoint:CGPointZero toView:_tableview];
    NSIndexPath *indexPath = [_tableview indexPathForRowAtPoint:point];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    
    NSMutableArray *staffArray = [dic objectForKey:DIC_ARRAY];
    ContactCellModel *model = [staffArray objectAtIndex:indexPath.row];
    if (!model.telNum) {
        [self showHint:@"电话号码不存在"];
        return;
    }
    else{
        NSURL * phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.telNum]];
        [webview loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
    }
}


- (NSInteger)isExpanded:(NSInteger)section{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    return [[dic objectForKey:DIC_EXPANDED] integerValue];
}

#pragma mark -
- (void)collapseOrExpand:(NSInteger)section{
    
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    NSInteger expanded = [[dic objectForKey:DIC_EXPANDED] integerValue];
    if ([dic[DIC_ARRAY] count] == 0) {
        return;
    }
    if (expanded) {
        [dic setValue:@0 forKey:DIC_EXPANDED];
    }
    else{
        [dic setValue:@1 forKey:DIC_EXPANDED];
        
        for (int i = 0; i<_dataArray.count; i++) {
            if (i != section) {
                NSMutableDictionary *sectionDic = [_dataArray objectAtIndex:i];
                NSInteger expanded = [[sectionDic objectForKey:DIC_EXPANDED] integerValue];
                if (expanded) {
                    [sectionDic setValue:@0 forKey:DIC_EXPANDED];
                }
            }
        }
    }
}

#pragma mark -
- (void)expandButtonClicked:(UIButton *)sender{
    [_searchBar resignFirstResponder];
    NSInteger section = sender.tag - 100;
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    if ([dic[DIC_ARRAY] count] == 0) {
        DeptEnity * dept = [dic objectForKey:DEPARTMENT_INFO];
        [self loadTwoLevelDept:dept.deptID index:section];
    }
    else{
        [self collapseOrExpand:section];
        [_tableview reloadData];
    }
}

#pragma mark - 加载部门下员工
- (void)loadDeptStaffInfo:(NSString *)deptID indexPath:(NSIndexPath *)indexPath{
    [self showHudInView:self.view hint:@"请等待..."];

    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    
    NSMutableArray *staffArray = [dic objectForKey:DIC_ARRAY];
    ContactCellModel *parentModel = [staffArray objectAtIndex:indexPath.row];
    parentModel.refresh = NO;
    // 设置返回格式
    NSDictionary*pramars=@{@"dpt_id":deptID};
    __weak ContactViewController *weakSelf = self;
    [[APIManagerHelper shareAPIManagerHelper] POST:@"" parameters:pramars success:^(NSDictionary *jsonDic) {
        [weakSelf hideHud];
        if (!jsonDic) {
            [weakSelf showHint:@"服务器异常"];
            return ;
        }
        if ([jsonDic[@"result_code"]isEqualToString:@"0"]) {
            NSArray *staff = [jsonDic objectForKey:@"user_info"];
            staff = [weakSelf sortArrayWithUserName:[staff mutableCopy]];
            int i = 0;
            for (NSDictionary *user in staff) {
                ContactCellModel *childModel = [[ContactCellModel alloc] init];
                childModel.name =  [user objectForKey:@"realname"];
                childModel.headImage = [@"" stringByAppendingString:[user objectForKey:@"userPic"]];;
                childModel.modelID = [NSString stringWithFormat:@"%@",[user objectForKey:@"userid"]];;
                childModel.parentModelID = deptID;
                childModel.telNum = [user objectForKey:@"userPhone"];
                childModel.easeMobName = [user objectForKey:@"easemobName"];
                childModel.isOpened = @0;
                childModel.refresh = NO;
                childModel.level = 2;
                [staffArray insertObject:childModel atIndex:indexPath.row + 1 + i];
                
                //保存部门人员信息
                KCChatUser*info=[[KCChatUser alloc]init];
                info.realName=[user objectForKey:@"realname"];
                info.userPhone=[user objectForKey:@"userPhone"];
                info.imageUrl=[NSURL URLWithString:[@"" stringByAppendingString:[user objectForKey:@"userPic"]]];
                info.easemobName=[user objectForKey:@"easemobName"];
                info.userId=[[user objectForKey:@"userid"]intValue];
                info.deptID = deptID.integerValue;
                if (![[StaffService shareStaffService] getStaffByUserID:info.userId]) {
                    [[StaffService shareStaffService] addStaff:info];
                }
                i++;
            }
            [staffArray replaceObjectAtIndex:indexPath.row withObject:parentModel];
            [weakSelf.tableview reloadData];
        }
        else{
            [weakSelf showHint:jsonDic[@"result_msg"]];
        }
    } failureFeedBack:^(NSError *error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络不给力"];
    }];
}

#pragma mark - 按姓名字母顺序排序
- (NSArray *)sortArrayWithUserName:(NSMutableArray *)array{
    for (int i=0; i<array.count; i++){
        
        for (int j=0; j<array.count-1-i; j++){
            
            NSDictionary *array1 = array[j];
            NSDictionary *array2 = array[j+1];
            
            NSString*string1= ChineseToPinyin([array1 objectForKey:@"realname"]);
            NSString*string2= ChineseToPinyin([array2 objectForKey:@"realname"]);
            
            unichar c1 = [[string1 uppercaseString] characterAtIndex:0];
            unichar c2 = [[string2 uppercaseString] characterAtIndex:0];
            
            if (c1 > c2) {
                NSDictionary *tmpArray = [NSDictionary dictionaryWithDictionary:array1];
                [array replaceObjectAtIndex:j withObject:array2];
                [array replaceObjectAtIndex:j+1 withObject:tmpArray];
            }
        }
    }
    return array;
}

#pragma mark - 汉字转为拼音
NSString *ChineseToPinyin(NSString * chineseString){
    if ([chineseString length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:chineseString];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", ms);
            return ms;
        }
    }
    return nil;
}
@end
