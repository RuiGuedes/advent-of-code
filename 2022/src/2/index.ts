import { syncReadFile } from '@utils';

type Shape = 'X' | 'Y' | 'Z'; // Rock, Paper, Scissors
type OpponentShape = 'A' | 'B' | 'C'; // Rock, Paper, Scissors

type Round = [OpponentShape, Shape];

const ROUND_SCORE = { LOST: 0, DRAW: 3, WON: 6 };
const SHAPE_SCORE: { [key in Shape]: number } = { X: 1, Y: 2, Z: 3 };

/**
 * Computes the score of a given round
 */
function score([s1, s2]: Round) {
  const draw = (s1 === 'A' && s2 === 'X') || (s1 === 'B' && s2 === 'Y') || (s1 === 'C' && s2 === 'Z');
  const lost = (s1 === 'A' && s2 === 'Z') || (s1 === 'B' && s2 === 'X') || (s1 === 'C' && s2 === 'Y');

  if (draw) return SHAPE_SCORE[s2] + ROUND_SCORE.DRAW;
  else if (lost) return SHAPE_SCORE[s2] + ROUND_SCORE.LOST;
  else return SHAPE_SCORE[s2] + ROUND_SCORE.WON;
}

function solve() {
  const input = syncReadFile('2/input.in').split('\n');
  const plays = input.map((e) => score(e.split(' ') as Round));
  const output = plays.reduce((acc, val) => acc + val, 0);
  console.log(`If everything goes exactly according to the strategy guide the total score will be ${output}.`);
}

solve();
