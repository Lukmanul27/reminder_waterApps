import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();

  Future<void> postComment() async {
    final apiUrl = 'https://jsonplaceholder.typicode.com/comments';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'body': _commentController.text,
      },
    );
    if (response.statusCode == 201) {
      await sendEmail();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Comment posted successfully! Email sent.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to post comment.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> sendEmail() async {
    String username = 'your-email@gmail.com';
    String password = 'your-password';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add('ariflukmanulhakim32@gmail.com') // Email tujuan
      ..subject = 'Masukan dari Aplikasi'
      ..text = _commentController.text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error occurred while sending email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Komentar/Masukan'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Komentar/Masukan',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              postComment();
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
