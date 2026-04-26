import 'dart:async';
import 'package:flutter/material.dart';

/// Widget para exibir e editar rating de estrelas (1-14)
/// 
/// Sistema de cores:
/// - Até 7 estrelas: amarelas
/// - De 8 a 14 estrelas: primeiras são rosa (#eb02f7), últimas são amarelas
/// 
/// Modo interativo:
/// - Tap simples na estrela N: define N estrelas (amarelas)
/// - Duplo tap na estrela N: define N + 7 estrelas (N rosas + N amarelas)
class StarRating extends StatelessWidget {
  final int stars;
  final double size;
  final bool interactive;
  final ValueChanged<int>? onStarsChanged;

  const StarRating({
    super.key,
    required this.stars,
    this.size = 24,
    this.interactive = false,
    this.onStarsChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (interactive) {
      return _InteractiveStarRating(
        stars: stars,
        size: size,
        onStarsChanged: onStarsChanged!,
      );
    } else {
      return _DisplayStarRating(
        stars: stars,
        size: size,
      );
    }
  }
}

/// Widget para exibir estrelas (não interativo)
class _DisplayStarRating extends StatelessWidget {
  final int stars;
  final double size;

  const _DisplayStarRating({
    required this.stars,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula quantas estrelas de cada cor mostrar (máximo 7 estrelas visíveis)
    // Até 7 estrelas: apenas amarelas
    // Acima de 7: rosas + amarelas (sem vazias)
    final int pinkStars;
    final int yellowStars;
    final int emptyStars;
    
    if (stars <= 7) {
      pinkStars = 0;
      yellowStars = stars;
      emptyStars = 7 - stars;
    } else {
      // stars > 7: mostra (stars-7) rosas + restante amarelas
      pinkStars = (stars - 7).clamp(0, 7);
      yellowStars = (7 - pinkStars).clamp(0, 7);
      emptyStars = 0;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrelas rosas (8-14 estrelas)
        ...List.generate(
          pinkStars,
          (_) => Icon(Icons.star, size: size, color: const Color(0xFFEB02F7)),
        ),
        // Estrelas amarelas
        ...List.generate(
          yellowStars,
          (_) => Icon(Icons.star, size: size, color: Colors.amber),
        ),
        // Estrelas vazias (apenas quando <= 7 estrelas)
        ...List.generate(
          emptyStars,
          (_) => Icon(Icons.star_border, size: size, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Widget para editar estrelas (interativo)
class _InteractiveStarRating extends StatefulWidget {
  final int stars;
  final double size;
  final ValueChanged<int> onStarsChanged;

  const _InteractiveStarRating({
    required this.stars,
    required this.size,
    required this.onStarsChanged,
  });

  @override
  State<_InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<_InteractiveStarRating> {
  Timer? _tapTimer;
  int? _pendingTapIndex;

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  void _handleStarTap(int index) {
    final position = index + 1; // 1-based index

    // Se já existe um tap pendente na mesma estrela, é um duplo tap
    if (_tapTimer != null && _tapTimer!.isActive && _pendingTapIndex == index) {
      // Cancela o tap simples pendente
      _tapTimer!.cancel();
      _tapTimer = null;
      _pendingTapIndex = null;

      // Duplo tap: toggle entre amarela e rosa
      final pinkStars = widget.stars > 7 ? (widget.stars - 7).clamp(0, 7) : 0;
      final isPinkStar = index < pinkStars;
      
      if (isPinkStar) {
        // Estrela rosa → vira amarela (reduz para position estrelas)
        widget.onStarsChanged(position);
      } else {
        // Estrela amarela/vazia → vira rosa (position + 7 estrelas)
        widget.onStarsChanged((position + 7).clamp(1, 14));
      }
      return;
    }

    // Tap simples: agenda com delay para detectar possível duplo tap
    _tapTimer?.cancel();
    _pendingTapIndex = index;
    
    _tapTimer = Timer(const Duration(milliseconds: 250), () {
      _tapTimer = null;
      _pendingTapIndex = null;
      
      // Calcula estado atual
      final pinkStars = widget.stars > 7 ? (widget.stars - 7).clamp(0, 7) : 0;
      final isPinkStar = index < pinkStars;
      final hasPinkStars = widget.stars > 7;
      
      // Estrela rosa: não faz nada em tap simples
      if (isPinkStar) {
        return;
      }
      
      // Estrela amarela quando há rosa: não faz nada em tap simples
      if (hasPinkStars && index >= pinkStars) {
        return;
      }
      
      // Estrela amarela sem rosa ou estrela vazia: toggle
      if (widget.stars == position) {
        widget.onStarsChanged(0);
      } else {
        widget.onStarsChanged(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calcula quantas estrelas de cada cor para exibição (máximo 7 estrelas visíveis)
    final int pinkStars;
    final int yellowStars;
    
    if (widget.stars <= 7) {
      pinkStars = 0;
      yellowStars = widget.stars;
    } else {
      // stars > 7: mostra (stars-7) rosas + restante amarelas
      pinkStars = (widget.stars - 7).clamp(0, 7);
      yellowStars = (7 - pinkStars).clamp(0, 7);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        Color starColor;
        IconData starIcon;

        if (index < pinkStars) {
          // Estrela rosa preenchida
          starColor = const Color(0xFFEB02F7);
          starIcon = Icons.star;
        } else if (index < pinkStars + yellowStars) {
          // Estrela amarela preenchida
          starColor = Colors.amber;
          starIcon = Icons.star;
        } else {
          // Estrela vazia
          starColor = Colors.grey;
          starIcon = Icons.star_border;
        }

        return GestureDetector(
          onTap: () => _handleStarTap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              starIcon,
              size: widget.size,
              color: starColor,
            ),
          ),
        );
      }),
    );
  }
}
