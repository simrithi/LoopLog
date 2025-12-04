import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// You will need to import the other class definitions from your main file
// or move them to their own files as well.
import 'main.dart'; // This imports AppState, Order, and InventoryItem
 // Assuming you've moved AddProductPage to its own file

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String searchQuery = '';
  String filterType = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    List<InventoryItem> filteredItems = appState.inventory.where((item) {
      bool matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesFilter = filterType == 'All' ||
          (filterType == 'Products' && !item.isMaterial) ||
          (filterType == 'Materials' && item.isMaterial);
      return matchesSearch && matchesFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX: Wrapped the title in Expanded to prevent overflow with button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filteredItems.length} items in stock',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search inventory...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
                ),
                onChanged: (val) => setState(() => searchQuery = val),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButton<String>(
                value: filterType,
                underline: const SizedBox(),
                items: ['All', 'Products', 'Materials']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (val) => setState(() => filterType = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (filteredItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2, size: 64, color: Color(0xFFCBD5E1)),
                  const SizedBox(height: 16),
                  Text(
                    'No inventory items found',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2, // Adjusted aspect ratio to prevent overflow
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, i) {
              final item = filteredItems[i];
              return InventoryCard(item: item);
            },
          ),
      ],
    );
  }
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final lowStock = item.stock <= 5;
    final iconData = item.isMaterial ? Icons.category : Icons.inventory_2;
    final typeLabel = item.isMaterial ? 'Raw Material' : 'Finished Product';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.isMaterial
                        ? const Color(0xFFF59E0B).withOpacity(0.1)
                        : const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconData,
                    color: item.isMaterial ? const Color(0xFFF59E0B) : const Color(0xFF6366F1),
                    size: 24,
                  ),
                ),
                if (lowStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Low',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  typeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stock',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      item.stock.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: lowStock ? const Color(0xFFEF4444) : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

