import 'package:aqgolf/aqgolf.dart';


class UserController extends ResourceController {
  final ManagedContext context;
  UserController(this.context);

//  @override
//  Future<RequestOrResponse> handle(Request request) async {
//    return Response.ok(_heroes);
//  }
  @Operation.get()
  Future<Response> getAllUsers() async {
    final userQuery = Query<User>(context);
    final users = await userQuery.fetch();
    return Response.ok(users);
  }
  @Operation.get('id')
  Future<Response> getUserByID(@Bind.path('id') int id) async {
    final userQuery = Query<User>(context)
      ..where((h) => h.id).equalTo(id);

    final user = await userQuery.fetchOne();

    if (user == null) {
      return Response.notFound();
    }
    return Response.ok(user);
  }

  @Operation.post()
  Future<Response> createUser() async {
    final Map<String, dynamic> body = await request.body.decode();
    final query = Query<User>(context)
      ..values.email = body['email'] as String;

    final insertedUser = await query.insert();

    return Response.ok(insertedUser);
  }




}