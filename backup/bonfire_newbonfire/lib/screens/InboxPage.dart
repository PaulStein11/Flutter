import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/conversation.dart';
import 'package:bonfire_newbonfire/model/message.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

import 'MessagePage.dart';


class InboxPage extends StatelessWidget {
  final double _height;
  final double _width;

  InboxPage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationsListViewWidget(context),
      ),
    );
  }

  Widget _conversationsListViewWidget(BuildContext context) {
    return Builder(
      builder: (BuildContext _context) {
        var _auth = Provider.of<AuthProvider>(_context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text("Inbox", style: TextStyle(color: Colors.grey),),
          ),
          body: Container(
            height: _height,
            width: _width,
            child: StreamBuilder<List<ConversationSnippet>>(
              stream: StreamService.instance.getUserConversations(_auth.user.uid),
              builder: (_context, _snapshot) {
                var _data = _snapshot.data;
                if (_data != null) {
                  _data.removeWhere((_c) {
                    return _c.timestamp == null;
                  });
                  return _data.length != 0
                      ? ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (_context, _index) {
                      return ListTile(
                        onTap: () {
                          NavigationService.instance.navigateToRoute(
                            MaterialPageRoute(
                              builder: (BuildContext _context) {
                                return ConversationPage(
                                    _data[_index].conversationID,
                                    _data[_index].id,
                                    _data[_index].name,
                                    _data[_index].image);
                              },
                            ),
                          );
                        },
                        title: Text(_data[_index].name, style: TextStyle(fontFamily: "PT-Sans", color: Color(0xFF222f3e)),),
                        subtitle: Text(
                            _data[_index].type == MessageType.Text
                                ? _data[_index].lastMessage
                                : "Attachment: Image"),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_data[_index].image),
                            ),
                          ),
                        ),
                        trailing: _listTileTrailingWidgets(
                            _data[_index].timestamp),
                      );
                    },
                  )
                      : Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "No Conversations Yet!",
                              style:
                              Theme.of(context).textTheme.headline1
                            ),
                          ),
                        ],
                      ),
                  );
                } else {
                  return OurLoadingWidget(context);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "Last Message",
          style: TextStyle(fontSize: 15, fontFamily: "PT-Sans"),
        ),
        Text(
          timeago.format(_lastMessageTimestamp.toDate()),
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
