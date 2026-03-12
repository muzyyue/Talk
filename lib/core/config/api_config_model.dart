/// API 服务类型
enum APIProviderType {
  mock,
  lmStudio,
  openAI,
  custom,
}

/// API 配置模型
/// 
/// 存储用户配置的 API 服务信息
class APIConfigModel {
  final APIProviderType provider;
  final String baseUrl;
  final String apiKey;
  final String model;
  final double temperature;
  final int maxTokens;
  final bool streamEnabled;
  final int timeoutSeconds;

  const APIConfigModel({
    this.provider = APIProviderType.mock,
    this.baseUrl = 'http://localhost:1234',
    this.apiKey = '',
    this.model = '',
    this.temperature = 0.8,
    this.maxTokens = 500,
    this.streamEnabled = true,
    this.timeoutSeconds = 30,
  });

  /// 从 JSON 创建
  factory APIConfigModel.fromJson(Map<String, dynamic> json) {
    return APIConfigModel(
      provider: APIProviderType.values[json['provider'] as int? ?? 0],
      baseUrl: json['baseUrl'] as String? ?? 'http://localhost:1234',
      apiKey: json['apiKey'] as String? ?? '',
      model: json['model'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
      maxTokens: json['maxTokens'] as int? ?? 500,
      streamEnabled: json['streamEnabled'] as bool? ?? true,
      timeoutSeconds: json['timeoutSeconds'] as int? ?? 30,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'provider': provider.index,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'model': model,
      'temperature': temperature,
      'maxTokens': maxTokens,
      'streamEnabled': streamEnabled,
      'timeoutSeconds': timeoutSeconds,
    };
  }

  /// 复制并修改
  APIConfigModel copyWith({
    APIProviderType? provider,
    String? baseUrl,
    String? apiKey,
    String? model,
    double? temperature,
    int? maxTokens,
    bool? streamEnabled,
    int? timeoutSeconds,
  }) {
    return APIConfigModel(
      provider: provider ?? this.provider,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      streamEnabled: streamEnabled ?? this.streamEnabled,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    );
  }
}

/// LM Studio 模型信息
class LMStudioModel {
  final String id;
  final String object;
  final String? ownedBy;

  const LMStudioModel({
    required this.id,
    this.object = 'model',
    this.ownedBy,
  });

  factory LMStudioModel.fromJson(Map<String, dynamic> json) {
    return LMStudioModel(
      id: json['id'] as String,
      object: json['object'] as String? ?? 'model',
      ownedBy: json['owned_by'] as String?,
    );
  }
}

/// LM Studio 模型列表响应
class LMStudioModelsResponse {
  final List<LMStudioModel> data;

  const LMStudioModelsResponse({required this.data});

  factory LMStudioModelsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return LMStudioModelsResponse(
      data: dataList.map((e) => LMStudioModel.fromJson(e)).toList(),
    );
  }
}
