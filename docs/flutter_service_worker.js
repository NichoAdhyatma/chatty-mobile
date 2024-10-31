'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "2232ce20921cd1605e3aefb91438146f",
"assets/AssetManifest.bin.json": "ef7df08c1e8a7b1e74adb30756d3e645",
"assets/AssetManifest.json": "08266bd889a2ddfaa5bd584a797c4db4",
"assets/assets/agora-logo.png": "52efcac8ec3d13dee56eb561fa7f0dd1",
"assets/assets/alert.mp3": "5e3d7e90b8ad1be0b30f8702fa89ae0a",
"assets/assets/audio_mixing/Agora.io-Interactions.mp3": "67bfcdbeb775cc0e495548f848f6ecff",
"assets/assets/dang.mp3": "aba71812da8fedbbff43c44968f8c5f2",
"assets/assets/ding.mp3": "12548e8380c99cc700d7ec163912cba6",
"assets/assets/fonts/Avenir-Book.ttf": "d9f644b72aa74e6787228a84a4edf5ca",
"assets/assets/fonts/iconfont.ttf": "bb1a11d2dcc4e2d37b31f155e7ec7e03",
"assets/assets/fonts/Montserrat-Medium.ttf": "c8b6e083af3f94009801989c3739425e",
"assets/assets/fonts/Montserrat-SemiBold.ttf": "c641dbee1d75892e4d88bdc31560c91b",
"assets/assets/gif.gif": "7e982f6859d7d5c600d1506ce82cf52e",
"assets/assets/icons/add.png": "e171472f2e89f5131f67628e4476990e",
"assets/assets/icons/ang.png": "5b2a6dfa8aa2190c380631d526233d93",
"assets/assets/icons/ao_trumpet.png": "75721a296a76376edbcfe0b80030dd3d",
"assets/assets/icons/apple.png": "a88b5a652a163b7d1412e6fb54ce814c",
"assets/assets/icons/a_microphone.png": "2c7e52c5f31be239b224af1820b732d0",
"assets/assets/icons/a_phone.png": "6dc5ecda66701887315ed6a75527da6a",
"assets/assets/icons/a_photo.png": "33b537beee592b92a281dcf426702ee2",
"assets/assets/icons/a_telephone.png": "8875ffda9378e29520eca555a36a4a70",
"assets/assets/icons/a_trumpet.png": "5034dcdaa2774da1a482119c2fe39cf2",
"assets/assets/icons/a_video.png": "067a79bddc1ef197b0047b1ff9cd1330",
"assets/assets/icons/back.png": "ba9d848a7b37b3e503099ad2775d1c42",
"assets/assets/icons/bo_trumpet.png": "eed542427fdc198d75749bf082d5c21a",
"assets/assets/icons/by.png": "4073eab7df0bb33b151db4d23502965b",
"assets/assets/icons/b_microphone.png": "c72c29678152dec061b83779d32b94af",
"assets/assets/icons/b_phone.png": "85c70c4e486de43dd200b8547ab5991c",
"assets/assets/icons/b_photo.png": "d046b7134abdc9a74a6f3f043e529bd5",
"assets/assets/icons/b_telephone.png": "09b4058eb39f1fd927b1cfa00d000119",
"assets/assets/icons/b_trumpet.png": "758e897af5ffcbc59b98427a140b1923",
"assets/assets/icons/b_video.png": "c9141c1903de87fbca92453a9046e5a4",
"assets/assets/icons/call.png": "03c25538e5c3f3bb262aaae418063de5",
"assets/assets/icons/contact.png": "8bc71582ba58dcea640c0bb45d91e51c",
"assets/assets/icons/down.png": "dc826a39917a88033b98718a3ca6bdd9",
"assets/assets/icons/edit.png": "6d9f94ca37f87a98b653df4966dbdc81",
"assets/assets/icons/facebook.png": "576056169fa41ae0b4bf14e70197f5d6",
"assets/assets/icons/file.png": "3ebffd6ec518ff861282f228511a20cb",
"assets/assets/icons/google.png": "7e24a358673cb41ff0e8c5c4f620ec1a",
"assets/assets/icons/photo.png": "b9cca5bf143dbc5238330e05868a0b32",
"assets/assets/icons/search.png": "b9c5d6cea9c1132b294eca9e42c84026",
"assets/assets/icons/send.png": "ede02235024e2fff140bc9d32005395a",
"assets/assets/icons/video.png": "4e51d59450cdbf830919501ee90b0ad3",
"assets/assets/icons/voice.png": "d7f198958d2855df8b4de1c28214ca53",
"assets/assets/images/account_header.png": "4c03370bfc85216bbb2c93db2b061ed7",
"assets/assets/images/actionbar_search.png": "63acbee38126be6a4408b74e68c1a2e3",
"assets/assets/images/aliuser_title_back_normal.9.png": "88f47782628856eba68dafe39664b675",
"assets/assets/images/icons-facebook.png": "1227f6e2aeb0572db0b6be1fe6ae179a",
"assets/assets/images/icons-google.png": "a7c1786ae33c01ce63c12cc5c22eaf4f",
"assets/assets/images/icons-twitter.png": "4ea6081c9718a12d8d55a28b55787898",
"assets/assets/images/ic_launcher.png": "52e6fde1958cb93e2a32c1ce0389810f",
"assets/assets/images/ic_playing.png": "5f6cd678f9eb221b3bc891d3190bab4a",
"assets/assets/images/love.jpeg": "7b5ecb85853d9a0203a22bd559d958c4",
"assets/assets/images/video_icon_praise.png": "faa3494f379f3161ef598b521b7d4e4f",
"assets/assets/images/video_msg_icon.png": "ef2b59f70fa36afe219fb976f7c30023",
"assets/assets/images/video_share_icon.png": "5e88a205429f2c443e44c9b938905ab7",
"assets/assets/jpg.jpg": "d272032fabd67d0762158e1033e0bbef",
"assets/assets/Sound_Horizon.mp3": "63990fc06cfe6def8aa65e198234fbd5",
"assets/FontManifest.json": "8171aaa3dbc48e798ab055c54622632e",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "ddc3a5b11e5c14faad1612d20bbc117c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "cb465c88fa8aafe451caa37a0fe8eaa8",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "5c1d73d9d056e62803ffb4f9d7f1972d",
"/": "5c1d73d9d056e62803ffb4f9d7f1972d",
"main.dart.js": "e9bcf080446c47469836c2c82c566a4c",
"manifest.json": "21524a6e211047214b9bb71fdef496e2",
"version.json": "8a2bde298f9a48aaf2036d42a333952c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
