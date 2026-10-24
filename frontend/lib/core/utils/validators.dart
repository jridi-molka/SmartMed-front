class Validators {
  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 2) return 'Le nom doit contenir au moins 2 caractères';
    if (text.length > 100) return 'Le nom ne peut pas dépasser 100 caractères';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Veuillez saisir votre email';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) return 'Adresse email invalide';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (text.length > 72) {
      return 'Le mot de passe ne peut pas dépasser 72 caractères';
    }
    return null;
  }

  static String? optionalPassword(String? value) {
    if (value == null || value.isEmpty) return null;
    return password(value);
  }
}