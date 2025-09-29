import 'dart:async';
import 'dart:math' as math;

import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:get/get_navigation/src/dialog/dialog_route.dart';

class PayCoinsPage extends StatefulWidget {
  const PayCoinsPage({
    super.key,
    required this.onPayCoin,
    int copyright = 1,
    this.hasCoin = false,
  }) : hasCopyright = copyright == 1;

  final Function(int coin, bool coinWithLike) onPayCoin;
  final bool hasCopyright;
  final bool hasCoin;

  @override
  State<PayCoinsPage> createState() => _PayCoinsPageState();

  static void toPayCoinsPage({
    required Function(int coin, bool coinWithLike) onPayCoin,
    int copyright = 1,
    bool hasCoin = false,
  }) {
    Navigator.of(Get.context!).push(
      GetDialogRoute(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          return PayCoinsPage(
            onPayCoin: onPayCoin,
            copyright: copyright,
            hasCoin: hasCoin,
          );
        },
        transitionDuration: const Duration(milliseconds: 225),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).chain(CurveTween(curve: Curves.linear)),
            ),
            child: child,
          );
        },
      ),
    );
  }
}

class _PayCoinsPageState extends State<PayCoinsPage>
    with TickerProviderStateMixin {
  late final _key = GlobalKey();
  late final _hasCopyright = widget.hasCopyright;
  late bool _isPaying = false;
  PageController? _controller;
  late final RxBool _coinWithLike = Pref.coinWithLike.obs;
  late final RxInt _pageIndex = 0.obs;

  late final AnimationController _slide22Controller;
  late final Animation<Offset> _slide22Anim;
  late final AnimationController _scale22Controller;
  late final Animation<double> _scale22Anim;
  late final AnimationController _coinSlideController;
  late final Animation<Offset> _coinSlideAnim;
  late final AnimationController _coinFadeController;
  late final Animation<double> _coinFadeAnim;
  late final AnimationController _boxAnimController;
  late final Animation<Offset> _boxAnim;

  Timer? _timer;
  late final RxInt _thunderIndex = (-1).obs;
  late final List<String> _thunderImages = const [
    'assets/images/paycoins/ic_thunder_1.png',
    'assets/images/paycoins/ic_thunder_2.png',
    'assets/images/paycoins/ic_thunder_3.png',
  ];
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  final num? _coins = GlobalData().coins;
  late final List<bool> _payState;
  late final List<String> _payImg;
  late final List<Color> _payFilter;

  bool _canPay(int index) {
    if (index == 1 && widget.hasCoin) {
      return false;
    }
    if (_coins == null) {
      return true;
    }
    if (index == 0 && _coins >= 1) {
      return true;
    }
    if (index == 1 && _coins >= 2) {
      return true;
    }
    return false;
  }

  String _getPayImage(int index) {
    if (!_payState[index]) {
      return 'assets/images/paycoins/ic_22_not_enough_pay.png';
    }
    return index == 0
        ? 'assets/images/paycoins/ic_22_mario.png'
        : 'assets/images/paycoins/ic_22_gun_sister.png';
  }

  late final color = Colors.black.withValues(alpha: 0.4);
  Color _getPayFilter(int index) {
    if (index == 1 && widget.hasCoin) {
      return color;
    }
    if (_coins == null) {
      return Colors.transparent;
    }
    if (index == 0 && _coins == 0) {
      return color;
    }
    if (index == 1 && _coins < 2) {
      return color;
    }
    return Colors.transparent;
  }

  @override
  void initState() {
    super.initState();
    if (_hasCopyright) {
      _controller = PageController(viewportFraction: 0.30);
    }
    final count = _hasCopyright ? 2 : 1;
    _payState = List.generate(count, _canPay);
    _payImg = List.generate(count, _getPayImage);
    _payFilter = List.generate(count, _getPayFilter);

    _slide22Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _slide22Anim = _slide22Controller.drive(
      Tween(
        begin: Offset.zero,
        end: const Offset(0.0, -0.2),
      ),
    );
    _scale22Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scale22Anim = _scale22Controller.drive(
      Tween(begin: 1, end: 1.1),
    );
    _coinSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _coinSlideAnim = _coinSlideController.drive(
      Tween(
        begin: Offset.zero,
        end: const Offset(0.0, -2),
      ),
    );
    _coinFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _coinFadeAnim = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_coinFadeController);
    _boxAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _boxAnim = _boxAnimController.drive(
      Tween(
        begin: Offset.zero,
        end: const Offset(0.0, -0.2),
      ),
    );

    _scale();
  }

  @override
  void dispose() {
    _cancelTimer();
    _slide22Controller.dispose();
    _scale22Controller.dispose();
    _coinSlideController.dispose();
    _coinFadeController.dispose();
    _boxAnimController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _scale() {
    _scale22Controller.forward().whenComplete(_scale22Controller.reverse);
  }

  void _onScroll(int index) {
    _controller?.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
    _scale();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.isPortrait;
    return isPortrait
        ? _buildBody(isPortrait)
        : Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: math.min(525, size.width * 0.6),
              ),
              child: _buildBody(isPortrait),
            ),
          );
  }

  Widget _buildCoinWidget(int index, double factor) {
    return Center(
      child: SizedBox(
        height: 70 + (factor * 30),
        width: 70 + (factor * 30),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            _payFilter[index],
            BlendMode.srcATop,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SlideTransition(
                position: _boxAnim,
                child: Image.asset(
                  'assets/images/paycoins/ic_pay_coins_box.png',
                ),
              ),
              SlideTransition(
                position: _coinSlideAnim,
                child: FadeTransition(
                  opacity: _coinFadeAnim,
                  child: Image.asset(
                    height: 35 + (factor * 15),
                    width: 35 + (factor * 15),
                    index == 0
                        ? 'assets/images/paycoins/ic_coins_one.png'
                        : 'assets/images/paycoins/ic_coins_two.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build22() {
    final index = _pageIndex.value;
    final canPay = _payState[index];
    final payImg = _payImg[index];
    return GestureDetector(
      onTap: canPay ? _onPayCoin : null,
      onVerticalDragStart: canPay
          ? (e) {
              _isHorizontal = false;
              _onDragDown(e);
            }
          : null,
      onVerticalDragUpdate: canPay ? _onDragUpdate : null,
      onVerticalDragEnd: canPay ? _onDragEnd : null,
      onVerticalDragCancel: canPay ? _onDragEnd : null,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale22Anim,
        child: SlideTransition(
          position: _slide22Anim,
          child: SizedBox(
            width: 110,
            height: 155,
            child: Image.asset(payImg),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(bool isV) => Stack(
    key: _key,
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      if (_hasCopyright)
        Obx(() {
          final index = _thunderIndex.value;
          return Offstage(
            offstage: index == -1 || index == 3,
            child: Image.asset(_thunderImages[index.clamp(0, 2)]),
          );
        }),
      Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_hasCopyright)
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: SizedBox(
                        height: 100,
                        child: PageView(
                          key: const PageStorageKey('PageView'),
                          physics: const ClampingScrollPhysics(),
                          controller: _controller,
                          onPageChanged: (index) {
                            _scale();
                            _pageIndex.value = index;
                          },
                          children: List.generate(
                            2,
                            (index) {
                              return ListenableBuilder(
                                listenable: _controller!,
                                builder: (context, child) {
                                  double factor = index == 0 ? 1 : 0;
                                  if (_controller!
                                      .position
                                      .hasContentDimensions) {
                                    factor =
                                        1 - (_controller!.page! - index).abs();
                                  }
                                  return Obx(
                                    () {
                                      if (_pageIndex.value != index &&
                                          _isPaying) {
                                        return const SizedBox.shrink();
                                      }
                                      return _buildCoinWidget(index, factor);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(
                        () {
                          final index = _pageIndex.value;
                          if (_isPaying) {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
                            onTap: index == 0 ? null : () => _onScroll(0),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Image.asset(
                                width: 16,
                                height: 28,
                                index == 0
                                    ? 'assets/images/paycoins/ic_left_disable.png'
                                    : 'assets/images/paycoins/ic_left.png',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() {
                        final index = _pageIndex.value;
                        if (_isPaying) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: index == 1 ? null : () => _onScroll(1),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.asset(
                              width: 16,
                              height: 28,
                              index == 1
                                  ? 'assets/images/paycoins/ic_right_disable.png'
                                  : 'assets/images/paycoins/ic_right.png',
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                )
              else
                SizedBox(height: 100, child: _buildCoinWidget(0, 1)),
              SizedBox(height: isV ? 25 : 10),
              if (_hasCopyright)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (e) {
                    _isHorizontal = true;
                    _onDragDown(e);
                  },
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  onHorizontalDragCancel: _onDragEnd,
                  child: Center(child: Obx(_build22)),
                )
              else
                Center(child: _build22()),
              if (_coins != null || widget.hasCoin) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${_coins != null ? '硬币余额：${_coins.toDouble().toPrecision(1)}' : ''}${widget.hasCoin ? '${_coins != null ? '，' : ''}已投1枚硬币' : ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  GestureDetector(
                    onTap: () {
                      final newVal = !_coinWithLike.value;
                      _coinWithLike.value = newVal;
                      GStorage.setting.put(SettingBoxKey.coinWithLike, newVal);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 12),
                        Obx(
                          () => Icon(
                            _coinWithLike.value
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          ' 同时点赞',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: Get.back,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'assets/images/paycoins/ic_panel_close.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height:
                    (isV ? 50 : 10) + MediaQuery.viewPaddingOf(context).bottom,
              ),
            ],
          ),
        ),
      ),
    ],
  );

  late bool _isHorizontal = true;
  DragStartDetails? _downPos;
  void _onDragDown(DragStartDetails detail) => _downPos = detail;
  void _onDragEnd([_]) => _downPos = null;
  void _onDragUpdate(DragUpdateDetails e) {
    if (_downPos == null) {
      return;
    }
    final offset = _isHorizontal
        ? (e.localPosition.dx - _downPos!.localPosition.dx).abs()
        : (e.localPosition.dy - _downPos!.localPosition.dy).abs();
    if (offset < 20) {
      return;
    }
    _downPos = null;
    if (_isHorizontal) {
      if (e.delta.dx > 0) {
        if (_pageIndex.value == 1) {
          _onScroll(0);
        }
      } else {
        if (_pageIndex.value == 0) {
          _onScroll(1);
        }
      }
    } else {
      if (e.delta.dy < 0) {
        _onPayCoin();
      }
    }
  }

  void _onPayCoin() {
    if (_isPaying) return;
    _isPaying = true;
    _pageIndex.refresh();
    _slide22Controller.forward().whenComplete(() {
      _slide22Controller.reverse().whenComplete(() {
        if (_pageIndex.value == 1) {
          _thunderIndex.value += 1;
          _timer ??= Timer.periodic(const Duration(milliseconds: 50 ~/ 3), (_) {
            final index = _thunderIndex.value;
            if (index == _thunderImages.length) {
              _cancelTimer();
            } else {
              _thunderIndex.value = index + 1;
            }
          });
        }
        _boxAnimController.forward().whenComplete(_boxAnimController.reverse);
        _coinSlideController.forward().whenComplete(() {
          _coinFadeController.forward().whenComplete(() {
            Get.back();
            widget.onPayCoin(_pageIndex.value + 1, _coinWithLike.value);
          });
        });
      });
    });
  }
}
