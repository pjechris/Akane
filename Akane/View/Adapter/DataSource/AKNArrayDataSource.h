//
//  AKNItemArrayAdapter.h
//  Akane
//
//  Created by JC on 05/02/15.
//  Copyright (c) 2015 fr.akane. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AKNDataSource.h"

@interface AKNArrayDataSource : NSObject<AKNDataSource>

@property(nonatomic, strong)NSArray *items;

@end
