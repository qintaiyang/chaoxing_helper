# 超星学习通 - 作业列表获取 API

> **版本**: 1.0  
> **说明**: 第三方项目调用指南  
> **加密要求**: ❌ 无需加密签名（仅需 Cookie 认证）

---

## 快速开始

### 1. API 端点

```
GET https://mooc1-api.chaoxing.com/work/phone/publish-list
```

### 2. 请求参数

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| `courseId` | String | ✅ | 课程 ID | `254841716` |
| `classId` | String | ✅ | 班级 ID | `127826023` |
| `page` | Integer | ❌ | 页码（默认 0） | `0` |

### 3. 必需 Cookies

以下 Cookies 用于身份认证（从登录后的会话中获取）：

| Cookie 名称 | 说明 | 示例 |
|------------|------|------|
| `UID` | 用户 ID | `416958689` |
| `_uid` | 用户 ID（副本） | `416958689` |
| `fid` | 机构/学校 ID | `291413` |
| `_tid` | 教师/课程 ID | `368519940` |
| `xxtenc` | 学习通加密标识 | `cafe01857f69087d0e56db7f0b03ad0f` |
| `vc3` | 会话验证令牌 | `AYKcNA8iYjpftCeWWJxvuMb%2FHLr05P9r...` |
| `uf` | 用户认证信息 | `da0883eb5260151ec72eef26c27a47898e...` |
| `cx_p_token` | 超星平台 Token | `74623be3c7002893e0ab6e39bfb2965a` |
| `p_auth_token` | JWT 认证 Token | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `_d` | 登录时间戳 | `1778145569861` |
| `sso_t` | SSO 时间戳 | `1778145569861` |
| `sso_v` | SSO 验证值 | `47ef0b94dff3d71109406c7872f28282` |

> **重要**: 这些 Cookies 在用户登录超星平台后自动设置，可从浏览器开发者工具或登录响应中获取。

---

## 代码示例

### Python (requests)

```python
import requests

# 1. 准备 Cookies（从登录后的会话获取）
cookies = {
    'UID': '416958689',
    '_uid': '416958689',
    'fid': '291413',
    '_tid': '368519940',
    'xxtenc': 'cafe01857f69087d0e56db7f0b03ad0f',
    'vc3': 'AYKcNA8iYjpftCeWWJxvuMb%2FHLr05P9r9r%2FqX4DdgizHFR80P5Hr7HTP5e9DKUNRxaLfk0hEf23zkv7qvoajv9p3lCyQj6PJP0yJMnFbEYI8F9l8FMLdhp8ewDset6DjWOUE4oiiEFDKPmli%2Fqnvig3e7gfk6F0nFV564KF9jEo%3D87693bd3efd298be07749334f5e10706',
    'uf': 'da0883eb5260151ec72eef26c27a47898e7681c5489509b7c49cf84010c95b48e12f802b011cebecceea1a69f40b71477cd6e6895f8d8daaea4a1670a3a8352fe9295d8c89b08ad0f44425e20f927c6b0e0830b6c4768777e4dcdf988f1bd6f7a5f2f33c8c1f84029f354fda8d460595a1e5bc71265238eea119d3f3a8137c5285cccd63a1b854d8e9f3009e54693dd98750b4f3ba223476d8a8d0ca21d204ebbfecd4077347b641475f05bda0a6c2581035057ee3ca452679123a9828d1f8e0',
    'cx_p_token': '74623be3c7002893e0ab6e39bfb2965a',
    'p_auth_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI0MTY5NTg2ODkiLCJsb2dpblRpbWUiOjE3NzgxNDU1Njk4NjIsImV4cCI6MTc3ODc1MDM2OX0.6DUUCL2v9pWNIxjVrGJEkfFWVAzLchaCx3HSQj_n6Og',
    '_d': '1778145569861',
    'sso_t': '1778145569861',
    'sso_v': '47ef0b94dff3d71109406c7872f28282',
}

# 2. 准备参数
params = {
    'courseId': '254841716',
    'classId': '127826023',
    'page': 0
}

# 3. 发送请求
response = requests.get(
    'https://mooc1-api.chaoxing.com/work/phone/publish-list',
    params=params,
    cookies=cookies
)

# 4. 解析结果
if response.status_code == 200:
    data = response.json()
    print(f"作业数量：{len(data.get('data', []))}")
    for homework in data.get('data', []):
        print(f"  - {homework.get('title')} ({homework.get('status')})")
else:
    print(f"请求失败：{response.status_code}")
```

