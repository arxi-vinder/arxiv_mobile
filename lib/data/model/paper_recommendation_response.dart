import 'package:equatable/equatable.dart';

class PaperRecommendationResponse extends Equatable {
  final String status;
  final int id;
  final String title;
  final double cosineScore;
  final int reward;
  final int totalAction;
  final double ucbScore;

  const PaperRecommendationResponse({
    required this.status,
    required this.id,
    required this.title,
    required this.cosineScore,
    required this.reward,
    required this.totalAction,
    required this.ucbScore,
  });

  factory PaperRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return PaperRecommendationResponse(
      status: json['status'] ?? '',
      id: json['paper_id'] ?? 0,
      title: json['title'] ?? '',
      cosineScore: (json['cosine_score'] ?? 0).toDouble(),
      reward: json['reward'] ?? 0,
      totalAction: json['total_action'] ?? 0,
      ucbScore: (json['ucb_score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cosine_score': cosineScore,
      'reward': reward,
      'total_action': totalAction,
      'ucb_score': ucbScore,
    };
  }

  PaperRecommendationResponse copyWith({
    int? id,
    String? title,
    double? cosineScore,
    int? reward,
    int? totalAction,
    double? ucbScore,
  }) {
    return PaperRecommendationResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      cosineScore: cosineScore ?? this.cosineScore,
      reward: reward ?? this.reward,
      totalAction: totalAction ?? this.totalAction,
      ucbScore: ucbScore ?? this.ucbScore, 
      status: '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    cosineScore,
    reward,
    totalAction,
    ucbScore,
  ];
}
