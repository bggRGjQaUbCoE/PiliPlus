# LG HLG→PQ 亮度映射与实际输出排查

## Current State（2026-10-27，观感验收通过；用户授权提交、推送）

- **当前方案**：HLG YUV载体以1000为参考峰值，gamma保持中性0，取消自动gamma+3，保留用户显式gamma偏好；无附加曲线。5份生产/测试源哈希与105项测试、analyze零问题记录一致。
- **人眼同帧验证**：熊场景35.035秒“基本一致”；夕阳720.052666667秒同背光255，“基本一致，没有明显过曝或细节丢失”；近黑600.032766667秒原HDR10与原HLG，在背光253下“基本一致”。同一近黑HDR10静态文件直通/离屏也“基本一致”。每次均等用户看清A后切B。
- **数值边界**：原片35秒以实际HDR10 FBO分段，0.1–1000nit中位偏差最大3.8733%；≥1000nit仅103像素为+6.7930%；没有<0.1nit样本，P90像素误差仍大于分段中位误差。10场景1080CRF12 fixture的少量暗边缘/高光残差保留，不宣称逐像素、全片或面板实测nits一致。已测附加曲线会伤及其他场景，不再盲加gamma或曲线。
- **主应用交付**：标准当前源码构建VERIFIED，APK `lg-hlg-reference-1000-g0-20261026-release.apk` SHA256 `6da37fb90c60e736db1700b0e0852ff965fa756cf50aff95958c1868e42d955f`；已装LG，设备base.apk一致。北海道原片BV1vY4y1N7TY：facts HLG/DV8 compat4、硬解SurfaceTexture、baseLayerConvert/gpu-next/PQ/ext:lg-pq、peak1000、applied verified=true；HDR1/背光255/thermal0。主App未直接采样gamma属性，不冒称实读gamma0。永久摘要：`archives/evidence/lg-hlg-pq-minimal-20261027.json`。
- **最终验收通过**：用户对主应用连续播放明确反馈“正常，采用这版”。采用1000参考峰值/gamma0、取消自动+3、无附加曲线，完成本轮实用映射与设备观感交付。保留数值残差边界，不宣称逐像素或全片零误差。当前安装保留，未暂存、未提交、未推送。
- **状态保护**：临时亮度覆盖已恢复，随后外部设置manual0/253予以保留；主App播放实际背光255另作运行采样，不写系统亮度。未暂存、未提交、未推送，未知工作区修改保留。并行助手额度不足，Lead处理交互与记录。

- **提交授权**：2026-10-27用户明确要求“提交、推送”。本次仅提交media-kit五份生产/测试文件及对应记录；HDR Lab、mpv临时诊断和其他未知修改不纳入。推送两个当前分支，包含此前已存在的未推送提交。

- **最终代码提交**：media-kit `806f75f8`（`fix(hdr): 修正 HLG 转 PQ 参考峰值并移除自动 gamma 提亮`），五份生产/测试源暂存字节与105项测试验收哈希完全一致；本仓仅提交本任务记录，不包含播放器其他改动。

## 历史过程（以下为按阶段保留的旧状态，当前结论以上方 Current State 为准）

### 2026-10-27交付前各阶段快照（由顶部Current State统一取代）

## Current State（2026-10-27，熊/夕阳/近黑观感均通过；主应用安装完成、运行验证中，未提交）

- **生产候选不变**：HLG YUV载体使用1000参考峰值，取消自动gamma+3，保持gamma0与用户显式gamma偏好；不加额外曲线。5份生产/测试源仍匹配105 tests、analyze0验证哈希。未提交、未暂存。
- **原片35.035秒实际回读**：原正常4K P8.4/HLG输入与原HDR10输入都取得唯一native selected_pts=35.035000000，输出统一1920×960。源字节/手机副本MD5匹配；硬解SurfaceTexture/gpu-next/PQ、HLG1000/g0与HDR参考10000/g0均实读验证。不是1080p重编码fixture替代原片。
- **原片数值结果**：以actual HDR10 FBO固定分bin，0.1–1000nit中位偏差最大3.8733%；≥1000nit n103为+6.7930%，仍超工作门限。没有<0.1nit样本；主区P90绝对相对误差17.9–41.2%，不能宣称逐像素匹配。最终报告`/tmp/lg-hlg-fit-20261026/results/original-pair-analysis.json` SHA b56d09da8cac0ed33a802243bd16ce2fbcff8fc3d489840dfdbce241ec5f36ca，独立V1通过。
- **原始无效记录保留**：HLG run-hlg-4仅因无依据的complete<STEP_DONE规则标invalid，原manifest/log/raw未改。独立33门重验通过，`original4k/run-hlg-4-revalidation.json` SHA 1d63b510c01b2f1b51b2e303f53d6451e6adab3911bfecfcf16826441256b2be，状态revalidated/originalStatus=invalid；Dart暂停确认不是VO GPU/文件写完栅栏。原HDR run-hdr10-1为verified。早期空参数、公共目录权限拒绝、日志解析失败不计亮度成功。
- **用户同帧观感（当前验收）**：用户选择“先做LG同帧观感对比，再决定”。visual-hdr10-A2与visual-hlg-B1均verified，actual_pts均35.035；A/B均HDR1、实测背光30、thermal0，系统保持自动亮度模式1/设置255。用户先确认看清A，再反馈B“基本一致”。画面保持暂停；未把这一帧当成全片或近黑验收。
- **当前下一步**：用户明确要求“再看夕阳和近黑”。先720秒夕阳A看清后切B，再600秒近黑；每次等待用户观察确认，不自动切换。对应标准源码包正在顺序构建（会话57900），尚未作这两组视觉验收。900秒两包已标准VERIFIED但未运行，暂不扩展数值探索。并行助手额度不足，Lead直接接管本轮交互与记录。
- **累计证据边界**：先前10场景actual FBO使用1080p CRF12 fixture，和本原片对照分开；旧t900低段+43.55%、bear高尾+13.85%、sunset高尾−7.91%及暗段.02424nit等残差仍为该fixture数据事实。已测附加曲线、位移/缩放顺序无稳健修复，不再重复扫描；不推断全体曲线不可能。完整goal active，最终NV12/HWC与面板nits未量测，待夕阳/近黑人眼反馈后决定最简方案。

