const express = require("express");
require("dotenv").config();
const http = require("http");
const mongoose = require("mongoose");
const roomModel = require("./models/gameroom_model");

const app = express();
const port = process.env.Port || 3000;
var server = http.createServer(app);

const io = require("socket.io")(server);

//use middlewares

//convert all incoming to jscon
app.use(express.json);

//db connection string
// console.log(process.env.DB_PASSWORD);
const DB = `mongodb+srv://iniwillie10:${process.env.DB_PASSWORD}@cluster0.mvh1bm6.mongodb.net/myfirstcollection`;

io.on("connection", (socket) => {
  console.log("connected");
  //listening to createroom event that is being emmitted to the server
  socket.on("createRoom", async ({ nickname }) => {
    try {
      console.log(nickname);

      // create a game room
      let room = new roomModel(); //roomModel object

      let player = {
        socketID: socket.id,
        nickname: nickname,
        playerType: "X",
      };
      //add player to the players list of room
      room.players.push(player);
      (room.turn = player),
        //save to mongodb
        (roomDoc = await room.save());
      const roomId = roomDoc._id.toString();
      //socket only listen/send to a particular roomId
      socket.join(roomId);
      // Note: IO- sends data to everyone
      // socket sends data to ourself
      io.to(roomId).emit("createdRoomSuccess", room);
    } catch (error) {
      console.log(error);
    }
  });

  socket.on("joinRoom", async ({ nickname, roomId }) => {
    try {
      //check roomid match if not emit error
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("errorOcuured", "please ensure you enter a valid room ID");
        return;
      }
      //find room with the roomId
      let room = await roomModel.findById(roomId);

      //check room is free ie not already joined
      if (room.isJoin) {
        let player = {
          nickname: nickname,
          socketID: socket.id,
          playerType: "O",
        };
        //join socket connection
        socket.join(roomId);

        room.players.push(player);
        // make the room not free for joining
        room.isJoin = false;
        //save room
        room = await room.save();
        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        //a listener to ensure the game screen is open from the waiting screen and another player join the game
        io.to(roomId).emit("updateRoom", room);
      } else {
        //emmit error if room is already join
        socket.emit("errorOcuured", "The game is already in progress....");
      }
    } catch (error) {
      console.log(error);
    }
  });

  socket.on("tap", async ({ index, roomId }) => {
    try {
      //get the room
      let room = await roomModel.findById(roomId);
      //capture current player choice
      let playerChoice = room.turn.playerType; //this is either x or o

      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      //save to mongo
      room = await room.save();

      io.to(roomId).emit("tapped", {
        index: index,
        choice: playerChoice,
        room,
      });
    } catch (error) {
      console.log(error);
    }
  });

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      //get game rrom
      let room = await roomModel.findById(roomId);

      //find a player that matches the winnersocketId
      let player = room.players.find(
        (Eachplayer) => Eachplayer.socketID == winnerSocketId
      );
      //increase player score
      player.points += 1;
      //save to mongo
      room = await room.save();
      //check when points is greater or equal to maxround which is 6
      if (player.points >= room.maxRounds) {
        io.to(roomId).emit("endGame", player);
      } else {
        io.to(roomId).emit("pointsIncrease", player);
      }
    } catch (error) {
      console.log(error);
    }
  });
});

mongoose
  .connect(DB)
  .then(() => {
    console.log("db connected");
    //start server
    server.listen(port, "0.0.0.0", () => {
      console.log("server started and running on port " + port);
    });
  })
  .catch((e) => {
    console.log(e);
    console.log("stuck here");
  });
