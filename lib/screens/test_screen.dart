import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class TestScreen extends StatelessWidget {
//   // const TestScreen({super.key});
//   late IO.Socket socket;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     connectTo();
//                   },
//                   child: Text("Connect")),
//               ElevatedButton(
//                   onPressed: () {
//                     createRoom();
//                   },
//                   child: Text("Create")),
//               ElevatedButton(onPressed: () {}, child: Text("Join")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void connectTo() {
//     socket = IO.io('http://127.0.0.1:3000', <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket.on('connect', (data) {
//       print(data);
//       print('Connected to socket*------');
//     });

//     socket.onDisconnect((_) => print('Disconnected from the socket'));
//     socket.connect();
//   }

//   void createRoom() {
//     socket.emit('createRoom');
//   }
// }

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  void connectToSocket() {
    // Update the URL to match your server's address
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the socket');

      // Example: Create a room
      socket.emit('createRoom');

      // Example: Join a room (replace 'room_id' with the actual room ID)
      socket.emit('joinRoom', {'roomId': 'room_id'});
    });

    // Add your socket event handling logic here

    socket.on('welcome', (data) {
      print('Received welcome message: $data');
    });

    socket.on('customMessage', (data) {
      print('Received custom message: $data');
    });

    // Handle room creation response
    socket.on('roomCreated', (data) {
      print('Room created with ID: ${data['roomId']}');
    });

    // Handle room join response
    socket.on('joinedRoom', (data) {
      print('Joined room with ID: ${data['roomId']}');
    });

    // Handle room not found response
    socket.on('roomNotFound', (_) {
      print('Room not found');
    });

    socket.onDisconnect((_) => print('Disconnected from the socket'));

    socket.connect();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.io Connection'),
      ),
      body: Center(
        child: Text(
            'Socket connection status: ${socket.connected ? 'Connected' : 'Disconnected'}'),
      ),
    );
  }
}
