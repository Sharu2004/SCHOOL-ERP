import 'package:flutter/material.dart';
import '../models/fee.dart';
import '../services/api_service.dart';

class FeeScreen extends StatefulWidget {
  const FeeScreen({super.key});

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  final _studentIdController = TextEditingController(text: '1');
  List<Fee> _fees = [];
  bool _loading = false;

  Future<void> _loadFees() async {
    setState(() => _loading = true);
    final id = int.tryParse(_studentIdController.text) ?? 1;
    final fees = await ApiService.getFees(id);
    setState(() { _fees = fees; _loading = false; });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid': return Colors.green;
      case 'partial': return Colors.orange;
      default: return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fee Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(labelText: 'Student ID', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _loadFees, child: const Text('Load')),
              ],
            ),
          ),
          if (_loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _fees.length,
              itemBuilder: (context, i) {
                final f = _fees[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(f.term),
                    subtitle: Text('Due: ₹${f.amountDue.toStringAsFixed(2)}  •  Paid: ₹${f.amountPaid.toStringAsFixed(2)}'),
                    trailing: Chip(
                      label: Text(f.status.toUpperCase(), style: const TextStyle(color: Colors.white)),
                      backgroundColor: _statusColor(f.status),
                    ),
                    onTap: f.status != 'paid' ? () => _payDialog(f) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _payDialog(Fee fee) {
    final amountCtrl = TextEditingController(text: fee.balance.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pay - ${fee.term}'),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text) ?? 0;
              await ApiService.payFee(fee.id, amount);
              if (context.mounted) Navigator.pop(context);
              _loadFees();
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }
}
