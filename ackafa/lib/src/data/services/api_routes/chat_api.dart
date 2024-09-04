import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ackaf/src/data/models/msg_model.dart';

part 'chat_api.g.dart';

// Define a Socket.IO client providerr
final socketIoClientProvider = Provider<SocketIoClient>((ref) {
  return SocketIoClient();
});

// Define a message stream provider
final messageStreamProvider = StreamProvider.autoDispose<MessageModel>((ref) {
  final socketIoClient = ref.read(socketIoClientProvider);
  return socketIoClient.messageStream;
});

class SocketIoClient {
  late IO.Socket _socket;
  final _controller = StreamController<MessageModel>();

  SocketIoClient();

  Stream<MessageModel> get messageStream => _controller.stream;

  void connect(String receiverId, String senderId) {
    final uri = 'http://43.205.89.79/api/v1/chats?userId=$senderId'; // Base URI

    // Initialize socket.io client
    _socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .setExtraHeaders({'receiver_id': receiverId}) // Optional headers
          .disableAutoConnect() // Disable auto-connect
          .build(),
    );

    log('Connecting to: $uri');

    // Listen for connection events
    _socket.onConnect((_) {
      log('Connected to: $uri');
    });

    // Listen to messages from the server
    _socket.on('message', (data) {
      final decodedMessage = jsonDecode(data);
      print('Received message: $decodedMessage');
      final messageModel = MessageModel.fromJson(decodedMessage);
      _controller.add(messageModel);
    });

    // Handle connection errors
    _socket.on('connect_error', (error) {
      print('Connection Error: $error');
      _controller.addError(error);
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      print('Disconnected from server');
      _controller.close();
    });

    // Connect manually
    _socket.connect();
  }

  void disconnect() {
    _socket.disconnect();
    _socket.dispose(); // To prevent memory leaks
  }
}

Future<void> sendChatMessage({
  required String userId,
  required String from,
  required String content,
  String? attachments,
}) async {
  final String url = 'http://43.205.89.79/api/v1/chats/send/$userId';

  var request = http.MultipartRequest('POST', Uri.parse(url))
    ..fields['content'] = content;

  if (attachments != null && attachments.isNotEmpty) {
    request.files.add(await http.MultipartFile.fromPath(
      'attachments',
      attachments,
    ));
  }
  request.headers.addAll({
    'accept': 'application/json',
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer ${token}',
  });

  log('Sending message to: $url');

  log('Request headers: ${request.headers}');
  try {
    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}

Future<List<MessageModel>> getMessages(
    String senderId, String recieverId) async {
  final String url =
      'http://43.205.89.79/api/v1/chats/messages/${senderId}/${recieverId}';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Parse the JSON data
    final messages = json.decode(response.body)['data'];
    // Handle the messages data as per your needs

    print(messages);

    return messages
        .map<MessageModel>((item) => MessageModel.fromJson(item))
        .toList();
  } else {
    // Handle the error
    print('Failed to load messages. Status code: ${response.body}');
    throw Exception('Failed to load messages');
  }
}

@riverpod
Future<List<ChatModel>> fetchChatThread(
    FetchChatThreadRef ref, String token) async {
  final url = Uri.parse('http://43.205.89.79/api/v1/chats/threads');
  print('Requesting URL: $url');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body)['data'];
    log('Response data: $data');
    final List<ChatModel> chats =
        await data.map<ChatModel>((item) => ChatModel.fromJson(item)).toList();
    final chat = chats[0].id;
    log('Response chat: ${chat}');

    return chats;
  } else {
    print('Error: ${json.decode(response.body)['message']}');
    throw Exception(json.decode(response.body)['message']);
  }
}
