import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckCard extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> checklistItem;
  const CheckCard({super.key, required this.checklistItem});

  @override
  State<CheckCard> createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Dismissible(
        key: Key(widget.checklistItem.id),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            widget.checklistItem.reference.delete();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Task deleted."),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: const Offset(3, 4),
                color: Colors.grey[800]!,
              )
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            gradient: LinearGradient(
              colors: [Colors.pink[900]!, Colors.deepOrange[700]!],
            ),
          ),
          child: ListTile(
            title: Text(
              widget.checklistItem['task'],
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Checkbox(
              checkColor: Colors.black,
              fillColor: const MaterialStatePropertyAll(Colors.white),
              value: widget.checklistItem['completed'],
              onChanged: (value) {
                setState(() {
                  widget.checklistItem.reference.update({'completed': value});
                });
              },
              activeColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
