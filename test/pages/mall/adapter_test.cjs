const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const {JSDOM, VirtualConsole} = require('jsdom');
const source = fs.readFileSync('assets/mall/adapter.js', 'utf8');
const navigation = '<div class="tab"><i class="icon-index"></i>商城</div><div class="tab"><i class="icon-category"></i>分类</div><div class="tab"><i class="icon-cart"></i>购物车</div><div class="tab"><i class="icon-order"></i>我的</div>';

function page(html = '', url = 'https://mall.bilibili.com/') {
  const errors = [];
  const virtualConsole = new VirtualConsole();
  virtualConsole.on('jsdomError', error => errors.push(error));
  const dom = new JSDOM(`<!doctype html><html><head></head><body>${html}</body></html>`, {url, pretendToBeVisual: true, runScripts: 'outside-only', virtualConsole});
  const observers = [];
  const OriginalObserver = dom.window.MutationObserver;
  dom.window.MutationObserver = class extends OriginalObserver { constructor(callback) { super(callback); observers.push(this); } };
  dom.qaClose = () => {
    assert.deepEqual(errors, []);
    observers.forEach(observer => observer.disconnect());
    dom.window.close();
  };
  return dom;
}
const frame = window => new Promise(resolve => window.requestAnimationFrame(resolve));

test('only a plain matching order title collapses into the native shell', async () => {
  const dom = page('<div id="app"><header class="header is-browser"><div class="icon-back"></div><div>订单中心</div></header></div>', 'https://mall.bilibili.com/orderlist.html');
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{surface:'#fff'},homeStyle:'/* theme */'});
  await frame(dom.window);
  assert(dom.window.document.querySelector('header').hasAttribute('data-pp-shell-header'));
  dom.window.document.querySelector('header').innerHTML = '<i class="icon-back"></i>订单中心<button>管理订单</button>';
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{surface:'#fff'}});
  await frame(dom.window);
  assert(!dom.window.document.querySelector('header').hasAttribute('data-pp-shell-header'));
  dom.qaClose();
});

test('page scrolling reports user movement and excludes a SKU popup', async () => {
  const dom = page('<div id="app"><div class="header"><div class="search-input"></div></div><div class="category-main"><div class="category-part-container"></div></div><div class="franky-popup_box"><div class="scroll-view-content"></div></div></div>', 'https://mall.bilibili.com/category.html');
  const calls = [];
  dom.window.innerWidth = 400;
  dom.window.flutter_inappwebview = {callHandler:(name,data)=>calls.push({name,data})};
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,scrollEnabled:true,theme:{surface:'#fff'},homeStyle:'/* theme */'});
  await frame(dom.window);
  const target = dom.window.document.querySelector('.category-part-container');
  target.dispatchEvent(new dom.window.Event('pointerdown', {bubbles:true}));
  target.scrollTop = 10;
  target.dispatchEvent(new dom.window.Event('scroll'));
  target.scrollTop = 75;
  target.dispatchEvent(new dom.window.Event('scroll'));
  await new Promise(resolve=>setTimeout(resolve,60));
  assert.equal(calls[0].data.delta,65);
  const popup = dom.window.document.querySelector('.franky-popup_box .scroll-view-content');
  popup.scrollTop = 200;
  popup.dispatchEvent(new dom.window.Event('scroll'));
  dom.window.document.dispatchEvent(new dom.window.Event('scrollend'));
  assert(calls.at(-1).data.ended);
  assert.equal(calls.at(-1).data.delta,0);
  dom.qaClose();
});

test('official ticket shortcut is recognized only by the account page’s configured App link', () => {
  const dom = page('', 'https://mall.bilibili.com/neul/index.html?page=box_me');
  const shortcut = 'bilibili://mall/test-ticket-shortcut';
  const receiving = 'bilibili://mall/test-receiving-shortcut';
  dom.window.localStorage.setItem('centerConfig', JSON.stringify({
    funcList: {data: [{name:'电子票', jumpUrl:shortcut}, {name:'在线客服', jumpUrl:'bilibili://mall/test-service'}]},
    orderList: {data: [{name:'待收货', jumpUrl:receiving}]},
  }));
  dom.window.eval(source);
  assert.equal(dom.window.__piliMallAdapter.accountAppShortcut(shortcut), 'ticket');
  assert.equal(dom.window.__piliMallAdapter.accountAppShortcut(receiving), 'receiving');
  assert.equal(dom.window.__piliMallAdapter.accountAppShortcut('bilibili://mall/test-service'), null);
  dom.window.history.replaceState(null, '', '/neul/index.html?page=mall_cart');
  assert.equal(dom.window.__piliMallAdapter.accountAppShortcut(shortcut), null);
  dom.qaClose();
});

test('both official ticket detail aliases preserve the purchase action', async () => {
  for (const path of ['/neul-next/ticket/detail.html', '/mall-dayu/neul-next/ticket/detail.html']) {
    const dom = page('<div class="footer-container"><div class="footer-menu" style="position:fixed"><div class="action-container"><button>立即购票</button></div></div></div>',
      `https://mall.bilibili.com${path}?id=123`);
    dom.window.eval(source);
    dom.window.__piliMallAdapter.update({width:400,bottom:80,theme:{surface:'#000000'},homeStyle:'/* theme */'});
    await frame(dom.window);
    assert.equal(dom.window.document.documentElement.dataset.ppPage, 'ticket-detail');
    assert(dom.window.document.querySelector('.footer-menu').hasAttribute('data-pp-raised'));
    assert.notEqual(dom.window.getComputedStyle(dom.window.document.querySelector('button')).display, 'none');
    dom.qaClose();
  }
});

