import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:saathi/Widgets/checkcard.dart';

class SharedList extends StatefulWidget {
  const SharedList({super.key});

  @override
  SharedListState createState() => SharedListState();
}

class SharedListState extends State<SharedList> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController shareController = TextEditingController();
  late CollectionReference tasks;
  late User user;
  GroupButtonController controller = GroupButtonController();
  List<String> sharedList = [];
  String cat = '';

  Future<void> fetchData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.displayName)
        .get();
    setState(() {
      sharedList = List<String>.from(userDoc['shared'] ?? []);
      cat = sharedList[0];
    });
    controller.selectIndex(0);
  }

  Future<void> addStringToSharedList(String newString) async {
    if (!sharedList.contains(newString)) {
      sharedList.add(newString);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.displayName)
          .update({'shared': sharedList});
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$newString" already used. Try using another.'),
        ),
      );
    }
  }

  Future<void> deleteStringFromSharedList(String stringToDelete) async {
    if (sharedList.contains(stringToDelete)) {
      sharedList.remove(stringToDelete);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.displayName)
          .update({'shared': sharedList});
      cat = sharedList[0];
      controller.selectIndex(0);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$stringToDelete" remove'),
        ),
      );
    }
  }

  Future<void> deleteCollection(String collectionName) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionName);

    final QuerySnapshot snapshot = await collectionRef.get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchData();
    controller.selectIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    tasks = FirebaseFirestore.instance.collection('tasks_$cat');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shared Checklist',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.group_add_outlined),
                  onPressed: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Add Group'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: shareController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Group id',
                                ),
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
                                if (shareController.text.isNotEmpty) {
                                  await addStringToSharedList(
                                      shareController.text);
                                  setState(() {
                                    shareController.clear();
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
                  label: const Text('Add Group'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.group_remove_outlined),
                  onPressed: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Group'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: shareController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Group id',
                                ),
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
                                if (shareController.text.isNotEmpty) {
                                  await deleteStringFromSharedList(
                                      shareController.text);
                                  await deleteCollection(
                                      'tasks_${shareController.text}');
                                  if (!mounted) return;
                                  Navigator.pop(context, 'Delete');
                                }
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  label: const Text('Delete Group'),
                ),
              ],
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
              buttons: sharedList,
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
                      buttons: sharedList,
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
