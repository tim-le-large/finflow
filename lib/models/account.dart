class Account {
  const Account({
    required this.id,
    required this.name,
    required this.initialBalanceCents,
  });

  final String id;
  final String name;
  final int initialBalanceCents;
}