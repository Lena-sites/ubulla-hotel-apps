import 'package:flutter/material.dart';

class PriceFilterPopup extends StatefulWidget{
  final String? selectedPrice;
  final Function(String?) onApply;

  const PriceFilterPopup({
      super.key,
      required this.selectedPrice,
      required this.onApply
  });

  @override
  State<PriceFilterPopup> createState() => _PriceFilterPopupState();
}

class _PriceFilterPopupState extends State<PriceFilterPopup>{
  static const categories = [
    '< Rp 500.000',
    'Rp 500.000 - 1.500.000',
    '> Rp 1.500.000',
  ];

  String? selected;

  @override
  void initState(){
    super.initState();
    selected = widget.selectedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Harga / malam',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            RadioGroup<String>(
              groupValue: selected,
              onChanged: (v) => setState(() => selected = v),
              child: Column(
                children: [
                  for (final c in categories)
                    RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.green,
                      title: Text(c, style: const TextStyle(fontSize: 13)),
                      value: c,
                    ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => selected = null),
                  child: const Text('Reset',
                      style: TextStyle(color: Colors.grey)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => widget.onApply(selected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}