test('an actual account shortcut click identifies a decorated native destination', () => {
  const dom = page('<div class="me-page"><div class="func-list"><div class="func-item"><div class="text">电子票</div></div></div><button>其他</button></div>',
    'https://mall.bilibili.com/neul/index.html?page=box_me');
  dom.window.eval(source);
  dom.window.document.querySelector('.text').click();
  const adapter = dom.window.__piliMallAdapter;
  assert.equal(adapter.accountAppShortcut('bilibili://mall/test?decorated=1'), 'ticket');
  assert.equal(adapter.accountAppShortcut('https://mall.bilibili.com/orderlist.html'), null);
  dom.window.document.querySelector('button').click();
  assert.equal(adapter.accountAppShortcut('bilibili://mall/test'), null);
  dom.qaClose();
});

test('a redirected after-sales page receives theme only after the official template is identified', async () => {
  const dom = page('', 'https://mall.bilibili.com/neul-next/index.html');
  dom.window.__piliMallAftersaleRoute = true;
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{'color-scheme':'dark'},homeStyle:'/* theme */'});
  await frame(dom.window);
  const {document} = dom.window;
  assert.equal(document.documentElement.dataset.ppPage, undefined);
  document.body.innerHTML = '<main class="result"><div class="bili-title-container"><div class="title">退换/售后</div></div><div class="tab-title-flex"><button class="tab-tilte_creat">处理中</button></div></main>';
  await frame(dom.window);
  assert.equal(document.documentElement.dataset.ppPage, 'aftersale');
  assert.equal(document.documentElement.style.getPropertyValue('--pp-color-scheme'), 'dark');
  assert.equal(document.querySelector('button').textContent, '处理中');
  dom.qaClose();
});

test('origin, scheme, unknown page and iframe are outside adaptation scope', () => {
  for (const url of ['https://example.org/', 'https://mall.bilibili.com.evil.example/', 'http://mall.bilibili.com/', 'https://mall.bilibili.com:8443/', 'https://mall.bilibili.com/unknown.html']) {
    const dom = page('', url);
    dom.window.eval(source);
    assert.equal(dom.window.__piliMallAdapter, undefined);
    assert.equal(dom.window.document.querySelector('style'), null);
    dom.qaClose();
  }
  const dom = page('<iframe src="https://mall.bilibili.com/category.html"></iframe>');
  const child = dom.window.document.querySelector('iframe').contentWindow;
  child.eval(source);
  assert.equal(child.__piliMallAdapter, undefined);
  dom.qaClose();
});

test('only identified site navigation hides; checkout, price, member label and image survive', async () => {
  const dom = page(`<section><nav class="bili-bottom">${navigation}</nav><div class="bottom-empty"></div></section>
    <div id="cartFooter" class="bil-cart-footer bottom-fixed" style="position:fixed;bottom:0px"><span id="price">¥123.45</span><button id="checkout">结算</button></div>
    <img id="product" src="https://i0.hdslb.com/test.jpg"><span id="member">会员价</span>
    <div class="bottom-bar">业务操作</div>`, 'https://mall.bilibili.com/neul/index.html?page=mall_cart');
  const {document} = dom.window;
  const image = document.querySelector('#product');
  const checkout = document.querySelector('#checkout');
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400, bottom:100});
  await frame(dom.window);
  assert(document.querySelector('.bili-bottom').hasAttribute('data-pp-nav'));
  assert(document.querySelector('#cartFooter').hasAttribute('data-pp-raised'));
  assert(!document.querySelector('#cartFooter').hasAttribute('data-pp-nav'));
  assert(!document.querySelector('.bottom-bar').hasAttribute('data-pp-nav'));
  assert.equal(document.querySelector('#checkout'), checkout);
  assert.equal(document.querySelector('#product'), image);
  assert.equal(image.getAttribute('src'), 'https://i0.hdslb.com/test.jpg');
  assert.equal(document.querySelector('#price').outerHTML, '<span id="price">¥123.45</span>');
  assert.equal(document.querySelector('#member').textContent, '会员价');
  dom.qaClose();
});

test('detail purchase bar and SKU popup are raised, never hidden', async () => {
  const dom = page('<div class="bottom bottom-type1" style="position:fixed;bottom:0px"><button class="bottom-buy">立即购买</button></div><div class="popup-container-wrapper" style="position:fixed;bottom:0px"><div class="sku-container">规格</div></div>', 'https://mall.bilibili.com/detail.html?itemsId=1');
  dom.window.eval(source);
  await frame(dom.window);
  for (const element of dom.window.document.querySelectorAll('.bottom,.popup-container-wrapper')) {
    assert(element.hasAttribute('data-pp-raised'));
    assert(!element.hasAttribute('data-pp-nav'));
  }
  assert.equal(dom.window.document.querySelector('.bottom-buy').textContent, '立即购买');
  dom.qaClose();
});

test('logical layout converts through viewport width and updates for keyboard/resize', async () => {
  const dom = page();
  Object.defineProperty(dom.window, 'innerWidth', {value:750, writable:true});
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400, bottom:110});
  await frame(dom.window);
  const style = dom.window.document.documentElement.style;
  assert.equal(style.getPropertyValue('--pp-overlay'), '206.25px');
  dom.window.__piliMallAdapter.update({width:400, bottom:0});
  await frame(dom.window);
  assert.equal(style.getPropertyValue('--pp-overlay'), '0px');
  dom.window.innerWidth = 800;
  dom.window.__piliMallAdapter.update({width:800, bottom:107});
  await frame(dom.window);
  assert.equal(style.getPropertyValue('--pp-overlay'), '107px');
  dom.qaClose();
});

