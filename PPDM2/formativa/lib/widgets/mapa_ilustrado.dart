import 'package:flutter/material.dart';

class MapaIlustrado extends StatelessWidget {
  const MapaIlustrado({required this.cidade, super.key});

  final String cidade;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFE9EEF4)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _RuasPainter()),
            const _Marcador(alignment: Alignment(-0.72, -0.50)),
            const _Marcador(alignment: Alignment(0.52, -0.66)),
            const _Marcador(alignment: Alignment(0.66, 0.16)),
            const _Marcador(alignment: Alignment(-0.44, 0.44)),
            const _Marcador(alignment: Alignment(0.10, 0.74)),
            const Align(
              alignment: Alignment(-0.10, 0.06),
              child: _PosicaoAtual(),
            ),
            Align(
              alignment: const Alignment(-0.52, -0.18),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'Locais em $cidade',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 14,
              bottom: 14,
              child: Column(
                children: [
                  _MapButton(icon: Icons.my_location_rounded),
                  SizedBox(height: 10),
                  _MapButton(icon: Icons.layers_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ruaPrincipal = Paint()
      ..color = Colors.white
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final ruaSecundaria = Paint()
      ..color = const Color(0xFFF9FBFD)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final parque = Paint()..color = const Color(0xFFCFE8D5);
    final agua = Paint()..color = const Color(0xFFBFE0F4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.05,
          size.height * 0.58,
          size.width * 0.34,
          size.height * 0.25,
        ),
        const Radius.circular(36),
      ),
      parque,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.90)
        ..cubicTo(
          size.width * 0.32,
          size.height * 0.72,
          size.width * 0.65,
          size.height * 1.02,
          size.width,
          size.height * 0.78,
        ),
      agua
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24,
    );

    canvas.drawLine(
      Offset(-20, size.height * 0.25),
      Offset(size.width + 20, size.height * 0.70),
      ruaPrincipal,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, -20),
      Offset(size.width * 0.64, size.height + 20),
      ruaPrincipal,
    );
    canvas.drawLine(
      Offset(-20, size.height * 0.52),
      Offset(size.width + 20, size.height * 0.28),
      ruaSecundaria,
    );
    canvas.drawLine(
      Offset(size.width * 0.78, -20),
      Offset(size.width * 0.18, size.height + 20),
      ruaSecundaria,
    );
    canvas.drawLine(
      Offset(-20, size.height * 0.12),
      Offset(size.width + 20, size.height * 0.42),
      ruaSecundaria,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Marcador extends StatelessWidget {
  const _Marcador({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Icon(
        Icons.location_on_rounded,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
        shadows: const [Shadow(color: Colors.black26, blurRadius: 6)],
      ),
    );
  }
}

class _PosicaoAtual extends StatelessWidget {
  const _PosicaoAtual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.24),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon),
        tooltip: 'Controle do mapa',
      ),
    );
  }
}
