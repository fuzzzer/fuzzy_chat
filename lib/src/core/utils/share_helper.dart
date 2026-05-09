import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  ShareHelper._();

  static Rect _originFromContext(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      return box.localToGlobal(Offset.zero) & box.size;
    }
    final size = MediaQuery.of(context).size;
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 1,
      height: 1,
    );
  }

  static Future<void> share(
    String text, {
    required BuildContext context,
  }) {
    return Share.share(
      text,
      sharePositionOrigin: _originFromContext(context),
    );
  }

  static Future<void> shareXFiles(
    List<XFile> files, {
    required BuildContext context,
  }) {
    return Share.shareXFiles(
      files,
      sharePositionOrigin: _originFromContext(context),
    );
  }
}
