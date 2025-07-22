import 'package:flutter/material.dart';

class KothaListeningNonLoadingWidget extends StatelessWidget {
  final String responseText;

  const KothaListeningNonLoadingWidget({
    super.key,
    required this.responseText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                responseText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
      
      ],
    );
  }
}
