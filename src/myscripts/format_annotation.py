import sys

def extract_info(input_file, output_file):
    with open(input_file, 'r') as file:
        with open(output_file, 'w') as output:
            output.write("chromosome\tstart_position\tend_position\tdescription\n")  # Write header line
            for line in file:
                line = line.strip().split('\t')
                first_column = line[0]
                description = None

                if ':' in first_column and '-' in first_column:
                    chromosome, position_range = first_column.split(':')
                    start_position, end_position = position_range.split('-')
                    start_position, end_position = int(start_position), int(end_position)

                    for part in line:
                        if part.startswith('ID='):
                            subfields = part.split(';')
                            for subfield in subfields:
                                if subfield.startswith('description='):
                                    description = subfield.split('=')[1]
                                    break

                    if description is not None:
                        output.write(f"{chromosome}\t{start_position}\t{end_position}\t{description}\n")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: python extract_info.py input_file output_file')
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
        extract_info(input_file, output_file)
