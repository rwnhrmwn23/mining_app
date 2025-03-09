import 'package:flutter/material.dart';
import '../../../../core/utils/utils.dart';

class MessageBubble extends StatefulWidget {
  final String senderNik;
  final String? senderName;
  final String message;
  final String createdAt;
  final String currentUserNik;

  const MessageBubble({
    Key? key,
    required this.senderNik,
    required this.senderName,
    required this.message,
    required this.createdAt,
    required this.currentUserNik,
  }) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.senderNik == widget.currentUserNik;
    String displayName =
    widget.senderName != null && widget.senderName!.isNotEmpty
        ? widget.senderName!
        : widget.senderNik;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: isCurrentUser ? const Color(0xFF1073FC) : const Color(0xFFC99D00),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isCurrentUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                const Icon(Icons.warning, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000 - 32,
              ),
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatDateTime(widget.createdAt),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}