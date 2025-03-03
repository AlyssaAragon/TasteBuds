# Filters recipes based on keywords to identify diets


'''
    non_vegan_keywords = ['beef', 'pork', 'chicken', 'turkey', 'duck', 'lamb', 'veal', 'goat', 'rabbit', 'venison', 'bison', 'buffalo', 'quail', 'pheasant', 'goose', 'kangaroo', 'horse', 'wild boar', 'frog legs', 'turtle meat',
'fish', 'salmon', 'tuna', 'cod', 'halibut', 'sardines', 'anchovy', 'mackerel', 'trout', 'bass', 'snapper', 'swordfish', 'catfish', 'herring', 'flounder', 'sole', 'grouper', 'perch', 'tilapia', 'eel', 'shark',
'shrimp', 'lobster', 'crab', 'clams', 'mussels', 'oysters', 'scallops', 'squid', 'octopus', 'caviar', 'roe', 'krill', 'snails',
'bacon', 'ham', 'prosciutto', 'pepperoni', 'salami', 'chorizo', 'sausage', 'hot dogs', 'pastrami', 'corned beef', 'bologna', 'liverwurst',
'gelatin', 'rennet', 'lard', 'suet', 'tallow', 'bone broth', 'meat broth', 'fish sauce', 'oyster sauce', 'Worcestershire sauce', 'shrimp paste', 'cuttlefish ink', 'gravy', 'pâté',
'haggis', 'blood sausage', 'black pudding', 'sweetbreads', 'tripe', 'head cheese', 'scrapple', 'chicken stock', 'beef stock', 'pork stock',
'honey', 'carmine', 'shellac']
    non_vegetarian_keywords = ['beef', 'pork', 'chicken', 'turkey', 'duck', 'lamb', 'veal', 'goat', 'rabbit', 'venison', 'bison', 'buffalo', 'quail', 'pheasant', 'goose', 'kangaroo', 'horse', 'wild boar', 'frog legs', 'turtle meat',
'fish', 'salmon', 'tuna', 'cod', 'halibut', 'sardines', 'anchovy', 'mackerel', 'trout', 'bass', 'snapper', 'swordfish', 'catfish', 'herring', 'flounder', 'sole', 'grouper', 'perch', 'tilapia', 'eel', 'shark',
'shrimp', 'lobster', 'crab', 'clams', 'mussels', 'oysters', 'scallops', 'squid', 'octopus', 'caviar', 'roe', 'krill', 'snails',
'bacon', 'ham', 'prosciutto', 'pepperoni', 'salami', 'chorizo', 'sausage', 'hot dogs', 'pastrami', 'corned beef', 'bologna', 'liverwurst',
'gelatin', 'rennet', 'lard', 'suet', 'tallow', 'bone broth', 'meat broth', 'fish sauce', 'oyster sauce', 'Worcestershire sauce', 'shrimp paste', 'cuttlefish ink', 'gravy', 'pâté',
'haggis', 'blood sausage', 'black pudding', 'sweetbreads', 'tripe', 'head cheese', 'scrapple', 'chicken stock', 'beef stock', 'pork stock',
'milk', 'butter', 'cheese', 'cream', 'yogurt', 'ghee', 'casein', 'whey', 'lactose', 'curds',
'eggs', 'egg whites', 'mayonnaise', 'albumin', 'lysozyme',
'honey', 'bee pollen', 'royal jelly',
'carmine', 'shellac', 'lanolin', 'isenglass']
    
    gluten_containing_keywords = ['wheat', 'barley', 'rye', 'triticale', 'spelt', 'farro', 'durum', 'semolina', 'bulgur', 'einkorn', 'kamut',
'bran', 'wheat germ', 'wheat starch', 'malt', 'malt extract', 'malt syrup', 'malt vinegar', 'brewer’s yeast', 'modified wheat starch',
'beer', 'ale', 'lager',
'soy sauce', 'teriyaki sauce', 'hoisin sauce', 'worcestershire sauce',
'seitan', 'couscous', 'orzo', 'graham flour',
'regular bread', 'regular pasta', 'regular pizza crust', 'regular flour tortillas', 'regular bagels', 'regular crackers', 'regular pretzels', 'regular pastries', 'regular cakes', 'regular cookies', 'regular cereals', 'regular pancakes', 'regular waffles', 'regular biscuits', 'regular pie crust',
'stuffing', 'breadcrumbs', 'croutons', 'panko',
'processed meats with fillers', 'meat substitutes made from wheat',
'soups or sauces with flour as a thickener', 'gravy with flour', 'roux',
'fried foods with a wheat-based batter',
'oatmeal unless certified gluten-free', 'white bread', 'all-purpose flour']
    
    keto_keywords = ['meat', 'beef', 'pork', 'chicken', 'turkey', 'lamb', 'duck', 'bison', 'venison', 'bacon', 'sausage', 'steak', 'ribs', 'ground beef', 'ham', 'pepperoni', 'salami',
'fish', 'salmon', 'tuna', 'mackerel', 'sardines', 'trout', 'cod', 'halibut', 'bass', 'snapper', 'herring', 'anchovy', 'flounder', 'sole',
'seafood', 'shrimp', 'lobster', 'crab', 'clams', 'mussels', 'oysters', 'scallops', 'squid', 'octopus',
'eggs', 'whole eggs', 'egg yolk', 'hard-boiled eggs', 'scrambled eggs', 'deviled eggs',
'cheese', 'cheddar', 'mozzarella', 'parmesan', 'gouda', 'brie', 'goat cheese', 'cream cheese', 'feta', 'blue cheese', 'swiss',
'dairy', 'butter', 'heavy cream', 'sour cream', 'ghee', 'whipping cream',
'low-carb vegetables', 'spinach', 'kale', 'lettuce', 'arugula', 'zucchini', 'broccoli', 'cauliflower', 'cabbage', 'asparagus', 'brussels sprouts', 'mushrooms', 'cucumber', 'bell peppers', 'avocado', 'celery', 'radish', 'eggplant', 'green beans', 'bok choy',
'nuts and seeds', 'almonds', 'walnuts', 'pecans', 'macadamia nuts', 'brazil nuts', 'pumpkin seeds', 'sunflower seeds', 'chia seeds', 'flaxseeds', 'hemp seeds',
'healthy fats', 'olive oil', 'avocado oil', 'coconut oil', 'lard', 'tallow', 'MCT oil', 'butter', 'ghee',
'low-carb fruits', 'avocado', 'blackberries', 'raspberries', 'strawberries', 'blueberries', 'olives',
'low-carb beverages', 'water', 'sparkling water', 'black coffee', 'tea', 'bone broth',
'sugar substitutes', 'stevia', 'erythritol', 'monk fruit', 'xylitol', 'allulose']
    
    keto_restricted_keywords = ['grains', 'wheat', 'barley', 'rye', 'corn', 'oats', 'rice', 'quinoa', 'bulgur', 'farro', 'millet', 'amaranth', 'sorghum', 'buckwheat',
'bread', 'white bread', 'whole wheat bread', 'bagels', 'toast', 'crackers', 'croutons', 'tortillas', 'pita', 'naan', 'flatbread',
'pasta', 'spaghetti', 'macaroni', 'lasagna', 'noodles', 'ramen', 'fettuccine', 'linguine', 'penne', 'rice noodles', 'udon', 'soba',
'cereal', 'granola', 'oatmeal', 'muesli', 'cornflakes', 'bran flakes',
'legumes', 'beans', 'black beans', 'kidney beans', 'pinto beans', 'chickpeas', 'lentils', 'peas', 'edamame', 'soybeans', 'hummus',
'starchy vegetables', 'potatoes', 'sweet potatoes', 'yams', 'carrots', 'parsnips', 'beets', 'corn', 'butternut squash', 'acorn squash', 'pumpkin', 'peas',
'fruit', 'bananas', 'apples', 'oranges', 'grapes', 'mangoes', 'pineapple', 'pears', 'peaches', 'plums', 'cherries', 'figs', 'dates', 'raisins', 'prunes', 'watermelon',
'dairy with added sugar', 'milk', 'skim milk', 'low-fat milk', 'sweetened yogurt', 'flavored yogurt', 'ice cream',
'processed foods', 'chips', 'pretzels', 'crackers', 'popcorn', 'cookies', 'cake', 'donuts', 'muffins', 'cupcakes', 'candy', 'chocolate bars',
'sugary foods', 'honey', 'maple syrup', 'agave syrup', 'table sugar', 'cane sugar', 'brown sugar', 'high-fructose corn syrup',
'sweetened beverages', 'soda', 'fruit juice', 'sports drinks', 'energy drinks', 'sweetened coffee', 'sweetened tea',
'alcohol with carbs', 'beer', 'wine', 'cocktails', 'liqueurs']
    high_carb_keywords = ['wheat', 'barley', 'rye', 'corn', 'oats', 'rice', 'quinoa', 'bulgur', 'farro', 'millet', 'amaranth', 'sorghum', 'buckwheat',
'bread', 'white bread', 'whole wheat bread', 'bagels', 'toast', 'crackers', 'croutons', 'tortillas', 'pita', 'naan', 'flatbread',
'pasta', 'spaghetti', 'macaroni', 'lasagna', 'noodles', 'ramen', 'fettuccine', 'linguine', 'penne', 'rice noodles', 'udon', 'soba',
'cereal', 'granola', 'oatmeal', 'muesli', 'cornflakes', 'bran flakes',
'potatoes', 'sweet potatoes', 'yams', 'parsnips', 'beets', 'corn', 'butternut squash', 'acorn squash', 'pumpkin', 'plantains', 'cassava', 'tapioca','black beans', 'kidney beans', 'pinto beans', 'chickpeas', 'lentils', 'peas', 'edamame', 'soybeans', 'hummus','chips', 'pretzels', 'crackers', 'popcorn', 'cookies', 'cake', 'donuts', 'muffins', 'cupcakes', 'candy', 'chocolate bars',
'honey', 'maple syrup', 'agave syrup', 'table sugar', 'cane sugar', 'brown sugar', 'high-fructose corn syrup','soda', 'fruit juice', 'sports drinks', 'energy drinks', 'sweetened coffee', 'sweetened tea',
'beer', 'sweet wine', 'cocktails', 'liqueurs']
    
    paleo_keywords = ['meat', 'fish', 'eggs', 'vegetables', 'fruits', 'nuts', 'seeds', 'olive oil', 'coconut oil', 'honey', 'grass-fed beef', 'free-range eggs', 'wild-caught fish', 'coconut aminos']
    paleo_restricted_keywords = ['beef', 'pork', 'chicken', 'turkey', 'duck', 'lamb', 'bison', 'venison', 'rabbit', 'wild boar', 'quail', 'pheasant', 'goose', 'kangaroo', 'fish', 'salmon', 'tuna', 'mackerel', 'sardines', 'trout', 'cod', 'halibut', 'snapper', 'herring', 'anchovy', 'flounder', 'sole', 'seafood', 'shrimp', 'lobster', 'crab', 'clams', 'mussels', 'oysters', 'scallops', 'squid', 'octopus', 'eggs', 'pasture-raised eggs', 'duck eggs', 'quail eggs', 'spinach', 'kale', 'lettuce', 'arugula', 'zucchini', 'broccoli', 'cauliflower', 'cabbage', 'asparagus', 'brussels sprouts', 'mushrooms', 'cucumber', 'bell peppers', 'celery', 'radish', 'eggplant', 'green beans', 'bok choy', 'beets', 'carrots', 'squash', 'sweet potatoes', 'apples', 'oranges', 'bananas', 'grapes', 'mangoes', 'pineapple', 'pears', 'peaches', 'plums', 'cherries', 'figs', 'dates', 'raisins', 'prunes', 'strawberries', 'blueberries', 'raspberries', 'blackberries', 'pomegranates', 'watermelon', 'kiwi', 'avocado', 'almonds', 'walnuts', 'pecans', 'macadamia nuts', 'brazil nuts', 'hazelnuts', 'cashews', 'pumpkin seeds', 'sunflower seeds', 'chia seeds', 'flaxseeds', 'hemp seeds', 'olive oil', 'avocado oil', 'coconut oil', 'lard', 'tallow', 'ghee', 'grass-fed butter', 'MCT oil', 'water', 'sparkling water', 'coconut water', 'herbal tea', 'black coffee', 'bone broth']
    
    dairy_keywords = ['milk', 'whole milk', 'skim milk', 'low-fat milk', 'raw milk', 'cow’s milk', 'goat’s milk', 'sheep’s milk', 'buffalo milk', 'butter', 'grass-fed butter', 'ghee', 'clarified butter', 'cheese', 'cheddar', 'mozzarella', 'parmesan', 'gouda', 'brie', 'goat cheese', 'cream cheese', 'feta', 'blue cheese', 'swiss cheese', 'colby', 'monterey jack', 'provolone', 'havarti', 'ricotta', 'cottage cheese', 'mascarpone', 'queso', 'cream', 'heavy cream', 'whipping cream', 'sour cream', 'half and half', 'yogurt', 'Greek yogurt', 'plain yogurt', 'flavored yogurt', 'kefir', 'buttermilk', 'ice cream', 'gelato', 'frozen yogurt', 'whey', 'casein', 'lactose', 'curds']
    nut_keywords = ['almonds', 'walnuts', 'pecans', 'macadamia nuts', 'brazil nuts', 'hazelnuts', 'cashews', 'pistachios', 'chestnuts', 'pine nuts', 'peanuts', 'nut butter', 'almond butter', 'peanut butter', 'cashew butter', 'macadamia butter', 'pistachio butter', 'walnut butter', 'pecan butter', 'hazelnut butter', 'nut flour', 'almond flour', 'coconut flour', 'cashew flour', 'hazelnut flour', 'nut milk', 'almond milk', 'cashew milk', 'macadamia milk', 'hazelnut milk']
'''

