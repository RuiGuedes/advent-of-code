import { syncReadFile } from '@utils';

type Command = 'cd' | 'ls';
type FilesystemDirectory = { parent?: string; files?: [string, number][]; size?: number };
type Filesystem = { [key: string]: FilesystemDirectory };

const isDir = (s: string) => !!s.match(/(?<=dir\s).+(?!\.)/g);

function solve() {
  const input = syncReadFile('7').split('$ ');
  const dirStack: string[] = [];

  /** Parses the terminal input/output */
  const commands = input
    .map((e) => (e === '' ? null : e.split(/\n|(?<=cd) /g))?.filter((e) => e !== ''))
    .filter((e) => e != undefined) as [Command, ...string[]][];

  /** Build filesystem data structure */
  const filesystem = commands.reduce<Filesystem>((acc, [cmd, ...args]) => {
    switch (cmd) {
      case 'cd':
        /** Moves out one level */
        if (args[0] === '..') dirStack.pop();
        else {
          /** Update the directory stack */
          dirStack.push(args[0]);

          /** Update the filesystem directories */
          if (dirStack.length === 1) acc[args[0]] = {};
          else if (dirStack[dirStack.length - 2] !== args[0]) acc[args[0]] = { parent: dirStack[dirStack.length - 2] };
        }
        break;
      case 'ls':
        /**  */
        const files: [string, number][] = args
          .filter((e) => !isDir(e))
          .map((e) => {
            const [fileSize, fileName] = e.split(' ') as [string, string];
            return [fileName.split('.')[0], Number.parseInt(fileSize)];
          });

        /** Current directory name and size  */
        const currDir = dirStack[dirStack.length - 1];

        /** Update the filesystem directories' files */
        if (acc[currDir]) acc[currDir].files = files;
        else acc[currDir] = { files };

        break;
      default:
        console.warn(`The following command is not supported: ${cmd}`);
        break;
    }

    return acc;
  }, {});

  /** Update the filesystem directories' size */
  const fsKeys = Object.keys(filesystem);
  const fsEntries = Object.entries(filesystem);

  const dirSize = (dir: string) => filesystem[dir].files?.reduce((acc, val) => acc + val[1], 0) ?? 0;
  const subDirSize = (dir: string) => {
    const subDirs = fsEntries.filter((e) => e[1].parent === dir);
    return subDirs.length === 0 ? 0 : subDirs.reduce((acc, val) => acc + dirSize(val[0]), 0);
  };

  fsKeys.forEach((dir) => {
    filesystem[dir].size = dirSize(dir) + subDirSize(dir);
  });

  const output = fsEntries.filter((e) => (e[1].size ?? 0) <= 100000).reduce((acc, val) => acc + (val[1].size ?? 0), 0);
  console.log(`The sum of the total sizes is ${output}.`);
}

solve();
