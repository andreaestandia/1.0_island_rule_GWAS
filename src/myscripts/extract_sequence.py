import argparse


def extract_fasta_sequence(fasta_file, sequence_id, start_position, end_position):
    """Extract a sequence from a fasta file between start_position and end_position, inclusive."""
    sequence = ''
    with open(fasta_file) as f:
        for line in f:
            if line.startswith('>' + sequence_id):
                continue  # Skip header line
            sequence += line.strip()
    
    return sequence[start_position-1:end_position]  # Adjust for 0-based indexing


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
    sequence = extract_fasta_sequence(args.fasta_file, args.sequence_id, args.start_position, args.end_position)
    
    # Print the extracted sequence to the console
    print(sequence)
