import '../../domain/entity/bill_data.dart';

class BillsModel {
  bool? success;
  BillsDataModel? data;

  BillsModel({this.success, this.data});

  BillsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? BillsDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BillsDataModel {
  List<BillItems>? items;
  Meta? meta;

  BillsDataModel({this.items, this.meta});

  BillsDataModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <BillItems>[];
      json['items'].forEach((v) {
        items!.add(BillItems.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class BillItems {
  String? id;
  String? name;
  String? amount;
  String? date;
  String? status;
  String? type;
  String? currencyId;

  BillItems({
    this.id,
    this.name,
    this.amount,
    this.date,
    this.status,
    this.type,
    this.currencyId,
  });

  BillItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    date = json['date'];
    status = json['status'];
    type = json['type'];
    currencyId = json['currencyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['date'] = date;
    data['status'] = status;
    data['type'] = type;
    data['currencyId'] = currencyId;
    return data;
  }

  BillData toEntity() {
    return BillData(
      id: id,
      name: name,
      amount: amount,
      date: date,
      status: status,
      type: type,
    );
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  Totals? totals;

  Meta({this.page, this.limit, this.total, this.totals});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totals = json['totals'] != null ? Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    if (totals != null) {
      data['totals'] = totals!.toJson();
    }
    return data;
  }
}

class Totals {
  int? individual;
  int? group;

  Totals({this.individual, this.group});

  Totals.fromJson(Map<String, dynamic> json) {
    individual = json['individual'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['individual'] = individual;
    data['group'] = group;
    return data;
  }
}
