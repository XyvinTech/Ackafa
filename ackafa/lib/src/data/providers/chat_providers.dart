import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/models/msg_model.dart';

final chatMessagesProvider = StateProvider<List<MessageModel>>((ref) {
  return [];
});
