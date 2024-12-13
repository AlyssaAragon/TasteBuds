#made this so that we have a command to upload the recipes instead of inputting them manually everytime we have database issues. 
# Alyssa 
import csv
import os

from django.core.management.base import BaseCommand
from tastebuds.models import AllRecipe

class Command(BaseCommand):

    def handle(self, *args, **options):
        file_path = '/Users/alyssaaragon/Desktop/TasteBuds/first_1000_rows.csv' #update for your setup
        
        try:
            with open(file_path, 'r') as file:
                reader = csv.DictReader(file)
                
                for row in reader:
                    all_recipe, created = AllRecipe.objects.get_or_create(
                        name=row['name'],
                        description=row.get('description', ''),
                        ingredients=row['ingredients'],
                        ingredients_raw_str=row['ingredients_raw_str'],
                        serving_size=row['serving_size'],
                        servings=row['servings'],
                        steps=row['steps'],
                        tags=row['tags'],
                        search_terms=row['search_terms']
                    )
                    if created:
                        self.stdout.write(self.style.SUCCESS(f'Successfully added recipe: {all_recipe.name}'))
                    else:
                        self.stdout.write(self.style.SUCCESS(f'Recipe already exists: {all_recipe.name}'))

        except FileNotFoundError:
            self.stderr.write(self.style.ERROR(f'Error: The file "{file_path}" was not found.'))
        except Exception as e:
            self.stderr.write(self.style.ERROR(f'An error occurred: {str(e)}'))