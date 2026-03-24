import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/text_field.dart';
import '../providers/rooms_notifier.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _nameController =
      TextEditingController();
  String? _selectedFriendName;
  String? _selectedFriendId;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.isNotEmpty &&
      _selectedFriendId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/auth/bg-vector.png',
              fit: BoxFit.fitWidth,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/auth/bg-vector-login.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const CustomHeader(
                      title: 'Create A New Room',
                    ),
                    const SizedBox(height: 160),

                    AppTextField(
                      label: 'Room name',
                      hint: 'Our Super Room',
                      controller: _nameController,
                    ),

                    const SizedBox(height: 16),
                    _buildFriendSelector(),
                    const SizedBox(height: 40),

                    Center(
                      child: ElevatedButton(
                        onPressed: _isValid
                            ? () async {
                                await context
                                    .read<RoomsNotifier>()
                                    .createRoom(
                                      _selectedFriendId!,
                                      _nameController.text,
                                    );
                                if (mounted) context.pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.gray500,
                          minimumSize: const Size(230, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Send Invitation',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a friend',
          style: GoogleFonts.comfortaa(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await context.push<dynamic>(
              AppPages.chooseFriend.path,
            );
            if (result != null && result is Map) {
              setState(() {
                _selectedFriendName = result['username']
                    ?.toString();
                _selectedFriendId = result['id']?.toString();
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.25),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedFriendName ?? 'Select a friend',
                  style: TextStyle(
                    color: _selectedFriendName != null
                        ? AppColors.primary
                        : AppColors.primary.withValues(
                            alpha: 0.4,
                          ),
                    fontSize: 18,
                    fontWeight: _selectedFriendName != null
                        ? FontWeight.w500
                        : FontWeight.w300,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
