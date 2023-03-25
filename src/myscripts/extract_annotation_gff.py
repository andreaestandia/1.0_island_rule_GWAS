import argparse

def extract_gff3_annotation(gff3_file, start_position, end_position, chromosome):
    """Extract a GFF3 annotation between start_position and end_position, inclusive."""
    annotation = ''
    with open(gff3_file) as f:
        for line in f:
            if line.startswith('#'):
                continue  # Skip comment lines
            fields = line.split('\t')
            if fields[0].startswith(chromosome):
                chrom_start, chrom_end = map(int, fields[0].split(':')[1].split('-'))
                if start_position <= chrom_end and end_position >= chrom_start:
                    annotation += line
    
    return annotation


if __name__ == '__main__':
    # Define command line arguments
    parser = argparse.ArgumentParser(description='Extract a GFF3 annotation between two positions')
    parser.add_argument('gff3_file', help='Path to the GFF3 file')
    parser.add_argument('start_position', type=int, help='Starting position of the region of interest')
    parser.add_argument('end_position', type=int, help='Ending position of the region of interest')
    parser.add_argument('chromosome', help='Chromosome to search for positions in')
    
    # Parse command line arguments
    args = parser.parse_args()
    
    # Extract annotation and print to console
    annotation = extract_gff3_annotation(args.gff3_file, args.start_position, args.end_position, args.chromosome)
    print(annotation)
