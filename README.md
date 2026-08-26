<div align="center">
  <img width="200" height="200" src="assets/images/logo/logo.png" alt="PiliPlus">
  <h1>PiliPlus FreeRate</h1>
  <p>使用 Flutter 开发的 Bilibili 第三方客户端 · 哥哥科技维护的自由速率分支</p>
  <p><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/ucxn/Bili.Libre.Speed"> <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/ucxn/Bili.Libre.Speed"> <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/ucxn/Bili.Libre.Speed/total"></p>
  <img src="assets/screenshots/510shots_so.png" width="32%" alt="home" /> <img src="assets/screenshots/174shots_so.png" width="32%" alt="home" /> <img src="assets/screenshots/850shots_so.png" width="32%" alt="home" />
  <br><img src="assets/screenshots/main_screen.png" width="96%" alt="main screen" />
</div>

## FreeRate · 自由速率

哥哥科技维护的 PiliPlus 分支，顾名思义——“自由速率”~ 专为偏爱高倍速、高信息熵的朋友们打造：热爱博物、渴求信息、资源饥渴、节约时间……凡是想在有限的生命中了解更多信息、高效看视频的，都可以选择本软件！测试宽带真实业务速率：网络 CDN 诊断、高峰调控、弱网优化，助你流畅，护你冲浪！

**高倍速与观看统计：** 默认倍速、长按倍速与长按倍率系数均可自定义，长按期间可滑动调整临时倍速，持续 2 秒可锁定当前速度；统计区分普通观看/倒带重看、播放/暂停/缓冲与基础/临时倍速，计算实际/名义平均倍速、倍速节约时间、倒带等效倍速与完成率，并记录评论区停留、前进跳转、按 UP 主/年份/直播主播汇总等，完整原始统计可随设置导入导出。 **网络与 CDN：** Wi-Fi/蜂窝可分别设置画质、音质、编码及 CDN 优先级，多 CDN 按顺序使用，连接失败自动回退并明确提示；测速直接模拟真实视频业务，可设置单 CDN 数据量、预热、冷却与并行/串行模式，长期保存原始诊断，分离 DNS 与首包等待，记录响应头、250 ms 固定窗吞吐、P02/P05/P50/P95、带宽抖动与趋势、最大传输空窗、解析 IP 等指标。

**弱网、高峰与缓冲：** PC 可按有线链路速率、Wi-Fi RSSI/协商速率等状态判断“等效宽带/等效移网”，Windows 可查看当前网卡、收发协商速率、Metric、MTU 等；网络高峰期支持多时段、条目独立启停，并临时覆盖编码偏好；按流量计费的 Wi-Fi 直接沿用蜂窝策略。缓冲分为宽带、非蜂窝弱网、真蜂窝三套配置，弱网可选择与宽带同步；联动判断主要发生在启动、进入播放器等关键节点，不持续扫描。 **更多可观察性：** 应用流量按小时统计上下行，并区分 Wi-Fi、等效移网与真蜂窝；播放器显示当前视频流大小/估算大小与总码率；首选编码不可用、CDN 回退、硬解兜底均给出明确提示；AI 字幕增加 UP 主粉丝数阈值控制。

## PiliPlus 基础功能

**内容与播放：** 推荐/最热视频/热门直播/番剧、分 P/合集/互动视频，弹幕/高级弹幕/字幕、高能进度条、SponsorBlock、DLNA、PIP、离线缓存与播放、音频播放、片头片尾跳过、画质/音质/解码预设、硬件加速、超分辨率、记忆播放、视频比例、滑动缩略图预览、视频动图、Live Photo、AI 原声翻译、课堂视频等；**账号与互动：** Cookie/短信/极验登录、多账号、无痕/游客模式，用户主页/粉丝/关注/拉黑，动态/评论/私信/SuperChat/投票/分享，点赞/投币/收藏、关注分组、收藏夹/稍后再看管理，图文/富文本/表情/@用户、楼中楼、举报/置顶/撤回/删除等；**搜索与设置：** 热搜/搜索历史/默认搜索词，投稿/番剧/直播间/用户搜索及排序筛选，WebDAV 设置备份/恢复，主题、图片质量、震动、高帧率、自动全屏/横屏、字幕/弹幕大小、亮度/音量等。

## 平台与下载

**适配平台：** Android、iOS、Pad、Windows、Linux。可从右侧 Releases 下载，也可拉取 `dev` 分支本地编译。Android 使用独立包名 `org.BroTech.gege.piliplus`，可与上游 PiliPlus 并存；本分支 Release 使用固定签名，同签名的后续构建可直接覆盖升级。

## 声明与致谢

本项目基于 [PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus) 继续开发，仅用于学习和测试，请于下载后 24 小时内删除；所用 API 皆从官方网站收集，不提供任何破解内容。本仓库对倍速、网络、CDN 与播放策略进行了更激进的修改，感谢原作者 [guozhigq/pilipala](https://github.com/guozhigq/pilipala)、上游 [orz12/PiliPalaX](https://github.com/orz12/PiliPalaX) 以及 PiliPlus 全体贡献者的开源工作。

特别感谢 [@My-Responsitories](https://github.com/My-Responsitories) 等贡献者，以及 [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)、[flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)、[media-kit](https://github.com/media-kit/media-kit)、[dio](https://pub.dev/packages/dio) 等项目。PiliPlus，乾杯-( ゜- ゜)つロ

## Star History

<a href="https://star-history.dera.page/#ucxn/Bili.Libre.Speed&Date"><picture><source media="(prefers-color-scheme: dark)" srcset="https://star-history.dera.page/svg?repos=ucxn/Bili.Libre.Speed&type=Date&theme=dark" /><source media="(prefers-color-scheme: light)" srcset="https://star-history.dera.page/svg?repos=ucxn/Bili.Libre.Speed&type=Date" /><img alt="Star History Chart" src="https://star-history.dera.page/svg?repos=ucxn/Bili.Libre.Speed&type=Date" /></picture></a>
