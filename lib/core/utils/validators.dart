/// 验证工具类
/// 
/// 提供常用的表单验证方法
class Validators {
  Validators._();

  /// 验证非空
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '此字段'}不能为空';
    }
    return null;
  }

  /// 验证邮箱
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱地址';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  /// 验证密码强度
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 8) {
      return '密码长度至少8位';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return '密码需包含大写字母';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return '密码需包含小写字母';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return '密码需包含数字';
    }
    return null;
  }

  /// 验证密码确认
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != password) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  /// 验证手机号
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return '请输入有效的手机号';
    }
    return null;
  }

  /// 验证用户名
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入用户名';
    }
    if (value.length < 3) {
      return '用户名长度至少3位';
    }
    if (value.length > 20) {
      return '用户名长度不能超过20位';
    }
    if (!RegExp(r'^[a-zA-Z0-9_\u4e00-\u9fa5]+$').hasMatch(value)) {
      return '用户名只能包含字母、数字、下划线和中文';
    }
    return null;
  }

  /// 验证长度范围
  static String? lengthRange(String? value, int min, int max, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '此字段'}不能为空';
    }
    if (value.length < min) {
      return '${fieldName ?? '此字段'}长度至少$min位';
    }
    if (value.length > max) {
      return '${fieldName ?? '此字段'}长度不能超过$max位';
    }
    return null;
  }

  /// 验证数值范围
  static String? numberRange(String? value, num min, num max, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '请输入${fieldName ?? '数值'}';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return '请输入有效的数值';
    }
    if (number < min || number > max) {
      return '${fieldName ?? '数值'}需在$min到$max之间';
    }
    return null;
  }

  /// 组合验证器
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