test('re-injection is idempotent: one style, one observer and one set of listeners', async () => {
  const dom = page();
  let observers = 0;
  const listeners = [];
  const OriginalObserver = dom.window.MutationObserver;
  dom.window.MutationObserver = class extends OriginalObserver { constructor(callback) { super(callback); observers++; } };
  const originalAdd = dom.window.addEventListener;
  dom.window.addEventListener = function(name, ...args) { listeners.push(name); return originalAdd.call(this, name, ...args); };
  dom.window.eval(source);
  const pushState = dom.window.history.pushState;
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400, bottom:100});
  await frame(dom.window);
  assert.equal(dom.window.document.querySelectorAll('#piliplus-mall-adapter').length, 1);
  assert.equal(observers, 1);
  assert.deepEqual(listeners.sort(), ['popstate', 'resize']);
  assert.equal(dom.window.history.pushState, pushState);
  dom.qaClose();
});

test('asynchronous navigation and SPA transitions adapt without a polling timer', async () => {
  const dom = page('<div class="scroll-container"><div id="content" style="padding-bottom:7px"></div></div>');
  dom.window.eval(source);
  const nav = dom.window.document.createElement('nav');
  nav.className = 'bottom-main';
  dom.window.document.body.append(nav);
  nav.innerHTML = navigation;
  await frame(dom.window);
  assert(nav.hasAttribute('data-pp-nav'));
  const content = dom.window.document.querySelector('#content');
  assert.equal(content.style.getPropertyValue('--pp-original-padding'), '7px');
  dom.window.__piliMallAdapter.update({width:400, bottom:100});
  await frame(dom.window);
  assert.equal(content.style.getPropertyValue('--pp-original-padding'), '7px');
  dom.window.history.pushState({state:'preserved'}, '', '/unknown.html');
  await frame(dom.window);
  assert(!dom.window.document.documentElement.hasAttribute('data-pp-mall'));
  assert.equal(dom.window.history.state.state, 'preserved');
  dom.window.history.replaceState({state:'again'}, '', '/neul/index.html?page=box_me');
  await frame(dom.window);
  assert(dom.window.document.documentElement.hasAttribute('data-pp-mall'));
  assert.equal(dom.window.history.state.state, 'again');
  dom.qaClose();
});

test('confirmed audio/comic promotion component collapses without hiding matching product text', async () => {
  const dom = page('<div class="container" id="promotions"><a class="item left" href="//www.biligo.com/neul/index.html?page=mall_tryoutmissevanlist#noReffer=true">免费音频试听</a><a class="item" href="//www.biligo.com/neul/index.html?page=mall_tryoutmangalist#noReffer=true">免费漫画试读</a></div><article id="product">免费音频试听与免费漫画试读商品介绍</article><a class="item" id="normal" href="/detail.html?itemsId=1">免费漫画试读</a>');
  dom.window.eval(source);
  await frame(dom.window);
  const row = dom.window.document.querySelector('#promotions');
  assert.equal(dom.window.getComputedStyle(row).display, 'none');
  assert.equal(row.querySelectorAll('[data-pp-promotion]').length, 2);
  assert.equal(dom.window.document.querySelector('#product').textContent, '免费音频试听与免费漫画试读商品介绍');
  assert(!dom.window.document.querySelector('#normal').hasAttribute('data-pp-promotion'));
  assert.notEqual(dom.window.getComputedStyle(dom.window.document.querySelector('#normal')).display, 'none');
  dom.qaClose();
});

test('asynchronous/reused promotion nodes adapt across SPA and retain non-promotion children', async () => {
  const dom = page();
  dom.window.eval(source);
  const row = dom.window.document.createElement('div');
  row.className = 'container';
  row.innerHTML = '<a class="item" href="https://www.biligo.com/neul/index.html?page=mall_tryoutmangalist">入口</a>';
  dom.window.document.body.append(row);
  await frame(dom.window);
  assert.equal(dom.window.getComputedStyle(row).display, 'none');
  const link = row.firstElementChild;
  link.href = 'https://mall.bilibili.com/detail.html?itemsId=1';
  await frame(dom.window);
  assert(!link.hasAttribute('data-pp-promotion'));
  assert(!row.hasAttribute('data-pp-promotion-row'));
  link.href = 'https://www.biligo.com/neul/index.html?page=mall_tryoutmangalist';
  row.append(dom.window.document.createTextNode('保留的普通内容'));
  await frame(dom.window);
  assert(link.hasAttribute('data-pp-promotion'));
  assert(!row.hasAttribute('data-pp-promotion-row'));
  dom.window.history.replaceState(null, '', '/neul/index.html?page=box_me');
  await frame(dom.window);
  assert.notEqual(dom.window.getComputedStyle(row).display, 'none');
  dom.qaClose();
});

test('only known visible overlay close buttons consume back; purchase actions are untouched', async () => {
  const dom = page('<div class="popup-container-wrapper"><button class="popup-close">关闭规格</button><button class="bottom-buy">购买</button></div><div class="search-board" style="display:none"><button class="cancel">取消搜索</button></div>', 'https://mall.bilibili.com/detail.html?itemsId=1');
  const document = dom.window.document;
  for (const button of document.querySelectorAll('button')) button.getBoundingClientRect = () => ({width:24, height:24});
  const clicked = [];
  for (const button of document.querySelectorAll('button')) button.addEventListener('click', () => clicked.push(button.textContent));
  dom.window.eval(source);
  await frame(dom.window);
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(), true);
  assert.deepEqual(clicked, ['关闭规格']);
  document.querySelector('.popup-container-wrapper').style.display = 'none';
  document.querySelector('.search-board').style.display = 'block';
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(), true);
  assert.deepEqual(clicked, ['关闭规格', '取消搜索']);
  document.querySelector('.search-board').style.display = 'none';
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(), false);
  dom.qaClose();
});