- **2026-10-27观感进展**：夕阳原片A/B actual_pts=720.052666667，在相同背光255、HDR1、thermal0下，用户确认“基本一致，没有明显过曝或细节丢失”。近黑同一HDR10静态文件直通/离屏也确认“基本一致”；这仅验证参考输出路径，原片HLG近黑仍待B反馈。
- **当前近黑切换**：原HDR10 A2 actual_pts=600.032766667已verified，用户已确认看清A，现在切到原4K HLG B（1000/gamma0）。此前临时亮度覆盖已恢复；之后系统外部变为manual0/253，保留最新设置，A/B按253核对，不覆盖回旧auto设置。
- **主应用交付准备**：标准当前源码构建已VERIFIED：`lg-hlg-reference-1000-g0-20261026-release.apk` SHA256 `6da37fb90c60e736db1700b0e0852ff965fa756cf50aff95958c1868e42d955f`，原生libmpv SHA256 `fea2b1ed0b631969b69f8e92b89fd83d44a19dcfee6edf0c271cc41a4a9867aa`。尚未安装，待最终近黑观感与方案选择；构建不能替代主应用设备播放验收。未提交。

- **近黑B已就绪**：`t600/visual-hlg-B1-original-fixed/captures.json` verified，native selected_pts=600.032766667，与A相同。捕获快照曾因待机调暗为背光10；唤醒后`visual-display-awake.json`核实HDR1/背光253/thermal0、manual0/253，再询问用户观感，待反馈。未写亮度设置。

- **最终近黑观感通过**：用户确认同帧原片HLG B相比HDR10 A“基本一致”。熊/夕阳/近黑三组视觉检查通过，Lead据此采用既有最简1000/g0候选，无附加曲线；不据此宣称逐像素或全片零误差。主应用已安装LG，设备base.apk SHA256与候选一致（`piliplus-delivery/installed-identity.json`），正在原北海道BVID `BV1vY4y1N7TY` 检查实际路由。

- **主应用运行证据**：LG PID22114播放北海道原片 `BV1vY4y1N7TY`，facts HLG/DV8 compat4，`baseLayerConvert/gpu-next/surfacetexture/PQ/ext:lg-pq peak1000 verified=true`；panel HDR1/背光255/thermal0，media session playing且标题相符。无该PID已观察FATAL/HdrPlaybackBlocked/hwdecMismatch；主App未直接采样gamma属性，不冒称运行实读gamma0。5份源哈希仍匹配105测试/analyze0记录。永久摘要 `archives/evidence/lg-hlg-pq-minimal-20261027.json`。主应用连续播放人眼确认待用户；未提交。



### 早期原片验证前交接状态（已由上方更新取代）

- **生产状态**：保留最简1000/gamma0，不增加gamma或curve。生产候选源码变更仍在本地，默认APK SHA-256 `bfb242c977acf525c72de906e96267dff860287410216653b44add529810dd5f`，105 tests通过、analyze 0；四scene default GPU行为仍为1000/gamma0并逐字节匹配stage4。此证据不代表本轮native hook build或原片实测。
- **目标仍未完成**：全部10个actual FBO场景比较使用1080p CRF12 fixture；不能宣称原始4K P8.4端到端数值匹配。Lead核验手机与host上的原HLG原片MD5均为`49841d19824e262b30ebbedbdd2fbbe9`，文件未改；原HDR10参考两侧MD5均为`96f2f05adfe7131d79061211cd6d714f`。`original4k-protocol.md`只是测试协议设计稿。native gpu-next实际selected `mpi->pts` tag (`MKS-FBO-FRAME`)及Lab单帧step探针已写入工作树但未经review；目前仅有Dart analyze与clang `-fsyntax-only`静态检查报告（clang有2条既存`-Wundef`警告），尚未开始标准build、未操作设备、无原片FBO数据或结论；禁止使用旧4K lossless panic素材。
- **actual FBO基准与累计残差**：每个场景以actual HDR10 FBO Y固定分bin。累计10场景中，新增t180/420/1020主bin通过已采样门限；t420 400–1000 n=14欠采样；t1020 .01–.1nit n=194 median abs .0200372730nit，略超.02。不要说这就是累计唯一超限：已有1000/g0实际残差仍包括t900 .1–1nit n=107 signed median +43.55%、≥1000nit n=442 −5.93%；bear ≥1000nit n=100 +13.85%；sunset ≥1000nit n=807 −7.91%；sunset暗段median abs .024241nit（n=483）。FBO位于最终YUV/HWC/面板之前，无光学或人眼验收。
- **CPU诊断完成、未锁定成因**：resize/transfer顺序扫描是negative。边缘重建报告版本为`t900 fixed-profile source edge-reconstruction diagnostic`，分析JSON SHA-256 `740f5ac4186c400b72facab843ba99eddba4ea173f20992f72b558b4a6af9144`、脚本 SHA-256 `c198791bcd90ebc6ffef34c3f784b41154b7b315aee83e44cb9e7da571cf8303`；排除111邻域与ROI后，以22,692梯度样本得到dx=+.25/dy=0，相关性仅+.001337，111固定点signed median从+34.924%变为+42.492%，P90 abs log误差 .885629→1.147909，六条profile无统一位移/宽度。它不能证明独立转码是根因，也不支持源位置排除、平移或滤镜改动。
- **局部曲线CPU扫描**：版本`1.0.0-local-midshadow-11point-diagnostic`，脚本 SHA-256 `f60f67457a389ddae402a4916df5493baf53aff8c63c012e3a166b06e8dda856`，JSON SHA-256 `7b97d521d9d836b68b0404694ff305d5ab79530b44cb8dd65a01311ffa915b9f`。11个冻结y(1.5)值均无全门通过候选；y=.9使t900 .1–1nit变为−2.898%，但8个原通过主bin回归；暗参考bin有9像素改变，高尾0像素改变。独立review通过；没有新heldout或GPU实现。不据此修改生产映射。
- **下一步**：不重复已完成的resize顺序、全局边缘位移和11点曲线扫描；待native hook review及Lead确认后，按精确source PTS绑定原始4K素材，先走标准当前源码build，再取得匹配actual FBO证据。此处目前未验证，不预称通过。用户精度取舍async仍pending，不默认为接受极端残差；goal保持active。


