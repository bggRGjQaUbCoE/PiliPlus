if (location.origin !== 'https://www.biligo.com') {
  throw new Error('Unexpected legacy mall cache origin');
}
const names = await caches.keys();
const estimate = async () => (await navigator.storage.estimate()).usageDetails?.caches ?? null;
const before = await estimate();
let removed = 0;
for (const name of names) {
  if (!/^\d{14}neul$/.test(name)) continue;
  const cache = await caches.open(name);
  for (const request of await cache.keys()) {
    const url = new URL(request.url);
    if (request.method !== 'GET' || url.origin !== 'https://s1.hdslb.com' ||
        url.search || !/^\/bfs\/static\/neul(?:-next)?\/.+\.(?:js|css|woff2?)$/i.test(url.pathname)) continue;
    if (await cache.delete(request)) removed++;
  }
}
return {before, after: await estimate(), removed};
