import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({ required this.onAddExpense, super.key});
final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();}
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text
        .trim()
        .isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please recheck the entered values'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("okay"),
              )
            ],
          );
        },
      );
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text,amount:enteredAmount,date: _selectedDate!,category: _selectedCategory));
  }



  @override
  Widget build(context) {
  return Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
  children: [
  TextField(
  controller: _titleController,
  maxLength: 50,
  decoration: const InputDecoration(
  label: Text(
  "Title",
  style: TextStyle(fontWeight: FontWeight.bold),
  )),
  ),
  Row(
  children: [
  Expanded(
  child: TextField(
  controller: _amountController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
  prefixText: '\$ ',
  label: Text(
  "Amount",
  style: TextStyle(fontWeight: FontWeight.bold),
  )),
  ),
  ),
  const SizedBox(
  width: 15,
  ),
  Expanded(
  child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
  Text(_selectedDate == null
  ? 'NO Date Selected'
      : Formatter.format(_selectedDate!)),
  IconButton(
  onPressed: _presentDatePicker,
  icon: const Icon(Icons.calendar_month),
  ),
  ],
  ),
  ),
  ],
  ),
  const SizedBox(
  height: 15,
  ),
  Row(
  children: [
  DropdownButton(
  value: _selectedCategory,
  items: Category.values.map((category) {
  return DropdownMenuItem(
  value: category,
  child: Text(category.name.toUpperCase()),
  );
  }).toList(),
  onChanged: (value) {
  if (value == null)
  return;
  else {
  setState(() {
  _selectedCategory = value;
  });
  }
  }),
  const Spacer(),
  ElevatedButton(
  onPressed: () {
  Navigator.pop(context);
  },
  child: Text('cancel')),
  const Spacer(),
  ElevatedButton(
  onPressed:_submitExpenseData,

  child: const Text('save amount'),
  ),
  ],
  ),
  ],
  ),
  );
  }
}
