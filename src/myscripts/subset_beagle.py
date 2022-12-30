
# Libraries

from subprocess import Popen, PIPE
import time
import argparse

# Function difinitions


def subset_beagle(PATH_BEAGLE, PATH_SAMPLES, PATH_OUTPUT):
    """This function removes individuals from a BEAGLE file

    Args:
        PATH_BEAGLE (PosixPath): Path to the BEAGLE file NOT in compressed format
        PATH_SAMPLES (PosixPath): Path to samples to remove
        PATH_OUTPUT (PosixPath): Path to output file. This path should include the 
            name of the file. If it does not exist it will create it. If it does exist 
            it will overwrite it.
    """

    ids2remove = get_ids(PATH_BEAGLE, PATH_SAMPLES)
    bash_command = f"cat {PATH_BEAGLE} | cut -f{ids2remove} --complement > {PATH_OUTPUT}"

    process, time_started = Popen(
        ["/bin/bash", "-c", bash_command], stdout=PIPE, stderr=PIPE, stdin=PIPE), time.time()

    stdout, stderr = process.communicate()

    time_delta = time.time() - time_started

    if process.returncode == 0:
        print(f"Finished process in {round(time_delta, 3)} seconds.\n"
              f"You can find the output file in {PATH_OUTPUT}")
    else:
        print(f"OMG it didn't work!\n{stderr}")


def get_ids(PATH_BEAGLE, PATH_SAMPLES):
    with open(PATH_SAMPLES, newline='') as f:
        reader = f.read().split('\n')
        samples2keep = list(reader)[:-1]

    with open(PATH_BEAGLE, 'r') as input:
        for line in input:
            linestr = line.split("\t")
            linestr[-1] = linestr[-1][:-1] if '\n' in linestr[-1] else linestr[-1]
            if line == 0:
                common_idx = [i for i, item in enumerate(
                    linestr) if item not in samples2keep]
                print(common_idx)
            else:
                break

    common_idx = [i+1 for i,
                  item in enumerate(linestr) if item not in samples2keep][3:]

    ids2remove = ','.join([str(x) for x in common_idx])
    return ids2remove

# Main


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--beagle", default="", help="Path to BEAGLE file.")
    parser.add_argument("--samples", default="",
                        help="Path to samples to keep.")
    parser.add_argument("--out", default="", help="Path to output file.")
    args = parser.parse_args()
    print(args.samples, args.beagle, args.out)
    subset_beagle(args.beagle, args.samples, args.out)


if __name__ == "__main__":
    main()
