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

#import "WTCBaseMultithreadBenchmark.h"

@interface WTCMultithreadReadWriteBenchmark : WTCBaseMultithreadBenchmark

@end

@implementation WTCMultithreadReadWriteBenchmark

- (void)setUp
{
    [super setUp];

    [self setUpWithPreCreateObject:self.config.batchWriteCount];
}

- (void)testMultithreadReadWrite
{
    __block NSString *tableName = [self getTableName];
    __block NSArray<WTCBenchmarkObject *> *results = nil;

    [self mesasure:^{
        results = nil;

        [self tearDownDatabase];

        [self setUpWithPreCreateTable];
        
        [self setUpWithPreInsertObjects:self.config.readCount];
        
        [self tearDownDatabaseCache];
        
        [self setUpDatabaseCache];
    } for:^{
        dispatch_group_async(self.group, self.queue, ^{
            results = [self.database getAllObjectsOfClass:WTCBenchmarkObject.class fromTable:tableName];
        });
        dispatch_group_async(self.group, self.queue, ^{
            XCTAssertTrue([self.database insertObjects:self.objects into:tableName]);
        });
    } checkCorrectness:^{
        XCTAssertEqual(results.count, self.config.readCount);
        NSNumber *count = [self.database getOneValueOnResult:WTCBenchmarkObject.AnyProperty.count() fromTable:tableName];
        XCTAssertEqual(count.intValue, self.config.readCount + self.config.batchWriteCount);
    }];
}

@end
