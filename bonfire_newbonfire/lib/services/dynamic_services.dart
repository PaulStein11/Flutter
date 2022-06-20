import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  Future<Uri> createLongDynamicLink(
      String mediaTitle, String mediaDescription) async {
    // Create dynamic link to share bonfire
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.bfpagoda.page.link.com/"),
      uriPrefix: "https://bfpagoda.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.example.bf_pagoda"),
      iosParameters: const IOSParameters(bundleId: "com.example.bfPagoda"),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: mediaTitle,
          description: mediaDescription,
          imageUrl: Uri.parse(
              "")
          //"join and participate in the bonfire"
          ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    return dynamicLink;
  }
}
