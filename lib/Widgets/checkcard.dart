import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckCard extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> checklistItem;
  const CheckCard({super.key, required this.checklistItem});

  @override
  State<CheckCard> createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  TextEditingController textEditingController = TextEditingController();
  late CollectionReference tasks;
  String t = '';
  String c = '';
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    tasks = FirebaseFirestore.instance.collection('tasks_${user.uid}');
  }

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
          t = widget.checklistItem['task'];
          c = widget.checklistItem['category'];

          widget.checklistItem.reference.delete();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Task deleted."),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  addTask(t, c);
                },
              ),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  fillColor: const MaterialStatePropertyAll(Colors.white),
                  value: widget.checklistItem['completed'],
                  onChanged: (value) {
                    setState(() {
                      widget.checklistItem.reference
                          .update({'completed': value});
                    });
                  },
                  activeColor: Colors.white,
                ),
                IconButton(
                    onPressed: () async {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Add Task'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: textEditingController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter new checklist item',
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (textEditingController.text.isNotEmpty) {
                                    await updateTask(
                                        textEditingController.text);
                                    setState(() {
                                      textEditingController.clear();
                                    });
                                    if (!mounted) return;
                                    Navigator.pop(context, 'Update');
                                  }
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.mode_edit_outlined,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTask(String task, String cat) {
    if (cat != 'Personal' && cat != 'Travel' && cat != 'Docs') {
      tasks = FirebaseFirestore.instance.collection('tasks_$cat');
    } else {
      tasks = FirebaseFirestore.instance.collection('tasks_${user.uid}');
    }
    return tasks.add({
      'task': task,
      'completed': false,
      'category': cat,
    });
  }

  Future<void> updateTask(String task) {
    return widget.checklistItem.reference.update({
      'task': task,
    });
  }
}
