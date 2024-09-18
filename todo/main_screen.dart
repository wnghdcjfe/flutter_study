import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_viewmodel.dart';
import 'add_task.dart';
import 'task_drawer.dart';

// URL launcher function
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // 앱이 시작될 때 비트코인 시세 정보를 주기적으로 가져오는 타이머를 시작
    Provider.of<TaskViewModel>(context, listen: false).startFetchingBitcoinData();
  }

  @override
  void dispose() {
    // 화면이 종료될 때 타이머 종료
    Provider.of<TaskViewModel>(context, listen: false).stopFetchingBitcoinData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TaskDrawer(),
      appBar: AppBar(
        title: const Text("zagabi's todo"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TaskViewModel>(
              builder: (context, taskViewModel, child) {
                return taskViewModel.todoList.isEmpty
                    ? const Center(
                  child: Text(
                    "No items on the list",
                    style: TextStyle(fontSize: 20),
                  ),
                )
                    : ListView.builder(
                  itemCount: taskViewModel.todoList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you want to delete this task?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        taskViewModel.removeTask(index);
                      },
                      child: ListTile(
                        title: Text(taskViewModel.todoList[index]),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    taskViewModel.removeTask(index);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Task done!"),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Add Bitcoin Price at the bottom
          Consumer<TaskViewModel>(
            builder: (context, taskViewModel, child) {
              if (taskViewModel.bitcoinData == null) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Fetching Bitcoin data...",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Text(
                    "Current BTC Price (KRW): ${taskViewModel.bitcoinData!['trade_price']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  height: 250,
                  child: AddTask(),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
