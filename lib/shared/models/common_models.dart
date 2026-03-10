/// 通用结果模型
/// 
/// 用于封装操作结果
class Result<T> {
  final T? data;
  final String? error;
  final bool success;

  const Result._({
    this.data,
    this.error,
    required this.success,
  });

  /// 成功结果
  factory Result.success(T data) => Result._(
        data: data,
        success: true,
      );

  /// 失败结果
  factory Result.failure(String error) => Result._(
        error: error,
        success: false,
      );

  /// 是否成功
  bool get isSuccess => success;

  /// 是否失败
  bool get isFailure => !success;

  /// 获取数据，如果失败则抛出异常
  T get dataOrThrow {
    if (isFailure) {
      throw Exception(error);
    }
    return data!;
  }

  /// 映射数据
  Result<R> map<R>(R Function(T) mapper) {
    if (isSuccess) {
      return Result.success(mapper(data!));
    }
    return Result.failure(error!);
  }

  /// 异步映射数据
  Future<Result<R>> asyncMap<R>(Future<R> Function(T) mapper) async {
    if (isSuccess) {
      return Result.success(await mapper(data!));
    }
    return Result.failure(error!);
  }

  /// 折叠结果
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(String) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data!);
    }
    return onFailure(error!);
  }
}

/// 分页响应模型
/// 
/// 用于封装分页数据
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  }) : hasMore = page * pageSize < total;

  /// 是否为空
  bool get isEmpty => items.isEmpty;

  /// 是否非空
  bool get isNotEmpty => items.isNotEmpty;

  /// 总页数
  int get totalPages => (total / pageSize).ceil();

  /// 映射数据
  PaginatedResponse<R> map<R>(R Function(T) mapper) {
    return PaginatedResponse(
      items: items.map(mapper).toList(),
      total: total,
      page: page,
      pageSize: pageSize,
    );
  }
}
