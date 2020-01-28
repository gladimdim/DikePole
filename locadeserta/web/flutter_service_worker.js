'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "d5db31e9f7dec8f223c009e5c7e83e64",
"/main.dart.js.deps": "ca9f61df9d7ed53f84d2482003effc8a",
"/main.dart.js": "4ccc9cd15510c80acb3c5c6e960fccc2",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/manifest.json": "b7f986df9dfee97b76dc3ec6a0ba4902",
"/assets/LICENSE": "ff3d356edfd4d8daa943e0f836cf5c63",
"/assets/images/background/forest/c_4.jpg": "45552da4efe37113aba53140d71a6312",
"/assets/images/background/forest/c_5.jpg": "0670b75bd0379bfe4de00b05c78a344f",
"/assets/images/background/forest/c_7.jpg": "d7dd30b33d9579560242ecb86de4a4d7",
"/assets/images/background/forest/c_6.jpg": "45d940a70fe06a59871cd627cd8ba4d9",
"/assets/images/background/forest/c_2.jpg": "c10bda1043ce016c45b5764fc2ca8a95",
"/assets/images/background/forest/c_3.jpg": "4db84b586b58c96c97374525b626c283",
"/assets/images/background/forest/8.jpg": "1ca0a0ef34809c46c461e4f0fc360622",
"/assets/images/background/forest/c_1.jpg": "0e36a127d0ab826bdadeac2fb1a1f57b",
"/assets/images/background/forest/c_0.jpg": "1905a2eaac1d2f42f6621bd07c9046c3",
"/assets/images/background/forest/9.jpg": "f8108092828c74824cef7d2c08a911f1",
"/assets/images/background/forest/4.jpg": "7e5c0e0a80756e87afecc053244aa5b6",
"/assets/images/background/forest/5.jpg": "1e5c26e41bcc91b21d9cc584bd075961",
"/assets/images/background/forest/7.jpg": "a125419308959e48f2cdc41e883a033b",
"/assets/images/background/forest/6.jpg": "ee2ca2f2b342602f255678afe7640899",
"/assets/images/background/forest/2.jpg": "153a08153131dae87cf1b6eacf72305e",
"/assets/images/background/forest/3.jpg": "bc40a678660d077704e5051e8447d3ea",
"/assets/images/background/forest/1.jpg": "374744be98afdd61044ff4e384f5768d",
"/assets/images/background/forest/c_8.jpg": "3f7d2a10494fc53df83e525c441300c6",
"/assets/images/background/forest/c_9.jpg": "f16beedd173c5d43c37819d9e61f9c01",
"/assets/images/background/forest/0.jpg": "f135fa6186977668460e2938a1099f44",
"/assets/images/background/bulrush/c_4.jpg": "33b3e804cb5414304c5c29dc3147ada5",
"/assets/images/background/bulrush/c_5.jpg": "4c47bdf0d8bb1edc9eef7004aa9ab5bb",
"/assets/images/background/bulrush/c_7.jpg": "bff2fe926233dd61e50bfd42314f8a55",
"/assets/images/background/bulrush/c_6.jpg": "d07b9fe755c4dfb69fbbf691ea796e68",
"/assets/images/background/bulrush/c_2.jpg": "615b21c51d6cdc9acbbe6fd68fc5248f",
"/assets/images/background/bulrush/c_3.jpg": "aa8a357afe49b6f827ec2dc7ff20dbae",
"/assets/images/background/bulrush/8.jpg": "070b71c6e89b66fabb45d10e3183e29f",
"/assets/images/background/bulrush/c_1.jpg": "602bf12f2476ac3e0d287bd4dd930373",
"/assets/images/background/bulrush/c_0.jpg": "485b331ed303161b76188ff987959949",
"/assets/images/background/bulrush/9.jpg": "b2574ea16ca2dfee6801b218f25a155e",
"/assets/images/background/bulrush/c_11.jpg": "d84f27ede25630c4196cbcbb254bb266",
"/assets/images/background/bulrush/c_10.jpg": "a9b9edc00798e8cb643dffc762365c1b",
"/assets/images/background/bulrush/11.jpg": "c2affdd3bbabb7048c3e17982a13659a",
"/assets/images/background/bulrush/10.jpg": "0d083150deb961dedefc2f0a8f20193c",
"/assets/images/background/bulrush/4.jpg": "2d74198fe8cc8c34b4e97f749cc6d5f4",
"/assets/images/background/bulrush/5.jpg": "98af9ddae386f4e5051cbaadf7114073",
"/assets/images/background/bulrush/7.jpg": "6bf354f59f704562d269d9d16d05cfe4",
"/assets/images/background/bulrush/6.jpg": "8ec5df034e238ed68953e7c11757d5d1",
"/assets/images/background/bulrush/2.jpg": "30cd366d7e706fca22585f6b3a3c20d1",
"/assets/images/background/bulrush/3.jpg": "592f5b9680b14ecc04a001e3074b9d4b",
"/assets/images/background/bulrush/1.jpg": "f484f3f058cd278707b2cd554aa0588e",
"/assets/images/background/bulrush/c_8.jpg": "59f71ec14ee802a756b2119364c26dfd",
"/assets/images/background/bulrush/c_9.jpg": "b85655b1bd2d945b400bcd1ccecc51a6",
"/assets/images/background/bulrush/0.jpg": "411f1f7379a3d25c0345dfa11afc287a",
"/assets/images/background/landing/c_4.jpg": "4bc5006b9c25de8e1307db2045be598e",
"/assets/images/background/landing/c_5.jpg": "3a30dff864f014e5b77722421e59c3b1",
"/assets/images/background/landing/c_7.jpg": "582c6ca7853ec0f40849e8213b912c50",
"/assets/images/background/landing/c_6.jpg": "48167f5d9435666ca4939ceb8bf51f23",
"/assets/images/background/landing/c_2.jpg": "dfa26ecde4540f9971abcb98e03a93b2",
"/assets/images/background/landing/c_3.jpg": "7ff3ad9169c6eed7e34a60f428771003",
"/assets/images/background/landing/c_1.jpg": "5a2f0d1ad907f4f7a17dd9fcae60f9dc",
"/assets/images/background/landing/c_0.jpg": "400b8355b88254517ec37733da1dc554",
"/assets/images/background/landing/4.jpg": "8679a83a4cbebf227a53107c8e72a860",
"/assets/images/background/landing/5.jpg": "35c578cf439b94ea06de1d29ad655ac5",
"/assets/images/background/landing/7.jpg": "6b7c695b64523d871add2a6f736fc612",
"/assets/images/background/landing/6.jpg": "eef04c081f38bc01bb375ad5b278b7a7",
"/assets/images/background/landing/2.jpg": "593ed8da74a1535f3a30975b40354428",
"/assets/images/background/landing/3.jpg": "aaa2b867d3898dd532dae7be9414fef9",
"/assets/images/background/landing/1.jpg": "fda49185c25a829a9b9d4032a3f77c35",
"/assets/images/background/landing/0.jpg": "a81890a12ace1f58005336f50279ce8b",
"/assets/images/background/river/c_4.jpg": "24d8a33330462c04baa6a6d554e44b6e",
"/assets/images/background/river/c_5.jpg": "f42da3641ff27fff2456bc3f73ab286e",
"/assets/images/background/river/c_7.jpg": "2049bd69f30732c7997212873c5ff848",
"/assets/images/background/river/c_6.jpg": "02916db4b2ac0056f74fbcd736f4714c",
"/assets/images/background/river/c_2.jpg": "bf72e93ad77cc4833fab5bbe6947eeb2",
"/assets/images/background/river/c_3.jpg": "6a5c5a8f9359c88832017e8fbcf6a092",
"/assets/images/background/river/8.jpg": "c7a8618f4f9f12d67c1d6be7a229c93d",
"/assets/images/background/river/c_1.jpg": "ea38492998c74118efda24ab097ddbe8",
"/assets/images/background/river/c_0.jpg": "1830b3755acaa416e7b9b76148e9000a",
"/assets/images/background/river/9.jpg": "66f4f451d47975e57faafc8e175f7b6e",
"/assets/images/background/river/14.jpg": "f6b5e603299e1d696b382a51e188da46",
"/assets/images/background/river/c_11.jpg": "66890553716734577e06f1711387d63b",
"/assets/images/background/river/c_10.jpg": "b580eaa080565ee13783aa49588c1ed6",
"/assets/images/background/river/15.jpg": "3d8873fdef03f87d5cc60017ae50076f",
"/assets/images/background/river/17.jpg": "506ea7c67b6b6a964a840242d3d2909e",
"/assets/images/background/river/c_12.jpg": "28569fbc31e637895cef5e004e441eda",
"/assets/images/background/river/c_13.jpg": "0e61671db0d5402a97012a3727640b32",
"/assets/images/background/river/16.jpg": "7f7dd6a00197798862bd4cbf0265d38c",
"/assets/images/background/river/12.jpg": "04b3054f0f35f0350ca381cba931db79",
"/assets/images/background/river/c_17.jpg": "694965f5dff370973a4d425e58cd7473",
"/assets/images/background/river/c_16.jpg": "a0caa585f3e5e9ff57a0632d5d68e925",
"/assets/images/background/river/13.jpg": "3cdc1757554903c8c3b7609d10fa112b",
"/assets/images/background/river/11.jpg": "8a4bcc5b589f7d50feab3d57682f70ad",
"/assets/images/background/river/c_14.jpg": "8a4cf654788221443ab647f0311f46b2",
"/assets/images/background/river/c_15.jpg": "8add9e35eae12fb590e52ba65c95db4f",
"/assets/images/background/river/10.jpg": "28eb0031fc4e5be5859aa4b1f1540e08",
"/assets/images/background/river/21.jpg": "f7eb753319190c990b258a04f20ef9e3",
"/assets/images/background/river/c_18.jpg": "087efd2ed6d01cb463f3af856af66a5a",
"/assets/images/background/river/c_19.jpg": "b8f67a291a1a7617e05d63f79b3d33d6",
"/assets/images/background/river/20.jpg": "f1757632b402df90e684c8bedba3342c",
"/assets/images/background/river/18.jpg": "083f8290148170a195b288a48a9b976a",
"/assets/images/background/river/c_21.jpg": "13ca0f466ba42d47624a4f9ace08311d",
"/assets/images/background/river/c_20.jpg": "34362373d73a8643dd5d7a0074fa599f",
"/assets/images/background/river/19.jpg": "bfb42a239667984051b320fb4b273981",
"/assets/images/background/river/4.jpg": "6d51abe5aee7458a9680b508e80d4f58",
"/assets/images/background/river/5.jpg": "3f028871610f29676074e3907edd2845",
"/assets/images/background/river/7.jpg": "a3bcfc1d4d8197b38f614fbe81a524bd",
"/assets/images/background/river/6.jpg": "ed75c0053cfca0b9907087a7a3a2cd59",
"/assets/images/background/river/2.jpg": "fc3b0962b4189f9d07abaefe597d3301",
"/assets/images/background/river/3.jpg": "d4ca2765b02361c9b6ec5dc057b83d5a",
"/assets/images/background/river/1.jpg": "e49b1d2d0b61c1e2e690b531ca502b51",
"/assets/images/background/river/c_8.jpg": "1b06791cae414bbe49b8185c8f88abed",
"/assets/images/background/river/c_9.jpg": "e05ab7c17f67c842a210cdf00d3553fa",
"/assets/images/background/river/0.jpg": "a3345d42fab01efa74a8b8a14f361219",
"/assets/images/background/boat/c_4.jpg": "2126510dde115dbf450b4263e3b2577c",
"/assets/images/background/boat/c_5.jpg": "a229d34cc6c235f1ee861e0b9d14eeea",
"/assets/images/background/boat/c_7.jpg": "71026f2ac36f9b80046b379ef9230507",
"/assets/images/background/boat/c_6.jpg": "0fe143447fd964197e342d38d6519438",
"/assets/images/background/boat/c_2.jpg": "232701aa642074bd90b55a94545b6056",
"/assets/images/background/boat/c_3.jpg": "9a9f2fac597609fe80232f9488639a08",
"/assets/images/background/boat/8.jpg": "3cfcf627e1aac9d5e3f8c891fbd4093c",
"/assets/images/background/boat/c_1.jpg": "74744c03071858ef7c28d38670cf7e3b",
"/assets/images/background/boat/c_0.jpg": "85faca8b6a94d01e86a8e8ce033c81ff",
"/assets/images/background/boat/9.jpg": "61edb813659fa77af8478e0c29d9b38f",
"/assets/images/background/boat/14.jpg": "9243b9d0461888783bdda6cab1cba577",
"/assets/images/background/boat/c_11.jpg": "9a157cfbc24a4ef9a1c4c164c14992e2",
"/assets/images/background/boat/c_10.jpg": "6adc959271e2937ddc1781e75a972333",
"/assets/images/background/boat/15.jpg": "d3eef9c807dffdd4655460806cd451b2",
"/assets/images/background/boat/17.jpg": "0adf6863563cbae7c3bd73bc901b0657",
"/assets/images/background/boat/c_12.jpg": "80c34cc8d329e44b814e03a6ceb4eff7",
"/assets/images/background/boat/c_13.jpg": "3a913baaf29047d69b32baddcb0d44ba",
"/assets/images/background/boat/16.jpg": "feceb28ef032a37335b236f4f0292d8b",
"/assets/images/background/boat/12.jpg": "53e30695086c7599c00862cdfcf6ee68",
"/assets/images/background/boat/c_17.jpg": "fae868461ae8020f84420796e7bbe0f1",
"/assets/images/background/boat/c_16.jpg": "d74371dbaaa866550e3ea830eb19f7ea",
"/assets/images/background/boat/13.jpg": "903e2d36cdf78c5b66529545f83b16b9",
"/assets/images/background/boat/11.jpg": "052e313d76d6db7dfdb3407fbc4706c8",
"/assets/images/background/boat/c_14.jpg": "2715bc1b44d62d702c25c4a6767076f3",
"/assets/images/background/boat/c_15.jpg": "8cdf13e11896643040c98ac196631662",
"/assets/images/background/boat/10.jpg": "a053a177add6ef1a767d07c81621b433",
"/assets/images/background/boat/c_18.jpg": "5e5f836009b29169ee3c763f8ed5352a",
"/assets/images/background/boat/18.jpg": "2abcb2a51ab1cf6756be4dceab7b33b9",
"/assets/images/background/boat/4.jpg": "7f4b38bf051e2ceb2df2c8e6dd630b93",
"/assets/images/background/boat/5.jpg": "dcd1bb15b7b9946b122c0626c3af627e",
"/assets/images/background/boat/7.jpg": "bf02382e35a6979470887a9dd6acd08c",
"/assets/images/background/boat/6.jpg": "e76943b9152a0d13360470fb24eccf35",
"/assets/images/background/boat/2.jpg": "bae07c018fe6920df4a49506023311d1",
"/assets/images/background/boat/3.jpg": "a6af760dbfea99e9cf344b8836d4f8ff",
"/assets/images/background/boat/1.jpg": "9ab57d00a3307ef85124ab9de27bd972",
"/assets/images/background/boat/c_8.jpg": "a8805172c4d35a83fc87689132593963",
"/assets/images/background/boat/c_9.jpg": "e6e30490b74919bc4039e90bf38674f2",
"/assets/images/background/boat/0.jpg": "b91caf977636d28c1510c4680731328b",
"/assets/images/background/camp/c_4.jpg": "d0c4daf544de48add2d8055c554f5e04",
"/assets/images/background/camp/c_5.jpg": "74ef5ed18d7aeb1b87a08b1a0119c556",
"/assets/images/background/camp/c_7.jpg": "450ee7b6d881d1dee20ebc3c5b8a8322",
"/assets/images/background/camp/c_6.jpg": "46827ccb7378193ed05fa85ef62bc5f7",
"/assets/images/background/camp/c_2.jpg": "896f144baa813bb83f4f03276de40549",
"/assets/images/background/camp/c_3.jpg": "9bda2a99a4565a0232d05bc0ea318a73",
"/assets/images/background/camp/8.jpg": "beb71e22a35dbf5c2e236af7fa11e820",
"/assets/images/background/camp/c_1.jpg": "710bf81cb65384c19b9c46cf52199b1a",
"/assets/images/background/camp/c_0.jpg": "1d2b2d756f85909f342cabbb1903729a",
"/assets/images/background/camp/9.jpg": "6293bbbb7671bcfb86ecaecbf3096277",
"/assets/images/background/camp/14.jpg": "efe2824c12d36b83704891548adf8041",
"/assets/images/background/camp/c_11.jpg": "80e2505500c46d9dd8ff5fe9dc780b71",
"/assets/images/background/camp/c_10.jpg": "28432fb54d787746e530192f0a096b55",
"/assets/images/background/camp/c_12.jpg": "47fd559a9db1ab95a4b578d3bbdde7f1",
"/assets/images/background/camp/c_13.jpg": "f70b8b2ccc1cc605eaefdf89f8b4e166",
"/assets/images/background/camp/12.jpg": "0d45226c6b9382b72be35978ab38e17a",
"/assets/images/background/camp/13.jpg": "999a9381c803577c7ae990b018b8a9e3",
"/assets/images/background/camp/11.jpg": "f32d387946857fc8c68af777e348cc63",
"/assets/images/background/camp/c_14.jpg": "a7531aaddcaf4bebe0aea600df8b7f4f",
"/assets/images/background/camp/10.jpg": "a6cc374f2d10999e8b13183e728aaed6",
"/assets/images/background/camp/4.jpg": "78741b06f4b909e929a221b205699853",
"/assets/images/background/camp/5.jpg": "8ca4d30dbc7e3221c3d0257e7546ef9b",
"/assets/images/background/camp/7.jpg": "3ac78a201122172771a81b28c1ee19d4",
"/assets/images/background/camp/6.jpg": "ccea705523535f3635443d6120aa8d9c",
"/assets/images/background/camp/2.jpg": "b0ecfa08bfc850264fc7373f700c5d91",
"/assets/images/background/camp/3.jpg": "cef27cfbae01ba14f15ad7645d00d88c",
"/assets/images/background/camp/1.jpg": "c30308256da3dfc62f28d119099f7168",
"/assets/images/background/camp/c_8.jpg": "9d5616cf77006b95c79b8884b47f475f",
"/assets/images/background/camp/c_9.jpg": "b45b2e844b694cc40701f48dd43bb9f5",
"/assets/images/background/camp/0.jpg": "d295c901f34a1b4747d2e6cb6dcfe045",
"/assets/images/background/c_cossack_0.jpg": "0b0868a9d66c93442aed3243dc05e6fe",
"/assets/images/background/cossack_0.jpg": "1a11633dad6bd62846bc34e51af99f67",
"/assets/images/city_building/resource_buildings/river.png": "107aa1744188343bb902e3133bf24f35",
"/assets/images/city_building/resource_buildings/forest.png": "f7e20f696dfc47f08b21190d7afa496f",
"/assets/images/city_building/resource_buildings/kurin.png": "03a17c22c2bef448fedc61284bdec6b9",
"/assets/images/city_building/resource_buildings/field.png": "c1ac4e1509ead8de375dc972504c60b8",
"/assets/images/city_building/resource_buildings/quarry.png": "c1906858c4ec465d5111afcadc5454a5",
"/assets/images/city_building/resource_buildings/trappershouse.png": "f26b6b20b17737a6d14f69c08d5373fe",
"/assets/images/city_building/resource_buildings/mill.gif": "15c0c9adf1a6dbff23979b4f703b2df2",
"/assets/images/city_building/resource_buildings/iron_mine.png": "fb22daa9c3bd4a86da744d1c8231e63f",
"/assets/images/city_building/city_buildings/kurin.png": "03a17c22c2bef448fedc61284bdec6b9",
"/assets/images/city_building/city_buildings/watch_tower.png": "bc59ccbe40805ff15d23618ed0f5d8b7",
"/assets/images/city_building/city_buildings/wall.png": "3e1f0d00e3b850c056f5a8fc78ad7201",
"/assets/images/city_building/resources/horse.png": "08805ee0d43b0c91b4ee7f0e08ce619f",
"/assets/images/city_building/resources/chastokol.png": "3e1f0d00e3b850c056f5a8fc78ad7201",
"/assets/images/city_building/resources/niter.png": "07bc3416b8d17f13411798a837a359c9",
"/assets/images/city_building/resources/fur2.png": "f72a39afc139d3d439889e7d7b018deb",
"/assets/images/city_building/resources/kurin.png": "03a17c22c2bef448fedc61284bdec6b9",
"/assets/images/city_building/resources/firearm.png": "2207793345efc510a53d5bec54952957",
"/assets/images/city_building/resources/wood.png": "bf320f06448ffa6cdc4de53f071010fa",
"/assets/images/city_building/resources/iron_ore.png": "f34296f6bf6f13d936d4c430949fb951",
"/assets/images/city_building/resources/stone.png": "6fa9cf8a4a2001272cb5ec12bf5a1f18",
"/assets/images/city_building/resources/food.png": "83e9ab3f5db52f33efeaa7382372ba5a",
"/assets/images/city_building/resources/money.png": "91f1c4d7e97b125fa0e573f06ca1a6e1",
"/assets/images/city_building/resources/fur.png": "da7bc6395247fd19cfe79df248af76f7",
"/assets/images/city_building/resources/fish.png": "58d93497fc5f97d894988c28f6b62253",
"/assets/AssetManifest.json": "6b1aa9b1fecdfeb07f29cea8730fc248",
"/assets/FontManifest.json": "22e886cc98169b38b22808336711cc7f",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/fonts/Roboto/Roboto-Regular.ttf": "18d44f79b3979ec168862093208c6d7d",
"/assets/fonts/Roboto/Roboto-Bold.ttf": "7c18188784f21915f42a5b3bc9d91e20",
"/assets/fonts/Raleway/Raleway-Regular.ttf": "84abe14c9756256a4b91300ba3e4ec62",
"/assets/fonts/Raleway/Raleway-Black.ttf": "3469d4a9bf3b8f9db8f3e5c69e3fce8e",
"/assets/fonts/Raleway/Raleway-Bold.ttf": "2f99a85426a45e0c7f8707aae53af803"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