import pandas as pd
import re

try:
    import spacy
    nlp = spacy.load("en_core_web_sm", disable=["ner"])
except Exception as e:
    print("spaCy failed to load; using fallback tokenizer.")
    nlp = None

def tokenize_and_process(text):
    text = text.lower()
    #remove punctuation
    text = re.sub(r'[^\w\s]', '', text)
    if nlp is not None:
        doc = nlp(text)
        #lemmatization
        tokens = {token.lemma_ for token in doc if not token.is_stop and not token.is_punct}
        return tokens
    else:
        return set(text.split())

def contains_phrase(phrases, text):
    for phrase in phrases:
        if phrase in text:
            return True
    return False

def contains_gluten(text): #gluten free check
    text = text.lower()
    if "gluten free" in text or "gluten-free" in text:
        return False
    gluten_free_exceptions = ["almond flour", "coconut flour", "rice flour", "corn masa flour", "tapioca flour"]
    for ex in gluten_free_exceptions:
        text = text.replace(ex, "")
    gluten_indicators = ["wheat", "barley", "rye", "triticale", "spelt", "farro", "durum",
                           "pasta", "macaroni", "bread", "loaf", "cracker", "bagel", "cereal", "flour"]
    for indicator in gluten_indicators:
        if indicator in text:
            return True
    return False

