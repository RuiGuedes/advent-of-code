import { syncReadFile } from '@utils';

/**
 * Determines the number of characters that need to be processed before
 * the first start-of-packet marker is detected (if any).
 */
function startOfPacketMarker(datastream: string): number | undefined {
  for (let i = 0; i < datastream.length - 3; i++) {
    const sequence = datastream.substring(i, i + 4).split('');
    const isMarker = sequence.every((c1) => sequence.filter((c2) => c1 === c2).length === 1);

    // Return if marker was found
    if (isMarker) return i + 4;
  }
}

function solve() {
  const input = syncReadFile('6').split('\n');
  const output = input.map((datastream) => {
    const markerIndex = startOfPacketMarker(datastream);
    return `${datastream} -> ${markerIndex ? `First marker after ${markerIndex} character.` : 'No marker was found.'}`;
  });

  console.log('Number of characters need to be processed before the first start-of-packet marker is detected:\n');
  console.log(output.join('\n'));
}

solve();
