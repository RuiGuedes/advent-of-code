import { syncReadFile } from '@utils';

function solve() {
  const input = syncReadFile('08').split('\n');
  const data = input.map((e) => e.split('').map((e) => [Number.parseInt(e), 1]));

  for (let i = 1; i < data.length - 1; i++) {
    for (let j = 1; j < data[i].length - 1; j++) {
      const row = data[i];
      const column = data.reduce((acc, val) => [...acc, ...val.filter((_, index) => index === j)], []);

      const [left, right] = [row.slice(0, j), row.slice(j + 1, row.length)];
      const [top, bottom] = [column.slice(0, i), column.slice(i + 1, column.length)];

      const isVerticalVisible = top.every(([e]) => e < data[i][j][0]) || bottom.every(([e]) => e < data[i][j][0]);
      const isHorizontalVisible = left.every(([e]) => e < data[i][j][0]) || right.every(([e]) => e < data[i][j][0]);

      const isVisible = isVerticalVisible || isHorizontalVisible ? 1 : 0;
      data[i][j] = [data[i][j][0], isVisible ? 1 : 0];
    }
  }

  const output = data.reduce((acc, val) => acc + val.filter(([_, e]) => e === 1).length, 0);
  console.log(`There is a total of ${output} trees that are visible from outside the grid.`);
}

solve();