- **当前进展（覆盖下方旧阶段待办）**：近黑FULL/LIMITED复看用户最终反馈“这次看基本没有区别”，先前B发灰未稳定复现；不采用LIMITED候选，保留原FULL，consumer优先级仍未证实。用户新要求比较HLG和HDR10离屏解码亮度，正在提取同内容帧并核对源信号、HLG OOTF和最终PQ三个层次。
- **新灰阶FBO run1未完成峰值对照**：`/tmp/lg-hlg-ootf-probe-20261026/run1/flutter-live.log`只完成500阶段；自定义峰值序列解析成`1000.0`被mpv整数选项拒绝，随后readback mismatch保护停止，不能宣称1000近黑下降已实测。500八柱输出约`.002783/.011446/.103854/.353959/1.440364/9.225300/126.964385/496.289391`信号nits；第3柱与基于OES输入的简单模型有约-26.6%偏差，保留未解释项。正在修正默认关闭的诊断序列整数格式并重新通过标准源码入口构建。
- 失败轮已停止测试App，清空luma/range诊断property，未修改系统亮度/旋转。后续实测另记，不以公式替代缺失数据。

- **用户确认新的比较顺序**：HDR10直通观感理想，但必须先确认同HDR10片离屏渲染与直通相符，再作为HLG参考；不能只凭离屏码值相等宣称屏幕相等。已在LG复用验证包采集直通基线（源文件fixture已换成PQ，配置路径仍ootf-gray）：真实HEVC/PQ/BT2020，hwdec=mediacodec、vo=mediacodec_embed、gamma0、target-peak auto、HDR1/背光255/thermal0，1920×960/7FA30C06。日志`/tmp/lg-hlg-hdr10-decoded-compare-20261026/direct-baseline/live.log`。500/1000 HLG探针因正确拒绝gamma0而不执行，不算本轮故障。
- HDR10静止参考源PTS720.019300，30秒902帧、原始YUV逐字节保持/902帧唯一hash，文件SHA`391b060b84cd860dcdc9ea2bbb08118416774832e5e340d4675c2ea95d5f2684`，LG`hdr10-reference.mp4` exec-out回读hash一致。当前HDR10生产直通并无FBO；现有convert realizer只接受HLG，正在补默认关闭lab-only真实PQ离屏诊断，禁止把输入伪标HLG。

- **HLG峰值/近黑机制现已离屏实测复现（run2）**：修复仅诊断的整数参数格式后，标准源码包`lg-hlg-ootf-probe2-20261026-release.apk` VERIFIED/装机SHA一致`074d7bab32b59525f17adba0ac028f2d2ea81d17aa575d4c7db421a6c9afc6e9`。完全相同900帧静止HLG，500/1000/500/1000各6秒，gamma3全程；24条GL prior/read/restore全0，源OES12次完全一致，同档重复精确一致，HDR1/背光255/thermal0，最终恢复500。八柱500→1000信号nits `.002783→.001532/.011446→.007186/.103854→.081881/.353959→.318188/1.440364→1.508206/9.225300→11.848035/126.964385→218.471077/496.289391→992.227754`。因此该共享HLG转换实际发生“高光增亮、近黑降低”，支持历史暗部反馈对应HLG系统gamma随目标变化的机制；不是面板光学实测，亦非最终NV12。bar2相对理想模型局部偏差仍保留。原始证据`/tmp/lg-hlg-ootf-probe-20261026/run2/`与独立`analysis-run2.json`。实验结束App停止、luma property清空；不改生产默认。

- **720.019300同帧统计口径更正**：先逐通道解PQ/HLG，再算线性BT2020 Y；旧文中HDR10 P95≈759、HLG500 P95≈380不能继续当每像素亮度分位数，近似通道池统计/非线性Y错误口径，已撤回这些数值。重新从源提取保留PQ/HLG RGB码值并验证精确PTS：HDR10线性Y P50/P90/P95/P99/P99.9=`9.07/134.80/337.20/941.68/980.44`信号nits；HLG500/gamma3模型=`7.56/84.19/185.88/474.92/478.54`，HLG1000/gamma3模型=`9.50/138.20/333.13/944.45/952.45`。二者分辨率不同，仅同内容分布比较；这些是源解码/HLG模型而非LG自然画面FBO。1000模型较接近此HDR10源分布不等于全场景应改1000，近黑降低实测约束继续有效。完整原帧/公式/manifest在`/tmp/lg-hlg-hdr10-decoded-compare-20261026/`。

