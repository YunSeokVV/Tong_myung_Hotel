import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tong_myung_hotel/model/note.dart';


// CollectionReference : A CollectionReference object can be used for adding documents, getting document references, and querying for documents (using the methods inherited from [Query]).
// 번역 : CollectionReference 객체는 문서를 추가하거나, 문서를 불러오거나, 문서를 쿼리하는데 사용된다. ([쿼리]에 의해 상속된 메소드를 사용)
// 내 생각 : FireabaseDB 에 데이터를 추가하거나 불러올 때 사용된다는것을 의미하는듯 하다. (그 과정에서 쿼리가 사용되는듯)

// Firestore : The entry point for accessing a Firestore. You can get an instance by calling [Firestore.instance].

// collection : Gets a [CollectionReference] for the specified Firestore path.
// 내 생각 : FIrebaseDB 의 데이터를 추가하거나 수정하기위해 파이어베이스 객체를 생성한다. 이 때 'notes' 라고하는 경로가 사용된다. (내가 설정한 CloudFirestore 을 참고할 것.)
final CollectionReference noteCollection = Firestore.instance.collection('Tongmyung_dormitory');

class FirebaseFirestoreService {

  //FirebaseFirestoreService 클래스의 객체 생성
  //여기서 internal 메소드가 어떻게 정의됐는지 찾아보고싶은데 어디있는지 모르겠다. internal : 내부의
  static final FirebaseFirestoreService _instance = new FirebaseFirestoreService
      .internal();

  //(공홈) factory : Use the factory keyword when implementing a constructor that doesn’t always create a new instance of its class.
  // 항상 클래스의 같은 객체를 만들지않기 위해서 factory 예약어를 사용한다. 더 이상 화살표함수에대한 설명은 하지않겠다. 에버노트를 참조할 것. (화살표 함수를 사용해서 _instance 를 return 한다는 뜻.)
  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

  //출처 : https://beomseok95.tistory.com/309
  //future는 비동기 작업의 결과를 나타내며 미완료(value를 생성하기 전)또는 완료(value 생성)의 두 가지 상태를 가질 수 있다. 주로 동기, 비동기 작업을 사용할 때 쓴다.
  //async (비동기 통신):정보를 일정한 속도로 보낼 것을 요구하지 않는 데이터 전송 방법이다.

