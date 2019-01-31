import 'package:path_parsing/path_parsing.dart';

void main(List<String> args) {
    if (args.length < 3) {
        print('Usage: width height path_string');
        return;
    }

    final width = int.parse(args[0]);
    final height = int.parse(args[1]);
    final pathString = args[2];

    print('canvas.drawPath(');
    print('    Path()');

    final FlutterPathProxy pathProxy = FlutterPathProxy(width, height);
    writeSvgPathDataToPath(pathString, pathProxy);

    print(pathProxy.lines.map((x) => '        $x').join('\n') + ',');

    print('    Paint()..color = Colors.black,');
    print(');');
}

class FlutterPathProxy extends PathProxy {
    int width;
    int height;
    List<String> lines;

    FlutterPathProxy(this.width, this.height) {
        this.lines = [];
    }

    @override
    void close() {
        lines.add('..close()');
    }

    @override
    void cubicTo(double x1, double y1, double x2, double y2, double x3, double y3) {
        lines.add('..cubicTo(');
        lines.add('    ${x1 / width} * size.width, ${y1 / height} * size.height,');
        lines.add('    ${x2 / width} * size.width, ${y2 / height} * size.height,');
        lines.add('    ${x3 / width} * size.width, ${y3 / height} * size.height,');
        lines.add(')');
    }

    @override
    void lineTo(double x, double y) {
        final s = [
            '${x / width} * size.width',
            '${y / height} * size.height',
        ].join(', ');

        lines.add('..lineTo($s)');
    }

    @override
    void moveTo(double x, double y) {
        final s = [
            '${x / width} * size.width',
            '${y / height} * size.height',
        ].join(', ');

        lines.add('..moveTo($s)');
    }
}
