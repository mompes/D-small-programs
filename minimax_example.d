#!/usr/bin/rdmd
//An example using the small Dminimax
/*
  Author: Juan Mompeán Esteban
  Date: 11, june 2012
*/

import minimax;
import std.array;
import std.algorithm;
import std.container;
import std.stdio;

class TicTacToeAction : Action {
  int x, y, player;
  this(int nx, int ny, int nplayer) {
    x = nx;
    y = ny;
    player = nplayer;
  }
}

class TicTacToeState : State {
  int[][] board;
  static int size = 3;
  
  this() {
    board = new int[][](TicTacToeState.size, TicTacToeState.size);
  }
  
  //Return true if it is a final state, otherwise false
  bool terminal_test() {
    //Check the horizontal and vertical lines
    for (int i = 0; i < TicTacToeState.size; i++) {
      if (((board[i][0] != 0) & (board[i][0] == board[i][1]) & (board[i][1] == board[i][2])) | ((board[0][i] != 0) & (board[0][i] == board[1][i]) & (board[1][i] == board[2][i]))) {
        return true;
      }
    }
    
    //Check the cross lines
    if (((board[0][0] != 0) & (board[0][0] == board[1][1]) & (board[1][1] == board[2][2])) | ((board[0][2] != 0) & (board[0][2] == board[1][1]) & (board[1][1] == board[2][0]))) {
      return true;
    }
    
    //Check if the board isn't full
    foreach (b; board) {
      if (any!"a == 0"(b)) {
        return false;
      }
    }
    
    //Otherwise the board is full
    return true;
  }
  
  //Return the value of the state
  int utility() {
    //Check the horizontal and vertical lines
    for (int i = 0; i < TicTacToeState.size; i++) {
      if ((board[i][0] != 0) & (board[i][0] == board[i][1]) & (board[i][1] == board[i][2])) {
        if (board[i][0] == 1) {
          return 1;
        } else {
          return -1;
        }
      }
      if ((board[0][i] != 0) & (board[0][i] == board[1][i]) & (board[1][i] == board[2][i])) {
        if (board[0][i] == 1) {
          return 1;
        } else {
          return -1;
        }
      }
    }
    //Check the cross lines
    if (((board[0][0] != 0) & (board[0][0] == board[1][1]) & (board[1][1] == board[2][2])) | ((board[0][2] != 0) & (board[0][2] == board[1][1]) & (board[1][1] == board[2][0]))) {
        if (board[1][1] == 1) {
          return 1;
        } else {
          return -1;
        }
    }
    //It is a tie
    return 0;
  }
  //Return an array with the possible actions from this state
  SList!Action actions(int player) {
    auto actions = SList!Action();
    for (int i = 0; i < TicTacToeState.size; i++) {
      for (int j = 0; j < TicTacToeState.size; j++) {
        if (board[i][j] == 0) {
          actions.insert(new TicTacToeAction(i, j, player));
        }
      }
    }
    return actions;
  }
  //Return the result of apply an action to this state
  State result(Action a) {
    TicTacToeAction b = cast(TicTacToeAction)a;
    auto nstate = new TicTacToeState();
    // Copy the current state
    for (int i = 0; i < TicTacToeState.size; i++) {
      copy(board[i], nstate.board[i]);
    }
    //Update the state with the new action
    nstate.board[b.x][b.y] = b.player;
    return nstate;
  }
}

void main() {
  int result = int.min;
  State state = new TicTacToeState();
  foreach(action; state.actions(1)) {
    writeln(min_value(state.result(action), int.min, int.max));
  }
}
