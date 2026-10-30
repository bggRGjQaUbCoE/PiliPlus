import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show SectionOpusCollection, OpusCollectionWithCover;
import 'package:PiliPlus/pages/member_opus/widgets/opus_grid.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_ui/material_ui.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;

const double _kOpusChildRatio = 0.85;
const _kGridDelegate = OpusGridDelegate(
  maxCrossAxisExtent: 144,
  mainAxisSpacing: Style.safeSpace,
  crossAxisSpacing: Style.safeSpace,
  childAspectRatio: _kOpusChildRatio,
  mainAxisExtent: 48,
);

class CollectionSection extends StatelessWidget {
  const CollectionSection({
    super.key,
    required this.onCollapse,
    required this.collection,
  });

  final VoidCallback onCollapse;
  final SectionOpusCollection collection;

  @override
  Widget build(BuildContext context) {
    final allCollections = collection.allCollections;
    final outline = ColorScheme.of(context).outline;
    final length = collection.allCollections.length;
    return OpusGridBuilder(
      childCount: length,
      expand: collection.expand,
      gridDelegate: _kGridDelegate,
      builder: (_, opusGridInfo) {
        final count = opusGridInfo.crossAxisCount;
        final Widget footer;
        if (count < length) {
          footer = LayoutId(
            id: kFooterId,
            child: Padding(
              padding: const .only(bottom: 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: outline.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: GestureDetector(
                  behavior: .translucent,
                  onTap: () {
                    if (collection.expand) onCollapse();
                    collection.expand = !collection.expand;
                    (context as Element).markNeedsBuild();
                  },
                  child: Padding(
                    padding: const .symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '${collection.expand ? '收起' : '展开'}全部文集',
                        style: TextStyle(fontSize: 13, color: outline),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          footer = LayoutId(
            id: kFooterId,
            child: Divider(
              height: 24,
              thickness: 1,
              color: outline.withValues(alpha: 0.1),
            ),
          );
        }
        if (collection.expand || count >= length) {
          return [...allCollections.map(OpusCollectionItem.new), footer];
        }
        return [
          ...allCollections.take(count).map(OpusCollectionItem.new),
          footer,
        ];
      },
    );
  }
}

class OpusCollectionItem extends StatelessWidget {
  const OpusCollectionItem(
    this.item, {
    super.key,
  });

  final OpusCollectionWithCover item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: Style.borderRadius6),
      child: InkWell(
        borderRadius: Style.borderRadius6,
        onTap: () => Get.toNamed(
          '/articleList',
          parameters: {
            'id': item.collectionInfo.collectionId.toString(),
          },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: _kOpusChildRatio,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Stack(
                    clipBehavior: .none,
                    children: [
                      NetworkImgLayer(
                        src: item.coverPic,
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight,
                        borderRadius: const .vertical(top: .circular(6)),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const .only(left: 8, top: 8, bottom: 4),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: .bottomCenter,
                              end: .topCenter,
                              colors: [Colors.black54, Colors.transparent],
                            ),
                          ),
                          child: Text(
                            item.coverBottomText.text,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const .fromLTRB(4, 5, 0, 0),
                child: Text(
                  item.collectionInfo.title.texts.map((e) => e.text).join(),
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding: const .fromLTRB(4, 0, 4, 4),
              child: Text(
                item.subTitleText,
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  letterSpacing: 0.3,
                  fontSize: 12,
                  color: ColorScheme.of(context).outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
