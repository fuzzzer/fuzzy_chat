import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import 'chat_invitation_page/chat_invitation_page.dart';

class ChatCreationPage extends StatefulWidget {
  const ChatCreationPage({super.key});

  @override
  State<ChatCreationPage> createState() => _ChatCreationPageState();
}

class _ChatCreationPageState extends State<ChatCreationPage> {
  final TextEditingController _chatNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _chatNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const FuzzyHeader(title: 'Create a New Chat'),
            FuzzyTextField(
              controller: _chatNameController,
              focusNode: _focusNode,
              labelText: 'Enter Chat Name',
              hintText: 'e.g. ZZZZ',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FuzzyButton(
                  text: 'Back',
                  onPressed: () => Navigator.pop(context),
                ),
                FuzzyButton(
                  text: 'Create',
                  onPressed: () {
                    final chatName = _chatNameController.text.trim();
                    if (chatName.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatInvitationPage(
                            payload: ChatInvitationPagePayload(
                              chatName: chatName,
                              chatId: chatName,
                            ),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a chat name.')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
