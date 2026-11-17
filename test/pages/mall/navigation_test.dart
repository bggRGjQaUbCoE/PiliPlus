import 'package:PiliPlus/pages/mall/navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'known ticket aliases and account links stay within their official scope',
    () {
      final activity = Uri.parse(MallTicketDestination.activity.url);
      for (final path in [
        '/neul-next/ticket/detail.html',
        '/mall-dayu/neul-next/ticket/detail.html',
      ]) {
        final ticket = Uri.https('mall.bilibili.com', path, {'id': '123'});
        expect(MallNavigation.pageKind(ticket), MallPageKind.ticketDetail);
        expect(MallNavigation.opensSecondary(activity, ticket), isTrue);
        expect(
          MallNavigation.pageKind(Uri.https('mall.bilibili.com', path)),
          isNull,
        );
      }
      final account = Uri.parse(MallDestination.account.url);
      final order = Uri.parse(MallTicketDestination.order.url);
      final detail = Uri.parse('https://mall.bilibili.com/orderdetail.html');
      final oldTicket = Uri.parse(
        'https://show.bilibili.com/m/platform/eticket.html',
      );
      final webTicket = Uri.parse(
        'https://mall.bilibili.com/neul-next/ticket/eTicket.html',
      );
      expect(MallNavigation.opensSecondary(account, order), isTrue);
      expect(MallNavigation.opensSecondary(order, detail), isFalse);
      expect(MallNavigation.opensSecondary(order, oldTicket), isTrue);
      expect(MallNavigation.pageKind(webTicket), MallPageKind.webTicket);
      expect(MallNavigation.opensSecondary(oldTicket, webTicket), isFalse);
      expect(
        MallNavigation.pageKind(
          Uri.parse('https://service.bilibili.com/v2/chat/h5/index.html'),
        ),
        MallPageKind.service,
      );
      expect(
        MallNavigation.isOfficial(
          Uri.parse('https://service.bilibili.com/unknown'),
        ),
        isFalse,
      );
    },
  );
  test('secondary navigation follows page kinds, not query changes or business redirects', () {
    final home = Uri.parse('https://mall.bilibili.com/');
    final search = Uri.parse(
      'https://mall.bilibili.com/neul-next/index.html?page=flow_searchResult&keyword=A',
    );
    final category = Uri.parse('https://mall.bilibili.com/category.html');
    final list = Uri.parse('https://mall.bilibili.com/list.html?category=1');
    final cart = Uri.parse(MallDestination.cart.url);
    final product = Uri.parse(
      'https://mall.bilibili.com/detail.html?itemsId=10120458',
    );
    expect(MallNavigation.opensSecondary(home, search), isTrue);
    expect(MallNavigation.opensSecondary(home, category), isTrue);
    expect(MallNavigation.opensSecondary(home, cart), isTrue);
    expect(MallNavigation.opensSecondary(search, product), isTrue);
    expect(MallNavigation.opensSecondary(category, list), isFalse);
    expect(
      MallNavigation.opensSecondary(
        search,
        search.replace(
          queryParameters: {
            ...search.queryParameters,
            'keyword': 'B',
            'order': 'price',
          },
        ),
      ),
      isFalse,
    );
    expect(
      MallNavigation.opensSecondary(
        product,
        product.replace(queryParameters: {'itemsId': '2'}),
      ),
      isFalse,
    );
    expect(
      MallNavigation.opensSecondary(
        cart,
        Uri.parse('https://passport.bilibili.com/login'),
      ),
      isFalse,
    );
    expect(
      MallNavigation.pageKind(
        Uri.parse(
          'https://mall.bilibili.com/neul/index.html?page=mall_tryoutmissevanlist',
        ),
      ),
      isNull,
    );
    expect(
      MallNavigation.pageKind(
        Uri.parse('https://show.bilibili.com/h5/detail.html'),
      ),
      isNull,
    );
  });
  test(
    'official ticket list and event details use bounded secondary routes',
    () {
      final activity = Uri.parse(MallTicketDestination.activity.url);
      final showDetail = Uri.parse(
        'https://show.bilibili.com/platform/detail.html?id=113289',
      );
      final mallDetail = Uri.parse(
        'https://mall.bilibili.com/neul-next/ticket-renovation/detail.html?id=1006312&noTitleBar=1',
      );
      final movie = Uri.parse(MallTicketDestination.movie.url);
      final collection = Uri.parse(MallTicketDestination.collection.url);
      final orders = Uri.parse(MallTicketDestination.order.url);
      expect(MallNavigation.pageKind(activity), MallPageKind.ticketActivity);
      expect(MallNavigation.pageKind(showDetail), MallPageKind.ticketDetail);
      expect(MallNavigation.pageKind(mallDetail), MallPageKind.ticketDetail);
      expect(MallNavigation.pageKind(movie), MallPageKind.ticketMovie);
      expect(
        MallNavigation.pageKind(collection),
        MallPageKind.ticketCollection,
      );
      expect(MallNavigation.pageKind(orders), MallPageKind.ticketOrder);
      expect(MallNavigation.opensSecondary(activity, showDetail), isTrue);
      expect(MallNavigation.opensSecondary(activity, mallDetail), isTrue);
      expect(MallNavigation.opensSecondary(activity, collection), isTrue);
      expect(MallNavigation.opensSecondary(activity, orders), isTrue);
      expect(
        MallNavigation.opensSecondary(showDetail, mallDetail),
        isFalse,
      );
      expect(
        MallNavigation.pageKind(
          Uri.parse(
            'https://mall.bilibili.com/neul-next/ticket-renovation/detail.html',
          ),
        ),
        isNull,
      );
      expect(
        MallNavigation.pageKind(
          Uri.parse(
            'https://mall.bilibili.com.evil.example/platform/detail.html?id=1',
          ),
        ),
        isNull,
      );
    },
  );
  test(
    'product routes require the confirmed official host and product template',
    () {
      expect(
        MallNavigation.isProductDetail(
          Uri.parse('https://mall.bilibili.com/detail.html?itemsId=10120458'),
        ),
        isTrue,
      );
      expect(
        MallNavigation.isProductDetail(
          Uri.parse(
            'https://mall.bilibili.com/neul-next/detailuniversal/detail.html?page=detailuniversal_detail&itemsId=10120458',
          ),
        ),
        isTrue,
      );
      for (final url in [
        'https://show.bilibili.com/detail.html?itemsId=1',
        'https://mall.bilibili.com.evil.org/detail.html?itemsId=1',
        'http://mall.bilibili.com/detail.html?itemsId=1',
        'https://mall.bilibili.com/detail.html',
        'https://mall.bilibili.com/neul-next/ticket-renovation/detail.html?itemsId=1',
        'https://passport.bilibili.com/login?itemsId=1',
      ]) {
        expect(MallNavigation.isProductDetail(Uri.parse(url)), isFalse);
      }
    },
  );
  test('official destinations match and cart rewrite preserves navigation arguments', () {
    for (final destination in MallDestination.values) {
      expect(MallDestination.fromUri(Uri.parse(destination.url)), destination);
    }
    final cart = MallNavigation.normalize(
      Uri.parse(
        'https://mall.bilibili.com/cart.html?noTitleBar=1&foo=a&foo=b#cart',
      ),
    );
    expect(cart.path, '/neul/index.html');
    expect(cart.queryParameters['page'], 'mall_cart');
    expect(cart.queryParametersAll['foo'], ['a', 'b']);
    expect(cart.fragment, 'cart');
    expect(
      MallNavigation.normalize(Uri.parse('https://example.org/cart.html')).path,
      '/cart.html',
    );
  });

  test(
    'verified homepage list alias stays on B-site without widening the official domain boundary',
    () {
      final original = Uri.parse(
        'https://www.biligo.com/list.html?category=1_107&foo=a&foo=b#position',
      );
      final target = MallNavigation.normalize(original);
      expect(target.host, 'mall.bilibili.com');
      expect(target.path, '/list.html');
      expect(target.queryParametersAll, original.queryParametersAll);
      expect(target.fragment, 'position');
      expect(MallNavigation.isOfficial(original), isFalse);
      expect(MallNavigation.isOfficial(target), isTrue);
      for (final value in [
        'https://www.biligo.com/order.html',
        'https://www.biligo.com:8443/list.html',
        'https://www.biligo.com.example.org/list.html',
      ]) {
        expect(MallNavigation.normalize(Uri.parse(value)), Uri.parse(value));
      }
    },
  );

  test(
    'official domain boundary excludes lookalikes and unsupported schemes',
    () {
      expect(
        MallNavigation.isOfficial(Uri.parse('https://mall.bilibili.com/')),
        isTrue,
      );
      expect(
        MallNavigation.isOfficial(
          Uri.parse('https://show.bilibili.com/m/platform/home.html'),
        ),
        isTrue,
      );
      expect(
        MallNavigation.isOfficial(
          Uri.parse('https://mall.bilibili.com.example.org/'),
        ),
        isFalse,
      );
      expect(
        MallNavigation.isOfficial(Uri.parse('http://mall.bilibili.com/')),
        isFalse,
      );
      expect(
        MallNavigation.isOfficial(Uri.parse('javascript:alert(1)')),
        isFalse,
      );
    },
  );
}