def load_and_process_csv(file_path):
    df = pd.read_csv(file_path)
    meat_keywords = [
        'beef', 'pork', 'chicken', 'turkey', 'duck', 'lamb', 'mutton', 'veal', 'goat', 'rabbit',
        'venison', 'bison', 'buffalo', 'quail', 'pheasant', 'goose', 'kangaroo', 'horse',
        'wild boar', 'frog', 'turtle', 'fish', 'salmon', 'tuna', 'cod', 'halibut',
        'sardine', 'anchovy', 'mackerel', 'trout', 'bass', 'snapper', 'swordfish',
        'catfish', 'herring', 'flounder', 'sole', 'grouper', 'perch', 'tilapia', 'eel',
        'shark', 'shrimp', 'prawn', 'lobster', 'crab', 'clam', 'mussel', 'oyster', 'scallop',
        'squid', 'octopus', 'caviar', 'roe', 'krill', 'bacon', 'ham', 'prosciutto',
        'pepperoni', 'salami', 'chorizo', 'sausage', 'hot dog', 'pastrami', 'corned beef',
        'bologna', 'liverwurst', 'gelatin', 'rennet', 'lard', 'suet', 'tallow',
        'bone broth', 'meat broth', 'fish sauce', 'oyster sauce', 'worcestershire',
        'shrimp paste', 'cuttlefish', 'gravy', 'pâté', 'haggis', 'blood', 'tripe',
        'head', 'scrapple', 'stock', 'liver', 'kidney', 'heart', 'tongue', 'sweetbread',
        'offal', 'jerky', 'bresaola', 'emu', 'ostrich', 'guinea fowl', 'squirrel'
    ]
    
    # meat keywords plus common non-vegan ingredients
    non_vegan_keywords = meat_keywords + [
        'milk', 'butter', 'cream', 'yogurt', 'ghee', 'casein', 'whey', 'lactose', 'curd',
        'cheese', 'cheddar', 'colby', 'colby jack', 'mozzarella', 'parmesan', 'gouda', 'brie',
        'camembert', 'feta', 'blue cheese', 'swiss', 'emmental', 'gruyere', 'monterey jack',
        'pepper jack', 'ricotta', 'cottage cheese', 'mascarpone', 'provolone', 'havarti',
        'stilton', 'roquefort', 'edam', 'burrata', 'paneer', 'pecorino', 'manchego', 'asadero',
        'queso fresco', 'queso blanco', 'chevre',
        'egg', 'eggs', 'egg white', 'egg whites', 'egg yolk', 'egg yolks',
        'mayonnaise', 'albumin', 'lysozyme', 'bee', 'pollen', 'royal jelly',
        'lanolin', 'isenglass', 'carmine', 'shellac'
    ]
    dairy_keywords = [
        'milk', 'butter', 'cream', 'yogurt', 'ghee', 'casein', 'whey', 'lactose', 'curd',
        'parmesan', 'buttermilk', 'paneer', 'labneh'
    ]
    nut_keywords = [
        'almond', 'walnut', 'pecan', 'macadamia', 'brazil', 'hazelnut', 'cashew',
        'pistachio', 'chestnut', 'pine', 'peanut', 'peanuts'
    ]
    
    keto_keywords = [
        'meat', 'beef', 'pork', 'chicken', 'turkey', 'lamb', 'duck', 'bison', 'venison',
        'bacon', 'sausage', 'steak', 'rib', 'ham', 'pepperoni', 'salami', 'fish', 'salmon',
        'tuna', 'mackerel', 'trout', 'egg', 'cheese', 'butter', 'heavy cream', 'sour cream',
        'ghee', 'avocado', 'coconut', 'olive oil', 'almond flour', 'cauliflower', 'zucchini'
    ]
    
    #high-carb, gluten, or sugary items
    keto_restricted_keywords = [
        'wheat', 'barley', 'rye', 'corn', 'oat', 'rice', 'quinoa', 'bulgur', 'farro', 'millet',
        'amaranth', 'sorghum', 'buckwheat', 'bread', 'bagel', 'toast', 'cracker', 'tortilla',
        'pasta', 'macaroni', 'flour', 'sugar', 'maple syrup', 'brown sugar', 'apple cider',
        'agave', 'cider', 'lentil', 'molasses', 'honey', 'potato', 'yam', 'cornstarch'
    ]
    
    # for low-carb checks
    high_carb_keywords = [
        'wheat', 'barley', 'rye', 'corn', 'oat', 'rice', 'pasta', 'macaroni', 'bread', 'flour',
        'loaf', 'cracker', 'bagel', 'cereal', 'potato', 'sweet potato', 'yam', 'sugar',
        'maple syrup', 'brown sugar', 'juice', 'agave', 'cider', 'lentil', 'butternut',
        'apple', 'pea', 'beans', 'legume', 'chickpea', 'black bean', 'kidney bean'
    ]
    paleo_keywords = [
        'meat', 'fish', 'egg', 'vegetable', 'fruit', 'nut', 'seed', 'olive', 'coconut',
        'honey', 'sweet potato', 'squash', 'cauliflower', 'spinach', 'kale'
    ]
    paleo_restricted_keywords = [
        'dairy', 'soy', 'legume', 'wheat', 'barley', 'rye', 'corn', 'rice', 'processed sugar',
        'beef', 'pork', 'chicken', 'turkey', 'duck', 'lamb', 'bison', 'venison', 'rabbit',
        'wild boar', 'quail', 'pheasant', 'goose', 'kangaroo', 'fish', 'salmon', 'tuna',
        'mackerel', 'sardine', 'trout', 'cod', 'halibut', 'snapper', 'herring', 'anchovy',
        'flounder', 'sole', 'seafood', 'shrimp', 'lobster', 'crab', 'clam', 'mussel',
        'oyster', 'scallop', 'squid', 'octopus', 'egg (non-paleo)', 'lentil'
    ]
    
    # Title keywords used for classification based on the recipe title
    title_keywords = {
        "Vegan": {'vegan', 'plant-based'},
        "Vegetarian": {'vegetarian', 'meatless'},
        "Gluten-Free": {'gluten-free', 'no gluten'},
        "Keto": {'keto', 'low carb'},
        "Paleo": {'paleo', 'caveman'},
        "Dairy-Free": {'dairy-free', 'no dairy'},
        "Nut-Free": {'nut-free', 'no nuts'},
        "Low-Carb": {'low-carb', 'low carb'}
    }
    
    def classify_diet(row):
        ingredients = tokenize_and_process(row['cleaned_ingredients'])
        title = tokenize_and_process(row['title'])
        diet_labels = set()
        for diet, keys in title_keywords.items():
            if keys & title:
                diet_labels.add(diet)
        

        cleaned_text = row['cleaned_ingredients'].lower()
        cleaned_text = re.sub(r'[^\w\s]', '', cleaned_text)
        if not contains_gluten(cleaned_text):
            diet_labels.add("Gluten-Free")
        
        # remove known false positives "apple butter"
        vegan_tokens = set(ingredients)
        if "apple butter" in cleaned_text:
            vegan_tokens.discard("butter")
        
        if not (set(non_vegan_keywords) & vegan_tokens):
            diet_labels.add("Vegan")
        if not (set(meat_keywords) & ingredients):
            diet_labels.add("Vegetarian")
        if not (set(dairy_keywords) & ingredients):
            diet_labels.add("Dairy-Free")
        if not (set(nut_keywords) & ingredients):
            diet_labels.add("Nut-Free")
        
        if not (set(high_carb_keywords) & ingredients):
            diet_labels.add("Low-Carb")
    
        if (set(keto_keywords) & ingredients) and not (set(keto_restricted_keywords) & ingredients) and not (set(high_carb_keywords) & ingredients):
            diet_labels.add("Keto")
        if (set(paleo_keywords) & ingredients) and not (set(paleo_restricted_keywords) & ingredients):
            diet_labels.add("Paleo")
        
        return ", ".join(sorted(diet_labels)) if diet_labels else "0"
    
    df['diet_type'] = df.apply(classify_diet, axis=1)
    output_file = "dietClassifiedRecipes.csv"
    df[['recipeID', 'diet_type']].to_csv(output_file, index=False)
    print(f"Processed file saved as {output_file}")
    
    return df

df_result = load_and_process_csv("recipe_updated.csv")
