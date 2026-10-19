class AppAvatarService {
  // final AppStorageService _appStorageService;
  final int selectedAvatarId;

  final Map<int, String> _getAvailableAvatars = {
    1: 'assets/avatars/avatar01x128.png',
    2: 'assets/avatars/avatar02x128.png',
    3: 'assets/avatars/avatar03x128.png',
    4: 'assets/avatars/avatar04x128.png',
    5: 'assets/avatars/avatar05x128.png',
    6: 'assets/avatars/avatar06x128.png',
    7: 'assets/avatars/avatar07x128.png',
    8: 'assets/avatars/avatar08x128.png',
    9: 'assets/avatars/avatar09x128.png',
    10: 'assets/avatars/avatar10x128.png',
    11: 'assets/avatars/avatar11x128.png',
    12: 'assets/avatars/avatar12x128.png',
  };

  AppAvatarService({
    this.selectedAvatarId = 1,
    // required this._appStorageService,
  });

  String getAvatarAssetPath(int avatarId) {
    return _getAvailableAvatars[avatarId] ??
        'assets/icons/assets/avatars/food.png';
  }

  String getSelectedAvatarAssetPath() {
    return getAvatarAssetPath(selectedAvatarId);
  }
}