### JavaScript (fetch)

```javascript
// 1. 准备 Cookies（从登录后的会话获取）
const cookies = {
    UID: '416958689',
    _uid: '416958689',
    fid: '291413',
    _tid: '368519940',
    xxtenc: 'cafe01857f69087d0e56db7f0b03ad0f',
    vc3: 'AYKcNA8iYjpftCeWWJxvuMb%2FHLr05P9r...',
    uf: 'da0883eb5260151ec72eef26c27a47898e...',
    cx_p_token: '74623be3c7002893e0ab6e39bfb2965a',
    p_auth_token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    _d: '1778145569861',
    sso_t: '1778145569861',
    sso_v: '47ef0b94dff3d71109406c7872f28282',
};

// 2. 准备参数
const params = new URLSearchParams({
    courseId: '254841716',
    classId: '127826023',
    page: '0'
});

// 3. 发送请求
fetch(`https://mooc1-api.chaoxing.com/work/phone/publish-list?${params}`, {
    method: 'GET',
    headers: {
        'Cookie': Object.entries(cookies)
            .map(([k, v]) => `${k}=${v}`)
            .join('; ')
    }
})
.then(res => res.json())
.then(data => {
    console.log(`作业数量：${data.data?.length || 0}`);
    data.data?.forEach(hw => {
        console.log(`  - ${hw.title} (${hw.status})`);
    });
});
```

### cURL

```bash
curl -G "https://mooc1-api.chaoxing.com/work/phone/publish-list" \
  -d "courseId=254841716" \
  -d "classId=127826023" \
  -d "page=0" \
  -H "Cookie: UID=416958689; _uid=416958689; fid=291413; _tid=368519940; xxtenc=cafe01857f69087d0e56db7f0b03ad0f; vc3=AYKcNA8iYjpftCeWWJxvuMb%2FHLr05P9r...; uf=da0883eb5260151ec72eef26c27a47898e...; cx_p_token=74623be3c7002893e0ab6e39bfb2965a; p_auth_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...; _d=1778145569861; sso_t=1778145569861; sso_v=47ef0b94dff3d71109406c7872f28282;"
```

---

## 响应格式

### 成功响应 (200)

```json
{
  "success": true,
  "status": "success",
  "data": [
    {
      "id": "53162426",
      "title": "Writing",
      "status": "未提交",
      "courseName": "《大学外语 2》",
      "deadline": "剩余 197 小时 42 分钟",
      "taskrefId": "53162426",
      "courseId": "254841716",
      "clazzId": "127826023",
      "enc_task": "69c4d824b9f9a00652d1d3058243b77e"
    },
    {
      "id": "53162285",
      "title": "Reading Comprehension (P153)",
      "status": "未提交",
      "courseName": "《大学外语 2》",
      "deadline": "剩余 190 小时 39 分钟",
      "taskrefId": "53162285",
      "courseId": "254841716",
      "clazzId": "127826023",
      "enc_task": "891c6d9760650d38a81d71e5ade9e3ba"
    }
  ]
}
```

### 失败响应

```json
{
  "success": false,
  "status": "error",
  "msg": "用户未登录或认证信息过期"
}
```

---

## 获取课程和班级 ID

要获取 `courseId` 和 `classId`，需要先获取课程列表：

### API: 获取课程列表

```
GET https://mobilelearn.chaoxing.com/mobile/learning/getCourses
```

**响应示例**:

```json
{
  "success": true,
  "data": [
    {
      "courseId": "254841716",
      "classId": "127826023",
      "name": "大学外语 2",
      "cpi": "abc123...",
      "content": "课程描述"
    }
  ]
}
```

**代码示例**:

```python
# 获取课程列表
response = requests.get(
    'https://mobilelearn.chaoxing.com/mobile/learning/getCourses',
    cookies=cookies
)
courses = response.json()['data']

