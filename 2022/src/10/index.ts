import { syncReadFile } from '@utils';

function solve() {
  const input = syncReadFile('10').split('\n');
  const program = input.map((e) => (e === 'noop' ? null : Number.parseInt(e.split(' ')[1])));
  const data: { [key: string]: number } = {};

  let X = 1;
  let currCycle = 1;
  let signalStrengthCycle = 20;

  const signalFn = () => {
    if (signalStrengthCycle === currCycle) {
      data[signalStrengthCycle] = X * currCycle;
      signalStrengthCycle += 40;
    }
  };

  for (let i = 0; i < program.length; i++) {
    // By default
    currCycle++;
    signalFn();

    // Continue if noop instruction was found
    if (program[i] === null) continue;

    currCycle++;
    X += program[i] as number;
    signalFn();
  }

  const output = Object.values(data).reduce((acc, val) => acc + val, 0);
  console.log(`The sum of all signal strengths is ${output}.`);
}

solve();
