import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_sales/src/models/item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  String? currentUserId;
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId();
    isAvailable = widget.item.isAvailable;
  }

  void fetchCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  Future<void> _toggleAvailability(bool availability) async {
    try {
      await FirebaseFirestore.instance
          .collection('cattle')
          .doc(widget.item.id)
          .update({'isAvailable': availability});

      setState(() {
        isAvailable = availability;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            availability ? "Item disponível!" : "Item marcado como indisponível!",
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar disponibilidade!")),
      );
    }
  }

  Future<void> _openPhone(BuildContext context) async {
    const String phoneNumber = "+5511999999999";
    final Uri uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao abrir o telefone!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSeller = widget.item.sellerId == currentUserId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.item.itemName ?? "Detalhes do Item"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (widget.item.imgUrl != null && widget.item.imgUrl!.isNotEmpty)
                    ? Image.network(
                        widget.item.imgUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                        },
                      )
                    : const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.monetization_on, "Preço",
                        "R\$${widget.item.price?.toStringAsFixed(2) ?? '0.00'}"),
                    _buildInfoRow(Icons.format_list_numbered, "Unidade",
                        widget.item.unit?.toString() ?? "Não especificada"),
                    _buildInfoRow(Icons.cake, "Idade",
                        "${widget.item.age ?? 'Não especificada'} meses"),
                    _buildInfoRow(Icons.balance, "Peso",
                        "${widget.item.weight?.toStringAsFixed(1) ?? 'Não especificado'} kg"),
                    _buildInfoRow(Icons.location_on, "Localização",
                        widget.item.location ?? "Não especificada"),
                    _buildInfoRow(Icons.description, "Descrição",
                        widget.item.description ?? "Sem descrição"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (isSeller && isAvailable)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _toggleAvailability(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Retirar Publicação",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (isSeller && !isAvailable)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _toggleAvailability(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Recolocar Publicação",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openPhone(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: const Text(
                    "Falar com o vendedor",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
