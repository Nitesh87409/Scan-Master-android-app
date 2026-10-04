import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scan_master_app/core/app_config.dart';

class AdService {
  static InterstitialAd? _protectInterstitialAd;
  static bool _isProtectInterstitialAdLoaded = false;
  static InterstitialAd? _splitInterstitialAd;
  static bool _isSplitInterstitialAdLoaded = false;
  static InterstitialAd? _mergeInterstitialAd;
  static bool _isMergeInterstitialAdLoaded = false;
  static InterstitialAd? _compressInterstitialAd;
  static bool _isCompressInterstitialAdLoaded = false;
  static InterstitialAd? _watermarkInterstitialAd;
  static bool _isWatermarkInterstitialAdLoaded = false;
  static final Completer<void> _initCompleter = Completer<void>();

  static Future<void> get waitForInit => _initCompleter.future;
  static bool get adsEnabled => AppConfig.adsEnabled;

  static Future<void> initialize() async {
    if (!adsEnabled) {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
      return;
    }
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('MobileAds initialize error: $e');
    } finally {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
    _loadProtectInterstitialAd();
    _loadSplitInterstitialAd();
    _loadMergeInterstitialAd();
    _loadCompressInterstitialAd();
    _loadWatermarkInterstitialAd();
  }

  // Old interstitial ad logic removed

  static void _loadProtectInterstitialAd() {
    if (!adsEnabled || !AppConfig.adsProtectInterstitialEnabled) return;
    InterstitialAd.load(
      adUnitId: Platform.isAndroid 
          ? AppConfig.admobProtectInterstitialAndroid
          : AppConfig.admobProtectInterstitialIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _protectInterstitialAd = ad;
          _isProtectInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load protect interstitial ad: ${err.message}');
          _isProtectInterstitialAdLoaded = false;
        },
      ),
    );
  }

  // showInterstitialAd removed

  static void showProtectInterstitialAd({VoidCallback? onAdClosed}) {
    if (!adsEnabled || !AppConfig.adsProtectInterstitialEnabled || !_isProtectInterstitialAdLoaded || _protectInterstitialAd == null) {
      onAdClosed?.call();
      return;
    }
    _protectInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isProtectInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadProtectInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isProtectInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadProtectInterstitialAd();
      },
    );
    _protectInterstitialAd!.show();
  }

  static void _loadSplitInterstitialAd() {
    if (!adsEnabled || !AppConfig.adsSplitInterstitialEnabled) return;
    InterstitialAd.load(
      adUnitId: Platform.isAndroid 
          ? AppConfig.admobSplitInterstitialAndroid
          : AppConfig.admobSplitInterstitialIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _splitInterstitialAd = ad;
          _isSplitInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load split interstitial ad: ${err.message}');
          _isSplitInterstitialAdLoaded = false;
        },
      ),
    );
  }

  static void showSplitInterstitialAd({VoidCallback? onAdClosed}) {
    if (!adsEnabled || !AppConfig.adsSplitInterstitialEnabled || !_isSplitInterstitialAdLoaded || _splitInterstitialAd == null) {
      onAdClosed?.call();
      return;
    }
    _splitInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isSplitInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadSplitInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isSplitInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadSplitInterstitialAd();
      },
    );
    _splitInterstitialAd!.show();
  }

  static void _loadMergeInterstitialAd() {
    if (!adsEnabled || !AppConfig.adsMergeInterstitialEnabled) return;
    InterstitialAd.load(
      adUnitId: Platform.isAndroid 
          ? AppConfig.admobMergeInterstitialAndroid
          : AppConfig.admobMergeInterstitialIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _mergeInterstitialAd = ad;
          _isMergeInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load merge interstitial ad: ${err.message}');
          _isMergeInterstitialAdLoaded = false;
        },
      ),
    );
  }

  static void showMergeInterstitialAd({VoidCallback? onAdClosed}) {
    if (!adsEnabled || !AppConfig.adsMergeInterstitialEnabled || !_isMergeInterstitialAdLoaded || _mergeInterstitialAd == null) {
      onAdClosed?.call();
      return;
    }
    _mergeInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isMergeInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadMergeInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isMergeInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadMergeInterstitialAd();
      },
    );
    _mergeInterstitialAd!.show();
  }

  static void _loadCompressInterstitialAd() {
    if (!adsEnabled || !AppConfig.adsCompressInterstitialEnabled) return;
    InterstitialAd.load(
      adUnitId: Platform.isAndroid 
          ? AppConfig.admobCompressInterstitialAndroid
          : AppConfig.admobCompressInterstitialIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _compressInterstitialAd = ad;
          _isCompressInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load compress interstitial ad: ${err.message}');
          _isCompressInterstitialAdLoaded = false;
        },
      ),
    );
  }

  static void showCompressInterstitialAd({VoidCallback? onAdClosed}) {
    if (!adsEnabled || !AppConfig.adsCompressInterstitialEnabled || !_isCompressInterstitialAdLoaded || _compressInterstitialAd == null) {
      onAdClosed?.call();
      return;
    }
    _compressInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isCompressInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadCompressInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isCompressInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadCompressInterstitialAd();
      },
    );
    _compressInterstitialAd!.show();
  }

  static void _loadWatermarkInterstitialAd() {
    if (!adsEnabled || !AppConfig.adsWatermarkInterstitialEnabled) return;
    InterstitialAd.load(
      adUnitId: Platform.isAndroid 
          ? AppConfig.admobWatermarkInterstitialAndroid
          : AppConfig.admobWatermarkInterstitialIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _watermarkInterstitialAd = ad;
          _isWatermarkInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load watermark interstitial ad: ${err.message}');
          _isWatermarkInterstitialAdLoaded = false;
        },
      ),
    );
  }

  static void showWatermarkInterstitialAd({VoidCallback? onAdClosed}) {
    if (!adsEnabled || !AppConfig.adsWatermarkInterstitialEnabled || !_isWatermarkInterstitialAdLoaded || _watermarkInterstitialAd == null) {
      onAdClosed?.call();
      return;
    }
    _watermarkInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isWatermarkInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadWatermarkInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isWatermarkInterstitialAdLoaded = false;
        onAdClosed?.call();
        _loadWatermarkInterstitialAd();
      },
    );
    _watermarkInterstitialAd!.show();
  }
}
