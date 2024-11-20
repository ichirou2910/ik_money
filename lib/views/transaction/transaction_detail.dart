import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../entities/transaction.dart';
import '../../services/transaction_service.dart';

class TransactionDetailView extends StatefulWidget {
  final int transactionId;

  TransactionDetailView({super.key, required String transactionId})
      : transactionId = int.parse(transactionId),
        super();

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isPending = false;

  // Read-only fields
  DateTime createdAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.transactionId <= 0) {
      return;
    }

    var response = await Provider.of<TransactionService>(context, listen: false)
        .get(widget.transactionId);
    if (response == null) {
      return;
    }
    var data = response;
    createdAt = data.createdAt;
    setState(() {
      _amountController.text = data.amount.toString();
      _titleController.text = data.title;
      _descriptionController.text = data.description;
      _timeController.text = dateFormat.format(data.time);
      _isPending = data.transactionStateId == 0;
    });
  }

  Future<void> _confirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete transaction"),
              content: const Text(
                  "Are you sure you want to delete this transaction?"),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackbar("Deleting..."),
                    );
                    await Provider.of<TransactionService>(context,
                            listen: false)
                        .delete(widget.transactionId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      context.pop();
                      context.pop();
                    }
                  },
                  child: const Text("Delete"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: widget.transactionId > 0
            ? const Text("Edit Transaction")
            : const Text("New Transaction"),
        actions: widget.transactionId > 0
            ? [
                IconButton(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete),
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _timeController.text = dateFormat.format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('Pending'),
                value: _isPending,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isPending = newValue ?? false;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackbar("Saving..."),
                    );

                    final Transaction transaction = Transaction(
                      id: widget.transactionId,
                      amount: int.parse(_amountController.text),
                      title: _titleController.text,
                      time: dateFormat.parse(_timeController.text),
                      transactionStateId: _isPending ? 0 : 1,
                    );
                    if (transaction.id > 0) {
                      await Provider.of<TransactionService>(context,
                              listen: false)
                          .update(transaction);
                    } else {
                      await Provider.of<TransactionService>(context,
                              listen: false)
                          .create(transaction);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      context.pop();
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SnackBar _buildSnackbar(String content) {
    return SnackBar(
      duration: const Duration(days: 1),
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Text(content),
        ],
      ),
    );
  }
}
