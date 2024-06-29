#!/bin/bash
# Update the package index
sudo apt-get update

# Install NGINX
sudo apt-get install -y nginx

# Create the website directory
sudo mkdir -p /var/www/html

# Add the HTML file
cat <<EOL > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Static Website</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Rufai Adeniyi</h1>
        <p>Username: @Rufai Adeniyi</p>
        <p>Email: kbneyo55@gmail.com</p>
    </header>
    <nav>
        <ul>
            <li><a href="#home">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>
        </ul>
    </nav>
    <main id="home">
        <h2>Welcome to My Website!</h2>
        <p>This is a static website created for the HNG Internship.</p>
        <p>Learn more about HNG at <a href="https://hng.tech" target="_blank">HNG Tech</a>.</p>
    </main>
    <section id="about">
        <h2>About Me</h2>
        <p>i am learning.</p>
    </section>
    <section id="contact">
        <h2>Contact Me</h2>
        <p>You can contact me at <a href="mailto:kbneyo55@gmail.com">kbneyo55@gmail.com</a>.</p>
    </section>
    <footer>
        © 2024 Adeniyi
    </footer>
    <script src="script.js"></script>
</body>
</html>
EOL

# Add the CSS file
cat <<EOL > /var/www/html/styles.css
/* Customize your styles here */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #e0f7fa;
}

header {
    background-color: #333;
    color: #fff;
    text-align: center;
    padding: 20px;
}

.profile-pic {
    border-radius: 50%;
    width: 150px;
    height: 150px;
    object-fit: cover;
    display: block;
    margin: 0 auto 20px;
}

nav ul {
    list-style: none;
    display: flex;
    justify-content: center;
    background-color: #444;
    padding: 10px 0;
}

nav li {
    margin: 0 15px;
}

nav a {
    color: #fff;
    text-decoration: none;
}

main, section {
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
    background-color: #fff;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

footer {
    text-align: center;
    background-color: #333;
    color: #fff;
    padding: 10px;
}
EOL

# Add the JavaScript file
cat <<EOL > /var/www/html/script.js
// Add any interactive functionality here
console.log("Welcome to my static website!");

// Smooth scrolling for navigation links
document.querySelectorAll('nav a').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});
EOL

# Restart NGINX to apply changes
sudo systemctl restart nginx



###################################################################

# #!/bin/bash
# # Update the package index
# sudo apt-get update

# # Install NGINX
# sudo apt-get install -y nginx

# # Create the website directory
# sudo mkdir -p /var/www/html

# # Add the HTML file
# cat <<EOL > /var/www/html/index.html
# <!DOCTYPE html>
# <html lang="en">
# <head>
#     <meta charset="UTF-8">
#     <meta name="viewport" content="width=device-width, initial-scale=1.0">
#     <title>Your Static Website</title>
#     <link rel="stylesheet" href="styles.css">
# </head>
# <body>
#     <header>
#         <img src="profile.jpg" alt="Profile Picture" class="profile-pic">
#         <h1>Rufai Adeniyi</h1>
#         <p>Username: @neyo55</p>
#         <p>Email: kbneyo55@gmail.com</p>
#     </header>
#     <nav>
#         <ul>
#             <li><a href="#home">Home</a></li>
#             <li><a href="#about">About</a></li>
#             <li><a href="#contact">Contact</a></li>
#         </ul>
#     </nav>
#     <main id="home">
#         <h2>Welcome to My Website!</h2>
#         <p>This is a static website created for the HNG Internship.</p>
#         <p>Learn more about HNG at <a href="https://hng.tech" target="_blank">HNG Tech</a>.</p>
#     </main>
#     <section id="about">
#         <h2>About Me</h2>
#         <p>Here you can add some information about yourself.</p>
#     </section>
#     <section id="contact">
#         <h2>Contact Me</h2>
#         <p>You can contact me at <a href="mailto:kbneyo55@gmail.com">kbneyo55@gmail.com</a>.</p>
#     </section>
#     <footer>
#         © 2024 Adeniyi
#     </footer>
#     <script src="script.js"></script>
# </body>
# </html>
# EOL

# # Add the CSS file
# cat <<EOL > /var/www/html/styles.css
# /* Customize your styles here */
# body {
#     font-family: Arial, sans-serif;
#     margin: 0;
#     padding: 0;
#     background-color: #e0f7fa;
# }

# header {
#     background-color: #333;
#     color: #fff;
#     text-align: center;
#     padding: 20px;
# }

# .profile-pic {
#     border-radius: 50%;
#     width: 150px;
#     height: 150px;
#     object-fit: cover;
#     display: block;
#     margin: 0 auto 20px;
# }

# nav ul {
#     list-style: none;
#     display: flex;
#     justify-content: center;
#     background-color: #444;
#     padding: 10px 0;
# }

# nav li {
#     margin: 0 15px;
# }

# nav a {
#     color: #fff;
#     text-decoration: none;
# }

# main, section {
#     max-width: 800px;
#     margin: 20px auto;
#     padding: 20px;
#     background-color: #fff;
#     box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
# }

# footer {
#     text-align: center;
#     background-color: #333;
#     color: #fff;
#     padding: 10px;
# }
# EOL

# # Add the JavaScript file
# cat <<EOL > /var/www/html/script.js
# // Add any interactive functionality here
# console.log("Welcome to my static website!");

# // Smooth scrolling for navigation links
# document.querySelectorAll('nav a').forEach(anchor => {
#     anchor.addEventListener('click', function(e) {
#         e.preventDefault();

#         document.querySelector(this.getAttribute('href')).scrollIntoView({
#             behavior: 'smooth'
#         });
#     });
# });
# EOL

# # Add the profile picture
# curl -o /var/www/html/profile.jpg https://example.com/path-to-your-profile-picture.jpg

# # Restart NGINX to apply changes
# sudo systemctl restart nginx
