import 'package:arxivinder/data/model/paper.dart';

final List<Paper> dummyPapers = [
  Paper(
    id: 1,
    title: "Deep Learning",
    abstract:
        "This paper explores the evolution of convolutional neural networks and their impact on modern image recognition tasks.",
    publishedDate: DateTime(2023, 5, 15),
    url: "https://arxiv.org/abs/2602.03699",
    doi: "10.1000/123456",
    category: "Math",
    createdAt: DateTime.now(),
  ),
  Paper(
    id: 2,
    title: "Climate Change",
    category: "Science",
    abstract:
        "An analysis of how rising temperatures affect migration patterns of Arctic species over the last decade.",
    publishedDate: DateTime(2024, 1, 10),
    url: "https://arxiv.org/abs/2602.03434",
    doi: "10.1000/789012",
    createdAt: DateTime.now(),
  ),
  Paper(
    id: 3,
    category: "Physics",
    title: "The Future",
    abstract:
        "This study examines the security protocols and scalability challenges of current blockchain-based financial systems.",
    publishedDate: DateTime(2023, 11, 22),
    url: "https://arxiv.org/abs/2602.03110",
    doi: "10.1000/345678",
    createdAt: DateTime.now(),
  ),
];
