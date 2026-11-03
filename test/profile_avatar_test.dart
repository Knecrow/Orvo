import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/ui/components/profile_avatar.dart';

void main() {
  group('ProfileAvatar.computeInitials', () {
    test('computes single initial for single name', () {
      expect(ProfileAvatar.computeInitials('Alex'), 'A');
      expect(ProfileAvatar.computeInitials('david'), 'D');
    });

    test('computes two initials for first and last name', () {
      expect(ProfileAvatar.computeInitials('John Doe'), 'JD');
      expect(ProfileAvatar.computeInitials('sarah connor'), 'SC');
    });

    test('takes first and last words when multiple words present', () {
      expect(ProfileAvatar.computeInitials('Marcus Aurelius Antoninus'), 'MA');
    });

    test('handles whitespace and empty strings gracefully', () {
      expect(ProfileAvatar.computeInitials(''), '');
      expect(ProfileAvatar.computeInitials('   '), '');
      expect(ProfileAvatar.computeInitials('   Alex   '), 'A');
      expect(ProfileAvatar.computeInitials('  John    Doe  '), 'JD');
    });
  });
}

