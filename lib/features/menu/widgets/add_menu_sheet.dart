import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:movo/core/components/app_scaffold.dart';
import 'package:movo/core/components/components.dart';
import 'package:movo/core/theme/movo_theme.dart';
import 'package:movo/data/repositories/menu_repository.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  late TextEditingController _itemNameController;
  late TextEditingController _priceController;

  String _selectedIcon = ''; // Default icon
  late MenuRepository menuRepository;

  bool _initialized = false;

  bool get isFormValid =>
      _itemNameController.text.trim().isNotEmpty &&
      _priceController.text.trim().isNotEmpty &&
      _selectedIcon.isNotEmpty;

  String? _itemNameError;
  String? _priceError;
  String? _emojiError;

  List<int> splitPrices(String priceText) {
    return priceText
        .split(',')
        .map((price) => int.tryParse(price.trim()))
        .where((price) => price != null)
        .whereType<int>()
        .toList();
  }

  String? validatePriceText(String value) {
    final priceText = value.trim();
    if (priceText.isEmpty) {
      return 'Please enter at least one price';
    }
    if (!RegExp(r'^\d+(,\d+)*$').hasMatch(priceText)) {
      return 'Prices can contain only digits and commas';
    }
    if (splitPrices(priceText).length > 8) {
      return 'You can only add up to 8 prices';
    }
    return null;
  }

  String? validateItemName(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a name for the menu item';
    }
    return null;
  }

  String? validateEmoji() {
    if (_selectedIcon.isEmpty) {
      return 'Please select an icon for the menu item';
    }
    return null;
  }

  Future<void> _addMenuItem() async {
    final itemName = _itemNameController.text.trim();
    final priceText = _priceController.text.trim();
    final itemNameError = validateItemName(itemName);
    final priceError = validatePriceText(priceText);
    final emojiError = validateEmoji();

    setState(() {
      _itemNameError = itemNameError;
      _priceError = priceError;
      _emojiError = emojiError;
    });

    if (itemNameError != null || priceError != null || emojiError != null) {
      return;
    }

    final prices = splitPrices(priceText);

    if (kDebugMode) {
      print('Prices selected: $prices');
    }

    try {
      await menuRepository.addMenuItem(
        name: itemName,
        prices: prices,
        icon: _selectedIcon,

        // name: itemName,
        // prices: prices,
        // icon: _selectedIcon.iconData.codePoint,
      );

      if (mounted) {
        Navigator.of(context).pop();
        showSimpleNotification(const Text('Menu item added successfully'));
      }
    } catch (e) {
      if (mounted) {
        showSimpleNotification(
          const Text('Failed to add menu item Please try again'),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _priceController = TextEditingController();
    _itemNameController.addListener(() {
      if (_itemNameError == null) {
        return;
      }
      setState(() {
        _itemNameError = validateItemName(_itemNameController.text);
      });
    });
    _priceController.addListener(() {
      if (_priceError == null) {
        return;
      }
      setState(() {
        _priceError = validatePriceText(_priceController.text);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      menuRepository = context.read<MenuRepository>();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    _priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context
        .fossTheme; // Read the current height taken up by the system keyboard

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final shouldPop =
        _itemNameController.text.isEmpty &&
        _priceController.text.isEmpty &&
        _selectedIcon.isEmpty;
    return PopScope(
      canPop: keyboardHeight == 0 && shouldPop, // Prevents the user from dismissing the sheet by tapping outside
      onPopInvokedWithResult: (didPop, result) async {
        if (kDebugMode) {
          print('onPopInvokedWithResult: didPop=$didPop, result=$result');
        }
        if (!didPop && !shouldPop) {
          // If the user tried to dismiss the sheet, show a confirmation dialog
          final shouldClose = await showFossDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return FossDialog(
                title: const Text('Discard Changes?'),
                content: const Text(
                  'You have unsaved changes. Are you sure you want to discard them?',
                ),
                actions: [
                  FossButton(
                    variant: FossButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FossButton(
                    variant: FossButtonVariant.destructive,
                    onPressed: () => {
                      _itemNameController.clear(),
                      _priceController.clear(),
                      _selectedIcon = '',
                      Navigator.of(context).pop(true),
                    },
                    child: const Text('Discard'),
                  ),
                ],
              );
            },
          );

          if (mounted && shouldClose == true) {
            Navigator.of(context)
                .pop(true); // Close the sheet if the user confirmed
          }
        }
      },
      child: AppScaffold(
        appBar: BrandTopBar(title: 'Add Menu Item'),
        body: FossCard(
          style: FossCardStyle(borderRadius: 0),
          title: Row(
            spacing: tokens.spacing.unit * 2,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radii.sm),
                  ),
                  child: HugeIcon(icon: HugeIcons.strokeRoundedCoffee02),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [BrandText.subtitle("Create Menu Item")],
              ),
            ],
          ),
          footer: Row(
            spacing: tokens.spacing.unit * 2,
            mainAxisAlignment: .end,
            children: [
              FossButton(
                size: .lg,
                variant: .ghost,
                style: FossButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    context.fossTheme.colors.destructiveLight,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    context.fossTheme.colors.destructiveLightForeground,
                  ),
                  side: BorderSide(color: context.fossTheme.colors.border),
                ),
                onPressed: () {
                  _itemNameController.clear();
                  _priceController.clear();
                  _selectedIcon = '';
                  Navigator.of(context).pop();
                },
                child: Text('Discard'),
              ),
              FossButton(
                variant: FossButtonVariant.primary,
                size: .lg,
                onPressed: _addMenuItem,
                child: Text('Add Menu Item'),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: tokens.spacing.unit * 6,
            children: [
              FossTextField(
                controller: _itemNameController,
                label: 'Item Name',
                hintText: 'i.e. Cheeseburger, Pizza, Sushi, etc.',
                errorText: _itemNameError,
              ),
              FossTextField(
                controller: _priceController,
                label: 'Prices (comma-separated)',
                hintText: 'e.g. 10,20,30',
                helperText: 'Enter up to 8 prices using digits separated by commas (e.g., 10,20,30).',
                keyboardType: .number,
                errorText: _priceError,
              ),

              Column(
                crossAxisAlignment: .start,
                spacing: tokens.spacing.unit * 2,
                children: [
                  BrandText.label(
                    "Select an Icon",
                    // color: ColorTokens.light.neutral.textSecondary,
                  ),
                  SizedBox.square(
                    child: FossButton.icon(
                      variant: .secondary,
                      semanticLabel: "Select an icon for the menu item",
                      style: FossButtonStyle(
                        // backgroundColor: ColorTokens.light.action.primaryHover
                        //     .withValues(alpha: .3),
                        borderRadius: tokens.radii.sm,
                      ),
                      icon: _selectedIcon.isEmpty
                          ? SizedBox(
                              height: tokens.spacing.unit * 10,
                              width: tokens.spacing.unit * 10,
                              child: Center(
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedSmile,
                                  size: tokens.spacing.unit * 6,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: tokens.spacing.unit * 10,
                              width: tokens.spacing.unit * 10,
                              child: Center(
                                child: BrandText.display(_selectedIcon),
                              ),
                            ),
                      onPressed: () async {
                        // Show the dialog and await the chosen food string string
                        final String? selectedEmoji =
                            await showFossDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const FoodEmojiDialog(),
                            );

                        // If the user didn't tap "Close" or click away, use the chosen symbol
                        if (selectedEmoji != null) {
                          if (kDebugMode) {
                            print('User picked: $selectedEmoji');
                          }
                          setState(() {
                            _selectedIcon = selectedEmoji;
                            _emojiError = null;
                          });
                          // Update your UI state or Controller text field here
                        }
                      },
                    ),
                  ),
                  if (_emojiError != null)
                    BrandText.caption(
                      _emojiError ?? 'Please select an icon for the menu item',
                      color: tokens.colors.destructiveForeground,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodEmojiDialog extends StatelessWidget {
  const FoodEmojiDialog({super.key});

  // Food emojis paired with search keywords
  static const Map<String, List<String>> foodData = {
    // Fruits
    // '🍏': ['apple', 'green apple', 'fruit', 'healthy'],
    // '🍎': ['apple', 'red apple', 'fruit', 'healthy'],
    // '🍐': ['pear', 'fruit', 'healthy'],
    // '🍊': ['orange', 'tangerine', 'mandarin', 'citrus', 'fruit'],
    // '🍋': ['lemon', 'citrus', 'fruit', 'sour'],
    // '🍌': ['banana', 'fruit', 'yellow'],
    // '🍉': ['watermelon', 'melon', 'fruit'],
    // '🍇': ['grapes', 'fruit'],
    // '🍓': ['strawberry', 'berry', 'fruit'],
    // '🫐': ['blueberry', 'berry', 'fruit'],
    // '🍈': ['melon', 'cantaloupe', 'honeydew', 'fruit'],
    // '🍒': ['cherry', 'cherries', 'fruit'],
    // '🍑': ['peach', 'fruit'],
    // '🥭': ['mango', 'fruit', 'tropical'],
    // '🍍': ['pineapple', 'fruit', 'tropical'],
    // '🥥': ['coconut', 'fruit', 'tropical'],
    // '🥝': ['kiwi', 'kiwifruit', 'fruit'],

    // Vegetables & Ingredients
    // '🍅': ['tomato', 'vegetable', 'salad'],
    // '🥑': ['avocado', 'guacamole', 'fruit', 'healthy'],
    // '🍆': ['eggplant', 'aubergine', 'vegetable'],
    // '🥔': ['potato', 'potatoes', 'veg'],
    // '🥕': ['carrot', 'carrots', 'vegetable', 'healthy'],
    // '🌽': ['corn', 'maize', 'sweetcorn', 'popcorn'],
    // '🌶️': ['pepper', 'chili', 'chilli', 'spicy', 'hot'],
    // '🫑': ['bell pepper', 'capsicum', 'paprika', 'vegetable'],
    // '🥒': ['cucumber', 'pickle', 'vegetable', 'salad'],
    // '🥬': ['leafy green', 'lettuce', 'salad', 'cabbage', 'spinach'],
    // '🥦': ['broccoli', 'vegetable', 'green'],
    // '🧄': ['garlic', 'spice', 'cooking'],
    // '🧅': ['onion', 'vegetable', 'cooking'],
    // '🍄': ['mushroom', 'fungus', 'vegetable'],
    // '🥜': ['peanuts', 'peanut', 'nut', 'snack'],
    // '🫘': ['beans', 'kidney beans', 'legume'],
    // '🌰': ['chestnut', 'nut'],

    // Bakery & Breakfast
    '🍞': ['bread', 'loaf', 'toast', 'bakery'],
    '🥐': ['croissant', 'bakery', 'pastry', 'breakfast'],
    '🥖': ['baguette', 'french bread', 'bakery'],
    '🫓': ['flatbread', 'naan', 'pita', 'roti', 'tortilla'],
    '🥨': ['pretzel', 'snack', 'bakery'],
    '🥯': ['bagel', 'bakery', 'breakfast'],
    '🥞': ['pancakes', 'pancake', 'flapjacks', 'breakfast', 'sweet'],
    '🧇': ['waffle', 'waffles', 'breakfast', 'sweet'],
    '🧀': ['cheese', 'cheesy', 'dairy'],

    // Fast Food & Meats
    '🍖': ['meat on bone', 'ribs', 'pork'],
    '🍗': [
      'poultry leg',
      'chicken leg',
      'drumstick',
      'turkey',
      'fried chicken',
    ],
    '🥩': ['meat', 'steak', 'beef', 'cut of meat', 'barbecue', 'bbq'],
    '🥓': ['bacon', 'pork', 'meat', 'breakfast'],
    '🍔': ['burger', 'hamburger', 'cheeseburger', 'fast food', 'meat'],
    '🍟': ['fries', 'french fries', 'chips', 'potato', 'fast food'],
    '🍕': ['pizza', 'slice', 'cheese', 'fast food'],
    '🌭': ['hotdog', 'hot dog', 'fast food', 'sausage'],
    '🥪': ['sandwich', 'bread', 'lunch'],
    '🌮': ['taco', 'mexican', 'fast food'],
    '🌯': ['burrito', 'mexican', 'wrap', 'fast food'],
    '🫔': ['tamale', 'mexican', 'wrap'],
    '🥙': ['stuffed flatbread', 'pita', 'gyros', 'shawarma', 'falafel'],
    '🧆': ['falafel', 'meatball', 'chickpea', 'vegetarian'],

    // Eggs & Bowls
    '🥚': ['egg', 'boiled egg', 'breakfast'],
    '🍳': ['cooking', 'fried egg', 'pan', 'breakfast'],
    '🥘': ['shallow pan of food', 'paella', 'casserole', 'dinner'],
    '🍲': ['pot of food', 'stew', 'soup', 'hot pot'],
    '🫕': ['fondue', 'cheese', 'chocolate', 'hot pot'],
    '🥣': ['bowl with spoon', 'cereal', 'soup', 'oatmeal', 'breakfast'],
    '🥗': ['green salad', 'healthy', 'vegetable', 'lettuce'],
    '🍿': ['popcorn', 'snack', 'movie'],
    '🧈': ['butter', 'dairy', 'cooking'],
    '🧂': ['salt', 'shaker', 'seasoning', 'spice'],
    '🥫': ['canned food', 'can', 'soup', 'tomato tin'],

    // Asian Cuisine
    '🍱': ['bento box', 'bento', 'japanese', 'lunch'],
    '🍘': ['rice cracker', 'japanese', 'snack'],
    '🍙': ['rice ball', 'onigiri', 'japanese'],
    '🍚': ['cooked rice', 'bowl of rice', 'asian'],
    '🍛': ['curry rice', 'curry', 'indian', 'asian'],
    '🍜': ['steaming bowl', 'ramen', 'noodles', 'soup', 'asian'],
    '🍝': ['spaghetti', 'pasta', 'noodles', 'italian'],
    '🍠': ['roasted sweet potato', 'yam'],
    '🍢': ['oden', 'japanese', 'skewers'],
    '🍣': ['sushi', 'raw fish', 'japanese', 'asian'],
    '🍤': ['fried shrimp', 'tempura', 'prawn', 'seafood', 'asian'],
    '🍥': ['fish cake with swirl', 'narutomaki', 'ramen topping'],
    '🥮': ['mooncake', 'chinese', 'festival', 'dessert'],
    '🍡': ['dango', 'japanese', 'sweet', 'dessert'],
    '🥟': ['dumpling', 'gyoza', 'potsticker', 'dim sum', 'asian'],
    '🥠': ['fortune cookie', 'cookie', 'snack'],
    '🥡': ['takeout box', 'chinese takeout', 'asian food'],
    '🦪': ['oyster', 'seafood', 'shellfish'],

    // Sweets & Desserts
    '🍦': ['soft ice cream', 'cone', 'dessert', 'cold', 'sweet'],
    '🍧': ['shaved ice', 'dessert', 'cold', 'sweet'],
    '🍨': ['ice cream', 'bowl', 'dessert', 'cold', 'sweet'],
    '🍩': ['doughnut', 'donut', 'sweet', 'bakery', 'dessert'],
    '🍪': ['cookie', 'chocolate chip', 'biscuit', 'snack', 'sweet'],
    '🎂': ['birthday cake', 'cake', 'celebration', 'sweet', 'dessert'],
    '🍰': ['shortcake', 'cake slice', 'sweet', 'dessert'],
    '🧁': ['cupcake', 'muffin', 'sweet', 'bakery', 'dessert'],
    '🥧': ['pie', 'bakery', 'dessert', 'sweet'],
    '🍫': ['chocolate bar', 'chocolate', 'candy', 'sweet'],
    '🍬': ['candy', 'sweet', 'sweets'],
    '🍭': ['lollipop', 'candy', 'sweet'],
    '🍮': ['custard', 'pudding', 'flan', 'dessert', 'sweet'],
    '🍯': ['honey pot', 'honey', 'sweet'],

    // Drinks & Beverages
    '🍼': ['baby bottle', 'milk', 'drink'],
    '🥛': ['glass of milk', 'milkshake', 'dairy', 'drink'],
    '☕': ['hot beverage', 'coffee', 'tea', 'cafe', 'drink', 'hot'],
    '🫖': ['teapot', 'tea', 'drink', 'hot'],
    '🍵': ['teacup without handle', 'green tea', 'matcha', 'drink', 'hot'],
    '🍶': ['sake', 'japanese', 'alcohol', 'drink'],
    '🍾': [
      'bottle with popping cork',
      'champagne',
      'wine',
      'celebration',
      'alcohol',
    ],
    '🍷': ['wine glass', 'wine', 'alcohol', 'drink'],
    '🍸': ['cocktail glass', 'martini', 'cocktail', 'alcohol', 'drink'],
    '🍹': ['tropical drink', 'cocktail', 'punch', 'alcohol', 'drink'],
    '🍺': ['beer mug', 'beer', 'ale', 'alcohol', 'drink'],
    '🍻': ['clinking beer mugs', 'beers', 'cheers', 'alcohol', 'drink'],
    '🥂': ['clinking glasses', 'champagne', 'toast', 'celebration', 'alcohol'],
    '🥃': [
      'tumbler glass',
      'whiskey',
      'whisky',
      'bourbon',
      'liquor',
      'alcohol',
    ],
    '🥤': ['cup with straw', 'soda', 'soft drink', 'juice', 'fast food'],
    '🧋': ['bubble tea', 'boba', 'milk tea', 'drink'],
    '🧃': ['beverage box', 'juice box', 'drink'],
    '🧉': ['mate', 'drink', 'herbal tea'],
    '🧊': ['ice cube', 'ice', 'cold', 'water'],

    // Other
    '🚬': [
      'cigarette',
      'smoke',
      'smoking',
      'tobacco',
      'nicotine',
      'cig',
      'vape',
      'smoke break',
      'lit cigarette',
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Keep track of the filtered list locally
    List<String> filteredEmojis = foodData.keys.toList();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: FossDialog(
        title: const Text('Search & Select Food', textAlign: TextAlign.center),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.maxFinite,
              height: 380, // Slightly taller to fit the search bar comfortably
              child: Column(
                children: [
                  // Search Input Field
                  FossTextField(
                    style: FossTextFieldStyle(
                      borderRadius: context.fossTheme.radii.sm,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                    hintText: 'Search food (e.g., burger, fruit)...',
                    leading: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
                    onChanged: (query) {
                      final lowercaseQuery = query.toLowerCase().trim();
                      setState(() {
                        if (lowercaseQuery.isEmpty) {
                          filteredEmojis = foodData.keys.toList();
                        } else {
                          filteredEmojis = foodData.entries
                              .where(
                                (entry) => entry.value.any(
                                  (keyword) => keyword.contains(lowercaseQuery),
                                ),
                              )
                              .map((entry) => entry.key)
                              .toList();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  // Grid View Results Area
                  Expanded(
                    child: filteredEmojis.isEmpty
                        ? const Center(
                            child: Text('No matching food found 🕵️‍♂️'),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: filteredEmojis.length,
                            itemBuilder: (context, index) {
                              final emoji = filteredEmojis[index];
                              return GestureDetector(
                                onTap: () => Navigator.pop(context, emoji),
                                // borderRadius: BorderRadius.circular(8),
                                child: Center(
                                  child: Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          FossButton(
            variant: .ghost,
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
