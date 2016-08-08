//
//  ContactsHeadView.m
//  KCBuinessKey
//
//  Created by eddy on 16/6/1.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "ContactsHeadView.h"

@implementation ContactsHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.guestBtn];
        [self addSubview:self.addBtn];
        [self addSubview:self.chatGroupBtn];
        [self addSubview:self.refreshBtn];
        [self addSubview:self.searchBar];
    }
    return self;
}

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 124)];
        _bgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    }
    return _bgView;
}
- (UIButton *)chatGroupBtn{
    if (_chatGroupBtn == nil) {
        _chatGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_chatGroupBtn setFrame:CGRectMake(0, 44 + 5, kScreenWidth/4, 70)];
        //设置图片
        UIImage *image = [UIImage imageNamed:@"abc_icon@2x.png"];
        [_chatGroupBtn setImage:image forState:0];
        _chatGroupBtn.imageEdgeInsets = UIEdgeInsetsMake(5, kScreenWidth/8 - image.size.width/2, 26, kScreenWidth/8 - image.size.width/2);
        //设置标题
        [_chatGroupBtn setTitle:@"群组" forState:0];
        _chatGroupBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_chatGroupBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_chatGroupBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        _chatGroupBtn.titleEdgeInsets = UIEdgeInsetsMake(44,-image.size.width , 0, 0);
    }
    
    return _chatGroupBtn;
}

- (UIButton *)addBtn{
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setFrame:CGRectMake(kScreenWidth/4, 44 + 5, kScreenWidth/4, 70)];
        //设置图片
        UIImage *image = [UIImage imageNamed:@"abc_icon@2x.png"];
        [_addBtn setImage:image forState:0];
        _addBtn.imageEdgeInsets = UIEdgeInsetsMake(5, kScreenWidth/8 - image.size.width/2, 26, kScreenWidth/8 - image.size.width/2);
        //设置标题
        [_addBtn setTitle:@"添加" forState:0];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_addBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        _addBtn.titleEdgeInsets = UIEdgeInsetsMake(45, -image.size.width, 0, 0);
    }
    return _addBtn;
}

- (UIButton *)guestBtn{
    if (_guestBtn == nil) {
        _guestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_guestBtn setFrame:CGRectMake(kScreenWidth/2, 44 + 5, kScreenWidth/4, 70)];
        //设置图片
        UIImage *image = [UIImage imageNamed:@"abc_icon@2x.png"];
        [_guestBtn setImage:image forState:0];
        _guestBtn.imageEdgeInsets = UIEdgeInsetsMake(5, kScreenWidth/8 - image.size.width/2, 26, kScreenWidth/8 - image.size.width/2);
        //设置标题
        [_guestBtn setTitle:@"客服" forState:0];
        _guestBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_guestBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_guestBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        _guestBtn.titleEdgeInsets = UIEdgeInsetsMake(45, -image.size.width, 0, 0);
    }
    return _guestBtn;
}

- (UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setFrame:CGRectMake(kScreenWidth * 3/4, 44 + 5, kScreenWidth/4, 70)];
        //设置图片
        UIImage *image = [UIImage imageNamed:@"abc_icon@2x.png"];
        [_refreshBtn setImage:image forState:0];
        _refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(5, kScreenWidth/8 - image.size.width/2, 26, kScreenWidth/8 - image.size.width/2);
        //设置标题
        NSString *title = @"刷新";
        [_refreshBtn setTitle:title forState:0];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_refreshBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_refreshBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        _refreshBtn.titleEdgeInsets = UIEdgeInsetsMake(45, -image.size.width, 0, 0);
    }
    return _refreshBtn;
}

- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0)];
        _searchBar.backgroundColor = [UIColor clearColor];
        [_searchBar sizeToFit];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_title"]];
        [_searchBar insertSubview:imageView atIndex:1];
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}
@end
