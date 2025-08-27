import 'package:ackaf/src/data/models/msg_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnMessageCard extends StatelessWidget {


  const OwnMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.status,
    this.feed,
    this.attachments,
  }) : super(key: key);

  final String message;
  final String time;
  final ChatFeed? feed;
   final String status;
  final List<MessageAttachment>? attachments;
  @override
  Widget build(BuildContext context) {
    final bool isVoiceOnly = (attachments != null && attachments!.isNotEmpty &&
        attachments!.every((a) => a.type == 'voice')) &&
        (message.isEmpty);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            padding: isVoiceOnly
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFE6FFE2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isVoiceOnly
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (attachments != null && attachments!.isNotEmpty)
                  ...attachments!.where((a) => a.url != null).map((a) {
                    if (a.type == 'image') {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            a.url!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              height: 160,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      );
                    }
                    if (a.type == 'voice') {
                      return _InlineAudio(url: a.url!, isOwn: true, dense: true);
                    }
                    if (a.type == 'file') {
                      return _AttachmentTile(
                        icon: Icons.insert_drive_file,
                        label: _extractFileName(a.url!),
                        url: a.url!,
                        isOwn: true,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                if (feed?.media != null && (attachments == null || attachments!.isEmpty))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      feed!.media!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                // Spacing between message and time row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 5),
                    _StatusIcon(status: status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _extractFileName(String url) {
  try {
    final uri = Uri.parse(url);
    if (uri.pathSegments.isNotEmpty) return uri.pathSegments.last;
    return 'Attachment';
  } catch (_) {
    return 'Attachment';
  }
}

class _AttachmentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool isOwn;

  const _AttachmentTile({required this.icon, required this.label, required this.url, required this.isOwn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwn ? const Color(0xFFDFF6DA) : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(url);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}

class _InlineAudio extends StatefulWidget {
  final String url;
  final bool isOwn;
  final bool dense;
  const _InlineAudio({required this.url, required this.isOwn, this.dense = false});

  @override
  State<_InlineAudio> createState() => _InlineAudioState();
}

class _InlineAudioState extends State<_InlineAudio> {
  late final AudioPlayer _player;
  bool _playing = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      setState(() {
        _playing = s == PlayerState.playing;
      });
    });
    _player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: widget.dense ? 6 : 10, vertical: widget.dense ? 4 : 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            height: widget.dense ? 28 : 32,
            width: widget.dense ? 28 : 32,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  if (_playing) {
                    await _player.pause();
                  } else {
                    await _player.play(UrlSource(widget.url));
                  }
                },
                child: Icon(
                  _playing ? Icons.pause : Icons.play_arrow,
                  size: widget.dense ? 16 : 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(width: widget.dense ? 6 : 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: widget.dense ? 1.5 : 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: widget.dense ? 5 : 6),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: widget.dense ? 8 : 10),
                  ),
                  child: Slider(
                    value: _position.inMilliseconds
                        .toDouble()
                        .clamp(0.0, _duration.inMilliseconds.toDouble() == 0 ? 1.0 : _duration.inMilliseconds.toDouble()),
                    min: 0,
                    max: _duration.inMilliseconds.toDouble() == 0 ? 1 : _duration.inMilliseconds.toDouble(),
                    onChanged: (v) async {
                      await _player.seek(Duration(milliseconds: v.toInt()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_fmt(_position), style: TextStyle(fontSize: widget.dense ? 9 : 10, color: Colors.black54)),
                    Text(_fmt(_duration), style: TextStyle(fontSize: widget.dense ? 9 : 10, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final String status; // sent | delivered | seen | pending
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 'seen') {
      return Icon(Icons.done_all, size: 20, color: Colors.blue[300]);
    }
    if (status == 'delivered') {
      return const Icon(Icons.done_all, size: 20, color: Colors.grey);
    }
    if (status == 'sent') {
      return const Icon(Icons.done, size: 20, color: Colors.grey);
    }
    // pending (local optimistic)
    return const Icon(Icons.access_time, size: 18, color: Colors.grey);
  }
}
