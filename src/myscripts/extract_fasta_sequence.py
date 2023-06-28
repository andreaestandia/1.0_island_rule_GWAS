import argparse


def extract_fasta_sequence(fasta_file, sequence_id, start_position, end_position):
    """Extract a sequence from a fasta file between start_position and end_position, inclusive."""
    sequence = ''
    header_line = ''
    sequence_id_found = False
    count = 0

    with open(fasta_file) as f:
        for line in f:
            if line.startswith('>' + sequence_id):
                header_line = line.strip()
                sequence_id_found = True
                continue  # Skip header line

            if sequence_id_found:
                count += len(line.strip())
                sequence += line.strip()

                if count >= end_position:
                    break

    extracted_sequence = sequence[start_position - 1: end_position]  # Adjust for 0-based indexing

    return header_line, f"Start: {start_position}, Finish: {end_position}", extracted_sequence


if __name__ == '__main__':
    # Set up command-line arguments
    parser = argparse.ArgumentParser(description='Extract a subsequence from a fasta file.')
    parser.add_argument('fasta_file', help='the name of the fasta file')
    parser.add_argument('sequence_id', help='the ID of the sequence to extract')
    parser.add_argument('start_position', type=int, help='the starting position of the subsequence')
    parser.add_argument('end_position', type=int, help='the ending position of the subsequence')

    # Parse command-line arguments
    args = parser.parse_args()

    # Call the extract_fasta_sequence function with the specified arguments
    header, positions, sequence = extract_fasta_sequence(args.fasta_file, args.sequence_id, args.start_position,
                                                        args.end_position)

    # Print the header line, start and finish positions, and the extracted sequence
    print(header)
    print(positions)
    print(sequence)
