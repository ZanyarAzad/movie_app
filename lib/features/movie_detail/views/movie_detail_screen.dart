import 'package:flutter/material.dart';
import '../../../data/models/movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  final MovieModel? initialMovie;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.initialMovie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialMovie?.title ?? 'Movie Details'),
      ),
      body: Center(
        child: Text('Movie ID: ${widget.movieId}'),
      ),
    );
  }
}
