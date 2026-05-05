# 超星 - 课程学习助手

一个基于 Flutter 开发的超星学习通课程学习助手客户端，帮助你更高效地管理课程、完成作业、参与签到。

## 功能特性

### 课程管理
- 课程列表浏览与搜索
- 课程活动查看（随堂练习、投票、问卷等）
- 课程资料下载与预览

### 作业与考试
- 作业列表查看与 WebView 作答
- 考试列表查看与 WebView 答题
- 作业/考试通知点击直达

### 签到功能
- 普通签到（支持拍照）
- 二维码签到（支持自动执行）
- 位置签到（百度地图选点）
- 手势签到（3x3 九宫格）
- 签到码签到
- 群组页面扫码直接签到

### 社交与群组
- 群组列表与私聊管理
- 群组聊天（文本、图片、文件、语音、视频、位置等 10 种消息类型）
- 实时消息推送与后台通知
- 好友搜索与添加
- 通讯录与联系人管理

### 云盘功能
- 文件浏览与管理
- 文件上传与下载
- 文件夹创建与删除
- 回收站管理
- 文件预览（WebView）

### 通知系统
- 通知收件箱（增量轮询）
- 作业/考试通知直达 WebView
- 系统通知与推送集成
- 一键已读功能

### 个性化
- 8 种内置主题（默认、深色、渐变等）
- 自定义页面背景（渐变色、纯色、图片）
- 图片背景透明度、裁剪方式、对齐方式配置
- Material 3 动态配色

### 账号管理
- 多账号切换
- 密码登录、验证码登录
- 网页扫码授权登录
- 二维码登录（APP 扫描）
- 修改密码

## 技术栈

- **Flutter** ^3.35.4 / **Dart** ^3.9.2
- **状态管理**: Riverpod 2.0 (riverpod_annotation + code generation)
- **架构模式**: Clean Architecture (Domain → Data → Infrastructure → Presentation)
- **路由**: go_router (声明式路由 + ShellRoute)
- **数据模型**: Freezed (不可变数据类 + JSON 序列化)
- **错误处理**: fpdart Either + Freezed Failure 联合类型
- **网络**: Dio + Cookie 管理
- **加密**: AES-CBC 加密服务
- **本地存储**: SharedPreferences
- **即时通讯**: 环信 IM SDK (im_flutter_sdk)
- **地图服务**: 百度地图 SDK (flutter_baidu_mapapi_map, flutter_bmflocation)
- **WebView**: webview_flutter

## 项目结构

