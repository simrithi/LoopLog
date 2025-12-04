import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [
    {
      "id": "ORD-001",
      "customer": "Ananya Sharma",
      "product": "Handloom Saree",
      "quantity": 2,
      "price": 3500.0,
      "orderStatus": "Pending",
      "paymentStatus": "Not Paid",
      "date": "2025-11-01",
    },
    {
      "id": "ORD-002",
      "customer": "Ravi Kumar",
      "product": "Cotton Kurta Set",
      "quantity": 1,
      "price": 1200.0,
      "orderStatus": "Shipped",
      "paymentStatus": "Paid",
      "date": "2025-10-28",
    },
    {
      "id": "ORD-003",
      "customer": "Meena Patel",
      "product": "Designer Blouse",
      "quantity": 3,
      "price": 850.0,
      "orderStatus": "In Progress",
      "paymentStatus": "Paid",
      "date": "2025-10-30",
    },
    {
      "id": "ORD-004",
      "customer": "Arjun Verma",
      "product": "Silk Dupatta",
      "quantity": 1,
      "price": 2100.0,
      "orderStatus": "Completed",
      "paymentStatus": "Not Paid",
      "date": "2025-10-25",
    },
    {
      "id": "ORD-005",
      "customer": "Priya Reddy",
      "product": "Embroidered Lehenga",
      "quantity": 1,
      "price": 8500.0,
      "orderStatus": "Pending",
      "paymentStatus": "Paid",
      "date": "2025-11-02",
    },
  ];

  String searchQuery = '';
  String filterStatus = 'All';

  void _togglePaymentStatus(int index) {
    setState(() {
      orders[index]['paymentStatus'] =
      orders[index]['paymentStatus'] == 'Paid' ? 'Not Paid' : 'Paid';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment status updated to ${orders[index]['paymentStatus']}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Color(0xFF1E293B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = orders.where((order) {
      bool matchesSearch = order['customer']
          .toLowerCase()
          .contains(searchQuery.toLowerCase()) ||
          order['product'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          order['id'].toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesFilter = filterStatus == 'All' ||
          order['orderStatus'] == filterStatus;

      return matchesSearch && matchesFilter;
    }).toList();

    // Calculate stats
    int totalOrders = orders.length;
    int pendingOrders = orders.where((o) => o['orderStatus'] == 'Pending').length;
    double totalValue = orders.fold(0.0, (sum, o) =>
    sum + (o['price'] * o['quantity']));

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orders',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${filteredOrders.length} orders found',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exporting orders...'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.download),
                      label: Text('Export'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF6366F1),
                        side: BorderSide(color: Color(0xFF6366F1)),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('New Order form coming soon!'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text('New Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Orders',
                    totalOrders.toString(),
                    Icons.shopping_bag,
                    Color(0xFF6366F1),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pendingOrders.toString(),
                    Icons.pending_actions,
                    Color(0xFFF59E0B),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Value',
                    '₹${totalValue.toStringAsFixed(0)}',
                    Icons.currency_rupee,
                    Color(0xFF10B981),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Search and Filter Bar
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search orders, customers, products...',
                        hintStyle: GoogleFonts.inter(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list,
                          size: 20, color: Color(0xFF64748B)),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        value: filterStatus,
                        underline: SizedBox(),
                        style: GoogleFonts.inter(
                          color: Color(0xFF1E293B),
                          fontSize: 14,
                        ),
                        items: ['All', 'Pending', 'In Progress', 'Completed', 'Shipped']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (val) => setState(() => filterStatus = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Orders List
            filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredOrders.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final originalIndex = orders.indexOf(order);
                return OrderCard(
                  order: order,
                  onTap: () => _togglePaymentStatus(originalIndex),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 48),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;

  const OrderCard({
    required this.order,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Color(0xFFF59E0B);
      case "In Progress":
        return Color(0xFF3B82F6);
      case "Completed":
        return Color(0xFF10B981);
      case "Shipped":
        return Color(0xFF8B5CF6);
      default:
        return Color(0xFF64748B);
    }
  }

  Color _getPaymentColor(String payment) {
    return payment == "Paid" ? Color(0xFF10B981) : Color(0xFFEF4444);
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Pending":
        return Icons.schedule;
      case "In Progress":
        return Icons.sync;
      case "Completed":
        return Icons.check_circle;
      case "Shipped":
        return Icons.local_shipping;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = order['price'] * order['quantity'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              order['id'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order['date'],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          order['customer'],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['orderStatus'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getStatusIcon(order['orderStatus']),
                      color: _getStatusColor(order['orderStatus']),
                      size: 24,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Product Details
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            order['product'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Quantity',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '× ${order['quantity']}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Footer Row with Status and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order['orderStatus'])
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _getStatusColor(order['orderStatus']),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              order['orderStatus'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(order['orderStatus']),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getPaymentColor(order['paymentStatus'])
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              order['paymentStatus'] == 'Paid'
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              size: 14,
                              color: _getPaymentColor(order['paymentStatus']),
                            ),
                            SizedBox(width: 4),
                            Text(
                              order['paymentStatus'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getPaymentColor(order['paymentStatus']),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '₹${order['price'].toStringAsFixed(2)} each',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}