- **HDR10离屏首包运行通过、数值测量未成立**：默认关闭lab-only PQ诊断的V1/analyze通过；标准源码APK`930440e2a8707f6763e2e893df4ee42145ea4623548c722f1d6f290ed83e8dee` VERIFIED且LG装机hash一致，1920×960 PQ条带fixturehash一致。实际PQ/hwdec surfacetexture/vo gpu-next/target10000/gamma0、RGBA16F→FULL YUV、HDR1/背光255/thermal0均成立。但ST-LUMA/YUV-LUMA采样0条，APK内probe字符串缺失，编译c_args=[]；worker误在deps/mpv/_build-arm64配置宏，而标准builder实际使用src/mpv/_build-arm64-mks，已认定本轮测量无效并重建。不能把路径运行成功当PQ数值等价。已停止App/清luma回桌面。证据`/tmp/lg-hlg-hdr10-decoded-compare-20261026/offscreen-bars/analysis.json`，生产默认未改。

- **当前进行：HDR10同静帧直通A→离屏B光学对照**：修正包`lg-hdr10-pq-offscreen2-20261026-release.apk` SHA`62f854633c8c044a1c49a49a12cd9b1ea59bd5a3e18e74e2550cb21b201785b9` VERIFIED/装机一致，APK实际probe marker存在，临时c_args恢复[]。均匀PQ条带12次重复OES/FBO读回稳定、GL头全0；ST→FBO局部线性Y差最高+4.54%，FBO对软件参考最高相对7.32%（最低亮档）、最高绝对21.685信号nit；不能称严格相等。ST identity shader mediump，不能把ST探针当零误差真值；尚无证据将差异归因于PQ公式或tone mapping。自然静帧离屏和直通均路由成功，HDR1/背光255/thermal0。用户已明确看清直通A并授权切B，正在安装/显示相同fixture的离屏B，待用户反馈；不改gamma/生产默认、不提交。
- **再次统计更正（本条覆盖先前撤回旧值的错误判断）**：GBR浮点文件的通道顺序必须[2,0,1]重排为RGB。此前新脚本漏了重排，导致错误HDR10 P95=337，并误撤回原P95≈759；现经独立Reviewer以YUV单像素反算复核，原HDR10 P95≈758.53/P99≈953.01正确；新337已撤回，不能继续引用。修正后的HLG500模型P95/P99≈392.77/478.37、HLG1000≈764.79/952.06。全部仍为源信号/模型而非面板nits。最终修正报告`/tmp/lg-hlg-hdr10-decoded-compare-20261026/comparison-report.md`，均匀条带完整读回`offscreen-bars2/analysis.json`。

- **夕阳帧HDR10直通/离屏目检通过，用户指定换35秒熊在水边**：用户看清直通A后切相同fixture离屏B，明确反馈“基本一致”。两轮HDR1/背光255/thermal0，PQ/gamma0，实际direct mediacodec_embed与offscreen gpu-next/surfacetexture均验证。它仅验收此夕阳帧的可见一致，不代表逐码/所有场景等价；数值局部差异仍保留。用户继续指定35秒熊在水边更易发现亮度/暗部问题，正在抽两源对应静帧；先复核该HDR10帧direct/offscreen，再将HLG作为对照，不改gamma/生产默认、不提交。

- **35秒熊水边对照**：用户指定场景已抽取精确PTS35.035000，HDR10 1920×960 PQ/BT2020NCL/limited静止902帧30.0967秒，首帧与原YUV逐字节相同；fixtureSHA`af34f399cbe67143571d3c927279beae536785c0c366f8f1fab6721f2d357ecc`，LG两路源路径副本已核对hash。直通A实机mediacodec_embed/mediacodec/gamma0/HDR1/背光255/thermal0，用户已看清A并要求切B；现正在换同片离屏B，尚未得观感结论。35秒HLG原标签静帧另备，须保持对照为同内容而非任意动态帧。证据`/tmp/lg-hlg-hdr10-decoded-compare-20261026/bear-35/`。

- **熊场景HDR10 A/B目检通过，C/HLG500已显示待反馈**：用户对35.035秒HDR10直通A→同帧离屏B再次答“基本一致”，故两处已测场景可作为可见参考，不升级为逐码/面板全局校准。当前C换同PTS的4K HLG基底lossless静帧，range诊断包`6cc37a10…997a`装机与fixturehash`77f9395c…1739`核对；range property空（原FULL），真实HLG→PQ/surfacetexture/gpu-next，peak500/gamma3、native pause=yes/time-pos=.266933锁定同静片，HDR1/背光255/thermal0。正在等用户描述相对HDR10的整体/高光/暗部。测试页单段500/hold60秒，不自动变1000；完成后恢复500/原播放。全部902帧raw相同，因此播放恢复不改变源图。未改生产默认/未提交。

- **C/4K熊静片触发两次整机重启，目检无效；已换1080p普通HEVC重播**：用户指出手机重启要求重播，/proc/uptime约59秒证实重启；重播原4K HLG无损fixture后约3秒再次掉线、uptime重新计时。两条SYSTEM_LAST_KMSG分别01:33:18/01:35:37，故障发生01:32:08/01:34:42，均HEVC 3840×1920 10bit的msm_vidc/Venus SMMU fault→fatal→kernel panic。首轮在60秒暂停恢复后，次轮在初始解码附近；不能判断责任属于App buffer/驱动/固件/码流。停止该4K测试片，不把它当亮度或gamma问题、不继续用它重试。日志`bear-35/reboot-check*/dropbox-last-kmsg.txt`。
- **1080p C已跨暂停恢复边界稳定，重新等观感**：01:37:59正常phase-end/restored peak500/gamma3，随后playback-restored；uptime连续增长、HDR1/背光255，原4K两次panic的边界未在本次复现。注意仅此候选这一轮稳定，不证明硬解崩溃问题已修复。现同35.035熊场景1920×960 CRF12 HLG已持续显示，重新询问相对HDR10亮度/暗部，提供“需要再看参考”选项以免重启间隔破坏比较。

