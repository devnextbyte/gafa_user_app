import 'package:gafamoney/model/company_model.dart';
import 'package:test/test.dart';

import '../dummy/companies_dummy_data.dart';
import '../snippets.dart';

void main() async {
  test("Test Company Model", () {
    final resp = CompanyListResp.fromJson(
      CompaniesDummyData.instance.getCompaniesListResp,
    );
    expect(resp.getBillPaymentCompanies().length, 1);
    final cBill = resp.getBillPaymentCompanies().first;
    expect(cBill.name, "Bill Payment");
    expect(cBill.type, 1);
    expect(cBill.companyId, 2);

    final cAir = resp.getAirtimeTopUpCompanies().first;
    expect(cAir.name, "Air Time Top Up Company");
    expect(cAir.type, 2);
    expect(cAir.companyId, 1);
  });

  group("Api test", () {
    test("Load Companies", () async {
      final cl = CompanyListLine();
      final resp = await cl.getCompaniesList(await getToken());
      expect(resp.isSuccess, true);
    });
  });
}
