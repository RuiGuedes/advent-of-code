import fs from 'fs';

/**
 * Reads the contents of an utf-8 file
 */
export function syncReadFile(filename: string) {
  return fs.readFileSync(`${__dirname}/${filename}/input.in`, { encoding: 'utf-8' });
}
