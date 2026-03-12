# Dart/Flutter 常见错误及解决方案

## 2026-03-11 错误记录

### 1. freezed 生成文件不存在

**错误信息**:
```
Target of URI doesn't exist: 'package:talk/core/config/api_config_model.freezed.dart'.
Target of URI hasn't been generated: 'package:talk/core/config/api_config_model.g.dart'.
```

**原因**: 
- 使用 `@freezed` 注解但没有运行 `build_runner` 生成代码
- 新创建的模型文件需要先运行代码生成器

**解决方案**:
1. 对于简单模型，手动实现 `fromJson`、`toJson`、`copyWith` 方法，避免依赖 freezed
2. 如果必须使用 freezed，在创建模型后立即运行：
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

**最佳实践**:
- 简单配置模型优先使用普通 class，手动实现序列化
- 只有复杂且需要大量样板代码的模型才使用 freezed

---

### 2. 类名重复定义冲突

**错误信息**:
```
The name 'AIRequestModel' is defined in the libraries 'package:talk/core/services/ai_service.dart' and 'package:talk/features/dialogue/data/models/chat_session_model.dart'.
```

**原因**:
- 在多个文件中定义了相同名称的类
- 导致导入时出现命名冲突

**解决方案**:
1. 删除重复定义，只保留一个位置
2. 或使用 `import 'xxx.dart' as prefix;` 添加前缀区分
3. 或使用 `show/hide` 关键字控制导出

**最佳实践**:
- 通用模型放在 `core/` 目录下
- 功能特定模型放在对应 feature 目录下
- 避免在多个位置定义相同功能的类

---

### 3. Provider 重复定义

**错误信息**:
```
Undefined name 'apiConfigProvider'.
```

**原因**:
- Provider 在多个文件中定义，删除后其他文件找不到
- Provider 定义位置不明确

**解决方案**:
1. Provider 应该只在一个地方定义
2. 其他文件通过 import 导入使用
3. 将通用 Provider 放在 `core/` 目录下

**最佳实践**:
- 每个 Provider 只定义一次
- 在最相关的文件中定义 Provider
- 通过 export 文件统一导出

---

### 4. 导出文件路径错误

**错误信息**:
```
Target of URI doesn't exist: 'pages/api_settings_page.dart'.
```

**原因**:
- 导出文件中的相对路径不正确
- 目录结构与导出路径不匹配

**解决方案**:
- 检查目录结构，确保路径正确
- 使用正确的相对路径

**最佳实践**:
- 创建导出文件时先确认目录结构
- 使用 IDE 的自动补全避免路径错误

---

## 代码规范总结

### 模型定义规范
1. 简单配置模型：使用普通 class，手动实现序列化
2. 复杂业务模型：使用 freezed，但需确保运行 build_runner
3. Hive TypeAdapter：手动实现，不依赖代码生成

### Provider 定义规范
1. 每个 Provider 只定义一次
2. 通用 Provider 放在 `core/services/` 下
3. 功能特定 Provider 放在对应 feature 的 `presentation/providers/` 下

### 文件组织规范
1. `core/` - 通用基础设施
2. `features/{module}/` - 功能模块
3. 避免跨模块重复定义相同功能的类

### 导入导出规范
1. 使用 `library;` 声明库
2. 使用相对路径导出同级或下级文件
3. 使用 `package:talk/...` 导入其他模块