test('identified ticket detail keeps purchase footer and moves the complete modal viewport', async () => {
  const dom = page('<div class="footer-container"><div class="footer-menu" style="position:fixed;bottom:0px"><div class="action-container"><button id="buy">购票</button></div></div></div><div class="bili-modal" style="position:fixed;height:100%"><div class="bili-modal-box"><button class="bili-modal-close">关闭</button><button id="confirm">确定</button></div><div class="bottom-bar">票务业务栏</div></div><div class="footer-menu" id="unrelated">其他菜单</div>', 'https://show.bilibili.com/h5/detail.html?id=1');
  const {document} = dom.window;
  let purchases = 0;
  for (const button of document.querySelectorAll('#buy,#confirm')) button.addEventListener('click', () => purchases++);
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400, bottom:107});
  await frame(dom.window);
  assert(document.querySelector('.footer-container > .footer-menu').hasAttribute('data-pp-raised'));
  assert(document.querySelector('.bili-modal').hasAttribute('data-pp-ticket-modal'));
  assert(!document.querySelector('#unrelated').hasAttribute('data-pp-raised'));
  assert.equal(document.querySelectorAll('[data-pp-nav]').length, 0);
  assert.notEqual(dom.window.getComputedStyle(document.querySelector('#buy')).display, 'none');
  const close = document.querySelector('.bili-modal-close');
  close.getBoundingClientRect = () => ({width:24, height:24});
  let closed = 0;
  close.addEventListener('click', () => closed++);
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(), true);
  assert.equal(closed, 1);
  assert.equal(purchases, 0);
  dom.window.__piliMallAdapter.update({width:400, bottom:0});
  await frame(dom.window);
  assert.equal(document.documentElement.style.getPropertyValue('--pp-overlay'), '0px');
  dom.qaClose();
});

test('ticket async footer and SPA remain scoped to known show pages', async () => {
  for (const url of ['https://show.bilibili.com/detail.html', 'https://show.bilibili.com/unknown', 'http://show.bilibili.com/h5/detail.html', 'https://show.bilibili.com:8443/h5/detail.html']) {
    const dom = page('', url);
    dom.window.eval(source);
    assert.equal(dom.window.__piliMallAdapter, undefined);
    dom.qaClose();
  }
  const dom = page('', 'https://show.bilibili.com/m/platform/home.html');
  dom.window.eval(source);
  dom.window.history.pushState(null, '', '/h5/detail.html?id=1');
  const footer = dom.window.document.createElement('div');
  footer.className = 'footer-container';
  dom.window.document.body.append(footer);
  footer.innerHTML = '<div class="footer-menu" style="position:fixed;bottom:0px"><div class="action-container">购票</div></div>';
  await frame(dom.window);
  assert(footer.firstElementChild.hasAttribute('data-pp-raised'));
  dom.window.history.pushState(null, '', '/unknown');
  await frame(dom.window);
  assert(!dom.window.document.documentElement.hasAttribute('data-pp-mall'));
  dom.qaClose();
});

test('current ticket list and identified event detail receive only scoped shell adaptation', async () => {
  const icons=['home','movie','collection','order'].map(icon=>`<li class="bili-nav-item"><i class="bili-icon-${icon}"></i></li>`).join('');
  const dom=page(`<div class="bottom"><div class="footer-tab"><ul class="bili-nav-bar">${icons}</ul></div></div><div id="event-list">官方活动列表</div>`, 'https://show.bilibili.com/platform/home.html');
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{surface:'#101010ff'},homeStyle:'html[data-pp-page="ticket-activity"] body { background: var(--pp-surface); }'});
  await frame(dom.window);
  const document=dom.window.document;
  assert.equal(document.documentElement.getAttribute('data-pp-page'),'ticket-activity');
  assert(document.querySelector('.footer-tab').hasAttribute('data-pp-nav'));
  assert.equal(dom.window.getComputedStyle(document.querySelector('.footer-tab')).display,'none');
  assert.equal(document.querySelector('#event-list').textContent,'官方活动列表');

  dom.window.history.pushState(null, '', '/platform/detail.html?id=113289');
  const footer=document.createElement('div');
  footer.className='footer-container';
  footer.innerHTML='<div class="footer-menu-wrapper" style="position:fixed;bottom:0"><div class="footer-menu"><div class="action-container"><button id="buy">立即购票</button></div></div></div>';
  document.body.append(footer);
  await frame(dom.window);
  assert.equal(document.documentElement.getAttribute('data-pp-page'),'ticket-detail');
  assert(document.querySelector('.footer-menu-wrapper').hasAttribute('data-pp-raised'));
  assert.equal(document.querySelector('#buy').textContent,'立即购票');
  assert.notEqual(dom.window.getComputedStyle(document.querySelector('#buy')).display,'none');

  dom.window.history.pushState(null, '', '/platform/unknown.html');
  await frame(dom.window);
  assert(!document.documentElement.hasAttribute('data-pp-mall'));
  assert(!document.documentElement.hasAttribute('data-pp-page'));
  dom.qaClose();
});

test('ticket movie, favorites and orders are themed only on their exact official routes', async () => {
  const routes=[
    ['/neul-next/ticket/movieHome.html?noTitleBar=1','ticket-movie'],
    ['/neul-next/ticket/collection.html?noTitleBar=1','ticket-collection'],
    ['/orderlist.html?noTitleBar=1','ticket-order'],
  ];
  for (const [path,kind] of routes) {
    const dom=page('<div id="official-page">官网票务页面</div>', `https://mall.bilibili.com${path}`);
    dom.window.eval(source);
    dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{surface:'#101010ff'},homeStyle:'/* themed ticket page */'});
    await frame(dom.window);
    assert.equal(dom.window.document.documentElement.getAttribute('data-pp-page'),kind);
    assert.equal(dom.window.document.querySelector('#official-page').textContent,'官网票务页面');
    dom.qaClose();
  }
});

