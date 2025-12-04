import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(LoopLogApp());
}

class Order {
  String id;
  String productName;
  int quantity;
  double price;
  String customerName;
  String orderStatus;
  String paymentStatus;
  String notes;
  DateTime createdAt;

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.customerName,
    this.orderStatus = "Pending",
    this.paymentStatus = "Not Paid",
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class InventoryItem {
  String id;
  String name;
  int stock;
  bool isMaterial;

  InventoryItem({
    required this.id,
    required this.name,
    required this.stock,
    required this.isMaterial,
  });
}

class AppState extends ChangeNotifier {
  final List<Order> _orders = [
    Order(id: '1', productName: 'T-Shirt', quantity: 2, price: 550, customerName: 'John Doe', orderStatus: 'Completed', paymentStatus: 'Paid'),
    Order(id: '2', productName: 'Mug', quantity: 5, price: 250, customerName: 'Jane Smith', orderStatus: 'Pending'),
  ];
  final List<InventoryItem> _inventory = [
    InventoryItem(id: '1', name: 'Cotton Fabric', stock: 20, isMaterial: true),
    InventoryItem(id: '2', name: 'T-Shirt', stock: 4, isMaterial: false),
    InventoryItem(id: '3', name: 'Mug', stock: 50, isMaterial: false),
  ];

  List<Order> get orders => _orders;
  List<InventoryItem> get inventory => _inventory;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrder(Order order) {
    notifyListeners();
  }

  void deleteOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  void addInventoryItem(InventoryItem item) {
    _inventory.add(item);
    notifyListeners();
  }

  void deleteInventoryItem(String id) {
    _inventory.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}

class LoopLogApp extends StatelessWidget {
  final AppState appState = AppState();

  LoopLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => appState,
      child: MaterialApp(
        title: 'LoopLog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF10B981),
            surface: Colors.white,
            background: const Color(0xFFF8FAFC),
          ),
          textTheme: GoogleFonts.interTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        home: const HomeDashboard(),
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardView(),
      const OrdersPage(),
      const InventoryPage(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              extended: MediaQuery.of(context).size.width > 800,
              backgroundColor: Colors.white,
              selectedIconTheme: const IconThemeData(
                color: Color(0xFF6366F1),
                size: 24,
              ),
              unselectedIconTheme: const IconThemeData(
                color: Color(0xFF64748B),
                size: 22,
              ),
              selectedLabelTextStyle: GoogleFonts.inter(
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelTextStyle: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 12,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.loop, color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 6),
                    if (MediaQuery.of(context).size.width > 800)
                      Text(
                        'LoopLog',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: Text('Orders'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text('Inventory'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFE2E8F0)),
            Expanded(
              child: pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    int totalOrders = appState.orders.length;
    int pendingOrders = appState.orders.where((o) => o.orderStatus == 'Pending').length;
    int completedOrders = appState.orders.where((o) => o.orderStatus == 'Completed').length;
    int lowStock = appState.inventory.where((i) => i.stock <= 5).length;
    double totalRevenue = appState.orders
        .where((o) => o.paymentStatus == 'Paid')
        .fold(0.0, (sum, o) => sum + (o.price * o.quantity));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome back! Here\'s your business overview',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  StatCard(
                    title: 'Total Orders',
                    value: totalOrders.toString(),
                    icon: Icons.shopping_cart,
                    color: const Color(0xFF6366F1),
                    trend: '+12%',
                  ),
                  StatCard(
                    title: 'Pending Orders',
                    value: pendingOrders.toString(),
                    icon: Icons.pending_actions,
                    color: const Color(0xFFF59E0B),
                    trend: '${pendingOrders > 0 ? pendingOrders : 0} active',
                  ),
                  StatCard(
                    title: 'Completed',
                    value: completedOrders.toString(),
                    icon: Icons.check_circle,
                    color: const Color(0xFF10B981),
                    trend: '+8%',
                  ),
                  StatCard(
                    title: 'Low Stock Alert',
                    value: lowStock.toString(),
                    icon: Icons.warning,
                    color: const Color(0xFFEF4444),
                    trend: 'Needs attention',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    _buildRevenueCard(totalRevenue),
                    const SizedBox(height: 12),
                    _buildQuickActionsCard(context),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRevenueCard(totalRevenue)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickActionsCard(context)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(double totalRevenue) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.payments, color: Color(0xFF10B981), size: 20),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Revenue',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '₹${totalRevenue.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddOrderPage()),
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('New Order'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
              icon: const Icon(Icons.add_box, size: 16),
              label: const Text('Add Product'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                side: const BorderSide(color: Color(0xFF6366F1)),
                foregroundColor: const Color(0xFF6366F1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trend,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String searchQuery = '';
  String filterStatus = 'All';

  Future<void> _exportPdf(List<Order> orders) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Text('Orders List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ['Customer', 'Product', 'Qty', 'Price', 'Status', 'Payment'],
              data: orders.map((o) => [
                o.customerName,
                o.productName,
                o.quantity.toString(),
                o.price.toStringAsFixed(2),
                o.orderStatus,
                o.paymentStatus,
              ]).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    List<Order> filteredOrders = appState.orders.where((order) {
      bool matchesSearch = order.customerName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          order.productName.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesFilter = filterStatus == 'All' || order.orderStatus == filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filteredOrders.length} orders found',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _exportPdf(filteredOrders),
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: const Text('Export PDF', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6366F1),
                          side: const BorderSide(color: Color(0xFF6366F1)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddOrderPage()),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New Order', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orders',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${filteredOrders.length} orders found',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _exportPdf(filteredOrders),
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text('Export PDF', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6366F1),
                        side: const BorderSide(color: Color(0xFF6366F1)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddOrderPage()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New Order', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search orders...',
                      hintStyle: TextStyle(fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: filterStatus,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
                      items: ['All', 'Pending', 'In Progress', 'Completed', 'Shipped']
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (val) => setState(() => filterStatus = val!),
                    ),
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search orders...',
                      hintStyle: TextStyle(fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButton<String>(
                    value: filterStatus,
                    underline: const SizedBox(),
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
                    items: ['All', 'Pending', 'In Progress', 'Completed', 'Shipped']
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => filterStatus = val!),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        if (filteredOrders.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  const Icon(Icons.inbox, size: 48, color: Color(0xFFCBD5E1)),
                  const SizedBox(height: 12),
                  Text(
                    'No orders found',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...filteredOrders.map((order) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: OrderCard(order: order),
          )).toList(),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return const Color(0xFFF59E0B);
      case "In Progress":
        return const Color(0xFF3B82F6);
      case "Completed":
        return const Color(0xFF10B981);
      case "Shipped":
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getPaymentColor(String payment) {
    return payment == "Paid" ? const Color(0xFF10B981) : const Color(0xFFEF4444);
  }

  void _showUpdateDialog(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    String currentStatus = order.orderStatus;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Order Status', style: GoogleFonts.inter(fontSize: 16)),
          content: DropdownButton<String>(
            value: currentStatus,
            isExpanded: true,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
            items: ['Pending', 'In Progress', 'Completed', 'Shipped']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                order.orderStatus = val;
                appState.updateOrder(order);
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 13)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _showUpdateDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 500) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_bag,
                            color: _getStatusColor(order.orderStatus),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerName,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E293B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${order.productName} × ${order.quantity}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.orderStatus,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(order.orderStatus),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getPaymentColor(order.paymentStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.paymentStatus,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getPaymentColor(order.paymentStatus),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${(order.price * order.quantity).toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '₹${order.price.toStringAsFixed(2)} each',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      color: _getStatusColor(order.orderStatus),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${order.productName} × ${order.quantity}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6.0,
                          runSpacing: 4.0,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.orderStatus,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(order.orderStatus),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getPaymentColor(order.paymentStatus).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.paymentStatus,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getPaymentColor(order.paymentStatus),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${(order.price * order.quantity).toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '₹${order.price.toStringAsFixed(2)} each',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(20),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filteredItems.length} items in stock',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddProductPage()),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Item', style: TextStyle(fontSize: 12)),
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${filteredItems.length} items in stock',
                        style: GoogleFonts.inter(
                          fontSize: 12,
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
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Item', style: TextStyle(fontSize: 12)),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search inventory...',
                      hintStyle: TextStyle(fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: filterType,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
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
              );
            }
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search inventory...',
                      hintStyle: TextStyle(fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButton<String>(
                    value: filterType,
                    underline: const SizedBox(),
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
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
            );
          },
        ),
        const SizedBox(height: 16),
        if (filteredItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2, size: 48, color: Color(0xFFCBD5E1)),
                  const SizedBox(height: 12),
                  Text(
                    'No inventory items found',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, i) {
                  final item = filteredItems[i];
                  return InventoryCard(item: item);
                },
              );
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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.isMaterial
                        ? const Color(0xFFF59E0B).withOpacity(0.1)
                        : const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    iconData,
                    color: item.isMaterial ? const Color(0xFFF59E0B) : const Color(0xFF6366F1),
                    size: 20,
                  ),
                ),
                if (lowStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Low',
                      style: GoogleFonts.inter(
                        fontSize: 9,
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
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  typeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stock',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      item.stock.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 18,
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

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();

  String productName = '';
  int quantity = 1;
  double price = 0.0;
  String customerName = '';
  String orderStatus = 'Pending';
  String paymentStatus = 'Not Paid';
  String notes = '';

  final List<String> orderStatuses = ['Pending', 'In Progress', 'Completed', 'Shipped'];
  final List<String> paymentStatuses = ['Not Paid', 'Paid'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Add New Order',
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Order Details',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Customer Name',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.person, size: 20),
                        ),
                        onSaved: (val) => customerName = val!.trim(),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.shopping_bag, size: 20),
                        ),
                        onSaved: (val) => productName = val!.trim(),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                labelStyle: TextStyle(fontSize: 13),
                                prefixIcon: Icon(Icons.numbers, size: 20),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue: '1',
                              onSaved: (val) => quantity = int.tryParse(val ?? '1') ?? 1,
                              validator: (val) {
                                int? q = int.tryParse(val ?? '');
                                if (q == null || q <= 0) return 'Enter valid quantity';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(
                                labelText: 'Price (₹)',
                                labelStyle: TextStyle(fontSize: 13),
                                prefixIcon: Icon(Icons.currency_rupee, size: 20),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onSaved: (val) => price = double.tryParse(val ?? '0') ?? 0,
                              validator: (val) {
                                double? p = double.tryParse(val ?? '');
                                if (p == null || p < 0) return 'Enter valid price';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          labelText: 'Order Status',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.info, size: 20),
                        ),
                        value: orderStatus,
                        items: orderStatuses
                            .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                            .toList(),
                        onChanged: (val) => setState(() => orderStatus = val!),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          labelText: 'Payment Status',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.payment, size: 20),
                        ),
                        value: paymentStatus,
                        items: paymentStatuses
                            .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                            .toList(),
                        onChanged: (val) => setState(() => paymentStatus = val!),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Notes (Optional)',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.note, size: 20),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        onSaved: (val) => notes = val?.trim() ?? '',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 42),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                                foregroundColor: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                _formKey.currentState!.save();

                                final appState = Provider.of<AppState>(context, listen: false);
                                appState.addOrder(Order(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  productName: productName,
                                  quantity: quantity,
                                  price: price,
                                  customerName: customerName,
                                  orderStatus: orderStatus,
                                  paymentStatus: paymentStatus,
                                  notes: notes,
                                ));

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Order created successfully', style: TextStyle(fontSize: 13)),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Create Order', style: TextStyle(fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 42),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int stock = 0;
  bool isMaterial = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Add Inventory Item',
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Item Details',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.label, size: 20),
                        ),
                        onSaved: (val) => name = val!.trim(),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          labelText: 'Stock Quantity',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.inventory, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (val) => stock = int.tryParse(val ?? '0') ?? 0,
                        validator: (val) {
                          int? s = int.tryParse(val ?? '');
                          if (s == null || s < 0) return 'Enter valid stock';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isMaterial ? Icons.category : Icons.inventory_2,
                              color: const Color(0xFF6366F1),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item Type',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    isMaterial ? 'Raw Material' : 'Finished Product',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isMaterial,
                              onChanged: (val) => setState(() => isMaterial = val),
                              activeColor: const Color(0xFF6366F1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 42),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                                foregroundColor: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                _formKey.currentState!.save();

                                final appState = Provider.of<AppState>(context, listen: false);
                                appState.addInventoryItem(InventoryItem(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  name: name,
                                  stock: stock,
                                  isMaterial: isMaterial,
                                ));

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Item added successfully', style: TextStyle(fontSize: 13)),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Add Item', style: TextStyle(fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 42),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}