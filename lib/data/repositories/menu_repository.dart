import 'package:movo/data/dao/menu_item_dao.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/interfaces/menu_repository_interface.dart';

class MenuRepository implements IMenuRepository {
  final MenuDao _menuDao;

  MenuRepository(this._menuDao);

  Future<List<MenuItemTableData>> getDemoMenuItems() async {
    final List<MenuItemTableData> menuItems = [];

    menuItems.addAll([
      MenuItemTableData(
        createdAt: DateTime(2024, 6, 1),
        isActive: true,
        id: '1',
        name: 'Cheeseburger',
        description: 'A delicious cheeseburger with all the fixings.',
        prices: [5, 7, 9],
        displayOrder: 1,
        icon: '🍔',
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      ),
      MenuItemTableData(
        createdAt: DateTime(2024, 6, 1),
        isActive: true,
        id: '2',
        name: 'Pizza',
        description: 'A classic pizza with your favorite toppings.',
        prices: [8, 10, 12],
        displayOrder: 2,
        icon: '🍕',
        imageUrl: 'https://images.unsplash.com/photo-1601924582975-6e3f0b7e4c1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      ),
      MenuItemTableData(
        createdAt: DateTime(2024, 6, 1),
        isActive: true,
        id: '3',
        name: 'Sushi',
        description: 'Fresh sushi rolls made with the finest ingredients.',
        prices: [12, 15, 18],
        displayOrder: 3,
        icon: '🍣',
        imageUrl: 'https://images.unsplash.com/photo-1562967916-eb82221dfb36?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      ),
    ]);
    return menuItems;
  }

  @override
  Stream<List<MenuItemTableData>> watchAllMenu() {
    return _menuDao.watchAllMenu();
  }

  @override
  Future<List<MenuItemTableData>> getAllMenu() {
    return _menuDao.getAllMenu();
  }

  @override
  Stream<List<MenuItemTableData>> watchActiveMenu() {
    return _menuDao.watchMenuByStatus(true);
  }

  @override
  Future<List<MenuItemTableData>> getActiveMenu() {
    return _menuDao.getMenuByStatus(true);
  }

  @override
  Stream<List<MenuItemTableData>> watchInactiveMenu() {
    return _menuDao.watchMenuByStatus(false);
  }

  @override
  Future<List<MenuItemTableData>> getInactiveMenu() {
    return _menuDao.getMenuByStatus(false);
  }

  @override
  Future<MenuItemTableData?> getMenuItemById(String id) {
    return _menuDao.getMenuItemById(id);
  }

  @override
  Future<int> addMenuItem({
    required String icon,
    required String name,
    required List<int> prices,
    String? description,
    String? imageUrl,
  }) {
    return _menuDao.addMenuItem(
      icon: icon,
      name: name,
      prices: prices,
      description: description,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<bool> updateMenuName({required String id, required String name}) {
    return _menuDao.updateMenuName(id: id, name: name);
  }

  @override
  Future<bool> updateDisplayOrder({
    required String id,
    required int displayOrder,
  }) {
    return _menuDao.updateDisplayOrder(id: id, displayOrder: displayOrder);
  }

  @override
  Future<bool> updateMenuPrice({
    required String id,
    required List<int> prices,
  }) {
    return _menuDao.updateMenuPrice(id: id, prices: prices);
  }

  @override 
  Future<bool> updateMenuIcon({required String id, required String icon}) {
    return _menuDao.updateMenuIcon(id: id, icon: icon);
  }

  @override
  Future<void> deleteMenu(String id) {
    return _menuDao.deleteMenu(id);
  }

  @override
  Future<bool> activateMenuItem(String menuId) {
    return _menuDao.updateMenuStatus(id: menuId, isActive: true);
  }

  @override
  Future<bool> deactivateMenuItem(String menuId) {
    return _menuDao.updateMenuStatus(id: menuId, isActive: false);
  }
}
