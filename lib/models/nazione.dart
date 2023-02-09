import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Nazione {
  final String area;
  final String capital;
  final String continent;
  final String country;
  final String currencyCode;
  final String currencyName;
  final String fips;
  final String iso3;
  final String iso;
  final String isoNumeric;
  final String phone;
  final String population;
  final String tld;

  const Nazione({
    required this.area,
    required this.capital,
    required this.continent,
    required this.country,
    required this.currencyCode,
    required this.currencyName,
    required this.fips,
    required this.iso,
    required this.iso3,
    required this.isoNumeric,
    required this.phone,
    required this.population,
    required this.tld,
  });

  factory Nazione.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Nazione(
      area: data?['area'],
      capital: data?['capital'],
      continent: data?['continent'],
      country: data?['country'],
      currencyCode: data?['currencyCode'],
      currencyName: data?['currencyName'],
      fips: data?['fips'],
      iso: data?['iso'],
      iso3: data?['iso3'],
      isoNumeric: data?['isoNumeric'],
      phone: data?['phone'],
      population: data?['population'],
      tld: data?['tld'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (area != null) "area": area,
      if (capital != null) "capital": capital,
      if (continent != null) "continent": continent,
      if (country != null) "country": country,
      if (currencyCode != null) "currencyCode": currencyCode,
      if (currencyName != null) "currencyName": currencyName,
      if (fips != null) "fips": fips,
      if (iso3 != null) "iso3": iso3,
      if (isoNumeric != null) "isoNumeric": isoNumeric,
      if (phone != null) "phone": phone,
      if (population != null) "population": population,
      if (tld != null) "tld": tld,
    };
  }
}