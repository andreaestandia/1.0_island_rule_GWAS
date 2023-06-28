import sys

def extract_annotations(input_table, gff3_file, output_file):
    # Read the table and store the relevant positions and chromosomes
    positions = {}
    with open(input_table, 'r') as table:
        next(table)  # Skip the header line
        for line in table:
            start_position, end_position, chromosome = line.strip().split('\t')
            start_position, end_position = int(start_position), int(end_position)
            if chromosome not in positions:
                positions[chromosome] = []
            positions[chromosome].append((start_position, end_position))

    # Process the GFF3 file and extract the matching annotations
    with open(gff3_file, 'r') as gff3:
        with open(output_file, 'w') as output:
            for line in gff3:
                if not line.startswith('#'):  # Skip commented lines
                    fields = line.strip().split('\t')
                    chromosome_field = fields[0]

                    if ':' in chromosome_field and '-' in chromosome_field:
                        chromosome, position_range = chromosome_field.split(':')
                        start, end = position_range.split('-')
                        start, end = int(start), int(end)

                        if chromosome in positions:
                            for pos_start, pos_end in positions[chromosome]:
                                if (pos_start <= start and pos_end >= start) or (pos_start <= end and pos_end >= end):
                                    output.write(line)
                                    break

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Usage: python extract_annotations.py input_table gff3_file output_file')
    else:
        input_table = sys.argv[1]
        gff3_file = sys.argv[2]
        output_file = sys.argv[3]
        extract_annotations(input_table, gff3_file, output_file)
