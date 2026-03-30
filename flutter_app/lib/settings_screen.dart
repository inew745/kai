import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class SettingsScreen extends StatefulWidget {
  final String token;
  final ValueChanged<String> onTokenChanged;

  const SettingsScreen({
    super.key,
    required this.token,
    required this.onTokenChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _tokenCtrl;
  bool _obscure = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _tokenCtrl = TextEditingController(text: widget.token);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hf_token', _tokenCtrl.text.trim());
    widget.onTokenChanged(_tokenCtrl.text.trim());
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Kai
          _SectionCard(
            icon: Icons.smart_toy_outlined,
            title: 'אודות Kai',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('K',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kai',
                          style: TextStyle(
                            color: KaiTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'מבוסס DialoGPT-medium',
                          style: TextStyle(
                            color: KaiTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kai הוא עוזר AI חכם המבוסס על מודל DialoGPT-medium של Microsoft, '
                  'דרך ה-Hugging Face Inference API.',
                  style: TextStyle(
                    color: KaiTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // API Token
          _SectionCard(
            icon: Icons.key_outlined,
            title: 'Hugging Face API Token',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'הכנס את ה-token שלך מ-Hugging Face כדי לקבל rate limit גבוה יותר. '
                  'ניתן לייצר token ב: huggingface.co/settings/tokens',
                  style: TextStyle(
                    color: KaiTheme.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tokenCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(
                    color: KaiTheme.textPrimary,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                  decoration: InputDecoration(
                    hintText: 'hf_...',
                    hintStyle: const TextStyle(color: KaiTheme.textMuted),
                    filled: true,
                    fillColor: KaiTheme.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: KaiTheme.primary, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: KaiTheme.textMuted,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KaiTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _saved ? '✓ נשמר!' : 'שמור Token',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Model info
          _SectionCard(
            icon: Icons.info_outline,
            title: 'מידע על המודל',
            child: const Column(
              children: [
                _InfoRow(label: 'מודל', value: 'DialoGPT-medium'),
                _InfoRow(label: 'ספק', value: 'Microsoft / Hugging Face'),
                _InfoRow(label: 'שפה', value: 'אנגלית (בעיקר)'),
                _InfoRow(label: 'גרסה', value: '1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    super.dispose();
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KaiTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KaiTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: KaiTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: KaiTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: KaiTheme.textSecondary, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: KaiTheme.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}
