import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/models/payment.dart';
import 'package:mamicoach_mobile/services/payment_service.dart';
import 'package:mamicoach_mobile/screens/payment_webview_page.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PaymentMethodSelectionPage extends StatefulWidget {
  final int bookingId;
  final int amount;

  const PaymentMethodSelectionPage({
    super.key,
    required this.bookingId,
    required this.amount,
  });

  @override
  State<PaymentMethodSelectionPage> createState() =>
      _PaymentMethodSelectionPageState();
}

class _PaymentMethodSelectionPageState
    extends State<PaymentMethodSelectionPage> {
  String? _selectedMethod;
  bool _isProcessing = false;

  final Map<String, List<PaymentMethod>> _methodsByCategory = {
    'E-Wallet': PaymentMethod.getMethodsByCategory('e-wallet'),
    'QRIS': PaymentMethod.getMethodsByCategory('qr-code'),
    'Virtual Account': PaymentMethod.getMethodsByCategory('virtual_account'),
    'Kartu Kredit': PaymentMethod.getMethodsByCategory('credit_card'),
    'Convenience Store': PaymentMethod.getMethodsByCategory('convenience_store'),
    'Cicilan': PaymentMethod.getMethodsByCategory('installment'),
  };

  Future<void> _processPayment() async {
    if (_selectedMethod == null) {
      _showSnackBar('Silakan pilih metode pembayaran', isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final request = context.read<CookieRequest>();
      final response = await PaymentService.processPayment(
        request,
        widget.bookingId,
        _selectedMethod!,
      );

      if (!mounted) return;

      if (response.success && response.redirectUrl != null) {
        // Open WebView for payment
        final result = await Navigator.push<bool?>(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebViewPage(
              paymentUrl: response.redirectUrl!,
              paymentId: response.paymentId!,
            ),
          ),
        );

        if (!mounted) return;

        // Return result to previous screen
        Navigator.pop(context, result);
      } else {
        _showErrorDialog(
          response.error ?? 'Gagal memproses pembayaran',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Gagal Memproses Pembayaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Amount info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatCurrency(widget.amount)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Payment methods list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildPaymentMethodSections(),
            ),
          ),

          // Pay button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Bayar Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentMethodSections() {
    List<Widget> sections = [];

    _methodsByCategory.forEach((category, methods) {
      if (methods.isNotEmpty) {
        sections.add(_buildCategorySection(category, methods));
        sections.add(const SizedBox(height: 16));
      }
    });

    return sections;
  }

  Widget _buildCategorySection(String category, List<PaymentMethod> methods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: methods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              final isLast = index == methods.length - 1;
              return _buildPaymentMethodTile(method, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method, bool isLast) {
    final isSelected = _selectedMethod == method.code;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method.code;
        });
      },
      borderRadius: BorderRadius.vertical(
        top: isLast && isSelected ? Radius.zero : const Radius.circular(12),
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(bottom: BorderSide(color: Colors.grey[200]!))
              : null,
          color: isSelected ? AppColors.primaryGreen.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            // Logo image or icon
            Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: method.logoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        method.logoUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getPaymentIcon(method.category),
                            color: AppColors.primaryGreen,
                            size: 24,
                          );
                        },
                      ),
                    )
                  : Icon(
                      _getPaymentIcon(method.category),
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 16),
            // Method name
            Expanded(
              child: Text(
                method.displayName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryGreen : Colors.grey[800],
                ),
              ),
            ),
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryGreen : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String category) {
    switch (category) {
      case 'e-wallet':
        return Icons.account_balance_wallet;
      case 'qr-code':
        return Icons.qr_code_2;
      case 'virtual_account':
        return Icons.account_balance;
      case 'credit_card':
        return Icons.credit_card;
      case 'convenience_store':
        return Icons.store;
      case 'installment':
        return Icons.payment;
      default:
        return Icons.payments;
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
