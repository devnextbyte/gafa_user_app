class CompaniesDummyData {
  static const CompaniesDummyData instance = const CompaniesDummyData();

  const CompaniesDummyData();

  dynamic get getCompaniesListResp => {
        "data": [
          {
            "name": "Bill Payment",
            "companyId": 2,
            "imageUrl": "/assets/img/3903d068-8ccf-4192-85ab-7b3052bd4a5a.jpg",
            "createdDate": "02/10/2021 07:38",
            "type": 1
          },
          {
            "name": "Air Time Top Up Company",
            "companyId": 1,
            "imageUrl": "/assets/img/d6cca5a9-85df-42b0-bd60-e348b12f82d4.jpg",
            "createdDate": "02/10/2021 07:37",
            "type": 2
          }
        ],
        "count": 2
      };
}
