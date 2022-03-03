import 'package:gafamoney/model/company_model.dart';

class InsuranceLine {
  List<CompanyModel> getInsuranceCompanies() {
    return [
      CompanyModel(
        type: 3,
        name: "Health Insurance",
        companyId: 0,
        imageUrl: "assets/images/ins_health.png",
      ),
      CompanyModel(
        type: 3,
        name: "House Insurance",
        companyId: 0,
        imageUrl: "assets/images/ins_house.png",
      ),
      CompanyModel(
        type: 3,
        name: "Car Insurance",
        companyId: 0,
        imageUrl: "assets/images/ins_car.png",
      ),
      CompanyModel(
        type: 3,
        name: "Education Insurance",
        companyId: 0,
        imageUrl: "assets/images/ins_edu.png",
      ),
    ];
  }
}
