class RequestModel {
  final String id;
  final String clientId;
  final String workerId;
  final String scriptContent;
  final String? location;
  final DateTime dateAndTime;
  final String details;

  const RequestModel(
      {required this.id,
      required this.clientId,
      required this.workerId,
      required this.scriptContent,
      required this.location,
      required this.dateAndTime,
      required this.details});

  toJson() {
    return {
      "client_id": clientId,
      "worker_id": workerId,
      "location": location,
      "date_time": dateAndTime,
      "details": details,
    };
  }
}
