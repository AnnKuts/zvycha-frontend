enum AppPages {
  loading('/loading'),
  welcome('/welcome'),
  login('/login'),
  signup('/signup'),
  
  rooms('/rooms'),
  createRoom('/rooms/create'),
  chooseFriend('/rooms/create/choose-friend'),
  roomDetails('details/:roomId'),

  invitationsReceived('/invitations/received'),
  invitationsSent('/invitations/sent'),
  acceptInvitation('/accept-invitation/:roomId'),

  friendsYours('/friends/yours'),
  friendsFind('/friends/find'),
  settings('/settings');

  const AppPages(this.path, {this.parent});
  final String path;
  final AppPages? parent;

  String get fullPath {
    if (parent == null) return path;

    final parentPath = parent!.fullPath;

    if (parentPath.endsWith('/')) {
      return '$parentPath$path';
    } else {
      return '$parentPath/$path';
    }
  }

  String withParams(Map<String, String> params) {
    var result = fullPath;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }
}