test('identified account, address, order and after-sales pages receive shell theme without changing actions', async () => {
  const routes = [
    ['/neul/index.html?page=box_me&noTitleBar=1', 'account'],
    ['/orderlist.html?noTitleBar=1', 'ticket-order'],
    ['/addresslist.html?noTitleBar=1', 'address'],
    ['/neul/index.html?page=aftersale_aftersaleList&noTitleBar=1', 'aftersale'],
  ];
  for (const [path, kind] of routes) {
    const dom = page('<main><button id="official-action">官网操作</button></main>', `https://mall.bilibili.com${path}`);
    dom.window.eval(source);
    dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{surface:'#101010ff'},homeStyle:'/* themed account page */'});
    await frame(dom.window);
    assert.equal(dom.window.document.documentElement.dataset.ppPage, kind);
    assert.equal(dom.window.document.querySelector('#official-action').textContent, '官网操作');
    dom.qaClose();
  }

  const dom = page('', 'https://mall.bilibili.com/neul/index.html?page=box_me');
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:{surface:'#101010ff'},homeStyle:'/* themed account page */'});
  await frame(dom.window);
  dom.window.history.pushState(null, '', '/neul/index.html?page=unrecognized_account_tab');
  await frame(dom.window);
  assert(!dom.window.document.documentElement.hasAttribute('data-pp-page'));
  dom.qaClose();
});

test('open product image preview closes before underlying SKU without triggering business buttons', async () => {
  const dom = page('<div class="popup-container-wrapper"><button class="popup-close">关闭规格</button></div><div class="pswp pswp--open"><i class="pswp__button--close">关闭图片</i></div>', 'https://mall.bilibili.com/detail.html?itemsId=1');
  const closed = [];
  for (const button of dom.window.document.querySelectorAll('.popup-close,.pswp__button--close')) {
    button.getBoundingClientRect = () => ({width:24, height:24});
    button.addEventListener('click', () => closed.push(button.textContent));
  }
  dom.window.eval(source);
  await frame(dom.window);
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(), true);
  assert.deepEqual(closed, ['关闭图片']);
  dom.qaClose();
});
test('new official ticket navigation hides only after native equivalents are provided; purchase wrapper stays', async () => {
  const icons=['home','movie','collection','order'].map(icon=>`<li class="bili-nav-item"><i class="bili-icon-${icon}"></i></li>`).join('');
  const dom=page(`<div class="bottom"><div class="footer-tab"><ul class="bili-nav-bar">${icons}</ul></div></div><div class="footer-container"><div class="footer-menu-wrapper" style="position:fixed;bottom:0px"><div class="footer-menu"><div class="action-container">立即购票</div></div></div></div><div class="bili-modal" style="position:fixed;height:100%"><div class="bili-modal-box">票种选择</div></div>`, 'https://mall.bilibili.com/neul-next/ticket-renovation/detail.html?id=1');
  dom.window.eval(source);
  await frame(dom.window);
  const document=dom.window.document;
  assert.equal(dom.window.getComputedStyle(document.querySelector('.footer-tab')).display,'none');
  assert.equal(dom.window.getComputedStyle(document.querySelector('.bottom')).display,'none');
  assert(document.querySelector('.footer-menu-wrapper').hasAttribute('data-pp-raised'));
  assert(document.querySelector('.bili-modal').hasAttribute('data-pp-ticket-modal'));
  assert(!document.querySelector('.footer-menu-wrapper').hasAttribute('data-pp-nav'));
  assert.equal(document.querySelector('.action-container').textContent,'立即购票');
  dom.qaClose();
});
test('confirmed search filter popup is bounded above native navigation and only close consumes back', async () => {
  const dom=page('<div class="franky-popup_box is-bottom" style="position:fixed;bottom:0"><div class="filter-board"><div class="board-wrapper"><i class="filter-close">关闭</i><div class="bottom-btn-group"><button class="reset">重置</button><button class="confirm">查看商品</button></div></div></div></div><div id="other" class="franky-popup_box is-bottom" style="position:fixed">无关弹层</div>', 'https://mall.bilibili.com/neul-next/index.html?page=flow_searchResult&keyword=test');
  const document=dom.window.document;
  let closed=0,confirmed=0;
  const close=document.querySelector('.filter-close');
  close.getBoundingClientRect=()=>({width:24,height:24});
  close.addEventListener('click',()=>closed++);
  document.querySelector('.confirm').addEventListener('click',()=>confirmed++);
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:107});
  await frame(dom.window);
  const popup=document.querySelector('.franky-popup_box');
  assert(popup.hasAttribute('data-pp-search-filter'));
  assert(popup.hasAttribute('data-pp-raised'));
  assert.equal(dom.window.getComputedStyle(popup).maxHeight,'calc(100vh - var(--pp-overlay))');
  assert(!document.querySelector('#other').hasAttribute('data-pp-search-filter'));
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(),true);
  assert.equal(closed,1);
  assert.equal(confirmed,0);
  dom.qaClose();
});

const homeStyle = fs.readFileSync('assets/mall/home.css', 'utf8');
const homeMarkup = `<div id="app"><div class="header"><div class="content">会员购</div></div><div class="franky-scroll-view"><div class="scroll-view-container"><div class="scroll-view-content"><div class="head-container"><div class="home-search-bar"><div class="bili-search-wrap"><i class="search-icon"></i><span class="search-text">搜一搜</span></div></div><div class="second-categories"><div class="item"><p class="desc">手办</p></div></div></div><div class="home-main"><div class="goods-container"><img id="photo" src="https://i0.hdslb.com/product.jpg"><div class="info-container"><div class="desc-container"><p class="desc">普通商品 <svg class="svg-tag"><text fill="#505050">预售</text></svg></p></div><p class="price" style="color:rgb(255,86,135)">¥123.45</p><span id="member">会员优惠</span></div></div></div></div></div></div></div>`;
const homeTheme = {'surface':'#faf8ffff','card':'#f4f2faff','search':'#e9e6efff','on-surface':'#19171dff','on-surface-variant':'#48454fff','primary':'#6750a4ff','font-size':14,'label-size':12,'line-height':1.43,'font-weight':400,'font-family':'Roboto, sans-serif','radius':10,'space':8,'gutter':12};

