import { syncReadFile } from '@utils';

/**
 * Computes the priority of a given element
 * - Lowercase item types a through z have priorities 1 through 26.
 * - Uppercase item types A through Z have priorities 27 through 52.
 */
function priority(elem: string) {
  if (elem.length !== 1) return -1;
  else return elem.toLowerCase().charCodeAt(0) - 97 + (elem === elem.toLowerCase() ? 1 : 27);
}

function solve() {
  const input = syncReadFile('03').split('\n');
  const data = input
    .map((e) => [e.slice(0, e.length / 2), e.slice(e.length / 2, e.length)])
    .map((e) => {
      const firstRucksack = [...new Set(e[0].split(''))];
      const secondRucksack = new Set(e[1].split(''));
      return firstRucksack.filter((e) => secondRucksack.has(e));
    })
    .map((e) => e.map((i) => [i, priority(i)] as [string, number]));

  const output = data.reduce((acc, val) => acc + val.map((e) => e[1]).reduce((_acc, _val) => _acc + _val, 0), 0);
  console.log(`The sum of the priorities of itens that appears in both compartments of each rucksack is ${output}.`);
}

solve();
