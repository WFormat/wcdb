/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "BaseMultithreadBenchmark.h"

@interface MultithreadReadReadBenchmark : BaseMultithreadBenchmark

@end

@implementation MultithreadReadReadBenchmark

- (void)setUp
{
    [super setUp];

    [self setUpWithPreCreateTable];

    [self setUpWithPreInsertObjects:self.config.readCount];
}

- (void)testMultithreadReadRead
{
    __block NSString *tableName = [self getTableName];
    __block NSArray<BenchmarkObject *> *results1 = nil;
    __block NSArray<BenchmarkObject *> *results2 = nil;

    [self mesasure:^{
        results1 = nil;
        results2 = nil;

        [self tearDownDatabaseCache];

        [self setUpDatabaseCache];
    } for:^{
        dispatch_group_async(self.group, self.queue, ^{
          results1 = [self.database getObjectsOfClass:BenchmarkObject.class fromTable:tableName];
        });
        dispatch_group_async(self.group, self.queue, ^{
          results2 = [self.database getObjectsOfClass:BenchmarkObject.class fromTable:tableName];
        });
        dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
    } checkCorrectness:^{
        XCTAssertEqual(results1.count, self.config.readCount);
        XCTAssertEqual(results2.count, self.config.readCount);
    }];
}

@end