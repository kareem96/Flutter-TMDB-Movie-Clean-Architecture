




class ServerException implements Exception{}

class DataBaseException implements Exception{
  final String message;
  DataBaseException(this.message);
}