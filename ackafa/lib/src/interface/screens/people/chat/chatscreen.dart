import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/models/msg_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/data/services/api_routes/file_upload.dart';
import 'package:ackaf/src/data/services/api_routes/image_upload.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/chat_widgets/OwnMessageCard.dart';
import 'package:ackaf/src/interface/common/chat_widgets/ReplyCard.dart';
import 'package:ackaf/src/interface/common/custom_dialog.dart';
// import 'package:ackaf/src/interface/common/loading.dart';

import 'package:ackaf/src/interface/screens/profile/profile_preview.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:io';

class IndividualPage extends ConsumerStatefulWidget {
  IndividualPage({required this.receiver, required this.sender, super.key});
  final Participant receiver;
  final Participant sender;
  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends ConsumerState<IndividualPage> {
  bool isBlocked = false;
  bool show = false;
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;

  @override
  void initState() {
    super.initState();
    // Ensure socket is connected for real-time updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ref.read(socketIoClientProvider).connect(widget.sender.id ?? '', ref);
      } catch (_) {}
    });
    getMessageHistory();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void getMessageHistory() async {
    final messagesette = await getChatBetweenUsers(widget.receiver.id!);
    if (mounted) {
      setState(() {
        messages.addAll(messagesette);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBlockStatus(); // Now safe to call
  }

  Future<void> _loadBlockStatus() async {
    final asyncUser = ref.watch(userProvider);
    asyncUser.whenData(
      (user) {
        setState(() {
          if (user.blockedUsers != null) {
            isBlocked = user.blockedUsers!
                .any((blockedUser) => blockedUser == widget.receiver.id);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    focusNode.unfocus();
    _controller.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    try {
      ref.read(socketIoClientProvider).disconnect();
    } catch (_) {}
    super.dispose();
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty && mounted) {
      sendChatMessage(
        userId: widget.receiver.id!,
        content: _controller.text,
      );
      setMessage("sent", _controller.text, widget.sender.id!);
      _controller.clear();
    }
  }

  Future<void> _sendImageAttachment() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        await _optimisticSendAttachment(
          type: 'image',
          localPath: picked.path,
          uploader: imageUpload,
        );
      }
    } catch (e) {
      debugPrint('Image send error: $e');
    }
  }

  Future<void> _sendDocumentAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result != null && result.files.single.path != null) {
        await _optimisticSendAttachment(
          type: 'file',
          localPath: result.files.single.path!,
          uploader: uploadFile,
        );
      }
    } catch (e) {
      debugPrint('Document send error: $e');
    }
  }

  Future<void> _captureAndSendPhoto() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        await _optimisticSendAttachment(
          type: 'image',
          localPath: picked.path,
          uploader: imageUpload,
        );
      }
    } catch (e) {
      debugPrint('Camera send error: $e');
    }
  }

  Future<void> _startOrStopVoiceRecording() async {
    try {
      if (!_isRecording) {
        final hasPerm = await _audioRecorder.hasPermission();
        if (!hasPerm) return;
        final tempDir = await getTemporaryDirectory();
        final filePath = p.join(tempDir.path, 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a');
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );
        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });
        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() {
            _recordDuration += const Duration(seconds: 1);
          });
        });
      } else {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
        });
        _recordTimer?.cancel();
        if (path != null) {
          if (_recordDuration.inSeconds >= 1) {
            await _optimisticSendAttachment(
              type: 'voice',
              localPath: path,
              uploader: uploadFile,
            );
          } else {
            try {
              await File(path).delete();
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      debugPrint('Voice record/send error: $e');
    }
  }

  void setMessage(String type, String message, String fromId) {
    final messageModel = MessageModel(
      from: fromId,
      status: type,
      content: message,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.add(messageModel);
    });
  }

  Future<void> _optimisticSendAttachment({
    required String type,
    required String localPath,
    required Future<String> Function(String) uploader,
  }) async {
    try {
      final uploadedUrl = await uploader(localPath);
      final temp = MessageModel(
        from: widget.sender.id,
        status: 'pending',
        createdAt: DateTime.now(),
        attachments: [MessageAttachment(url: uploadedUrl, type: type)],
      );
      setState(() => messages.add(temp));

      final ok = await sendChatMessage(
        userId: widget.receiver.id!,
        attachments: [MessageAttachment(url: uploadedUrl, type: type)],
      );

      setState(() {
        final idx = messages.indexOf(temp);
        if (idx != -1) {
          messages[idx] = MessageModel(
            from: widget.sender.id,
            status: ok ? 'sent' : 'pending',
            createdAt: temp.createdAt,
            attachments: temp.attachments,
          );
        }
      });
    } catch (e) {
      debugPrint('Attachment send error: $e');
    }
  }

  Future<void> _optimisticSendText() async {
    if (_controller.text.trim().isEmpty) return;
    final temp = MessageModel(
      from: widget.sender.id,
      content: _controller.text,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    setState(() => messages.add(temp));
    final text = _controller.text;
    _controller.clear();
    final ok = await sendChatMessage(userId: widget.receiver.id!, content: text);
    setState(() {
      final idx = messages.indexOf(temp);
      if (idx != -1) {
        messages[idx] = MessageModel(
          from: widget.sender.id,
          content: text,
          status: ok ? 'sent' : 'pending',
          createdAt: temp.createdAt,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = ref.watch(messageStreamProvider);

    messageStream.whenData((newMessage) {
      bool messageExists = messages.any((message) =>
          message.createdAt == newMessage.createdAt &&
          message.content == newMessage.content);

      if (!messageExists) {
        setState(() {
          messages.add(newMessage);
        });
      }
    });

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFFCFCFC),
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                elevation: 1,
                shadowColor: Colors.white,
                backgroundColor: Colors.white,
                leadingWidth: 90,
                titleSpacing: 0,
                leading: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipOval(
                      child: Container(
                        width: 30,
                        height: 30,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Image.network(
                          widget.receiver.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                'assets/icons/dummy_person_small.png');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                title: Consumer(
                  builder: (context, ref, child) {
                    final asyncUser = ref
                        .watch(fetchUserByIdProvider(widget.receiver.id ?? ''));
                    return asyncUser.when(
                      data: (user) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => ProfilePreview(
                                  user: user,
                                ),
                                transitionDuration: Duration(milliseconds: 500),
                                transitionsBuilder: (_, a, __, c) =>
                                    FadeTransition(opacity: a, child: c),
                              ),
                            );
                          },
                          child: Text(
                            '${widget.receiver.name ?? ''}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      loading: () => Text(
                        '${widget.receiver.name ?? ''}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      error: (error, stackTrace) {
                        // Handle error state
                        return Center(
                          child: Text(
                              'Something went wrong please try again later'),
                        );
                      },
                    );
                  },
                ),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.report_gmailerrorred),
                      onPressed: () {
                        showReportPersonDialog(
                            context: context,
                            onReportStatusChanged: () {},
                            reportType: 'User',
                            reportedItemId: widget.receiver.id ?? '');
                      }),
                  IconButton(
                      icon: const Icon(Icons.block),
                      onPressed: () {
                        showBlockPersonDialog(
                            context: context,
                            userId: widget.receiver.id ?? '',
                            onBlockStatusChanged: () {
                              Future.delayed(Duration(seconds: 1));
                              setState(() {
                                if (isBlocked) {
                                  isBlocked = false;
                                } else {
                                  isBlocked = true;
                                }
                              });
                            });
                      }),
                ],
              )),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PopScope(
              child: Column(
                children: [
                  Expanded(
                    child: messages.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[messages.length -
                                  1 -
                                  index]; // Reverse the index to get the latest message first
                              if (message.from == widget.sender.id) {
                                return OwnMessageCard(
                                  feed: message.feed,
                                  status: message.status!,
                                  message: message.content ?? '',
                                  attachments: message.attachments,
                                  time: DateFormat('h:mm a').format(
                                    DateTime.parse(message.createdAt.toString())
                                        .toLocal(),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onLongPress: () {
                                    showReportPersonDialog(
                                        reportedItemId: message.id ?? '',
                                        context: context,
                                        onReportStatusChanged: () {
                                          setState(() {
                                            if (isBlocked) {
                                              isBlocked = false;
                                            } else {
                                              isBlocked = true;
                                            }
                                          });
                                        },
                                        reportType: 'Message');
                                  },
                                  child: ReplyCard(
                                    feed: message.feed,
                                    attachments: message.attachments,
                                    message: message.content ?? '',
                                    time: DateFormat('h:mm a').format(
                                      DateTime.parse(
                                              message.createdAt.toString())
                                          .toLocal(),
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Image.asset(
                                    'assets/startConversation.png')),
                          ),
                  ),
                  isBlocked
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE30613),
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'This user is blocked',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                shadows: [
                                  // Shadow(
                                  //   color: Colors.black45,
                                  //   blurRadius: 5,
                                  //   offset: Offset(2, 2),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isRecording)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                    border: Border.all(color: Color.fromARGB(255, 220, 215, 215), width: 0.5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.mic, color: Color(0xFFE30613), size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatDuration(_recordDuration),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 36,
                                        width: 36,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          tooltip: 'Cancel',
                                          onPressed: () async {
                                            try {
                                              final path = await _audioRecorder.stop();
                                              _recordTimer?.cancel();
                                              setState(() {
                                                _isRecording = false;
                                              });
                                              if (path != null) {
                                                try {
                                                  await File(path).delete();
                                                } catch (_) {}
                                              }
                                            } catch (_) {}
                                          },
                                          icon: const Icon(Icons.close, color: Color(0xFFE30613), size: 20),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      SizedBox(
                                        height: 36,
                                        width: 36,
                                        child: Material(
                                          color: const Color(0xFFE30613),
                                          borderRadius: BorderRadius.circular(6),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(6),
                                            onTap: () async {
                                              await _startOrStopVoiceRecording();
                                            },
                                            child: const Center(
                                              child: Icon(Icons.send, color: Colors.white, size: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    color: Color.fromARGB(255, 220, 215, 215),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    color: const Color(0xFFE30613),
                                    onPressed: _isRecording
                                        ? () {}
                                        : () async {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              ),
                                              builder: (_) => bottomSheet(),
                                            );
                                          },
                                  ),
                                  Expanded(
                                    child: Card(
                                      elevation: 1,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Color.fromARGB(255, 220, 215, 215),
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 5.0),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxHeight: 150,
                                          ),
                                          child: Scrollbar(
                                            thumbVisibility: true,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              reverse: true,
                                              child: TextField(
                                                controller: _controller,
                                                focusNode: focusNode,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                minLines: 1,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Type a message",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!_isRecording)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 2, left: 2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE30613),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            (_controller.text.trim().isEmpty)
                                                ? Icons.mic
                                                : Icons.send,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            if (_controller.text.trim().isEmpty) {
                                              await _startOrStopVoiceRecording();
                                            } else {
                                              await _optimisticSendText();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              onPopInvoked: (didPop) {
                if (didPop) {
                  if (show) {
                    setState(() {
                      show = false;
                    });
                  } else {
                    focusNode.unfocus();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });
                  }
                  ref.invalidate(fetchChatThreadProvider);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document", _sendDocumentAttachment),
                  const SizedBox(width: 40),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera", _captureAndSendPhoto),
                  const SizedBox(width: 40),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery", _sendImageAttachment),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text, [Future<void> Function()? onTap]) {
    return InkWell(
      onTap: () async {
        if (onTap != null) {
          Navigator.pop(context);
          await onTap();
        }
      },
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
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
