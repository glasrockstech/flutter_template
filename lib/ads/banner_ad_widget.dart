import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _banner;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return; // AdMob is not supported on web.

    final unitId = Platform.isAndroid
        ? dotenv.env['ADMOB_BANNER_ANDROID']
        : Platform.isIOS
            ? dotenv.env['ADMOB_BANNER_IOS']
            : null;

    if (unitId == null || unitId.isEmpty) return;

    final ad = BannerAd(
      adUnitId: unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    ad.load();
    _banner = ad;
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!
        _loaded || _banner == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: _banner!.size.height.toDouble(),
      width: _banner!.size.width.toDouble(),
      child: AdWidget(ad: _banner!),
    );
  }
}

