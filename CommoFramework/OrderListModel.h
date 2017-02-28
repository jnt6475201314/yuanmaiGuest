//
//  OrderListModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * add_time;
@property (nonatomic, copy) NSString<Optional> * address_f;
@property (nonatomic, copy) NSString<Optional> * address_s;

@property (nonatomic, copy) NSString<Optional> * collect_id;
@property (nonatomic, copy) NSString<Optional> * comment;
@property (nonatomic, copy) NSString<Optional> * complete_time;
@property (nonatomic, copy) NSString<Optional> * consignee_name;
@property (nonatomic, copy) NSString<Optional> * consignee_tel;

@property (nonatomic, copy) NSString<Optional> * del;
@property (nonatomic, copy) NSString<Optional> * deliver_name;
@property (nonatomic, copy) NSString<Optional> * deliver_tel;
@property (nonatomic, copy) NSString<Optional> * delivery_time;
@property (nonatomic, copy) NSString<Optional> * driver_id;

@property (nonatomic, copy) NSString<Optional> * f_address;
@property (nonatomic, copy) NSString<Optional> * f_default;
@property (nonatomic, copy) NSString<Optional> * fid;
@property (nonatomic, copy) NSString<Optional> * forwarding_unit;

@property (nonatomic, copy) NSString<Optional> * goods_load;
@property (nonatomic, copy) NSString<Optional> * goods_size;
@property (nonatomic, copy) NSString<Optional> * goods_type;

@property (nonatomic, copy) NSString<Optional> * meet_time;

@property (nonatomic, copy) NSString<Optional> * oid;
@property (nonatomic, copy) NSString<Optional> * order_number;
@property (nonatomic, copy) NSString<Optional> * order_state;
@property (nonatomic, copy) NSString<Optional> * order_time;

@property (nonatomic, copy) NSString<Optional> * qr_code;

@property (nonatomic, copy) NSString<Optional> * receiving_unit;

@property (nonatomic, copy) NSString<Optional> * s_address;
@property (nonatomic, copy) NSString<Optional> * s_default;
@property (nonatomic, copy) NSString<Optional> * sid;

@property (nonatomic, copy) NSString<Optional> * uid;

@end
