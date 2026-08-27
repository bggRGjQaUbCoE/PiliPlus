<div align="center">
  <img width="200" height="200" src="assets/images/logo/logo.png" alt="PiliPlus">
  <h1>PiliBro FreeRate</h1>
  <p>使用 Flutter 开发的 Bilibili 第三方客户端 · 哥哥科技维护的自由速率分支</p>
  <p><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/ucxn/Bili.Libre.Speed"> <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/ucxn/Bili.Libre.Speed"> <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/ucxn/Bili.Libre.Speed/total"></p>
  <img src="assets/screenshots/510shots_so.png" width="32%" alt="home" /> <img src="assets/screenshots/174shots_so.png" width="32%" alt="home" /> <img src="assets/screenshots/850shots_so.png" width="32%" alt="home" />
  <br><img src="assets/screenshots/main_screen.png" width="96%" alt="main screen" />
</div>

## FreeRate · 自由速率

哥哥科技维护的 PiliPlus 分支，顾名思义——“自由速率”~ 专为偏爱高倍速、高信息熵的朋友们打造：热爱博物、渴求信息、资源饥渴、节约时间……凡是想在有限的生命中了解更多信息、高效看视频的，都可以选择本软件！测试宽带真实业务速率：网络 CDN 诊断、高峰调控、弱网优化，助你流畅，护你冲浪！

**高倍速与观看统计：** 默认倍速、长按倍速与长按倍率系数均可自定义，长按期间可滑动调整临时倍速，持续 2 秒可锁定当前速度；统计区分普通观看/倒带重看、播放/暂停/缓冲与基础/临时倍速，计算实际/名义平均倍速、倍速节约时间、倒带等效倍速与完成率，并记录评论区停留、前进跳转、按 UP 主/年份/直播主播汇总等，完整原始统计可随设置导入导出。 **网络与 CDN：** Wi-Fi/蜂窝可分别设置画质、音质、编码及 CDN 优先级，多 CDN 按顺序使用，连接失败自动回退并明确提示；测速直接模拟真实视频业务，可设置单 CDN 数据量、预热、冷却与并行/串行模式，长期保存原始诊断，分离 DNS 与首包等待，记录响应头、250 ms 固定窗吞吐、P02/P05/P50/P95、带宽抖动与趋势、最大传输空窗、解析 IP 等指标。

**弱网、高峰与缓冲：** PC 可按有线链路速率、Wi-Fi RSSI/协商速率等状态判断“等效宽带/等效移网”，Windows 可查看当前网卡、收发协商速率、Metric、MTU 等；网络高峰期支持多时段、条目独立启停，并临时覆盖编码偏好；按流量计费的 Wi-Fi 直接沿用蜂窝策略。缓冲分为宽带、非蜂窝弱网、真蜂窝三套配置，弱网可选择与宽带同步；联动判断主要发生在启动、进入播放器等关键节点，不持续扫描。 **更多可观察性：** 应用流量按小时统计上下行，并区分 Wi-Fi、等效移网与真蜂窝；播放器显示当前视频流大小/估算大小与总码率；首选编码不可用、CDN 回退、硬解兜底均给出明确提示；AI 字幕增加 UP 主粉丝数阈值控制。

**离线解码实验室：** 在离线缓存界面增加离线解码测试，您可以在固定倍速、关闭弹幕、同一视频、同一起点播放相同时间，观察播放器实际推进的时间，得出实际倍速。您也可以指定某一编码器，看它在您的设备上性能到底如何。我们不关心复杂的实现，我们只关心该解码器在您的设备上到底能为您节约多少时间。测试方法非常朴素，就是可以选择不改变设置、轻微丢帧和激进丢帧，看流逝相同的物理时间，播放器时间能推进多少？**UI 针对实验优化：** 抛弃所有入口必须统一的教科书形式主义、学院派，例如当前视频切换 CDN 变成单选题，避免复杂的排序。在不同的场景运用不同的选择偏好复杂度。

## 适配平台
Android、iOS、Pad、Windows、Linux。

