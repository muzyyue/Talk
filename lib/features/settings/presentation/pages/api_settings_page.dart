import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/config/api_config_model.dart';
import 'package:talk/core/services/ai_service.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// API 设置页面
/// 
/// 配置 AI 服务提供商和相关参数
class APISettingsPage extends ConsumerStatefulWidget {
  const APISettingsPage({super.key});

  @override
  ConsumerState<APISettingsPage> createState() => _APISettingsPageState();
}

class _APISettingsPageState extends ConsumerState<APISettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();
  
  late APIProviderType _selectedProvider;
  late double _temperature;
  late int _maxTokens;
  late bool _streamEnabled;
  late int _timeoutSeconds;
  
  bool _isTesting = false;
  bool? _connectionStatus;
  List<String> _availableModels = [];

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  /// 加载当前配置
  void _loadConfig() {
    final config = ref.read(apiConfigProvider);
    _selectedProvider = config.provider;
    _baseUrlController.text = config.baseUrl;
    _apiKeyController.text = config.apiKey;
    _modelController.text = config.model;
    _temperature = config.temperature;
    _maxTokens = config.maxTokens;
    _streamEnabled = config.streamEnabled;
    _timeoutSeconds = config.timeoutSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 设置'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveConfig,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProviderSelector(),
            const SizedBox(height: 16),
            if (_selectedProvider != APIProviderType.mock) ...[
              _buildBaseUrlField(),
              const SizedBox(height: 16),
              if (_selectedProvider == APIProviderType.openAI) ...[
                _buildApiKeyField(),
                const SizedBox(height: 16),
              ],
              _buildModelSelector(),
              const SizedBox(height: 16),
            ],
            _buildTemperatureSlider(),
            const SizedBox(height: 16),
            _buildMaxTokensField(),
            const SizedBox(height: 16),
            _buildStreamToggle(),
            const SizedBox(height: 16),
            _buildTimeoutField(),
            const SizedBox(height: 24),
            _buildTestConnectionButton(),
            const SizedBox(height: 16),
            _buildConnectionStatus(),
            const SizedBox(height: 24),
            _buildProviderInfo(),
          ],
        ),
      ),
    );
  }

  /// 构建服务提供商选择器
  Widget _buildProviderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('服务提供商', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: APIProviderType.values.map((provider) {
              return RadioListTile<APIProviderType>(
                title: Text(_getProviderName(provider)),
                subtitle: Text(_getProviderDescription(provider)),
                value: provider,
                groupValue: _selectedProvider,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedProvider = value;
                      _connectionStatus = null;
                      _availableModels = [];
                      if (value == APIProviderType.lmStudio) {
                        _baseUrlController.text = 'http://localhost:1234';
                      } else if (value == APIProviderType.openAI) {
                        _baseUrlController.text = 'https://api.openai.com';
                      }
                    });
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 获取提供商名称
  String _getProviderName(APIProviderType provider) {
    switch (provider) {
      case APIProviderType.mock:
        return '模拟服务 (测试用)';
      case APIProviderType.lmStudio:
        return 'LM Studio (本地)';
      case APIProviderType.openAI:
        return 'OpenAI';
      case APIProviderType.custom:
        return '自定义 API';
    }
  }

  /// 获取提供商描述
  String _getProviderDescription(APIProviderType provider) {
    switch (provider) {
      case APIProviderType.mock:
        return '用于测试，返回模拟响应';
      case APIProviderType.lmStudio:
        return '本地运行的 LM Studio 服务';
      case APIProviderType.openAI:
        return 'OpenAI 官方 API';
      case APIProviderType.custom:
        return '兼容 OpenAI 格式的自定义服务';
    }
  }

  /// 构建基础 URL 输入框
  Widget _buildBaseUrlField() {
    return TextFormField(
      controller: _baseUrlController,
      decoration: const InputDecoration(
        labelText: 'API 地址',
        hintText: 'http://localhost:1234',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.link),
      ),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入 API 地址';
        }
        if (!value.startsWith('http://') && !value.startsWith('https://')) {
          return '请输入有效的 URL（以 http:// 或 https:// 开头）';
        }
        return null;
      },
    );
  }

  /// 构建 API Key 输入框
  Widget _buildApiKeyField() {
    return TextFormField(
      controller: _apiKeyController,
      decoration: const InputDecoration(
        labelText: 'API Key',
        hintText: 'sk-...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.key),
      ),
      obscureText: true,
    );
  }

  /// 构建模型选择器
  Widget _buildModelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _modelController,
          decoration: InputDecoration(
            labelText: '模型',
            hintText: '选择或输入模型名称',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.memory),
            suffixIcon: _selectedProvider != APIProviderType.mock
                ? IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadModels,
                    tooltip: '获取可用模型',
                  )
                : null,
          ),
        ),
        if (_availableModels.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableModels.map((model) {
              return ActionChip(
                label: Text(model),
                onPressed: () {
                  setState(() {
                    _modelController.text = model;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// 构建温度滑块
  Widget _buildTemperatureSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('温度 (Temperature)', style: AppTextStyles.body1),
            Text(_temperature.toStringAsFixed(2), style: AppTextStyles.body2),
          ],
        ),
        Slider(
          value: _temperature,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (value) {
            setState(() {
              _temperature = value;
            });
          },
        ),
        Text(
          '较低的值使输出更确定，较高的值使输出更随机',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  /// 构建最大 Token 输入框
  Widget _buildMaxTokensField() {
    return TextFormField(
      initialValue: _maxTokens.toString(),
      decoration: const InputDecoration(
        labelText: '最大 Token 数',
        hintText: '500',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.token),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入最大 Token 数';
        }
        final num = int.tryParse(value);
        if (num == null || num < 1) {
          return '请输入有效的数字';
        }
        return null;
      },
      onSaved: (value) {
        _maxTokens = int.tryParse(value ?? '500') ?? 500;
      },
    );
  }

  /// 构建流式输出开关
  Widget _buildStreamToggle() {
    return SwitchListTile(
      title: const Text('流式输出'),
      subtitle: const Text('逐字显示 AI 响应'),
      value: _streamEnabled,
      onChanged: (value) {
        setState(() {
          _streamEnabled = value;
        });
      },
    );
  }

  /// 构建超时设置
  Widget _buildTimeoutField() {
    return TextFormField(
      initialValue: _timeoutSeconds.toString(),
      decoration: const InputDecoration(
        labelText: '请求超时 (秒)',
        hintText: '30',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.timer),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入超时时间';
        }
        final num = int.tryParse(value);
        if (num == null || num < 1) {
          return '请输入有效的数字';
        }
        return null;
      },
      onSaved: (value) {
        _timeoutSeconds = int.tryParse(value ?? '30') ?? 30;
      },
    );
  }

  /// 构建测试连接按钮
  Widget _buildTestConnectionButton() {
    return GradientButton(
      text: _isTesting ? '测试中...' : '测试连接',
      onPressed: _selectedProvider == APIProviderType.mock 
          ? null 
          : (_isTesting ? null : _testConnection),
    );
  }

  /// 构建连接状态显示
  Widget _buildConnectionStatus() {
    if (_connectionStatus == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _connectionStatus!
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _connectionStatus! ? AppColors.success : AppColors.error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _connectionStatus! ? Icons.check_circle : Icons.error,
            color: _connectionStatus! ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _connectionStatus! ? '连接成功！' : '连接失败，请检查配置',
              style: AppTextStyles.body1.copyWith(
                color: _connectionStatus! ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建提供商信息
  Widget _buildProviderInfo() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('使用说明', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedProvider == APIProviderType.lmStudio) ...[
            _buildInfoItem('1. 下载并安装 LM Studio'),
            _buildInfoItem('2. 在 LM Studio 中加载模型'),
            _buildInfoItem('3. 启动本地服务器 (默认端口 1234)'),
            _buildInfoItem('4. 确保 LM Studio 正在运行'),
          ] else if (_selectedProvider == APIProviderType.openAI) ...[
            _buildInfoItem('1. 访问 OpenAI 官网获取 API Key'),
            _buildInfoItem('2. 确保 API Key 有足够的配额'),
            _buildInfoItem('3. 选择合适的模型'),
          ] else if (_selectedProvider == APIProviderType.mock) ...[
            _buildInfoItem('模拟服务用于测试应用功能'),
            _buildInfoItem('返回预设的模拟响应'),
            _buildInfoItem('无需配置即可使用'),
          ],
        ],
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: AppTextStyles.body2),
          Expanded(child: Text(text, style: AppTextStyles.body2)),
        ],
      ),
    );
  }

  /// 加载可用模型
  Future<void> _loadModels() async {
    if (_selectedProvider == APIProviderType.mock) return;

    try {
      final models = await ref.read(aiServiceProvider).getAvailableModels();
      setState(() {
        _availableModels = models;
      });
      
      if (models.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法获取模型列表，请检查连接')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取模型失败: $e')),
        );
      }
    }
  }

  /// 测试连接
  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _connectionStatus = null;
    });

    try {
      // 先保存临时配置
      _saveTempConfig();
      
      final isConnected = await ref.read(aiServiceProvider).testConnection();
      setState(() {
        _connectionStatus = isConnected;
      });

      if (isConnected) {
        // 连接成功后加载模型列表
        await _loadModels();
      }
    } catch (e) {
      setState(() {
        _connectionStatus = false;
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  /// 保存临时配置（用于测试）
  void _saveTempConfig() {
    final config = APIConfigModel(
      provider: _selectedProvider,
      baseUrl: _baseUrlController.text,
      apiKey: _apiKeyController.text,
      model: _modelController.text,
      temperature: _temperature,
      maxTokens: _maxTokens,
      streamEnabled: _streamEnabled,
      timeoutSeconds: _timeoutSeconds,
    );
    ref.read(apiConfigProvider.notifier).state = config;
  }

  /// 保存配置
  void _saveConfig() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    _saveTempConfig();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('配置已保存')),
    );

    Navigator.of(context).pop();
  }
}