  // (내 생각) 이 추상클래스는 FirebStore 에서 데이터를 갖고오는 역할을 해준다.
  // (틀린 생각) 여기서 createNote 라고 표현한 이유는 ListView의 아이템하나하나를 Note 라고 생각한뒤 아이템을 만들기 때문에 create Note 라고 표현한듯 하다.
  // Firestore 에 데이터를 추가하는 역할을 해주는 메소드이다. 컬렉션의 이름이 'notes' 이기 때문에 createNote 라고 메소드명을 지은듯 하다.
  Future<Note> createNote(Map title,String enter_room_time,String after_room_time,int differ_day) async {
    print("firebase_firestore_service 파일의 createNote 메소드가 호출됨");

    //TransactionHandler,Transaction : The [TransactionHandler] may be executed multiple times; it should be able to handle multiple executions.
    final TransactionHandler createTransaction = (Transaction tx) async {
      //DocumentSnapshot : A DocumentSnapshot contains data read from a document in your Firestore database.
      // document : Returns a `DocumentReference` with the provided path.
      // 내 생각 : FirebaseDB 에서 내가 지정한 경로의 데이터를 갖고온다.
      // document : Returns a `DocumentReference` with the provided path.
      //final DocumentSnapshot ds = await tx.get(noteCollection.document("hl3IeIYptZAcRJeaZyr9"));
      final DocumentSnapshot ds = await tx.get(noteCollection.document());

      //불러온 데이터의 객체 note 이다. 문서의ID, 제목, 설명 등이 멤버변수로 포함되있다.
      // documentID : Returns the ID of the snapshot's document
      final Note note = new Note(ds.documentID,title,enter_room_time,after_room_time,differ_day);
      print("ds.documentID 의 값 ");
      print(ds.documentID);
      print("ds.reference 의 값 ");
      print(ds.reference);

      // (공홈) dynamic : Dart supports generic types, like List<int> (a list of integers) or List<dynamic> (a list of objects of any type).
      // (공홈)When you want to explicitly say that no type is expected, use the special type dynamic. (이걸 읽을것)
      // Map 자료형인 data 에 사용자의 id, title, description 정보가 내포된다.
      //note.toMap() : 이 메소드는 Map 에 사용자의 id, title, description 을 대입한다. 그리고 Map 객체를 리턴한다.
      final Map<String, dynamic> data = note.toMap(enter_room_time,after_room_time,differ_day);

      //(블로거 주석) Using set() to create or overwrite a single document   (Create)
      //await : The async and await keywords support asynchronous(비동기) programming, letting you write asynchronous code that looks similar to synchronous code.
      // reference : The reference(언급한것) that produced this snapshot
      // 불러온 데이터를 Tranaction 객체인 tx 에 최신화 시킨다.
      await tx.set(ds.reference, data);

      return data;
    };

    //Firestore : The entry point for accessing a Firestore. You can get an instance by calling [Firestore.instance].
    //runTransaction : Executes the given TransactionHandler and then attempts to commit the changes applied within an atomic transaction.
    //번역 : TransactionHandler 를 실행하고 DB의 원자단위를 적용된 변경 사항을 실행한다.
    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Note.fromMap(mapData,enter_room_time,after_room_time,differ_day);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  //(블로거 주석) : get all Documents from Collection (Read)
  //Stream : A source of asynchronous(동시에 발생하지 않는) data events.
  //QuerySnapshot : A QuerySnapshot contains zero or more DocumentSnapshot objects.
  //내 생각 : 파이어베이스DB 의 데이터를 불러와주는 역할을 하는듯 하다.
  Stream<QuerySnapshot> getNoteList({int offset, int limit}) {
    print("firebase_firestore_service 파일의 getNoteList 메소드가 호출됨");
    print("offset 의 값 : "+offset.toString());
    print("limit 의 값 : "+limit.toString());

    //noteCollection : FIrebaseDB 의 데이터를 추가하거나 수정하기위해 파이어베이스 객체를 생성한다.
    //snapshots : Notifies of query results at this location
    Stream<QuerySnapshot> snapshots = noteCollection.snapshots();

    if (offset != null) {
      print("offset 이 null 이 아니면");
      //skip : Skips the first [count] data events from this stream.
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      print("limit 이 null 이 아니면");
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  //Update
  // (공홈) dynamic : Dart supports generic types, like List<int> (a list of integers) or List<dynamic> (a list of objects of any type).
  // (공홈)When you want to explicitly say that no type is expected, use the special type dynamic. (이걸 읽을것)
  // 이 메소드는 FireStore 의 데이터를 업데이트 해주는 역할을 하는 메소드이다.
  Future<dynamic> updateNote(Note note,String enter_time,Map map) async {
    print("firebase_firestore_service 파일의 updateNote 메소드가 호출됨");
    print(note.document_id);
    print(enter_time);
    print("map 의 값 ");
    print(map);

    print("updateNote 1");

    // TransactionHandler,Transaction : The [TransactionHandler] may be executed multiple times; it should be able to handle multiple executions.
    final TransactionHandler updateTransaction = (Transaction tx) async {

      print("updateNote 2");

      //DocumentSnapshot : A DocumentSnapshot contains data read from a document in your Firestore database.
      // document : Returns a `DocumentReference` with the provided path.
      // 내 생각 : FirebaseDB 에서 내가 지정한 경로의 데이터를 갖고온다.
      final DocumentSnapshot ds = await tx.get(noteCollection.document(note.document_id));

      print("updateNote 3");

      //await : The async and await keywords support asynchronous(비동기) programming, letting you write asynchronous code that looks similar to synchronous code.
      // reference : The reference that produced this snapshot
      //update : Updates fields in the document referred to by [documentReference].
      //이 메소드는 Map 에 사용자의 id, title, description 을 대입한다. 그리고 Map 객체를 리턴한다.
      await tx.update(ds.reference, note.toMapforUpdate(enter_time,map));

      print("updateNote 4");

      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('updateNote 메소드에서 Update 실패함: $error');
      return false;
    });
  }

}