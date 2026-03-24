import 'package:flutter/material.dart';
import 'package:zvycha_frontend/core/theme/app_colors.dart';

class AppSearchField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onSearch;

  const AppSearchField({
    super.key,
    this.hint,
    this.controller,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final searchController =
        controller ?? TextEditingController();

    return TextField(
      controller: searchController,
      onSubmitted: onSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        hintStyle: const TextStyle(
          color: AppColors.gray300,
          fontWeight: FontWeight.w300,
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.search,
            color: AppColors.gray500,
          ),
          onPressed: () {
            if (onSearch != null) {
              onSearch!(searchController.text);
            }
          },
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.gray300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gray500),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
