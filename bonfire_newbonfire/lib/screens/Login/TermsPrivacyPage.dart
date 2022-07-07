import 'package:flutter/material.dart';

class TermsOfPrivacyPage extends StatefulWidget {
  @override
  _TermsOfPrivacyPageState createState() => _TermsOfPrivacyPageState();
}

class _TermsOfPrivacyPageState extends State<TermsOfPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.cancel,
            color: Colors.grey,
            size: 26.0,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Text(
                              "Privacy and Policy of Bonfire",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          "Introduction",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "Bonfire, we respect the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our mobile application, including any other media form, media channel, mobile website, or mobile application related or connected thereto (collectively, the 'Site'). Please read this privacy policy carefully. If you do not agree with the terms of this privacy policy, please do not access the site.",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            "We reserve the right to make changes to this Privacy Policy at any time and for any reason.  We will alert you about any changes by updating the “Last Updated” date of this Privacy Policy.  Any changes or modifications will be effective immediately upon posting the updated Privacy Policy on the Site, and you waive the right to receive specific notice of each such change or modification."),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                            "You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Site after the date such revised Privacy Policy is posted.  "),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Collection of your Information",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            "We may collect information about you in a variety of ways. The information we may collect on the Site includes:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Personal Data",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "Personally identifiable information, such as your name, email address, and telephone number, and interests, that you voluntarily give to us [when you register with our mobile application, or when you choose to participate in various activities related to  our mobile application, such as online chat and message boards. You are under no obligation to provide us with personal information of any kind, however your refusal to do so may prevent you from using certain features of our mobile application"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Derivative Data",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "Information our servers automatically collect when you access the Site, such as your IP address, your browser type, your operating system, your access times, and the pages you have viewed directly before and after accessing the Site. If you are using our mobile application, this information may also include your device name and type, your operating system, your phone number, your country, your likes and replies to a post, and other interactions with the application and other users via server log files, as well as any other information you choose to provide."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Mobile Device Data",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "Device information, such as your mobile device ID, model, and manufacturer, and information about the location of your device, if you access the Site from a mobile device."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Third-Party Data",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "Information from third parties, such as personal information or network friends, if you connect your account to the third party and grant the Site permission to access this information."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Data From Contests, Giveaways, and Surveys",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "Personal and other information you may provide when entering contests or giveaways and/or responding to surveys."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Mobile Application Information",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Geo-Location Information. We may request access or permission to and track location-based information from your mobile device, either continuously or while you are using our mobile application, to provide location-based services. If you wish to change our access or permissions, you may do so in your device’s settings."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Mobile Device Access. We may request access or permission to certain features from your mobile device, including your mobile device’s [ camera, contacts, microphone, social media accounts, storage,] and other features. If you wish to change our access or permissions, you may do so in your device’s settings."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Mobile Device Data. We may collect device information (such as your mobile device ID, model, and manufacturer), operating system, version information and IP address."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Push Notifications. We may request to send you push notifications regarding your account or the Application. If you wish to opt-out from receiving these types of communications, you may turn them off in your device’s settings."),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Use of your Information",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "Having accurate information about you permits us to provide you with a smooth, efficient, and customized experience.  Specifically, we may use information collected about you via the Site or our mobile application to: "),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Administer sweepstakes, promotions, and contests."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Assist law enforcement and respond to subpoenas."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Compile anonymous statistical data and analysis for use internally or with third parties."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text("Create and manage your account."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Deliver targeted advertising, coupons, newsletters, and other information regarding promotions and the Site [and our mobile application] to you. "),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Email you regarding your account or order."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text("Enable user-to-user communications."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Generate a personal profile about you to make future visits to the Site [and our mobile application] more personalized."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Increase the efficiency and operation of the Site [and our mobile application]."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Monitor and analyze usage and trends to improve your experience with the Site [and our mobile application]."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Notify you of updates to the Site [and our mobile application]s."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Offer new products, services, [mobile applications,] and/or recommendations to you."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Perform other business activities as needed."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Prevent fraudulent transactions, monitor against theft, and protect against criminal activity."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Request feedback and contact you about your use of the Site [and our mobile application] . "),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Resolve disputes and troubleshoot problems."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Respond to product and customer service requests."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text("Send you a newsletter."),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                "Solicit support for the Site  [and our mobile application]."),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Disclosure of your information",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "We may share information we have collected about you in certain situations. Your information may be disclosed as follows:"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "By Law or to Protect Rights",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "If we believe the release of information about you is necessary to respond to legal process, to investigate or remedy potential violations of our policies, or to protect the rights, property, and safety of others, we may share your information as permitted or required by any applicable law, rule, or regulation.  This includes exchanging information with other entities for fraud protection and credit risk reduction."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Third-Party Service Providers",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "We may share your information with third parties that perform services for us or on our behalf, including payment processing, data analysis, email delivery, hosting services, customer service, and marketing assistance."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Marketing Communications",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "With your consent, or with an opportunity for you to withdraw consent, we may share your information with third parties for marketing purposes, as permitted by law."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Interactions with Other Users",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "If you interact with other users of the Site [and our mobile application], those users may see your name, profile photo, and descriptions of your activity, including sending invitations to other users, chatting with other users, liking posts, following blogs."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Online Postings",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "When you post comments, contributions or other content to the Site [or our mobile applications], your posts may be viewed by all users and may be publicly distributed outside the Site [and our mobile application] in perpetuity. "),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Third-Party Advertisers",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "We may use third-party advertising companies to serve ads when you visit the Site [or our mobile application]. These companies may use information about your visits to the Site [and our mobile application] and other websites that are contained in web cookies in order to provide advertisements about goods and services of interest to you."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Affiliates",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "We may share your information with our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include our parent company and any subsidiaries, joint venture partners or other companies that we control or that are under common control with us."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Social Media Contacts",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "If you connect to the Site [or our mobile application] through a social network, your contacts on the social network will see your name, profile photo, and descriptions of your activity."),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Other Third Parties",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "We may share your information with advertisers and investors for the purpose of conducting general business analysis. We may also share your information with such third parties for marketing purposes, as permitted by law. "),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Sale or Bankruptcy",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          "If we reorganize or sell all or a portion of our assets, undergo a merger, or are acquired by another entity, we may transfer your information to the successor entity.  If we go out of business or enter bankruptcy, your information would be an asset transferred or acquired by a third party.  You acknowledge that such transfers may occur and that the transferee may decline honor commitments we made in this Privacy Policy. We are not responsible for the actions of third parties with whom you share personal or sensitive data, and wehave no authority to manage or control third-party solicitations. If you no longer wish to receive correspondence, emails or other communications from third parties, you are responsible for contacting the third party directly.")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


