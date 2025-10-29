class GridSolver {
  static List<List<String>> _grid = [];
  static String _searchKey = "";
  static Map<String, List<(int, int)>> _results = {};
  static Function(Map<String, List<(int, int)>>)? _callback;

  static int _rows = 0;
  static int _cols = 0;

  static void solveGrid(
      {required List<String> dictionary,
      required String grid,
      required int rows,
      required int cols,
      Function(Map<String, List<(int, int)>>)? callback}) {
    _results = {};
    _rows = rows;
    _cols = cols;
    _callback = callback;
    _grid = _generateCharGrid(gridString: grid, rows: rows, columns: cols);
    final re = RegExp("[$grid]+");
    for (var word in dictionary) {
      if (word.length < 3 || word.length > grid.length) continue;
      if (_results.containsKey(word)) continue;
      if (!re.hasMatch(word)) continue;
      _searchKey = word;
      _searchWord();
    }
    if (_callback != null) {
      _callback!(_results);
    }
  }

  static void _searchWord() {
    var r = 0;
    while (r < _rows) {
      var c = 0;
      while (c < _cols) {
        final board = List.generate(_rows, (_) => List.filled(_cols, 0));
        _traverse(0, r, c, board);
        c++;
      }
      r++;
    }
  }

  static void findWord(
      {required String word,
      required String grid,
      required int rows,
      required int cols,
      Function(Map<String, List<(int, int)>>)? callback}) {
    _results = {};
    _searchKey = word;
    _rows = rows;
    _cols = cols;
    _callback = callback;
    _grid = _generateCharGrid(gridString: grid, rows: rows, columns: cols);
    _searchWord();
    if (_callback != null) {
      _callback!(_results);
    }
  }

  static void searchPath() {}
  static void _traverse(int depth, int row, int column, List<List<int>> board) {
    if (_grid[row][column] != _searchKey[depth]) return;
    if (board.isEmpty) return;
    depth++;
    if (depth == _searchKey.length) {
      if (!_results.keys.contains(_searchKey)) {
        board[row][column] = depth;
        _results[_searchKey] = _printCoordinates(board);
        board[row][column] = 0;
      }
      return;
    } else {
      board[row][column] = depth;
      if (row - 1 >= 0 && column - 1 >= 0 && board[row - 1][column - 1] == 0) {
        _traverse(depth, row - 1, column - 1, board);
      }

      if (row + 1 < board.length &&
          column - 1 >= 0 &&
          board[row + 1][column - 1] == 0) {
        _traverse(depth, row + 1, column - 1, board);
      }
      if (row + 1 < board.length &&
          board[row + 1].length > column &&
          board[row + 1][column] == 0) {
        _traverse(depth, row + 1, column, board);
      }
      if (row + 1 < board.length &&
          column + 1 < board[row + 1].length &&
          board[row + 1][column + 1] == 0) {
        _traverse(depth, row + 1, column + 1, board);
      }
      if (column - 1 >= 0 && board[row][column - 1] == 0) {
        _traverse(depth, row, column - 1, board);
      }
      if (column + 1 < board[row].length && board[row][column + 1] == 0) {
        _traverse(depth, row, column + 1, board);
      }
      if (row - 1 >= 0 &&
          column + 1 < board[row - 1].length &&
          board[row - 1][column + 1] == 0) {
        _traverse(depth, row - 1, column + 1, board);
      }
      if (row - 1 >= 0 && board[row - 1][column] == 0) {
        _traverse(depth, row - 1, column, board);
      }
      board[row][column] = 0;
    }
  }

  static List<(int, int)> _printCoordinates(List<List<int>> board) {
    var start = 1;
    var end = _searchKey.length + 1;
    final result = <(int, int)>[];
    while (start < end) {
      var r = 0;
      while (r < board.length) {
        var c = 0;
        bool isFound = false;
        while (c < board[r].length) {
          if (board[r][c] == start) {
            result.add((r, c));
            isFound = true;
            break;
          }
          c++;
        }
        if (isFound) break;
        r++;
      }
      start++;
    }
    return result;
  }

  static List<List<String>> _generateCharGrid({
    required String gridString,
    required int rows,
    required int columns,
  }) {
    final result = List.generate(rows, (_) => <String>[]);
    var index = 0;
    var i = 0;

    while (i < gridString.length) {
      var c = gridString[i];
      //if your grid has a gap, represented here by a dash, replace it with a symbol which is not found in words (a number, for instance)
      //if (c == '-') c = '2';
      result[index].add(c);
      i++;
      if (i != 0 && i % columns == 0) index++;
    }

    return result;
  }
}
