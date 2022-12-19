import { syncReadFile } from '@utils';

type Position = [number, number]; // [Row, Column]

const INITIAL_POSITION: Position = [0, 0];
const FINAL_POSITION: Position = [2, 5];

const CACHE: { [key in `${number},${number}`]: ReturnType<typeof next> } = {};

/**
 * Get the set of new candidate positions
 */
function next([r, c]: Position, heightmap: number[][], path: Position[]) {
  const nextPos: Position[] = [
    [r - 1, c], // Up
    [r, c + 1], // Right
    [r + 1, c], // Down
    [r, c - 1] // Left
  ];

  return nextPos.filter(
    ([er, ec]) =>
      !path.find(([pr, pc]) => pr === er && pc === ec) &&
      heightmap[er]?.[ec] &&
      heightmap[er][ec] - heightmap[r][c] <= 1
  );
}

/**
 * Recursively computes the path with the fewest steps to reach the final position.
 */
function computePath(currPos: Position, heightmap: number[][], path: Position[] = []): number {
  const cacheId: keyof typeof CACHE = `${currPos[0]},${currPos[1]}`;

  // Update the recursive path
  path.push(currPos);

  // Update the cache by retrieving the next candidate's position
  if (!CACHE[cacheId]) CACHE[cacheId] = next(currPos, heightmap, path);

  if (CACHE[cacheId].find(([er, ec]) => er === FINAL_POSITION[0] && ec === FINAL_POSITION[1])) return 1;
  else return 1 + CACHE[cacheId].map((nextPos) => computePath(nextPos, heightmap, path)).sort((a, b) => a - b)[0];
}

function solve() {
  const input = syncReadFile('12').split('\n');
  const heightmap = input.map((e) => e.split('').map((e) => (e === 'S' ? 'a' : e === 'E' ? 'z' : e).charCodeAt(0)));

  const output = computePath(INITIAL_POSITION, heightmap);
  console.log(`A total of ${output} steps are required to reach the location that should get the best signal.`);
}

solve();