test('home visual scope requires the real structure; controls in an unknown header stay', async () => {
  const dom=page(homeMarkup);
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:107,theme:homeTheme,homeStyle});
  await frame(dom.window);
  const document=dom.window.document;
  assert.equal(document.documentElement.getAttribute('data-pp-page'),'home');
  assert(document.querySelector('#app > .header').hasAttribute('data-pp-home-title'));
  const control=document.createElement('button');
  control.textContent='保留业务操作';
  document.querySelector('#app > .header .content').append(control);
  await frame(dom.window);
  assert(!document.querySelector('#app > .header').hasAttribute('data-pp-home-title'));
  assert.equal(control.textContent,'保留业务操作');
  dom.qaClose();
  const unknown=page('<div class="goods-container"><button>未知业务</button></div>');
  unknown.window.eval(source);
  unknown.window.__piliMallAdapter.update({width:400,bottom:107,theme:homeTheme,homeStyle});
  await frame(unknown.window);
  assert(!unknown.window.document.documentElement.hasAttribute('data-pp-page'));
  assert.equal(unknown.window.document.querySelector('button').textContent,'未知业务');
  unknown.qaClose();
});

test('theme changes keep official photos, prices, labels and handlers with one stylesheet', async () => {
  const dom=page(homeMarkup);
  const document=dom.window.document;
  const card=document.querySelector('.goods-container');
  const business=card.innerHTML;
  let opened=0;
  card.addEventListener('click',()=>opened++);
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:107,theme:homeTheme,homeStyle});
  await frame(dom.window);
  let scans=0;
  const original=document.body.querySelectorAll.bind(document.body);
  document.body.querySelectorAll=(...args)=>{scans++;return original(...args);};
  const dark={...homeTheme,surface:'#141218ff',card:'#1d1b20ff','on-surface':'#e6e0e9ff',primary:'#c5b4ddff'};
  for(let n=0;n<4;n++) {
    dom.window.eval(source);
    dom.window.__piliMallAdapter.update({width:400,bottom:107,theme:n%2?homeTheme:dark,homeStyle});
  }
  await frame(dom.window);
  assert.equal(scans,0,'theme-only updates must not rescan the page');
  assert.equal(document.querySelectorAll('#piliplus-mall-home').length,1);
  assert.equal(document.querySelectorAll('#piliplus-mall-adapter').length,1);
  assert.equal(document.querySelector('.goods-container'),card);
  assert.equal(card.innerHTML,business);
  assert.equal(document.documentElement.style.getPropertyValue('--pp-primary'),homeTheme.primary);
  card.click();
  assert.equal(opened,1);
  assert.equal(document.querySelector('.price').style.color,'rgb(255, 86, 135)');
  assert(!homeStyle.includes('filter:'));
  dom.qaClose();
});

test('asynchronous home content activates styling; SPA subpages deactivate it', async () => {
  const dom=page();
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:107,theme:homeTheme,homeStyle});
  await frame(dom.window);
  assert(!dom.window.document.documentElement.hasAttribute('data-pp-page'));
  dom.window.document.body.insertAdjacentHTML('beforeend',homeMarkup);
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.getAttribute('data-pp-page'),'home');
  dom.window.history.pushState({scroll:420},'', '/category.html');
  await frame(dom.window);
  assert(!dom.window.document.documentElement.hasAttribute('data-pp-page'));
  assert.equal(dom.window.history.state.scroll,420);
  dom.window.history.replaceState(null,'','/index.html');
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.getAttribute('data-pp-page'),'home');
  dom.qaClose();
});

test('home layout unit follows actual viewport while theme variables survive keyboard insets', async () => {
  const dom=page(homeMarkup);
  Object.defineProperty(dom.window,'innerWidth',{value:750,writable:true});
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:107,theme:homeTheme,homeStyle});
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.style.getPropertyValue('--pp-unit'),'1.875px');
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:homeTheme,homeStyle});
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.style.getPropertyValue('--pp-overlay'),'0px');
  assert.equal(dom.window.document.documentElement.style.getPropertyValue('--pp-card'),homeTheme.card);
  dom.qaClose();
});

const coreStyle = homeStyle + '\n' + fs.readFileSync('assets/mall/core.css', 'utf8');
const coreTheme = {...homeTheme, 'on-primary':'#ffffffff', 'primary-container':'#e9ddffff', 'on-primary-container':'#231047ff'};
const modernDetail = '<div class="detail-container-wrap"><section class="product-info-area detail-module"><span class="clamp-real-text">商品名称</span><img id="product-image" src="https://i0.hdslb.com/product.jpg"><span class="bili-price" style="color:rgb(255,86,135)">¥123.45</span><span class="sale-tag" style="color:rgb(240,20,70)">会员优惠</span></section><div class="bottom bottom-bar-module" style="position:fixed;bottom:0px"><div class="bottom-bar-wrap"><div class="buy-cart-button"><button id="buy">立即购买</button></div></div></div></div>';
const cartMarkup = '<div class="bil-cart"><div id="cartHeader"><button>管理</button></div><div class="shop-item"><div class="scroll-view-content"><div class="warehouse-item"><div class="bili-sku-item"><span class="sku-name">测试商品</span><span class="bili-pink" style="color:rgb(255,86,135)">¥123.45</span><button class="minus disabled" disabled>减</button><span class="count-panel">1</span><button class="plus">加</button></div><div class="bili-sku-item failure"><span class="failure-tag">失效</span></div></div></div></div><div id="cartFooter" class="bil-cart-footer bottom-fixed" style="position:fixed;bottom:0px"><div class="footer-content"><span>合计</span><button>结算</button></div></div></div>';

