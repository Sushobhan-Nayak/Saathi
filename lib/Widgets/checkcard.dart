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
  DateTime d = DateTime.now();
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
          d = widget.checklistItem['time'];
          widget.checklistItem.reference.delete();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Task deleted."),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  addTask(t, c, d);
                },
              ),
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(3, 4),
                color: Color.fromARGB(255, 92, 91, 91),
              )
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            gradient: LinearGradient(
              colors: [
                Color(0xff122C34),
                Color.fromARGB(255, 63, 96, 194),
                Color(0xff224870),
              ],
            ),
          ),
          child: ListTile(
            title: Text(
              widget.checklistItem['task'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                            title: const Text(
                              'Update Task',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: textEditingController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter new checklist item',
                                  ),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                                child: const Text(
                                  'Update',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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

  Future<void> addTask(String task, String cat, DateTime d) {
    if (cat != 'Personal' && cat != 'Travel' && cat != 'Docs') {
      tasks = FirebaseFirestore.instance.collection('tasks_$cat');
    } else {
      tasks = FirebaseFirestore.instance.collection('tasks_${user.uid}');
    }
    return tasks.add({
      'task': task,
      'completed': false,
      'category': cat,
      'time': d,
    });
  }

  Future<void> updateTask(String task) {
    return widget.checklistItem.reference.update({
      'task': task,
    });
  }
}
