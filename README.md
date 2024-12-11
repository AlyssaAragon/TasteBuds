<h1>TasteBuds README</h1>
<h3>Culinary Mobile Application</h3>

University of Nevada, Reno 
Computer Science & Engineering Department

Group 36: Alyssa Aragon, Alicia Chiang, Hannah Haggerty

Instructors: Sara Davis, Vinh Le
External Advisor: Dr. David St-Jules, UNR Department of Nutrition

<h3>Abstract</h3>
TasteBuds is an innovative cooking application designed to enhance the user experience in meal planning and recipe discovery. The app allows users to swipe through recipes to easily save them to favorites and collaborate with friends to explore meal options. Additionally, TasteBuds allows syncing accounts with a roommate or significant other, enabling them to easily make meal-planning decisions by finding common meal interests.

<h3>Introduction</h3>
TasteBuds is an iOS application that matches recipes between a pair. The main feature is a swiping function through an index of recipes. After that, there is a page that displays all the recipes two users matched on; a page for a user’s personally liked recipes; a page for the recipes the user’s partner liked; and a user profile and cooked recipe feed. TasteBuds’ goal is to streamline the meal-planning process for couples and friends. In addition, TasteBuds is an accessible platform that factors into dietary restrictions. TasteBuds makes planning easy, so when people spend time together, all they have to focus on is the present act of cooking together. Our project aims to simplify meal planning for couples and friends. We offer them a platform to discover recipes and cater to their cravings and dietary needs. Our objective is to eliminate couples’ struggle in deciding what to cook together, a chore that leads to frustration and decision fatigue. Finding time to meal plan with a partner in a busy world can be challenging. TasteBuds simplifies decision-making, allowing users to find recipes at their own pace and helping couples discover meals that they will both love.

<h3>Server</h3>
<p>To run the TasteBuds server, follow the steps below:</p>
<ol>
  <li><strong>Clone the Repository:</strong> Clone the TasteBuds project repository from GitHub
  </li>
  <li><strong>Navigate to the Project Directory:</strong> Use the terminal or command prompt to navigate to the server directory:
    <pre><code>cd tastebuds/tasteBudsDjango</code></pre>
  </li>
  <li><strong>Install Dependencies:</strong> Set up a virtual environment and install the required packages using the Pipfile.
  </li>
  <li><strong>Set Up the Database:</strong> Apply the Django migrations to set up the database:
    <pre><code>python manage.py migrate</code></pre>
  </li>
  <li><strong>Start the Server:</strong> Run the following command to start the development server:
    <pre><code>python manage.py runserver</code></pre>
    The server should now be running on <code>http://localhost:3000</code>.
  </li>
  <li><strong>Start the Image Server:</strong> Run the following command in the image file to start the image server:
    <pre><code>python3 -m http.server 8000</code></pre>
  </li>
  <li><strong>Open the Frontend on Xcode:</strong> Open the project in Xcode, build the frontend, and run the app on an iOS simulator or connected device.</li>
</ol>
