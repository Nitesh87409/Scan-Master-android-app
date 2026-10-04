import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;
import '../core/app_config.dart';

class BannerAdCardWidget extends StatefulWidget {
  final String? customAdUnitId;

  const BannerAdCardWidget({super.key, this.customAdUnitId});

  @override
  State<BannerAdCardWidget> createState() => _BannerAdCardWidgetState();
}

class _BannerAdCardWidgetState extends State<BannerAdCardWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (!AppConfig.adsEnabled || !AppConfig.adsFoldersNativeEnabled) return;

    final adUnitId = widget.customAdUnitId ??
        (Platform.isAndroid
            ? AppConfig.admobFoldersNativeAndroid
            : AppConfig.admobFoldersNativeIos);

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.grey, size: 20),
            tooltip: 'Open Ad Inspector',
            onPressed: () {
              MobileAds.instance.openAdInspector((error) {
                if (error != null) {
                  debugPrint('Ad Inspector error: \${error.message}');
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
