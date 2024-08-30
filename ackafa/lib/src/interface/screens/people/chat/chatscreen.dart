import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/providers/chat_providers.dart';
import 'package:kssia/src/interface/common/OwnMessageCard.dart';
import 'package:kssia/src/interface/common/ReplyCard.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/models/msg_model.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';

class IndividualPage extends ConsumerStatefulWidget {
  IndividualPage({required this.chatModel, required this.sourchat, super.key});
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends ConsumerState<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late final webSocketClient;
  @override
  void initState() {
    super.initState();
    webSocketClient = ref.read(socketIoClientProvider);
    webSocketClient.connect(widget.chatModel.id, widget.sourchat.id);
    getMessageHistory();
  }

  void getMessageHistory() async {
    final messagesette =
        await getMessages(widget.chatModel.id, widget.sourchat.id);
    setState(() {
      messages.addAll(messagesette);
    });
  }

  @override
  void dispose() {
    focusNode.unfocus();
    webSocketClient.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty && mounted) {
      sendChatMessage(
        userId: widget.chatModel.id,
        from: widget.sourchat.id,
        content: _controller.text,
      );
      setMessage("sent", _controller.text, widget.sourchat.id);
      _controller.clear();
      if (mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void setMessage(String type, String message, String fromId) {
    final messageModel = MessageModel(
      fromId: fromId,
      status: type,
      message: message,
      time: DateTime.now().toString().substring(10, 16),
    );

    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFFCFCFC),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                elevation: 1,
                shadowColor: Colors.white,
                backgroundColor: Colors.white,
                leadingWidth: 90,
                titleSpacing: 0,
                leading: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      child: SvgPicture.asset(
                        "assets/icons/person.svg",
                        color: Colors.white,
                        height: 30,
                        width: 30,
                      ),
                      radius: 19,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
                title: Text(
                  widget.chatModel.name,
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  IconButton(icon: Icon(Icons.call), onPressed: () {}),
                ],
              )),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }
                        if (messages[index].fromId == widget.sourchat.id) {
                          return OwnMessageCard(
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        } else {
                          return ReplyCard(
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 65,
                                child: Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      left: 15, right: 2, bottom: 22),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 220, 215, 215),
                                      width: .5,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "What would you share?",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.attach_file),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomSheet());
                                            },
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  right: 2,
                                  left: 2,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFE30613),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      sendMessage();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  focusNode.unfocus();
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
