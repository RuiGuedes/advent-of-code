import { syncReadFile } from '@utils';

/**
 * Parses the stack-related input to a mapped approach in which each
 * key represents the stack identifier and each value represents its
 * content.
 */
function parseStacks(input: string[][]) {
  return input
    .map((e) => {
      const output: string[] = [];
      for (let i = 1; i < e.length; i += 4) {
        output.push(e[i]);
      }
      return output.map((e) => (e === ' ' ? null : e));
    })
    .reduce((acc, val) => {
      for (let i = 0; i < val.length; i++) {
        acc[i + 1] = [...(val[i] ? ([val[i]] as string[]) : []), ...(acc[i + 1] ?? [])];
      }
      return acc;
    }, {} as { [key: number]: string[] });
}

function solve() {
  const input = syncReadFile('5').split('\n');
  const inputSplitIndex = input.findIndex((e) => e === '');

  const stacks = parseStacks(input.slice(0, inputSplitIndex - 1).map((e) => e.split('')));
  const procedure = input
    .slice(inputSplitIndex + 1, input.length)
    .map((e) => e.match(/\d+/g)?.map((e) => Number.parseInt(e)) ?? []);

  /** Executes the stacks rearrangement procedure */
  for (let i = 0; i < procedure.length; i++) {
    let amount = procedure[i][0];
    const source = procedure[i][1];
    const destination = procedure[i][2];

    while (amount-- > 0) {
      const crate = stacks[source].pop();
      if (crate) stacks[destination].push(crate);
    }
  }

  const output = Object.entries(stacks).map(([key, value]) => [key, value[value.length - 1]]);
  console.log(`Here you can find each stack and respective top crate`, output);
}

solve();
