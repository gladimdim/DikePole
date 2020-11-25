import 'dart:math';

String generateMetaTags() {
  var imageRandom = Random().nextInt(7);
  return """
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-7FCN6S3PRK"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    
      gtag('config', 'G-7FCN6S3PRK');
    </script>
    <meta name="title" content="Інтерактивна історія. Дике Поле. Loca Deserta.">
    <meta name="description" content="Loca Deserta: Дике Поле. Інтерактивні історії про Великий Луг. Створи свою власну історію">
    
    <!-- FACEBOOK -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://locadeserta.com">
    <meta property="og:title" content="Інтерактивна історія. Дике Поле. Loca Deserta.">
    <meta property="og:description" content="Loca Deserta: Дике Поле. Інтерактивні історії про Великий Луг. Створи свою власну історію.">
    <meta property="og:image" content="https://locadeserta.com/game/assets/images/background/landing/$imageRandom.jpg">

    
    <!-- TWITTER -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://locadeserta.com">
    <meta property="twitter:title" content="Інтерактивна історія. Дике Поле. Loca Deserta.">
    <meta property="twitter:description" content="Loca Deserta: Дике Поле. Інтерактивні історії про Великий Луг. Створи свою власну історію">
    <meta property="twitter:image" content="https://locadeserta.com/game/assets/images/background/landing/$imageRandom.jpg">
  """;
}
