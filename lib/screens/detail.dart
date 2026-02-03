import 'package:exam_prep/model/model.dart';
import 'package:exam_prep/repository/repository.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final Payment item;
  final Repository repository;

  const Detail({super.key, required this.item, required this.repository});

  @override
  State<StatefulWidget> createState() => DetailState();
}

class DetailState extends State<Detail> {
  late TextEditingController _dateController;
  late TextEditingController _amountController;
  late TextEditingController _typeController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.item.date);
    _amountController = TextEditingController(
      text: widget.item.id == -1 ? "" : widget.item.amount.toString(),
    );
    _typeController = TextEditingController(text: widget.item.type);
    _categoryController = TextEditingController(text: widget.item.category);
    _descriptionController = TextEditingController(
      text: widget.item.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Date",
                errorText: _dateError,
                hintText: "YYYY-MM-DD",
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                errorText: _amountError,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: "Type",
                errorText: _typeError,
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: "Category",
                errorText: _categoryError,
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                errorText: _descriptionError,
              ),
              onChanged: (_) => setState(() {}),
            ),
            ElevatedButton(
              onPressed: (widget.item.id == -1 && _isFormValid)
                  ? _saveChanges
                  : null,
              child: Text("Save Changes"),
            ),
            ElevatedButton(onPressed: _back, child: Text("Back")),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    widget.item.date = _dateController.text;
    widget.item.amount = int.parse(_amountController.text);
    widget.item.type = _typeController.text;
    widget.item.category = _categoryController.text;
    widget.item.description = _descriptionController.text;

    try {
      await widget.repository.create(widget.item);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _back() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String? get _dateError {
    final text = _dateController.text;
    if (text.isEmpty) return 'Date cannot be empty';
    final dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegExp.hasMatch(text)) return 'Format must be YYYY-MM-DD';
    try {
      DateTime.parse(text);
      return null;
    } catch (e) {
      return 'Invalid date';
    }
  }

  String? get _amountError {
    final text = _amountController.text;
    if (text.isEmpty) return 'Amount cannot be empty';
    if (int.tryParse(text) == null) return 'Must be a valid number';
    return null;
  }

  String? get _typeError {
    return _typeController.text.isEmpty ? 'Type cannot be empty' : null;
  }

  String? get _categoryError {
    return _categoryController.text.isEmpty ? 'Category cannot be empty' : null;
  }

  String? get _descriptionError {
    return _descriptionController.text.isEmpty
        ? 'Description cannot be empty'
        : null;
  }

  bool get _isFormValid {
    return _dateError == null &&
        _amountError == null &&
        _typeError == null &&
        _categoryError == null &&
        _descriptionError == null;
  }
}
