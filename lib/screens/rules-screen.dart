import 'package:flutter/material.dart';
import 'package:spyfall/custom_widgets/custombutton.dart';

class RulesScreen extends StatelessWidget {
  // const RulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        width: screenWidth,
        child: ListView(
          children: [
            HeadingText("What you need to play"),
            UnorderedListItem("4-12 people."),
            UnorderedListItem("All in same room or same Zoom call"),
            UnorderedListItem("Each has their own phone, computer, or tablet."),
            /////
            HeadingText('Game objectives:'),
            UnorderedListItem(
                "The spy: try to guess the round's location. Infer from others' questions and answers."),
            UnorderedListItem("Other players: figure out who the spy is."),
            ////////
            //////
            ///////
            HeadingText('Gameplay flow:'),
            UnorderedListItem(
                'Round length: 6-10 minutes. Shorter for smaller groups, longer for larger.'),
            UnorderedListItem(
                "The location: round starts, each player is given a location card. The location is the same for all players (e.g., the bank) except for one player, who is randomly given the spy card. The spy does not know the round's location."),
            UnorderedListItem(
                "Questioning: the game leader (person who started the game) begins by questioning another player about the location."),
            UnorderedListItem(
                "Answering: the questioned player must answer. No follow up questions allowed. After they answer, it's then their turn to ask someone else a question. This continues until round is over."),
            UnorderedListItem(
                "No retaliation questions: if someone asked you a question for their turn, you cannot then immediately ask them a question back for your turn. You must choose someone else."),
            //////
            //////
            //////
            HeadingText("Players guessing the spy:"),
            UnorderedListItem(
                "Putting up for vote: at any time, a player can try to indict a suspected spy by putting that suspect up for vote. They must say I'd like to put (player x) up for vote. Then go one by one clockwise around the circle, and each player much cast their vote if they're in agreement to indict."),
            UnorderedListItem(
                "Vote must be unanimous to indict: the vote must be unanimous to indict the suspect: if any player votes no, the round continues as it was. Each person can only put a suspect up for vote once per round. Use it wisely!"),
            UnorderedListItem(
                "Spy is indicted: if a player is indicted, they must reveal whether or not they are the spy and the round ends."),
            //////
            //////
            /////
            HeadingText("Spy guessing the location:"),
            UnorderedListItem(
                "Spy guesses: at any time, the spy can reveal that they are the spy and make a guess at what the location is. The round immediately ends."),
            //////
            //////
            /////
            HeadingText("Round ends when:"),
            UnorderedListItem(
                "Indictment: group successfully indicts a player after voting OR"),
            UnorderedListItem(
                "Spy guesses: spy stops the round to make a guess about the location OR"),
            UnorderedListItem("No time left: clock runs out"),
            //////
            /////
            HeadingText("Scoring and who wins:"),
            Text(
              "Spy Victory",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            UnorderedListItem(
                "The spy earns 2 points if no one is successfully indicted of being the spy"),
            UnorderedListItem(
                "The spy earns 4 points if a non-spy player is successfully indicted of being a spy"),
            UnorderedListItem(
                "The spy earns 4 points if the spy stops the game and successfully guesses the location"),
            Text("Non-Spy Victory"),
            UnorderedListItem("Each non-spy player earns 1 point"),
            UnorderedListItem(
                "The player who initiated the successful indictment of the spy earns 2 points instead"),
            Text("Running total:"),
            UnorderedListItem(
                "You can play for as many rounds as you'd like. Whoever has the most points at the end of the target number of rounds is the overall game winner."),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 25),
                  child: SFButton(
                      "Go Back", screenHeight * 0.06, screenWidth * 0.3, () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  // const HeadingText({Key? key}) : super(key: key);
  final String text;
  HeadingText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 6,
        ),
        Text(
          "• ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}

class NormalText extends StatelessWidget {
  // const HeadingText({Key? key}) : super(key: key);
  final String text;
  NormalText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