# 提取第一个课程的 ID
course = courses[0]
course_id = course['courseId']
class_id = course['classId']

print(f"课程：{course['name']}")
print(f"courseId: {course_id}, classId: {class_id}")
```

---

## 获取作业详情

获取作业列表后，可以使用 `taskrefId` 和 `enc_task` 获取作业详情：

### API: 获取作业详情

```
GET https://mooc1-api.chaoxing.com/mooc-ans/android/mtaskmsgspecial
```

**参数**:

| 参数 | 类型 | 说明 |
|------|------|------|
| `taskrefId` | String | 作业任务引用 ID（从作业列表获取） |
| `courseId` | String | 课程 ID |
| `clazzId` | String | 班级 ID |
| `userId` | String | 用户 ID（从 Cookie 获取） |
| `type` | String | 固定为 `work` |
| `enc_task` | String | 作业加密标识（从作业列表获取） |

**示例**:

```python
homework_id = '53162426'
enc_task = '69c4d824b9f9a00652d1d3058243b77e'

params = {
    'taskrefId': homework_id,
    'courseId': course_id,
    'clazzId': class_id,
    'userId': '416958689',
    'type': 'work',
    'enc_task': enc_task
}

response = requests.get(
    'https://mooc1-api.chaoxing.com/mooc-ans/android/mtaskmsgspecial',
    params=params,
    cookies=cookies
)
```

---

## 常见问题

### Q1: 是否需要加密签名（enc 参数）？

**A**: ❌ **不需要**。作业列表查询是只读操作，仅需通过 Cookie 验证身份即可。`enc` 签名主要用于签到、课程认证等写操作。

### Q2: Cookies 从哪里获取？

**A**: 有三种方式：

1. **浏览器开发者工具**:
   - 登录超星学习通网页版
   - 按 F12 打开开发者工具
   - 进入 Network 标签，刷新页面
   - 点击任意请求，查看 Request Headers 中的 `Cookie` 字段

2. **程序化登录**:
   - 调用登录 API 获取 Cookies
   - 保存登录响应中的 `Set-Cookie` 头

3. **已有会话**:
   - 如果已经有登录态，直接从浏览器导出 Cookies

### Q3: JWT Token (`p_auth_token`) 过期了怎么办？

**A**: `p_auth_token` 的有效期约为 7 天。过期后需要：
- 重新登录获取新的 Token
- 或者刷新 Token（如果支持）

### Q4: 为什么我的请求返回 401 或 403？

**A**: 可能原因：
- Cookies 不完整或已过期
- 缺少关键 Cookie（如 `UID`, `vc3`, `uf`, `p_auth_token`）
- IP 地址变化触发安全验证
- 请求频率过高被限流

**解决方案**:
- 检查 Cookies 是否完整
- 重新登录获取新 Cookies
- 降低请求频率（建议间隔 1-2 秒）

### Q5: 是否需要处理反爬虫机制？

**A**: 建议：
- 添加 `User-Agent` 头（模拟浏览器）
- 控制请求频率（1-2 秒/次）
- 保持会话一致性（使用相同 IP 和设备指纹）

---

## 安全建议

1. **保护用户凭证**:
   - 不要硬编码 Cookies 到代码中
   - 使用环境变量或配置文件存储敏感信息
   - 定期更新 Token

2. **遵守使用规范**:
   - 控制请求频率，避免对服务器造成压力
   - 仅用于合法用途（如个人学习工具）
   - 不要用于批量爬取或商业用途

3. **错误处理**:
   - 捕获并处理网络错误
   - 检查响应状态码
   - 实现重试机制（指数退避）

---

## 相关文档

- [完整 API 文档](./API_DOCUMENTATION.md) - 516 个 API 详细文档
- [加密算法参考](./ENCRYPTION.md) - 签到、课程认证等加密场景
- [项目 README](../README.md) - 项目概述和使用指南

---

## 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0 | 2026-05-07 | 初始版本，基于 HAR 文件分析 |

---

**许可证**: MIT  
**维护者**: PassChaoxing Team  
**问题反馈**: [GitHub Issues](https://github.com/your-repo/issues)
