import { syncReadFile } from '@utils';

let TOTAL_ROUNDS = 20;

type Operator = '+' | '-' | '*' | '/';
type Operation = [string, Operator, string];

type ParsedInput = {
  [key: string]: {
    items: number[];
    opFn: ReturnType<typeof parseOperation>;
    testFn: (a: number) => string;
  };
};

/**
 * Parses an array-based operation to an actual function
 */
function parseOperation([_, op, val]: Operation) {
  const _val = val === 'old' ? null : Number.parseInt(val);

  switch (op) {
    case '+':
      return (a: number) => a + (_val ?? a);
    case '-':
      return (a: number) => a - (_val ?? a);
    case '*':
      return (a: number) => a * (_val ?? a);
    case '/':
      return (a: number) => a / (_val ?? a);
    default:
      const _exhaustiveCheck: never = op;
      return _exhaustiveCheck;
  }
}

/**
 * Parses the input to a structured format
 */
function parseInput(input: string[]) {
  return input
    .map((e) => e.split('\n'))
    .reduce((acc, val) => {
      // Build the respective monkey object
      acc[val[0].match(/(?<=Monkey )\d(?=:)/g)![0]] = {
        items: val[1].match(/(?<=\s)\d+/g)!.map((e) => Number.parseInt(e)),
        opFn: parseOperation(val[2].match(/(?<== ).*/g)![0].split(' ') as Operation),
        testFn: (a: number) => (a % Number.parseInt(val[3].match(/\d+/g)![0]) === 0 ? val[4] : val[5]).match(/\d+/g)![0]
      };

      return acc;
    }, {} as ParsedInput);
}

function solve() {
  const input = syncReadFile('11');
  const data = parseInput(input.split(/(?<!.+)\n/g));

  const monkeyIds = Object.keys(data);
  const monkeyActivity = monkeyIds.reduce((acc, id) => ({ ...acc, [id]: 0 }), {} as { [key: string]: number });

  while (TOTAL_ROUNDS-- > 0) {
    for (let i = 0; i < monkeyIds.length; i++) {
      const monkeyId = monkeyIds[i];

      // Update the respective monkey activity
      monkeyActivity[monkeyId] += data[monkeyId].items.length;

      // Perform each monkey turn
      while (data[i].items.length > 0) {
        const item = data[i].items.shift() as number;
        const newItem = Math.floor(data[i].opFn(item) / 3);

        // Throws the item to another monkey
        data[data[i].testFn(newItem)].items.push(newItem);
      }
    }
  }

  const output = Object.values(monkeyActivity).sort((a, b) => b - a);
  console.log(`The level of monkey business after 20 rounds is ${output[0] * output[1]}`);
}

solve();
