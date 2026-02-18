import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/asym_card.dart';

class ProviderListItem extends StatelessWidget {
  const ProviderListItem({
    super.key,
    required this.imageUrl,
    required this.providerName,
    required this.rating,
    required this.location,
    required this.distance,
    required this.price,
    required this.priceUnit,
    required this.status,
  });

  final String imageUrl;
  final String providerName;
  final double rating;
  final String location;
  final String distance;
  final double price;
  final String priceUnit;
  final String status; // VERIFIED or OFFLINE

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;

    if (status == 'VERIFIED') {
      statusBgColor = Colors.blue.shade50;
      statusTextColor = Theme.of(context).colorScheme.primary;
    } else {
      statusBgColor = Colors.grey.shade100;
      statusTextColor = Colors.grey.shade500;
    }

    return AsymCard(
      color: Theme.of(context).cardColor,
      borderColor: Theme.of(context).dividerColor,
      borderWidth: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      elevation: 5,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16), // Rounded-2xl from html
            child: Image.network(
              imageUrl,
              width: 64, // w-16
              height: 80, // h-20
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber.shade500,
                        ),
                        Text(
                          rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                color: Colors.amber.shade500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$location • $distance',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(height: 8), // Spacer between location and price/status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${price.toStringAsFixed(0)} ETB',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '/$priceUnit',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: statusTextColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
