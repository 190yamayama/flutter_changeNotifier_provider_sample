enum StoreNode {
  users,
  article
}

extension StoreNodeExtension on StoreNode {

  String get node {
    switch (this) {
      case StoreNode.users:
        return "users";
      case StoreNode.article:
        return "article";
      default:
        return null;
    }
  }

}