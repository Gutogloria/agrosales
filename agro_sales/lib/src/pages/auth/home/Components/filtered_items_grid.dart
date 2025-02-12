import 'package:flutter/material.dart';
import 'package:agro_sales/src/models/item_model.dart';

class FilteredItemsGrid extends StatelessWidget {
  final List<ItemModel> items;
  final String currentUserId;
  final Function(ItemModel) onItemSelected;

  const FilteredItemsGrid({
    super.key,
    required this.items,
    required this.currentUserId,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onItemSelected(item),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: item.imgUrl != null && item.imgUrl!.isNotEmpty
                      ? Image.network(
                          item.imgUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName ?? 'Sem Nome',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (item.weight != null)
                        Row(
                          children: [
                            const Icon(Icons.balance, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${item.weight?.toStringAsFixed(1)} kg',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      if (item.age != null)
                        Row(
                          children: [
                            const Icon(Icons.cake, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${item.age} meses',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      if (item.location != null)
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.location!,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
