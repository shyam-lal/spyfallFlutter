class RoomModel {
  final String id, location;
  final Map players;
  final bool isPlaying;
  final int time;

  RoomModel(this.id, this.location, this.players, this.isPlaying, this.time);

  RoomModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        location = json['location'] as String,
        players = json['players'] as Map<dynamic, dynamic>,
        isPlaying = json['isplaying'] as bool,
        time = json['time'] as int;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'location': location,
        'players': players,
        'isplaying': isPlaying,
        'time': time
      };
}