- 用户要求重播仍在执行：同PTS35.035帧改1920×960、HLG/BT2020/limited、Main10正常CRF12、3秒90帧，fixtureSHA`ac6b4bb917099a0f38d62e5c85a4b41bab138550569d62e6e7166e1f6120c595`，LG回读一致。只在YUV码域降采样/普通高质量编码，非原源逐像素一致；未改transfer/gamma。现运行peak500/gamma3、原FULL、surfacetexture→PQ/HDR1/背光255，native暂停于.333667秒；正在跨60秒恢复边界检查稳定，待重新取得C观感。原4K两轮不计人眼验收。

- 用户要求：找出 LG DV P8.4 的 HLG 基层转 PQ 后偏暗的根因；不继续增加 gamma，先不提交。
- 范围：当前 PiliPlus dev 实际会话、media-kit 渲染配置、mpv/libplacebo 转换数学、LG vendor/HWC/面板状态。仅收集和诊断，不调整产品默认映射。
- **当前进行：最终范围一致性A/B（用户已要求继续）**：只读材料未能确认consumer优先级，故实现默认关闭的`MKS_YUV_RANGE_PROBE`，context初始化锁定`debug.mks.yuv_range_probe=full|limited`；FULL保留原shader及metadata `{9,1,16}`，LIMITED只改最终8-bit packing并配`{9,0,16}`，窗口保持PQ/LIMITED，offscreen full-PQ/peak500/gamma3保持。8-bit由现有EGL config49必经断言与追加回读证据支撑；range0/1由本机SetCSC分支与Qualcomm官方枚举交叉支持。新增probe与Dart默认空峰值序列（本轮单段500/hold60秒）已V1审核、NDK宏0/1编译/定向analyze通过，标准源码测试包构建中，尚无本轮设备/光学结论。
- 范围试验素材位于`/tmp/lg-yuv-range-ab-20261025/fixtures/manifest.json`：从原片120/480/720秒提取的人物/暗鹿群/夕阳HLG基底，3840×1920 Main10 lossless静止短片；逐字节首帧解码等于原raw，RPU不保留，因此仅验证共享HLG转换路径。三片已推送LG app-scoped files并逐字节hash核对。新诊断只比较完整最终编码+声明契约；EGL LIMITED/CSC601保持，实际NV12平面和最终HWC range仍无独立读回，视觉差异不可唯一当作HWC优先级证明。
- **范围测试包与首轮结果（跨日完成）**：`lg-yuv-range-ab-20261025-release.apk`标准源码VERIFIED，41,438,471字节，SHA256`6cc37a10dc9e6591380346b3c074b9adbe3eba0f0d2e99925be625f47bea997a`，LG base.apk回读一致；libmpv`790c01bbd2dbd3891b79b4278a57c4eedeaded2bc0e4fe12cda3250933fe91f3`。三个静止素材全部90/90帧raw SHA与对应原帧一致。首个480秒黄昏鹿群场景FULL/LIMITED两轮均成功锁定mode/BPP8/shader/P1range（分别1/0），metadata写入rc0、同PTS0.233333、peak500/gamma3、HDR1/背光255/thermal0，60秒后原状态恢复，无invalid。用户初答“基本没有区别”，紧接指出“这张不够暗，这种亮度差异还不大”，因此该结果不作为近黑范围问题已排除的证据；正在补已知低亮度阶梯及更深暗场。原始材料`/tmp/lg-yuv-range-ab-20261025/`。
- **近黑阶梯补充与当前待输入项**：合成16条HLG中性近黑阶梯，按500/gamma3反推目标信号亮度0/.02/.05/.1/.2/.35/.5/.75/1/1.5/2/3/4/6/8/12nits并量化为Y10，1280×720 Main10 HLG；90/90帧raw SHA一致。它仅是编码信号预测，不是面板nits实测。近黑A（FULL）已在LG跑满60秒：同PTS0.233333、peak500/gamma3、HDR1/背光255/thermal0、P1range1写入rc0，无invalid并恢复播放；B尚未执行，等待用户确认已看清A后再切，不能擅自作近黑观感结论。等待阶段的屏幕保活进程已停止，range property已清空；当前context仍是基线FULL，系统亮度模式自动、旋转1/0未改。收到观察确认后应先重新激活背光255再进行B，以免待机DIM影响比较。原片540/570/600/630候选经Vision判断没有合格的深暗纹理场景（600主要纯剪影），不强行替代近黑阶梯。
- 既有状态：gamma 中性值时设 +3 的逻辑仍在；2026-10-24 目标峰值从兜底 1000 改为设备上报 500。先前“过曝消失”验收不等于本轮普通白/高光亮度校准通过。
- 用户补充：仅高光不够亮，普通景物尚可；对照为同片源 LYA（HLG→PQ）及 marble（nativeDV）。不能把跨手机物理亮度差直接等同于转换算法错误。
- **同帧峰值A/B（本轮新增）**：用户同意保持gamma+3、仅改变target-peak。测试页新增默认关闭的hold-frame诊断：实际P8.4源正常硬解/HDR applied后，native pause/time-pos稳定双读，按500→1000→500→1000各15秒，阶段开始/结束均原生回读peak/gamma/pause/time-pos，最终恢复500及原播放状态。V1审核、定向dart analyze、标准源码构建/VERIFIED和装机哈希通过。APK `lg-p84-peak-hold-ab-20261025-release.apk` SHA256 `69e6b0e90c77c8cd3f7956edab888390b0f9fdd39fd0688638c040eafc81b702`（41,433,959字节），libmpv `a337e7ebba9795041699392eedf40086f80150bf6a8491a3018a60e9882d3573`。测试只改diagnostic页，未改生产峰值/gamma策略。
- **同帧运行证据与用户反馈**：首轮确实暂停于715.948567s，但用户未看到过程，不计人眼验收。待用户明确准备好后重播，第二轮四段均为`pause=yes/time-pos=716.048667/gamma=3`，target-peak依次500/1000/500/1000；四段均HDR模式1、背光255/255、thermal0，HWC视频层2672×1336/`7FA30C04`。用户明确反馈1000“更亮，细节仍清楚”，普通景物/暗部“正常，没有明显过亮”。最终回读恢复`peak=500/gamma=3`，`pause=no`后位置开始推进。请求起播点720s实际落在关键帧附近约716s，故本轮不能套用720.0193s的离线帧统计。证据 `/tmp/lg-p84-peak-hold-ab-20261025/` 和 `replay1/`；独立V1核对首轮运行日志无异常。
- **新补充约束：不能据单帧把1000定为默认**：用户紧接着提醒此前1000曾出现过曝和暗处层次不足。该历史反馈继续有效；本轮只确认500相对1000降低当前夕阳帧高光，并未验收1000对所有亮/暗场正确。需要先对齐历史1000的target-trc/range/gamma/vo/背光等配置，再结合明亮普通场景与暗场评估；不直接全局回退1000，也不继续增加gamma。当前测试已恢复500，生产配置未改。
- **历史配置复核（只读Specialist）**：LYA最初严重过曝对应未设置target-peak而被推断为10000，与LG的1000残余过曝不能混同；Oct21 LG已是PQ/full、gpu-next、gamma3、targetPeak1000，用户曾接受高光，但当轮背光曾255→100、最终验收背光未另采样，不能和本轮固定255严格等同。`bf5ce384`主要改变设备峰值选择，`98c611a3`引入scoped gamma3；已核对的相关历史没有发现同期target-trc、最终YUV range或HLG OOTF算法改变，但未证明历史APK与当前二进制完全相同。targetPeak会改变整条HLG OOTF及system gamma，不能当成只调高光的旋钮。
- **接下来优先排查的独立变量**：当前最终shader为FULL YUV、gralloc COLOR_METADATA为FULL，但window dataspace强制PQ/LIMITED。若consumer采用LIMITED展开，方向上可同时造成亮端过冲与暗端截断，符合历史症状；现有SurfaceFlinger/固件符号与只读材料没有给出本机HWC实际优先级，所以仍是假设。下一轮若做运行隔离，应保持同一源/PTS、targetPeak、gamma、offscreen full-PQ和缓冲格式不变，将最终YUV编码与gralloc/window声明成套改为一致LIMITED后对照当前路径；不能只改像素packing而保留FULL metadata，也不能据格式码猜位深。暗阶/近黑、夕阳高光、正常肤色需共同验收。range排除后若仍有分场景冲突，再评估保留低中亮度、平滑扩展上部高光的映射，先不改生产默认。
- **日志通道更正**：上一轮交互式`adb shell logcat`返回空，不能解释为logcat缓冲为空；历史归档已注明LG需`adb exec-out logcat`，本轮使用该通道成功取得实际route/属性/PTS证据。`debug.mks.luma_probe`仍为空，meson c_args为`[]`，系统自动亮度/旋转设置未改。
- **LG 同片源两版对照（2026-10-25）**：`蹲守一周，我终于拍到了夕阳下的梦幻场景｜北海道VLOG _ Links  4K HDR.mp4`（SHA256 `7626cac28819ffd1377a712b56c7cc4bbf8677f5db4b39fb0c83f92e58d74443`）为 HEVC Main10 3840×1920、BT.2020 limited、HLG、DV P8.4/RPU present；`Links_北海道VLOG_HDR10_1080p_HEVC.mp4`（SHA256 `831c808ea5d6220fba41dbbb681d92fa6c567ccbe68cf285574948ad8f532621`）为 HEVC Main10 1920×960、BT.2020 limited、PQ/HDR10，无DV数据。时长均1170.636s、画幅2:1、标题与来源 BVID 一致。使用同一测试包在约12:00夕阳鹿群高光段依次播放；每次从同一媒体时间起播。
- **本次实际输出证据**：4K P8.4路线的SurfaceFlinger/HWC活动视频buffer为2672×1336、格式码`7FA30C04`；1080p HDR10路线为1920×960、格式码`7FA30C06`；两者均显示为独立SurfaceView视频层并被HWC采用。P8.4尺寸/格式变化与HLG→PQ渲染输出路径相符，HDR10保留原视频尺寸/格式码；仅凭SurfaceFlinger数据不能推断最终EOTF或光学亮度。两段均为自动亮度模式，亮度设置/读数255/255，窗口亮度override=-1。设备停在HDR10版本12:00场景；保留两原片于`/sdcard/Movies/Hokkaido_DV_P84_HLG.mp4`和`/sdcard/Movies/Hokkaido_HDR10_PQ.mp4`，测试包源路径当前放HDR10副本。
- **对照限制与配置差异**：现有`hdr_player_backend.dart`仅在LG HLG + `baseLayerConvert`分支把中性gamma设为3；HDR10/PQ不走此分支（本次未写gamma）。因此这是播放器当前策略下的输出对照，不是保持gamma一致的变量隔离实验。Android screencap因HDR视频Surface返回黑色图，且本轮`adb logcat`缓冲读回0字节；不能据此主观判断哪个版本高光更亮，也未取得本轮FBO探针值、最终NV12平面码值、有效dataspace/EOTF或面板nits。Native诊断编译宏已恢复`c_args=[]`，系统`debug.mks.luma_probe` property已清空；系统亮度模式仍为自动，未提交。
- **用户人眼反馈与同帧源信号分析**：用户确认HDR10版高光更亮。独立只读分析按相同媒体时间`720.0193s`提取两片夕阳鹿群帧；两片内容对齐但分辨率和编码不同。先把limited BT.2020 YUV还原成RGB，再按源HLG/PQ分别解码：P8.4 HLG经当前`targetPeak=500`、HLG system gamma及equalizer+3模型，P50/P90/P95/P99/P99.9约`19.9/189/380/478/481 nits`，信号最大值被映射至约500；HDR10 PQ绝对码值对应约`24.8/326/759/953/976 nits`，最大约1397。高端P95/P99约为P8.4映射估算值两倍，与用户观感一致。此为编码信号和转换模型估算，不是HDR层FBO或屏幕实测；HLG离线估算使用HLG基底、不应用RPU。
- **可解释当前差异的首要机制**：源码中HDR10默认首选`baseLayerDirect`，采用`mediacodec_embed`/`mediacodec`，不经过libplacebo，亦不设置软件`targetPeak`；LG DV P8.4按HLG兼容基底走`baseLayerConvert`，使用设备能力峰值500并`stripDvRpu=true`。该片RPU的`source_max_pq=3079/4095`，按ST2084 EOTF约1000.6nits；RPU被剥离后，当前转换路径按500目标绘制。HDR10文件是独立`hevc_videotoolbox` 1080p PQ转码且无Mastering Display/MaxCLL，PQ码流自身的高光数值明显高于P8.4在500目标下的模型值；所以“HDR10更亮”可由源版本亮度编码+不对称播放映射共同解释，不能单据此认定500本身错误，也不能将HDR10文件视为经过校准的正确亮度参照。gamma+3按现有equalizer只略抬中灰；其变换在输入白顶为1处不增加白顶，不能补出P95/P99差值。
- **当前根因判断与剩余边界**：已确认HLG转换生产者目标500将高光顶端限制在约500信号nits，而HDR10直出没有这个软件侧限制；这是本次同机高光差异的首要软件解释，并与用户观感、灰片500/1000实机码值A/B、同帧源信号估算相符。它还不是“LG面板真实峰值高于500”的证明：设备HWC只静态报告500能力，最终NV12打包/metadata、PQ HWC tone mapping和面板光学峰值仍未实测。下一步若继续，优先做同一HLG帧的target500 PQ参考直出/HWC对照，或取得亮度计数据；先不增加gamma，也不直接将targetPeak改为1000。
- 本轮测试APK：`/Users/wuweiwei1/src/media-kit/media_kit_hdr_lab/build/app/outputs/flutter-apk/lg-hokkaido-hdr-compare-20261025-release.apk`，VERIFIED SHA256 `f7e00cfa2a6fed791e0d5fb575d76a50c13a754c1fdb1ef2627d2976870fb243`，LG installed `base.apk`回读一致。构建/SurfaceFlinger/电源快照及画面缩略表保存在`/tmp/lg-hlg-pq-brightness-20261025/`。
- **确认的直接机制**：当前 gpu-next/libplacebo 的 HLG 源峰值跟随 HDR 目标；以现有 gamma=3、同一无损 HLG 灰阶片实机 A/B，target-peak=500 的 PQ 白顶 0.67578125（PQ 解码等价值 496.289 nits），改为 1000 后 0.75097656（992.228 nits），恢复 500 后完全回到原值。gamma 未写入，始终回读 3。此处 nits 仅表示生产者码值，**不是面板实测亮度**。
- **输入/转换边界**：高通 HEVC 硬解→surfacetexture→gpu-next→baseLayerConvert→PQ/ext:lg-pq；源为 HLG/BT2020/limited，输出 full。OES 输入白顶 0.99902344，75% 条约 0.7485–0.7490；不存在完整 limited 范围未扩展造成的明显压顶。目标 FBO 与峰值响应总体一致，但各灰阶相对理想公式约 ±4% 局部残差未定，不宣称精确色度校准通过。该片无 DV RPU，只证明共享 HLG 转换路径，不替代真实 P8.4 全链逐帧验收。
- **500 的来源**：从本机只读提取的 `hwcomposer.msm8996.so`（SHA256 `b2b8d82fb3dafa0c71f23070db8924adf734d0b077aba694222e021ec8810c33`）中，`HWCSession::GetHdrCapabilities@0x131d0` 直接写入常量 500/200/0.5；未查询 panel。可确认其为固件能力描述，非实时测量；常量可能是工厂额定/策略值，**不能由硬编码推出错误，也未证明真实面板峰值高于 500**。独立 Specialist 已复核地址、LOAD 映射及浮点字节。
- **面板状态干扰已排除到活动态边界**：初采暂停 242.35s 时系统 DIM、背光 10；无播放语义的 SHIFT_LEFT 后仍停在同一帧，两点采样 BRIGHT、背光 255/255、hdr_mode=1、thermal=0。不能把初采 DIM 当用户报障根因；活动态状态也不证明 EOTF/nits 正确。
- **尚未闭合 / blocked 项**：最终 NV12 缓冲实际平面码值和有效 range/metadata 未读回；HWC 后端映射与面板 EOTF/峰值未光学测量。500 是否过于保守、是否有显示端再次压缩、与 LYA 物理亮度差的唯一根因仍未知。缺少同机匹配 PQ 参考片的光学对照或亮度计数据，不能继续声称绝对亮度校准；软件侧后续可补最终 buffer 平面/metadata 取证。不能宣布“改回 1000”就是正确修复。
- **改动范围**：新增默认关闭的输入/目标 FBO 诊断与 lab 峰值 A/B；为跑通测试补齐 `LyaDiagnosticsDataSpaceExt` 的 9 个 delegate 转发（首包 API 被 wrapper 默认 0 截断；非产品亮度根因）。仅诊断，生产映射/gamma 默认值未改；无提交、无 staging。既有 mpv `f_decoder_wrapper.c`、lab Gradle 及 PiliPlus 并行工作区修改均保留。
- **构建/状态**：标准源码入口第二包 `lg-hlg-pq-luma-probe2-20261025-release.apk` VERIFIED，SHA256 `5b561037c4b6db54635057a9da272a6e91007877b8e871401526785602581afb`，LG 安装回读匹配；libmpv SHA256 `6c91de07f3ef2f7704215309fd3f7d5eb434b110be87a6d8ee88087500f9e76c`。GL read/restore 错误均 0；V1 诊断与独立数据审核通过，不计作面板验收。峰值恢复 500；debug property 恢复空值；meson c_args 恢复 `[]`（原生诊断宏默认 0）。没有写系统亮度/旋转设置，测试包留场。
- 验收：对齐活跃面板状态与会话身份；核实源/目标亮度映射、range 与 HDR 元数据；区分可复现的码值问题和需要光学测量的面板问题。无法测得的物理亮度不宣称已闭合。
- 原始材料：`/tmp/lg-hlg-pq-brightness-20261025/`；历史对照 `video-gray-getx-20261021.md`、`lya-dv-p84-hlg-to-pq-overexposure-20261024.md`。
- 持久机器摘要：`/Users/wuweiwei1/src/media-kit/docs/validation/lg-hlg-pq-brightness-mapping-20261025.json`。固件原始字节仅 `/tmp` 留存，不入源码仓。

