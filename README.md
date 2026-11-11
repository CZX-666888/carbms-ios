# 随车电源 · iOS 测试版（TestFlight）打包说明

这份工程是车主端的 iOS 外壳：启动后直接加载 `https://chezhi.xin/h5/` 的 H5 车主端，登录后即可查看设备运行参数、告警、轨迹，并下发定位 / 上报间隔 / 重启三类控制指令。

## 为什么要在 GitHub 上编译

本机是 Windows，没有 Xcode，苹果的 `.ipa` 只能在 macOS 上编译签名。这台机器上一次的氛围灯 iOS 包也是同样绕法：代码放 GitHub，用 GitHub 免费提供的 macOS 机器跑 `xcodebuild`，签名后自动走 App Store Connect 传到 TestFlight。

## 工程结构

```
ios-app/
├─ project.yml                       XcodeGen 工程定义（bundle id / 版本号 / 签名方式）
├─ Sources/
│  ├─ AppDelegate.swift              应用入口
│  └─ RootViewController.swift       WKWebView 外壳，加载车主端 H5
├─ Resources/Info.plist              应用信息、显示名“随车电源”、深色模式、竖屏
└─ .github/workflows/ios-testflight.yml   推 main 自动打 archive → 导出 ipa → 上传 TestFlight
```

## 需要先配好的四样东西（都在 GitHub 仓库 Secrets 里）

| Secret | 说明 |
|---|---|
| `ASC_KEY_ID` | App Store Connect API 密钥的 Key ID（10 位） |
| `ASC_ISSUER_ID` | Issuer ID（UUID 形式） |
| `ASC_KEY_P8` | `.p8` 私钥文件内容的 base64，一条命令可生成：`base64 -i AuthKey_XXXX.p8` |
| `APPLE_TEAM_ID` | 开发者账号 Team ID（10 位），developer.apple.com 右上角 Membership 里能看到 |

API 密钥在 App Store Connect →「用户和访问 → 集成 → App Store Connect API」里新建，权限选「App 管理」。`.p8` 只能下载一次。

## Apple 后台还需要建的东西

1. **Bundle ID**：`com.chezhixin.carbms`（在 developer.apple.com → Identifiers 新建 App ID，能力只需默认）
2. **App 记录**：App Store Connect →「我的 App」新建 iOS App，套装 ID 选上面这个，名称填“随车电源”
3. 首次上传后到 TestFlight 里配置内部测试人员

## 触发打包

推到 `main` 分支即自动跑；也可以在 GitHub 仓库 Actions 页手动 `Run workflow`。

成功的标志：Actions 日志最后出现 `No errors uploading`，随后 App Store Connect → TestFlight 里出现新的构建版本（处理几分钟后才可测）。

## 已做过与未做的

已做：WKWebView 外壳、进度条、深色状态栏适配、Info.plist 权限描述、自动签名 + API Key 认证的完整 CI 流程。

未做：iOS 原生阿里云号码认证一键登录（需要 iOS 版 SDK 与 Xcode 工程内嵌 framework，当前测试版走 H5 里的短信验证码登录）；AppIcon 与启动图（测试版可用，正式上架前需补 1024×1024 图标）。
