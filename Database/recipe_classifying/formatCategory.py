import pandas as pd
# Format the final csv to fit the recipeClassifcation model

df_media = pd.read_csv('recipeCategoryClassification.csv')
df_recipe = pd.read_csv('recipe_updated.csv')

# Merge the two data tables
df_merged = pd.merge(df_recipe, df_media, on='image_name', how='inner')

df_output = df_merged[['recipeID','tag']]

df_output.to_csv('foodCat.csv', index=False)
