import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/contact_tables.dart';

part 'contact_dao.g.dart';

@DriftAccessor(tables: [Contact])
class ContactDao extends DatabaseAccessor<AppDatabase> with _$ContactDaoMixin {
  ContactDao(super.db);

  Future<List<ContactData>> getAllContacts() => select(contact).get();

  Future<List<ContactData>> getContactsByPatientId(int patientId) {
    return (select(contact)..where((t) => t.patientId.equals(patientId))).get();
  }

  Future<ContactData?> getContactById(int id) {
    return (select(contact)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertContact(ContactCompanion entry) {
    return into(contact).insert(entry);
  }

  Future<bool> updateContact(ContactCompanion entry) {
    return update(contact).replace(entry);
  }

  Future<int> deleteContact(int id) {
    return (delete(contact)..where((t) => t.id.equals(id))).go();
  }
}
