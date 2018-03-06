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

#ifndef CopyOnWriteLazyDescribable_hpp
#define CopyOnWriteLazyDescribable_hpp

#include <WCDB/CopyOnWrite.hpp>
#include <WCDB/CopyOnWriteString.hpp>

template <typename T>
class CopyOnWriteLazyDescribable : public CopyOnWrite<T> {
public:
    const CopyOnWriteString &description() const
    {
        if (!m_calculated) {
            m_description.assign(calculatedDescription());
            m_calculated = true;
        }
        return m_description;
    }

protected:
    virtual void willProbablyChange() override { m_calculated = false; }
    virtual CopyOnWriteString calculatedDescription() const = 0;

private:
    mutable CopyOnWriteString m_description;
    mutable bool m_calculated;
};

#endif /* CopyOnWriteLazyDescribable_hpp */