import 'package:ackaf/src/data/models/user_model.dart';

Map<int, int> getRatingDistribution(UserModel user) {
  Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  for (var review in user.reviews!) {
    distribution[review.rating!] = (distribution[review.rating] ?? 0) + 1;
  }
  return distribution;
}

double getAverageRating(UserModel user) {
  if (user.reviews!.isEmpty) return 0.0;
  int totalRating =
      user.reviews!.fold(0, (sum, review) => sum + review.rating!);
  return totalRating / user.reviews!.length;
}
