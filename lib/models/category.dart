class Category {
  final String name;
  final String emoji;

  const Category({
    required this.name,
    required this.emoji,
  });

  static const List<Category> expenseCategories = [
    Category(name: 'Food', emoji: '🍔'),
    Category(name: 'Transportation', emoji: '🚗'),
    Category(name: 'Entertainment', emoji: '🎮'),
    Category(name: 'Shopping', emoji: '🛍️'),
    Category(name: 'Utilities', emoji: '💡'),
    Category(name: 'Housing', emoji: '🏠'),
    Category(name: 'Healthcare', emoji: '🏥'),
    Category(name: 'Education', emoji: '📚'),
  ];

  static const List<Category> incomeCategories = [
    Category(name: 'Salary', emoji: '💵'),
    Category(name: 'Freelance', emoji: '💻'),
    Category(name: 'Investment', emoji: '📈'),
    Category(name: 'Gifts', emoji: '🎁'),
  ];

  @override
  String toString() => name;
}