test('new detail route requires matching page and real components; buying bar remains raised and visible', async () => {
  const url='https://mall.bilibili.com/neul-next/detailuniversal/detail.html?page=detailuniversal_detail&itemsId=1';
  const dom=page(modernDetail,url);
  const document=dom.window.document;
  const business=document.querySelector('.product-info-area').innerHTML;
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:92,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert.equal(document.documentElement.getAttribute('data-pp-page'),'detail');
  const operation=document.querySelector('.bottom-bar-module');
  assert(operation.hasAttribute('data-pp-raised'));
  assert(!operation.hasAttribute('data-pp-nav'));
  assert.equal(document.querySelector('.product-info-area').innerHTML,business);
  assert.notEqual(dom.window.getComputedStyle(operation).display,'none');
  dom.qaClose();
  const unknown=page(modernDetail,url.replace('detailuniversal_detail','unknown'));
  unknown.window.eval(source);
  assert.equal(unknown.window.__piliMallAdapter,undefined);
  unknown.qaClose();
});

test('real SKU portal moves the inner fixed box and preserves selection, stock and business handlers', async () => {
  const html=modernDetail+'<div class="popup-container-wrapper" style="position:fixed;height:0"></div><div class="franky-popup_box is-bottom" style="position:fixed;bottom:0"><div class="popup-container"><div class="popup-close">关闭</div><div class="popup-body"><div class="sku-container"><h4>规格</h4><div class="spec-normal spec-active">已选</div><button class="spec-normal spec-disable" disabled style="color:rgb(153,153,153)">售罄</button></div><div class="group-button-container"><button id="cart-action">加购物车</button></div></div></div></div>';
  const dom=page(html,'https://mall.bilibili.com/neul-next/detailuniversal/detail.html?page=detailuniversal_detail&itemsId=1');
  const document=dom.window.document;
  let purchases=0,closed=0;
  document.querySelector('#cart-action').addEventListener('click',()=>purchases++);
  const close=document.querySelector('.franky-popup_box .popup-close');
  close.getBoundingClientRect=()=>({width:24,height:24});
  close.addEventListener('click',()=>closed++);
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:92,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert(document.querySelector('.franky-popup_box').hasAttribute('data-pp-raised'));
  assert(document.querySelector('.franky-popup_box').hasAttribute('data-pp-sku-popup'));
  assert(document.querySelector('.spec-disable').disabled);
  assert(document.querySelector('.spec-active').classList.contains('spec-active'));
  assert.equal(dom.window.__piliMallAdapter.dismissOverlay(),true);
  assert.equal(closed,1);
  assert.equal(purchases,0);
  dom.qaClose();
});

test('cart uses one scroll inset and preserves quantities, failure markers and checkout', async () => {
  const dom=page(cartMarkup,'https://mall.bilibili.com/neul/index.html?page=mall_cart');
  const document=dom.window.document;
  const item=document.querySelector('.bili-sku-item');
  const contents=item.innerHTML;
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:92,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert.equal(document.documentElement.getAttribute('data-pp-page'),'cart');
  assert(document.documentElement.hasAttribute('data-pp-inner-scroll'));
  assert(document.querySelector('.scroll-view-content').hasAttribute('data-pp-scroll'));
  assert.equal(item.innerHTML,contents);
  assert(document.querySelector('.minus').disabled);
  assert.equal(document.querySelector('.failure-tag').textContent,'失效');
  assert(document.querySelector('#cartFooter').hasAttribute('data-pp-raised'));
  assert(!document.querySelector('#cartFooter').hasAttribute('data-pp-nav'));
  dom.qaClose();
});

test('search and public list signatures activate per page; SPA replaces the marker without duplicate styles', async () => {
  const dom=page('<div class="search-result-wrap"><div class="header-sticky"><div class="header-wrap"></div></div><div class="filter-wrap"></div><div class="scroll-view-content"><div class="goods-list"><div class="goods-item"><span class="name">搜索商品</span><span class="bili-price" style="color:rgb(255,86,135)">¥8</span></div></div></div></div>','https://mall.bilibili.com/neul-next/index.html?page=flow_searchResult&keyword=test');
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:92,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.getAttribute('data-pp-page'),'search');
  dom.window.history.pushState(null,'','/neul/index.html?page=mall_cart');
  dom.window.document.body.innerHTML=cartMarkup;
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.getAttribute('data-pp-page'),'cart');
  dom.window.history.pushState(null,'','/list.html?category=1_107');
  dom.window.document.body.innerHTML='<div id="app"><div class="main-goods-container"><div class="main-filter-bar"></div><div class="goods-list"></div></div></div>';
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.getAttribute('data-pp-page'),'list');
  assert(!dom.window.document.documentElement.hasAttribute('data-pp-inner-scroll'));
  assert.equal(dom.window.document.querySelectorAll('#piliplus-mall-home').length,1);
  dom.qaClose();
});


test('search content inset follows the measured combined header and responds to viewport changes', async () => {
  const dom=page('<div class="search-result-wrap"><div class="header-sticky"><div class="header-wrap"></div></div><div class="filter-wrap"></div></div>','https://mall.bilibili.com/neul-next/index.html?page=flow_searchResult');
  const header=dom.window.document.querySelector('.header-sticky');
  let height=91;
  header.getBoundingClientRect=()=>({height});
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:92,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.style.getPropertyValue('--pp-search-header-height'),'91px');
  height=110;
  dom.window.dispatchEvent(new dom.window.Event('resize'));
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.style.getPropertyValue('--pp-search-header-height'),'110px');
  assert.equal(dom.window.document.querySelectorAll('#piliplus-mall-home').length,1);
  dom.qaClose();
});


