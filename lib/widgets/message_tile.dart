// import 'dart:html';
// import 'dart:math';
import 'package:chat_app_with_firebase/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as int1;

class MessageTile extends StatefulWidget {
  String message;
  String sender;
  bool sentByMe;
  dynamic time;
  // dynamic hours;
  // dynamic minutes;
  // dynamic timeOfSendingMsg;
  MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.time,
    // required this.hours,
    // required this.minutes
    // required this.timeOfSendingMsg
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  // DateTime? dt;

  @override
  void initState() {
    // dt = widget.time.();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        bottom: 5,
        right: widget.sentByMe ? 24 : 0,
        left: widget.sentByMe ? 0 : 24,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          width: widget.message.length >= 2 && widget.message.length <= 13
              ? 130
              : widget.message.length >= 14 && widget.message.length <= 25
                  ? 200
                  : 320,

          // width: 320,
          margin: widget.sentByMe
              ? const EdgeInsets.only(left: 40)
              : const EdgeInsets.only(right: 40),
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 17, top: 17),
          decoration: BoxDecoration(
              color: widget.sentByMe
                  ? Constants().primaryColor.withOpacity(0.42)
                  : Constants().backgroundColor.withOpacity(0.1),
              borderRadius: widget.sentByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.sentByMe
                ? const SizedBox()
                : Text(
                    widget.sender.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.grey,
                        letterSpacing: -0.2,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
            widget.sentByMe
                ? const SizedBox()
                : const SizedBox(
                    height: 7,
                  ),
            Text(
              widget.message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text(
                "${widget.time}",
                // textWidthBasis: TextWidthBasis,
                textAlign: TextAlign.right,
                // textDirection: TextDirection.ltr,
                // textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 9,
                ),
                // DateFormat("hh:mm a").format(widget.time)
                //  ${DateTime.fromMillisecondsSinceEpoch(widget.timeOfSendingMsg.seconds * 1000)}
              ),
            )
          ])),
    );
  }
}
