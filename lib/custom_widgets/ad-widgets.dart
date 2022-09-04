import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spyfall/managers/g_ads_manager.dart';

class SFBannerAd extends StatefulWidget {
  // const SFBannerAd({Key? key}) : super(key: key);
  final String adId;
  SFBannerAd(this.adId);

  @override
  State<SFBannerAd> createState() => _SFBannerAdState();
}

class _SFBannerAdState extends State<SFBannerAd> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BannerAd(
      adUnitId: widget.adId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ));
    } else {
      return SizedBox();
    }
  }
}
