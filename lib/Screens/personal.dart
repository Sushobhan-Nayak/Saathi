import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_button/group_button.dart';
import 'package:saathi/Widgets/checkcard.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  ChecklistScreenState createState() => ChecklistScreenState();
}

class ChecklistScreenState extends State<ChecklistScreen> {
  TextEditingController textEditingController = TextEditingController();
  late CollectionReference tasks;
  late User user;
  GroupButtonController controller = GroupButtonController();
  final List<String> categories = ['Personal', 'Travel', 'Docs'];
  String cat = 'Personal';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    controller.selectIndex(0);
    tasks = FirebaseFirestore.instance.collection('tasks_${user.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Checklist',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GroupButton(
              enableDeselect: false,
              controller: controller,
              onSelected: (value, index, isSelected) {
                setState(() {
                  cat = value;
                });
              },
              options: GroupButtonOptions(
                spacing: 6,
                groupingType: GroupingType.row,
                selectedShadow: [],
                selectedColor: Theme.of(context).colorScheme.primary,
                unselectedColor: Colors.white,
                unselectedBorderColor: const Color.fromARGB(114, 186, 186, 186),
                mainGroupAlignment: MainGroupAlignment.start,
                unselectedShadow: [],
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              isRadio: true,
              buttons: categories,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: tasks.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No data to show !'));
                  }
                  var checklistItems = snapshot.data!.docs
                      .where((doc) => doc['category'] == cat)
                      .toList();
                  return ListView.builder(
                    itemCount: checklistItems.length,
                    itemBuilder: (context, index) {
                      var checklistItem = checklistItems[index];
                      return CheckCard(
                        checklistItem: checklistItem,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
                        hintText: 'Enter checklist item',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GroupButton(
                      enableDeselect: false,
                      controller: controller,
                      onSelected: (value, index, isSelected) {
                        setState(() {
                          cat = value;
                        });
                      },
                      options: GroupButtonOptions(
                        spacing: 6,
                        groupingType: GroupingType.wrap,
                        selectedShadow: [],
                        selectedColor: Theme.of(context).colorScheme.primary,
                        unselectedColor: Colors.white,
                        unselectedBorderColor:
                            const Color.fromARGB(114, 186, 186, 186),
                        mainGroupAlignment: MainGroupAlignment.start,
                        unselectedShadow: [],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      isRadio: true,
                      buttons: categories,
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
                        await addTask(textEditingController.text, cat);
                        setState(() {
                          textEditingController.clear();
                        });
                        if (!mounted) return;
                        Navigator.pop(context, 'Add');
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> addTask(String task, String cat) {
    return tasks.add({
      'task': task,
      'completed': false,
      'category': cat,
    });
  }
}
