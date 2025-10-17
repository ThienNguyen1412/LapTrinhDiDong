import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';
import 'package:scheduling_application/services/user.dart';

class UsersAdminScreen extends StatefulWidget {
  const UsersAdminScreen({Key? key}) : super(key: key);

  @override
  State<UsersAdminScreen> createState() => _UsersAdminScreenState();
}

class _UsersAdminScreenState extends State<UsersAdminScreen> {
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  static const String _defaultAvatarUrl =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

  List<User> _allUsers = [];
  List<User> _users = [];
  bool _isInitialLoading = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = _searchController.text.trim().toLowerCase();
      if (q.isEmpty) {
        setState(() => _users = List<User>.from(_allUsers));
      } else {
        setState(() {
          _users = _allUsers.where((u) {
            final name = u.fullname.toLowerCase();
            final email = u.email.toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();
        });
      }
    });
  }

  // Simplified: service *always* returns List<User>
  Future<void> _fetchUsers() async {
    if (!mounted) return;
    setState(() {
      _isInitialLoading = true;
      _errorMessage = '';
    });

    try {
      final List<User> fetched = await _userService.getAllUsers();
      if (!mounted) return;
      setState(() {
        _allUsers = fetched;
        _users = List<User>.from(_allUsers);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _allUsers = [];
        _users = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi tải danh sách: ${e.toString()}')));
    } finally {
      if (!mounted) return;
      setState(() => _isInitialLoading = false);
    }
  }

  Future<void> _refresh() async => _fetchUsers();

  Future<void> _confirmDelete(User user) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có muốn xóa người dùng "${user.fullname}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Hủy')),
          ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (ok == true) {
      setState(() => _isLoading = true);
      try {
        await _userService.deleteUser(user.id);
        if (!mounted) return;
        setState(() {
          _allUsers.removeWhere((u) => u.id == user.id);
          _users.removeWhere((u) => u.id == user.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xóa thành công')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi xóa: ${e.toString()}')));
      } finally {
        if (!mounted) return;
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildUserTile(User user) {
    final initials = (user.fullname.isNotEmpty) ? user.fullname.trim()[0].toUpperCase() : '?';
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(_defaultAvatarUrl),
        child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Text(user.fullname),
      subtitle: Text(user.email),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            Navigator.pushNamed(context, '/update_profile', arguments: user).then((_) => _refresh());
          } else if (value == 'delete') {
            _confirmDelete(user);
          } else if (value == 'view') {
            Navigator.pushNamed(context, '/admin_user_detail', arguments: user);
          }
        },
        itemBuilder: (ctx) => const [
          PopupMenuItem(value: 'view', child: Text('Xem')),
          PopupMenuItem(value: 'edit', child: Text('Sửa')),
          PopupMenuItem(value: 'delete', child: Text('Xóa')),
        ],
      ),
      onTap: () => Navigator.pushNamed(context, '/admin_user_detail', arguments: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm tên hoặc email',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchTextChanged();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text('Lỗi: $_errorMessage'))
                    : _users.isEmpty
                        ? RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 120),
                                Center(child: Text('Không có người dùng')),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView.separated(
                              itemCount: _users.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                return _buildUserTile(user);
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'refresh_users',
              onPressed: _refresh,
              mini: true,
              backgroundColor: Colors.blueGrey,
              tooltip: 'Làm mới',
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: 'add_user',
              onPressed: () async {
                await Navigator.pushNamed(context, '/admin_create_user');
                _refresh();
              },
              tooltip: 'Thêm người dùng',
              child: const Icon(Icons.person_add),
            ),
          ],
        ),
      ),
    );
  }
}