```
lib/
├── main.dart                          # 应用入口
└── v2/                                # V2 重构代码
    ├── app.dart                       # 应用配置（主题、路由、通知处理）
    ├── app_dependencies.dart          # 全局依赖注入入口
    ├── data/                          # 数据层
    │   ├── datasources/remote/chaoxing/  # API 客户端（15个）
    │   │   ├── cx_auth_api.dart         # 认证登录
    │   │   ├── cx_account_manage_api.dart # 账号管理（修改密码、验证码）
    │   │   ├── cx_course_api.dart       # 课程与活动
    │   │   ├── cx_exam_api.dart         # 考试
    │   │   ├── cx_homework_api.dart     # 作业
    │   │   ├── cx_signin_api.dart       # 签到
    │   │   ├── cx_quiz_api.dart         # 测验
    │   │   ├── cx_todo_api.dart         # 待办
    │   │   ├── cx_notice_api.dart       # 通知
    │   │   ├── cx_pan_api.dart          # 云盘
    │   │   ├── cx_materials_api.dart    # 课程资料
    │   │   ├── cx_group_im_api.dart     # 群组 IM
    │   │   ├── cx_chat_api.dart         # 聊天消息
    │   │   ├── cx_friend_contact_api.dart # 通讯录
    │   │   └── cx_upload_api.dart       # 图片上传
    │   ├── mappers/                     # DTO → Entity 映射器
    │   ├── models/                      # Freezed DTO 数据类
    │   └── repositories/                # Repository 实现
    ├── domain/                          # 领域层
    │   ├── entities/                    # 业务实体（16个）
    │   │   └── enums.dart               # 枚举类型
    │   ├── failures/                    # Failure 联合类型
    │   ├── repositories/                # Repository 接口
    │   └── usecases/                    # 用例（30+个）
    ├── infra/                           # 基础设施层
    │   ├── crypto/                      # AES 加密服务
    │   ├── network/                     # DioClient + CookieInterceptor
    │   ├── services/                    # 运行时服务
    │   │   ├── im_service.dart          # 环信 IM 服务
    │   │   ├── notification_service.dart # 通知服务
    │   │   ├── push_dispatcher.dart     # 推送分发导航
    │   │   ├── dnd_service.dart         # 免打扰服务
    │   │   ├── member_name_cache.dart   # IM 昵称/头像缓存
    │   │   ├── platform_service.dart    # 平台切换
    │   │   └── legacy_storage_service.dart
    │   ├── storage/                     # 存储
    │   │   ├── cookie_manager.dart      # CookieJar 管理
    │   │   └── storage_service.dart     # SharedPreferences
    │   └── theme/                       # 主题系统
    │       ├── theme_data.dart          # 主题数据
    │       ├── theme_compiler.dart      # 主题编译
    │       └── theme_extensions.dart    # 主题扩展（背景系统）
    └── presentation/                    # 表现层
        ├── controllers/                 # Riverpod Controllers
        ├── pages/                       # 页面（30+个）
        │   ├── course_list_page.dart    # 课程列表
        │   ├── course_detail_page.dart  # 课程详情
        │   ├── homework_list_page.dart  # 作业列表
        │   ├── homework_webview_page.dart # 作业 WebView
        │   ├── exam_list_page.dart      # 考试列表
        │   ├── exam_webview_page.dart   # 考试 WebView
        │   ├── sign_in_page.dart        # 签到主页
        │   ├── group_list_page.dart     # 群组列表
        │   ├── group_chat_page.dart     # 群组聊天
        │   ├── pan_page.dart            # 云盘
        │   ├── notice_inbox_page.dart   # 通知收件箱
        │   ├── notice_detail_page.dart  # 通知详情
        │   ├── location_select_page.dart # 位置选择（百度地图）
        │   ├── theme_settings_page.dart # 主题设置
        │   └── ...
        ├── providers/                   # Riverpod DI 提供者
        │   ├── providers.dart           # 控制器提供者
        │   ├── services_providers.dart  # 服务提供者
        │   └── theme_provider.dart      # 主题提供者
        ├── routing/                     # 路由配置
        │   └── app_router.dart          # GoRouter 声明
        ├── widgets/                     # 共享 UI 组件
        │   ├── sign_areas/              # 签到区域组件
        │   │   ├── normal_sign_area.dart    # 普通签到
        │   │   ├── code_sign_area.dart      # 签到码
        │   │   ├── location_sign_area.dart  # 位置签到
        │   │   ├── qr_code_sign_area.dart   # 二维码签到
        │   │   ├── pattern_sign_area.dart   # 手势签到
        │   │   └── group_sign_area.dart     # 群组签到
        │   ├── accounts_selector.dart   # 账号选择器
        │   ├── captcha_dialog.dart      # 验证码对话框
        │   ├── network_image.dart       # 网络图片
        │   └── staggered_animation.dart # 交错动画效果
        └── utils/                       # 工具类
            └── image_picker_helper.dart # 图片选择器
```

## 快速开始

### 环境要求

- Flutter SDK >= 3.35.4
- Dart SDK >= 3.9.2
- Android SDK / Xcode (iOS)
- 百度地图 API Key（用于位置签到）

### 安装依赖

```bash
flutter pub get
```

### 配置环境变量

复制 `.env.example` 为 `.env`，填入百度地图 API Key：

```env
BAIDU_MAP_API_KEY=your_api_key_here
```

### 生成代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 运行应用

```bash
flutter run
```

### 构建 APK

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release
```

## 架构设计

本项目采用 **Clean Architecture**（整洁架构），分为四层：

### Domain 层（领域层）
- 业务实体（Entities）
- Repository 接口（接口定义）
- 用例（UseCases）- 业务逻辑封装

### Data 层（数据层）
- Repository 实现（实现 Domain 层的接口）
- 数据模型（DTOs）
- 数据源（API 客户端）

### Infrastructure 层（基础设施层）
- 网络请求（Dio）
- 加密服务
- 存储服务
- IM 服务、通知服务等

### Presentation 层（表现层）
- 页面（Pages）
- 控制器（Controllers - Riverpod）
- 提供者（Providers - Riverpod）
- 组件（Widgets）
- 路由（Router）

### 数据流

```
UI (Pages/Widgets)
  ↓ 调用
Controller (Riverpod)
  ↓ 调用
UseCase (Domain)
  ↓ 调用
Repository (Data)
  ↓ 调用
DataSource (API)
  ↓ 返回
DTO → Mapper → Entity
  ↓ 返回
UI
```

## 开源协议

本项目采用 [GPL-3.0](LICENSE) 开源协议。

## 免责声明

本项目仅用于技术研究和学习交流，请勿用于非法用途。使用者需自行承担因使用本项目产生的所有法律责任。