## 证据与复现

- 灰片工具：姊妹仓 `tool/diagnostics/hlg_pq_gray_probe.py`。8 条 HLG 码值 0/.1/.25/.5/.65/.75/.9/1，HEVC Main10、BT2020、limited、30fps。软件解码与生成 raw SHA256 同为 `194bd3d3cfdb63db6d0076384dd7e61a720b525cf642ae019df046a45ce9283f`。
- 原生诊断门：`MKS_YUV_LUMA_PROBE=1` + `debug.mks.luma_probe=1`；普通构建宏默认关闭；不启用旧 ST diag（其会强制 PQ input 标记而污染 HLG 实验）。新 ST probe 仅在 OES identity-copy 后读输入，目标 probe 在 YUV 打包前读 PQ RGBA16F，均保存/恢复 READ FBO/PBO/PACK 状态，采样有限，失败停止且不伪造数据。
- lab define：`MEDIA_KIT_ANDROID_LUMA_PEAK_PROBE=true`、`MEDIA_KIT_ANDROID_PROP_SNAPSHOT=true`。Session 正常打开并 applied 后 500/1000 各保持 6 秒、回读确认，最后恢复原值；gamma 不是 3 时拒绝此特定对照而非强行改写。仅使用切峰后 0.3 秒以上稳定采样；固定图案无需将 ST frame 与 swap frame 强配。
- 构建：`tool/build-android-test.sh --tag lg-hlg-pq-luma-probe2-20261025 --platform-view --local-source /sdcard/Android/data/com.example.media_kit_hdr_lab/files/hlg-bars.mp4 -- --dart-define=MEDIA_KIT_ANDROID_LUMA_PEAK_PROBE=true --dart-define=MEDIA_KIT_ANDROID_PROP_SNAPSHOT=true`。编译门通过临时 meson c_args 加入，原值保存在 `/tmp/.../meson-c-args-before.json` 并已恢复；仍由标准入口编译当前依赖、mpv、helper、JAR 和 APK。
- `run3/merged.log`：正常路线、属性回读、输入/输出实测及峰值恢复。`run3/logcat-final-full.txt` 无观察到的 FATAL/ANR。`measured.json` 为原始采样归并和 PQ 解码计算。`firmware/REPORT.md`、`GetHdrCapabilities.objdump.txt`、`SHA256SUMS` 为固件窄函数证据（现有 NDK 普通只读工具，非 REA Evidence；当前会话无 REA 工具，未安装或改配置）。

## 模型与历史措辞修正

- HLG 是场景相对信号；1000 nits 是 nominal reference display，不是不可变的信号峰值。gpu-next 的 `pl_color_space_infer_map` 会让 HLG 源峰值跟 HDR 目标，再计算系统 gamma，非先固定 1000 再动态压一次；此同峰路线的 peak detection 跳过。
- 旧归档“HLG 语义固定 1000、整幅统一放大十倍”过于简化。10000 对 1000 的倍数仅直接描述白顶，不描述所有灰阶；也不能直接拿 `vo=gpu` 公式解释复用 Android OpenGL context 的 `vo=gpu-next`。
- gamma=+3 是 mpv equalizer 8^0.03≈1.06437 的审美非线性调整，不是 HLG 标准系统 gamma；输入 1 仍为 1，所以不增加顶端峰值。它可作为偏好，不构成本轮高光根因修复。
