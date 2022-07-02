class RoomModel {
  final String id, location;
  final Map players;
  final bool isPlaying;

  RoomModel(this.id, this.location, this.players, this.isPlaying);

  RoomModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        location = json['location'] as String,
        players = json['players'] as Map<dynamic, dynamic>,
        isPlaying = json['isplaying'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'location': location,
        'players': players,
        'isplaying': isPlaying
      };
}
