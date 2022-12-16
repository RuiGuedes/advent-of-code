import { syncReadFile } from '@utils';

function solve() {
  const input = syncReadFile('01').split('\n');

  const data = input.reduce<number[]>((acc, val) => {
    if (acc.length === 0) acc.push(Number.parseInt(val));
    else if (val === '') acc.push(0);
    else acc[acc.length - 1] = acc[acc.length - 1] + Number.parseInt(val);

    return acc;
  }, []);

  const output = data.reduce<[number, number]>((acc, val, index) => (acc[1] < val ? [index, val] : acc), [-1, -1]);
  console.log(`The Elf number ${output[0]} carrying the most calories (${output[1]})`);
}

solve();
