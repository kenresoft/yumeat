import 'dart:async';
import 'dart:collection'; // Import the 'dart:collection' library for using Queue

import 'package:flutter/material.dart';

class NotificationDialog extends StatefulWidget {
  final Queue<String> messageQueue; // Change to Queue<String> type

  const NotificationDialog({super.key, required this.messageQueue});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _showNextNotification();
  }

  void _showNextNotification() {
    if (widget.messageQueue.isNotEmpty) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          widget.messageQueue.removeFirst();
          _animationController.reset();
          _animationController.forward();
        });
        _showNextNotification();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, -MediaQuery.of(context).size.height * 0.3 * (1 - _animation.value)), // Slide in from the top
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 10,
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.messageQueue.isNotEmpty ? widget.messageQueue.first : '',
                        style: const TextStyle(fontSize: 18.0, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
