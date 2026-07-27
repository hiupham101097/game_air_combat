import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Wraps rewarded ads so game code only receives a verified reward result.
/// Android uses the production rewarded unit. Keep iOS on Google's test unit
/// until a separate iOS production unit is configured in AdMob.
class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  RewardedAd? _rewardedAd;
  bool _loading = false;
  String? lastError;

  bool get _isSupported => Platform.isAndroid || Platform.isIOS;

  String get _adUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    return Platform.isAndroid
        ? 'ca-app-pub-8298908398449019/9342756674'
        : 'ca-app-pub-3940256099942544/1712485313';
  }

  Future<void> initialize() async {
    if (!_isSupported) {
      lastError = 'Quang cao chi ho tro Android va iOS.';
      return;
    }
    await MobileAds.instance.initialize();
    await _load();
  }

  Future<void> _load() async {
    if (!_isSupported || _loading || _rewardedAd != null) return;
    _loading = true;
    final completer = Completer<void>();
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          lastError = null;
          _loading = false;
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          lastError = 'Khong tai duoc quang cao: ${error.code}';
          _loading = false;
          completer.complete();
        },
      ),
    );
    await completer.future;
  }

  /// Returns true only after the ad network confirms that the reward was earned.
  Future<bool> showRewardedAd() async {
    if (!_isSupported) {
      lastError = 'Quang cao chi ho tro Android va iOS.';
      return false;
    }
    if (_rewardedAd == null) await _load();
    final ad = _rewardedAd;
    if (ad == null) {
      lastError ??= 'Quang cao dang tai, vui long thu lai.';
      return false;
    }

    _rewardedAd = null;
    final completer = Completer<bool>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _load();
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        lastError = 'Khong the mo quang cao. Vui long thu lai.';
        ad.dispose();
        _load();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    ad.show(onUserEarnedReward: (_, __) => earned = true);
    return completer.future;
  }
}
