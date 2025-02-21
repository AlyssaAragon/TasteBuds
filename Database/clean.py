import csv

input_file = 'recipe.csv'
output_file = 'recipe_updated.csv'
base_url = 'http://localhost:8000/'
max_lines = 2000  # Number of lines (rows) to process (excluding the header)

with open(input_file, mode='r', encoding='utf-8') as infile, \
     open(output_file, mode='w', newline='', encoding='utf-8') as outfile:
    
    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames  # e.g. ['recipeID', 'title', 'ingredients', 'instructions', 'image_name', 'cleaned_ingredients']
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    writer.writeheader()
    
    line_count = 0
    for row in reader:
        if line_count >= max_lines:
            break

        # Get the current image_name, stripping whitespace
        image_name = row.get('image_name', '').strip()
        if image_name:
            # Prepend the base_url if it's not already there
            if not image_name.startswith(base_url):
                image_name = base_url + image_name
            # Ensure the URL ends with ".jpg" (case insensitive)
            if not image_name.lower().endswith('.jpg'):
                image_name = image_name.rstrip()  # remove trailing whitespace
                image_name += '.jpg'
        row['image_name'] = image_name
        
        writer.writerow(row)
        line_count += 1

print(f"Updated CSV saved as {output_file}")