test('category theming needs the observed template and preserves async category items', async () => {
  const dom=page('<div class="header"><div class="search-input"></div></div><div class="category-main"><div class="category-part-container"></div></div>', 'https://mall.bilibili.com/category.html');
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert.equal(dom.window.document.documentElement.dataset.ppPage,'category');
  dom.window.document.querySelector('.category-part-container').innerHTML='<div class="category-part-item"><div class="category-title">分类</div><a class="category-item" href="/list.html?category=1">商品</a></div>';
  await frame(dom.window);
  assert.equal(dom.window.document.querySelector('.category-item').getAttribute('href'), '/list.html?category=1');
  assert.equal(dom.window.document.querySelectorAll('#piliplus-mall-home').length,1);
  dom.qaClose();
});


test('identified filter uses Weeko G2 geometry once until measured dimensions change', async () => {
  const dom=page('<div class="search-result-wrap"><div class="header-sticky"><div class="header-wrap"></div></div><div class="filter-wrap"></div></div><div class="franky-popup_box is-bottom"><div class="filter-board"><div class="bottom-btn-group"></div></div></div>', 'https://mall.bilibili.com/neul-next/index.html?page=flow_searchResult');
  dom.window.innerWidth=400;
  const panel=dom.window.document.querySelector('.filter-board');
  let width=400;
  Object.defineProperty(panel,'offsetWidth',{get:()=>width});
  Object.defineProperty(panel,'offsetHeight',{get:()=>500});
  dom.window.eval(source);
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  const path=panel.style.clipPath;
  const points=path.match(/-?\d+(?:\.\d+)?/g).map(Number);
  assert.deepEqual(points.slice(0,4),[32,0,368,0]);
  assert(Math.abs(points[8]-394.24)<1e-6);
  assert(Math.abs(points[9]-5.76)<1e-6);
  assert(path.includes('L 400 500 L 0 500'));
  dom.window.__piliMallAdapter.update({width:400,bottom:0,theme:coreTheme,homeStyle:coreStyle});
  await frame(dom.window);
  assert.equal(panel.style.clipPath,path);
  width=300;
  dom.window.dispatchEvent(new dom.window.Event('resize'));
  await frame(dom.window);
  assert.notEqual(panel.style.clipPath,path);
  dom.qaClose();
});


test('early history injection waits for a body and installs only once', async () => {
  const dom=page();
  dom.window.document.body.remove();
  dom.window.eval(source);
  dom.window.eval(source);
  assert.equal(dom.window.__piliMallAdapter,undefined);
  const body=dom.window.document.createElement('body');
  dom.window.document.documentElement.appendChild(body);
  dom.window.document.dispatchEvent(new dom.window.Event('DOMContentLoaded'));
  await frame(dom.window);
  assert(dom.window.__piliMallAdapter);
  assert.equal(dom.window.document.querySelectorAll('#piliplus-mall-adapter').length,1);
  dom.qaClose();
});

test('mall static budget stabilizes after repeated growth without touching session or active files', async () => {
  const dom = page();
  const {window} = dom;
  const mib = 1024 * 1024;
  const asset = n => 'https://s1.hdslb.com/bfs/static/neul/a' + n + '.js';
  const active = asset('active');
  const ticket = 'https://mall.bilibili.com/neul-next/ticket/detail.html';
  const protectedCache = {keys: async () => { throw Error('must not inspect unrelated cache'); }};
  const entries = new Map([[active, 8 * mib], [ticket, 27 * mib]]);
  const cache = {
    keys: async () => [...entries.keys()].map(url => ({url, method: 'GET'})),
    match: async request => ({ok: true, headers: {get: () => String(entries.get(request.url))}}),
    delete: async request => entries.delete(request.url),
  };
  window.caches = {
    keys: async () => ['20261013075049neul', 'account-data'],
    open: async name => name.endsWith('neul') ? cache : protectedCache,
  };
  window.performance.getEntriesByType = () => [{name: active}];
  window.performance.getEntriesByName = url => url === active ? [{name: active}] : [];
  window.eval(source);
  for (let cycle = 0; cycle < 4; cycle++) {
    for (let i = 0; i < 5; i++) entries.set(asset(cycle * 5 + i), 8 * mib);
    assert.equal(await window.__piliMallAdapter.trimStaticCache(32 * mib), 32 * mib);
    assert.equal([...entries.values()].reduce((a, b) => a + b), 59 * mib);
    assert.equal(entries.get(active), 8 * mib);
    assert.equal(entries.get(ticket), 27 * mib);
  }
  Object.defineProperty(window.navigator, 'onLine', {value: false});
  entries.set(asset('offline'), 8 * mib);
  await window.__piliMallAdapter.trimStaticCache(32 * mib);
  assert(entries.has(asset('offline')));
  dom.qaClose();
});

test('Chromium cache quota trims opaque public assets but preserves active and private entries', async () => {
  const dom = page();
  const {window} = dom;
  const mib = 1024 * 1024;
  const asset = n => 'https://s1.hdslb.com/bfs/static/neul/asset' + n + '.js';
  const active = asset(0);
  const protectedUrl = 'https://mall.bilibili.com/account/receipt';
  const entries = new Map([[protectedUrl, 16 * mib]]);
  for (let i = 0; i < 12; i++) entries.set(asset(i), 8 * mib);
  const cache = {
    keys: async () => [...entries.keys()].map(url => ({url, method: 'GET'})),
    match: async () => { throw Error('opaque response bodies should not need to be read'); },
    delete: async request => entries.delete(request.url),
  };
  window.caches = {
    keys: async () => ['20261013075049neul'],
    open: async () => cache,
  };
  window.navigator.storage = {
    estimate: async () => ({usageDetails: {caches: [...entries.values()].reduce((a, b) => a + b, 0)}}),
  };
  window.performance.getEntriesByType = () => [{name: active}];
  window.performance.getEntriesByName = url => url === active ? [{name: active}] : [];
  window.eval(source);
  assert(await window.__piliMallAdapter.trimStaticCache(64 * mib) <= 64 * mib);
  assert(entries.has(active));
  assert(entries.has(protectedUrl));
  dom.qaClose();
});
