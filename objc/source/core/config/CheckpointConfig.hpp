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

#ifndef CheckpointConfig_hpp
#define CheckpointConfig_hpp

#include <WCDB/Config.hpp>
#include <WCDB/TimedQueue.hpp>

#pragma GCC visibility push(hidden)

namespace WCDB {

class CheckpointConfig : public Config {
public:
    static std::shared_ptr<Config> config();
    static constexpr const int order = 1;
    ~CheckpointConfig();

    bool invoke(Handle *handle) const override;

protected:
    CheckpointConfig();
    CheckpointConfig(const CheckpointConfig &) = delete;
    CheckpointConfig &operator=(const CheckpointConfig &) = delete;

    TimedQueue<std::string, const int> m_timedQueue;

    void loopQueue(const std::atomic<bool> &stop);
    void reQueue(const std::string &path, int pages);
    void blockedStopQueue();
};

} //namespace WCDB

#pragma GCC visibility pop

#endif /* CheckpointConfig_hpp */