[![Packaging status](https://repology.org/badge/vertical-allrepos/piliplus.svg)](https://repology.org/project/piliplus/versions)

## PiliPlus 基础功能

**内容与播放：**
推荐/最热视频/热门直播/番剧、分 P/合集/互动视频，弹幕/高级弹幕/字幕、高能进度条、SponsorBlock、DLNA、PIP、离线缓存与播放、音频播放、片头片尾跳过、画质/音质/解码预设、硬件加速、超分辨率、记忆播放、视频比例、滑动缩略图预览、视频动图、Live Photo、AI 原声翻译、课堂视频等；

**账号与互动：** Cookie/短信/极验登录、多账号、无痕/游客模式，用户主页/粉丝/关注/拉黑，动态/评论/私信/SuperChat/投票/分享，点赞/投币/收藏、关注分组、收藏夹/稍后再看管理，图文/富文本/表情/@用户、楼中楼、举报/置顶/撤回/删除等；

**搜索与设置：** 热搜/搜索历史/默认搜索词，投稿/番剧/直播间/用户搜索及排序筛选，WebDAV 设置备份/恢复，主题、图片质量、震动、高帧率、自动全屏/横屏、字幕/弹幕大小、亮度/音量等。

### refactor

<input type="checkbox" disabled> gRPC [wip]　
<input type="checkbox" checked disabled> 用户界面　
<input type="checkbox" checked disabled> 其他

## 下载

可从右侧 Releases 下载，也可拉取 `dev` 分支本地编译。Android 使用独立包名 `org.BroTech.gege.piliplus`，可与上游 PiliPlus 并存；本分支 Release 使用固定签名，同签名的后续构建可直接覆盖升级。

## 声明与致谢

本项目基于 [PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus) 继续开发，仅用于学习和测试，请于下载后 24 小时内删除；所用 API 皆从官方网站收集，不提供任何破解内容。本仓库对倍速、网络、CDN 与播放策略进行了更激进的修改，感谢原作者 [guozhigq/pilipala](https://github.com/guozhigq/pilipala)、上游 [orz12/PiliPalaX](https://github.com/orz12/PiliPalaX) 以及 PiliPlus 全体贡献者的开源工作。

特别感谢 [@My-Responsitories](https://github.com/My-Responsitories) 等贡献者，以及 [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)、[flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)、[media-kit](https://github.com/media-kit/media-kit)、[dio](https://pub.dev/packages/dio) 等项目。

PiliBro，乾杯-( ゜- ゜)つロ

本项目主要面向个人学习、技术研究与非商业使用，并尤其鼓励具有明确、合理目的的使用场景。例如：用于公立学校、班级、实验室、社团等非营/盈利环境中的旧设备或低性能设备，在不额外增加硬件负担的前提下小规模在受限的、可控的计算机系统上安装，改善学习和观看体验；用于个人所有、仅供本人使用的私人设备，通过更自由的倍速控制、长按临时倍速、弱网适应和播放策略调整，让软件更贴合个人长期形成的观看习惯；用于预/学/复习高考、考研、语言学习、专业课程、资格考试、论文资料搜集等持续数月乃至数年的学习阶段，在大量课程、讲座、访谈、纪录片和知识型视频之间更有效地分配时间；用于需要快速回顾已经熟悉内容的场景，在保留完整语义和上下文的同时减少重复信息占用的时间；用于高信息摄入需求的用户，在兴趣足够广、想看的内容远多于可支配时间时，把有限的注意力留给真正值得停留、思考和反复观看的部分。

本项目尤其重视长期统计所具有的个人意义。观看时间、实际平均倍速、不同阶段的倍速习惯、倒带重看、暂停与缓冲、节约时间等数据，在当天看来可能只是一些数字，经过几年甚至十几年积累后，却可能成为一份非常具体的个人信息生活记录：曾经把多少时间用于学习、兴趣与探索，哪些年份看得更多，哪些创作者陪伴得更久，又通过更高效的播放方式为自己留下了多少原本会消失在重复等待中的时间。其意义并不一定在于追求某个更高的数字，而在于让长期行为能够被看见、被回顾、被保存，避免很多年后只剩下一句模糊的“以前好像看过很多东西”，却再也不知道那些时间究竟去了哪里。

它同样适合把视频当作一种日常知识媒介，而非单纯娱乐内容的人：有人习惯用书阅读，有人喜欢播客，也有人大量依赖视频获取科技、人文、历史、社会、音乐、交通、地理、自然科学等不同领域的信息。当兴趣范围不断扩大，而一天仍然只有 24 小时时，提高单位时间的信息获取效率就具有真实的边际价值。节约下来的10分钟、半小时，在单独一次观看中并不起眼；当这种差异重复数千次、延续数年以后，它最终对应的是更多读完的资料、更多看完的课程、更多了解过的领域，以及更多真正属于自己的自由时间。

其他合理场景还包括：在通勤、候车、课间等碎片时间快速处理已经收藏的视频；为需要反复复习的课程建立更符合个人节奏的观看方式；在较差网络、老旧硬件或资源有限的设备上减少无意义的卡顿和资源浪费；通过长期数据观察自己的注意力与观看习惯变化；对播放器交互、倍速算法、统计模型、缓冲策略、编码选择和跨平台适配进行学习与实验；在考研、考试准备或更多需要长期专注的阶段，用于学习效率管理与自律；仅通过私聊等非公开方式分享给现实生活中相识的挚友、亲人或家人，供共同学习、测试或个人使用；以及单纯因为珍惜自己的时间，用于仅供个人使用的私人设备，希望一件每天都要使用的软件能够真正服从于人的习惯，而非让人反过来适应软件预设的节奏：其边界效用在于节约自己宝贵的时间和生命。

本项目无意建立独立的软件分发体系，也不鼓励以商业推广、广告捆绑、流量获利、批量转载或其他与上述用途明显无关的方式传播。上述内容主要用于说明项目的创作目的与作者认可的合理使用方式，不改变上游项目原有许可证及各原作者依法享有的权利。
The open-source authors—whether associated with or unrelated to this matter—and I shall not be held liable for any consequences or disputes arising from the use of methods not recommended on the official website; the developers bear no legal responsibility.

Most of the code included in this project remains the copyrighted work and intellectual property of its respective original authors and upstream contributors.
It is provided here solely for non-commercial, educational, research, and transformative purposes.
This project is strictly a fan-made modification and is not affiliated with, maintained by, authorized by, endorsed by, or sponsored by Bilibili or any other SaaS platform, website, or service provider.
The simple proposition that a person's limited time is itself a resource worth respecting.

## Star History

<a href="https://star-history.dera.page/#ucxn/Bili.Libre.Speed&Date"><picture><source media="(prefers-color-scheme: dark)" srcset="https://star-history.dera.page/svg?repos=ucxn/Bili.Libre.Speed&type=Date&theme=dark" /><source media="(prefers-color-scheme: light)" srcset="https://star-history.dera.page/svg?repos=ucxn/Bili.Libre.Speed&type=Date" /><img alt="Star History Chart" src="https://star-history.dera.page/svg?repos=ucxn/Bili.Libre.Speed&type=Date" /></picture></a>
