#!/usr/bin/rdmd
//A small minimax implementation. AKA Dminimax
/*
  Author: Juan Mompeán Esteban
  Date: 11, june 2012
*/

module minimax;

import std.algorithm;
import std.container;


abstract class Action {

}

interface State {
  //Return true if it is a final state, otherwise false
  bool terminal_test();
  //Return the value of the state
  int utility();
  //Return an array with the possible actions from this state
  SList!Action actions(int player);
  //Return the result of apply an action to this state
  State result(Action a) 
    in {
      assert (a !is null);
    }
    out (result) {
      assert (result !is null);
    }
}

int max_value(State state, int alpha, int beta) 
  in {
    assert (state !is null);
  }
  body {
    if (state.terminal_test()) {
      return state.utility();
    }
    int v = int.min;
    foreach(action; state.actions(1)) {
      v = max(v, min_value(state.result(action), alpha, beta));
      if (v >= beta) {
        return v;
      }
      alpha = max(v, alpha);
    }
    return v;
  }

int min_value(State state, int alpha, int beta) 
  in {
    assert (state !is null);
  }
  body {
    if (state.terminal_test()) {
      return state.utility();
    }
    int v = int.max;
    foreach(action; state.actions(2)) {
      v = min(v, max_value(state.result(action), alpha, beta));
      if (v <= alpha) {
        return v;
      }
      beta = min(v, beta);
    }
    return v;
  }

