import 'package:flutter_test/flutter_test.dart';
import 'package:talk/core/config/api_config_model.dart';

void main() {
  group('APIConfigModel', () {
    test('默认构造函数应该创建默认配置', () {
      const config = APIConfigModel();
      
      expect(config.provider, APIProviderType.mock);
      expect(config.baseUrl, 'http://localhost:1234');
      expect(config.apiKey, '');
      expect(config.model, '');
      expect(config.temperature, 0.8);
      expect(config.maxTokens, 500);
      expect(config.streamEnabled, true);
      expect(config.timeoutSeconds, 30);
    });

    test('自定义参数构造函数应该正确设置值', () {
      const config = APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://192.168.1.100:8080',
        apiKey: 'test-api-key',
        model: 'llama-3',
        temperature: 0.5,
        maxTokens: 1000,
        streamEnabled: false,
        timeoutSeconds: 60,
      );
      
      expect(config.provider, APIProviderType.lmStudio);
      expect(config.baseUrl, 'http://192.168.1.100:8080');
      expect(config.apiKey, 'test-api-key');
      expect(config.model, 'llama-3');
      expect(config.temperature, 0.5);
      expect(config.maxTokens, 1000);
      expect(config.streamEnabled, false);
      expect(config.timeoutSeconds, 60);
    });

    test('toJson 应该正确转换为 JSON', () {
      const config = APIConfigModel(
        provider: APIProviderType.openAI,
        baseUrl: 'https://api.openai.com',
        apiKey: 'sk-test',
        model: 'gpt-4',
        temperature: 1.0,
        maxTokens: 2000,
        streamEnabled: true,
        timeoutSeconds: 45,
      );
      
      final json = config.toJson();
      
      expect(json['provider'], APIProviderType.openAI.index);
      expect(json['baseUrl'], 'https://api.openai.com');
      expect(json['apiKey'], 'sk-test');
      expect(json['model'], 'gpt-4');
      expect(json['temperature'], 1.0);
      expect(json['maxTokens'], 2000);
      expect(json['streamEnabled'], true);
      expect(json['timeoutSeconds'], 45);
    });

    test('fromJson 应该正确从 JSON 创建实例', () {
      final json = {
        'provider': APIProviderType.custom.index,
        'baseUrl': 'http://custom.api:3000',
        'apiKey': 'custom-key',
        'model': 'custom-model',
        'temperature': 0.7,
        'maxTokens': 800,
        'streamEnabled': false,
        'timeoutSeconds': 20,
      };
      
      final config = APIConfigModel.fromJson(json);
      
      expect(config.provider, APIProviderType.custom);
      expect(config.baseUrl, 'http://custom.api:3000');
      expect(config.apiKey, 'custom-key');
      expect(config.model, 'custom-model');
      expect(config.temperature, 0.7);
      expect(config.maxTokens, 800);
      expect(config.streamEnabled, false);
      expect(config.timeoutSeconds, 20);
    });

    test('fromJson 处理缺失字段应该使用默认值', () {
      final json = <String, dynamic>{};
      
      final config = APIConfigModel.fromJson(json);
      
      expect(config.provider, APIProviderType.mock);
      expect(config.baseUrl, 'http://localhost:1234');
      expect(config.apiKey, '');
      expect(config.model, '');
      expect(config.temperature, 0.8);
      expect(config.maxTokens, 500);
      expect(config.streamEnabled, true);
      expect(config.timeoutSeconds, 30);
    });

    test('copyWith 应该正确复制并修改指定字段', () {
      const original = APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
        apiKey: 'original-key',
        model: 'original-model',
        temperature: 0.8,
        maxTokens: 500,
        streamEnabled: true,
        timeoutSeconds: 30,
      );
      
      final copied = original.copyWith(
        apiKey: 'new-key',
        model: 'new-model',
        temperature: 0.5,
      );
      
      expect(copied.provider, APIProviderType.lmStudio);
      expect(copied.baseUrl, 'http://localhost:1234');
      expect(copied.apiKey, 'new-key');
      expect(copied.model, 'new-model');
      expect(copied.temperature, 0.5);
      expect(copied.maxTokens, 500);
      expect(copied.streamEnabled, true);
      expect(copied.timeoutSeconds, 30);
    });

    test('copyWith 不传参数应该返回相同值的实例', () {
      const original = APIConfigModel(
        provider: APIProviderType.openAI,
        baseUrl: 'https://api.openai.com',
        apiKey: 'test-key',
        model: 'gpt-4',
      );
      
      final copied = original.copyWith();
      
      expect(copied.provider, original.provider);
      expect(copied.baseUrl, original.baseUrl);
      expect(copied.apiKey, original.apiKey);
      expect(copied.model, original.model);
    });

    test('toJson 和 fromJson 应该可以互相转换', () {
      const original = APIConfigModel(
        provider: APIProviderType.lmStudio,
        baseUrl: 'http://localhost:1234',
        apiKey: 'test-key',
        model: 'llama-3',
        temperature: 0.7,
        maxTokens: 1000,
        streamEnabled: true,
        timeoutSeconds: 45,
      );
      
      final json = original.toJson();
      final restored = APIConfigModel.fromJson(json);
      
      expect(restored.provider, original.provider);
      expect(restored.baseUrl, original.baseUrl);
      expect(restored.apiKey, original.apiKey);
      expect(restored.model, original.model);
      expect(restored.temperature, original.temperature);
      expect(restored.maxTokens, original.maxTokens);
      expect(restored.streamEnabled, original.streamEnabled);
      expect(restored.timeoutSeconds, original.timeoutSeconds);
    });
  });

  group('APIProviderType', () {
    test('枚举值顺序正确', () {
      expect(APIProviderType.values.length, 4);
      expect(APIProviderType.values[0], APIProviderType.mock);
      expect(APIProviderType.values[1], APIProviderType.lmStudio);
      expect(APIProviderType.values[2], APIProviderType.openAI);
      expect(APIProviderType.values[3], APIProviderType.custom);
    });

    test('index 属性正确', () {
      expect(APIProviderType.mock.index, 0);
      expect(APIProviderType.lmStudio.index, 1);
      expect(APIProviderType.openAI.index, 2);
      expect(APIProviderType.custom.index, 3);
    });
  });

  group('LMStudioModel', () {
    test('fromJson 正确解析模型信息', () {
      final json = {
        'id': 'llama-3-8b',
        'object': 'model',
        'owned_by': 'meta',
      };
      
      final model = LMStudioModel.fromJson(json);
      
      expect(model.id, 'llama-3-8b');
      expect(model.object, 'model');
      expect(model.ownedBy, 'meta');
    });

    test('fromJson 处理缺失字段使用默认值', () {
      final json = {'id': 'test-model'};
      
      final model = LMStudioModel.fromJson(json);
      
      expect(model.id, 'test-model');
      expect(model.object, 'model');
      expect(model.ownedBy, null);
    });
  });

  group('LMStudioModelsResponse', () {
    test('fromJson 正确解析模型列表', () {
      final json = {
        'data': [
          {'id': 'model-1'},
          {'id': 'model-2', 'owned_by': 'user'},
        ],
      };
      
      final response = LMStudioModelsResponse.fromJson(json);
      
      expect(response.data.length, 2);
      expect(response.data[0].id, 'model-1');
      expect(response.data[1].id, 'model-2');
      expect(response.data[1].ownedBy, 'user');
    });

    test('fromJson 处理空数据', () {
      final json = <String, dynamic>{};
      
      final response = LMStudioModelsResponse.fromJson(json);
      
      expect(response.data.isEmpty, true);
    });
  });
}
