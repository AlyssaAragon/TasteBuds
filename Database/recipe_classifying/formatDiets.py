# this file reads the csv outputted by dietRecipeClassification.py and formats the csv to fit the recipeDiet model
import pandas as pd
possible_tags = ["Vegetarian", "Vegan", "Gluten-Free", "Dairy-Free", "Nut-Free", "Low-Carb", "Keto", "Paleo"]
df = pd.read_csv("dietClassifiedRecipes.csv")
for tag in possible_tags:
    df[tag] = df["diet_type"].apply(lambda x: 1 if tag in x else 0)

output_df = df[["recipeID"] + possible_tags]
output_df.to_csv("dietRecipe.csv", index=False)
