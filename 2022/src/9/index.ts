import { syncReadFile } from '@utils';

type Direction = 'U' | 'R' | 'D' | 'L';
type Position = [number, number]; // [Row, Column]

const INITIAL_STATE = [
  ['.', '.', '.', '.', '.', '.'],
  ['.', '.', '.', '.', '.', '.'],
  ['.', '.', '.', '.', '.', '.'],
  ['.', '.', '.', '.', '.', '.'],
  ['s', '.', '.', '.', '.', '.']
];

const INITIAL_POSITION: Position = [INITIAL_STATE.length - 1, 0];

/**
 * Returns the new position after a given move is performed
 */
function move(dir: Direction, [row, column]: Position, state: string[][]): Position {
  switch (dir) {
    case 'U':
      return [Math.max(row - 1, 0), column];
    case 'R':
      return [row, Math.min(column + 1, state[row].length - 1)];
    case 'D':
      return [Math.min(row + 1, state.length - 1), column];
    case 'L':
      return [row, Math.max(0, column - 1)];
    default:
      const _exhaustiveCheck: never = dir;
      return _exhaustiveCheck;
  }
}

/**
 * Determines whether or not two positions are adjacent
 */
function isAdjacent([tr, tc]: Position, [hr, hc]: Position): boolean {
  return Math.abs(tr - hr) <= 1 && Math.abs(tc - hc) <= 1;
}

/**
 * Updates the tail position to a new one that is adjacent to the head position
 */
function updateTail([tr, tc]: Position, [hr, hc]: Position, state: string[][]): Position {
  const motions: Direction[] = [];

  if (tr === hr) motions.push(tc < hc ? 'R' : 'L'); // Same row
  else if (tc === hc) motions.push(tr < hr ? 'D' : 'U'); // Same column
  else motions.push(tc < hc ? 'R' : 'L', tr < hr ? 'D' : 'U'); // Move diagonally

  let finalPos: Position = [tr, tc];
  for (let i = 0; i < motions.length; i++) {
    finalPos = move(motions[i], finalPos, state);
  }

  return finalPos;
}

function solve() {
  const input = syncReadFile('9').split('\n');
  const data = input.map((e) => e.split(' ').map((e, idx) => (idx === 1 ? Number.parseInt(e) : e))) as [
    Direction,
    number
  ][];

  const state = INITIAL_STATE;
  const headPos: Position[] = [INITIAL_POSITION];
  const tailPos: Position[] = [INITIAL_POSITION];

  for (let i = 0; i < data.length; i++) {
    let totalSteps = data[i][1];
    const direction = data[i][0];

    while (totalSteps-- > 0) {
      const newHeadPos = move(direction, headPos[headPos.length - 1], state);

      // Check if tail is adjacent and update it if needed
      if (!isAdjacent(tailPos[tailPos.length - 1], newHeadPos)) {
        const newTailPos = updateTail(tailPos[tailPos.length - 1], newHeadPos, state);
        tailPos.push(newTailPos);
      }

      // Update the head position
      headPos.push(newHeadPos);
    }
  }

  const output = [...new Set(tailPos.map((e) => JSON.stringify(e)))];
  console.log(`A total of ${output.length} positions have been visited at least once by the tail of the rope.`);
}

solve();
