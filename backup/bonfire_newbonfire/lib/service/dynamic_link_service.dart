import 'package:bonfire_newbonfire/screens/HomePage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {

  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bonfirenewbonfire.page.link',
      link: Uri.parse('https://bonfirenewbonfire.page.link.com'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.bonfire_newbonfire',
        minimumVersion: 1,
      ),
      /*iosParameters: IosParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),*/
    );
    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
      }

      FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
      });

    } catch (e) {
      print(e.toString());
    }
  }

}