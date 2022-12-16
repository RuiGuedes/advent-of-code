import { syncReadFile } from '@utils';

/**
 * Computes a range of numeric values (inclusive)
 */
function range(a: number, b: number) {
  const output = [a++];
  while (a <= b) {
    output.push(a++);
  }
  return output;
}

function solve() {
  const input = syncReadFile('04').split('\n');
  const data = input.map((e) =>
    e
      .split(',')
      .map((e) => e.split('-').map((e) => Number.parseInt(e)))
      .map(([a, b]) => range(a, b))
  );

  const output = data
    .map(([a, b]) => (a.length >= b.length ? b.every((e) => a.includes(e)) : a.every((e) => b.includes(e))))
    .reduce((acc, val) => acc + (val ? 1 : 0), 0);

  console.log(`A total of ${output} assignment pairs has one range that fully contains the other.`);
}

solve();
