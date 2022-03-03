import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/model/gafa_user_model.dart';

import '../dummy/recent_contacts_dummy.dart';
import '../snippets.dart';

void main() {
  test("Test Gafa User Model", () {
    final model = GafaUserModel.fromJson(getRecentContactsDummy['data'][0]);
    expect(model.phoneNumber, "+923024191873");
    expect(model.name, "Kamran");
    expect(model.userId, "12-id-kamran");
    expect(model.image, "imageUrl");
  });

  test("Test request recent contacts line", () async {
    final line = RecentContactsLine();
    final resp = await line.getRecentContacts(await getToken());
    expect(resp.isSuccess, true);
    print(resp.response.users.length);
  });
}
