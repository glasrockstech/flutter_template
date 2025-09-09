import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;
  AnchoredAdaptiveBannerAdSize? _adaptiveSize;

  String get _bannerUnitId {
    // Fallback to Google's test unit IDs when not provided.
    const androidTest = 'ca-app-pub-3940256099942544/6300978111';
    const iosTest = 'ca-app-pub-3940256099942544/2934735716';
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_BANNER_ANDROID'] ?? androidTest;
    }
    return dotenv.env['ADMOB_BANNER_IOS'] ?? iosTest;
  }

  @override
  void initState() {
    super.initState();
    // Compute adaptive size after first layout to have correct width.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mq = MediaQuery.maybeOf(context);
      if (mq == null) return;
      final width = mq.size.width.truncate();
      try {
        final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
        if (!mounted) return;
        setState(() => _adaptiveSize = size);
        final ad = BannerAd(
          size: size!,
          adUnitId: _bannerUnitId,
          listener: BannerAdListener(
            onAdLoaded: (_) => setState(() => _loaded = true),
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
          request: const AdRequest(),
        );
        _ad = ad..load();
      } catch (_) {
        // Fallback: do not render ad if size fails.
      }
    });
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null || _adaptiveSize == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: _adaptiveSize!.height.toDouble(),
      width: _adaptiveSize!.width.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
