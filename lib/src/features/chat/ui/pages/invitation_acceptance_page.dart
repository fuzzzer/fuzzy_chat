import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import 'acceptance_export_page.dart';

class InvitationAcceptancePage extends StatefulWidget {
  const InvitationAcceptancePage({super.key});

  @override
  State<InvitationAcceptancePage> createState() => _InvitationAcceptancePageState();
}

class _InvitationAcceptancePageState extends State<InvitationAcceptancePage> {
  final TextEditingController _invitationTextController = TextEditingController();
  String? _importedFilePath;

  @override
  void dispose() {
    _invitationTextController.dispose();
    super.dispose();
  }

  void _importInvitationFile() {
    // Here you would integrate file picker functionality to import a file.
    setState(() {
      _importedFilePath = 'path/to/imported/file.fuzz';
    });
  }

  void _acceptInvitation() {
    final invitationText = _invitationTextController.text.trim();
    if (invitationText.isNotEmpty || _importedFilePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AcceptanceExportPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide invitation text or import a file.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Accept Chat Invitation',
              style: uiTextStyles.bodyLargeBold20,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FuzzyTextField(
              controller: _invitationTextController,
              labelText: 'Paste Invitation Text',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FuzzyButton(
              text: 'Accept Invitation',
              onPressed: _acceptInvitation,
            ),
            const Spacer(),
            FuzzyButton(
              text: 'Import Invitation File',
              onPressed: _importInvitationFile,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FuzzyButton(
                  text: 'Back',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
