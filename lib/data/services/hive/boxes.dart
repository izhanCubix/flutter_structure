class BoxConfig {
  final String name;
  final bool encrypted;

  const BoxConfig(this.name, {this.encrypted = false});
}

abstract final class Boxes {
  static const user = BoxConfig('User', encrypted: true);
  static const settings = BoxConfig('Settings');
}
