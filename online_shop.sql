-- Création de la table `users`
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Création de la table `products`
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Création de la table `orders`
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Création de la table `order_items`
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insertion des utilisateurs
INSERT IGNORE INTO users (username, email, password) VALUES
('john_doe', 'john@example.com', 'password123'),
('jane_smith', 'jane@example.com', 'securepassword'),
('mark_taylor', 'mark@example.com', 'pass789'),
('emily_davis', 'emily@example.com', 'passwordemily'),
('michael_brown', 'michael@example.com', 'browniepassword'),
('linda_jones', 'linda@example.com', 'lindapass12'),
('robert_miller', 'robert@example.com', 'millertime45'),
('susan_wilson', 'susan@example.com', 'susansafe56'),
('james_moore', 'james@example.com', 'mooresecure9'),
('nancy_white', 'nancy@example.com', 'whitepassword77');

-- Insertion des produits
INSERT INTO products (name, description, price, stock_quantity) VALUES
('Ordinateur Portable', 'Ordinateur léger et performant', 799.99, 10),
('Smartphone', 'Smartphone dernière génération', 699.99, 20),
('Tablette', 'Tablette pratique et puissante', 499.99, 15),
('Casque Audio', 'Casque de haute qualité sonore', 199.99, 25),
('Clavier Mécanique', 'Clavier pour gamer', 89.99, 30),
('Souris Gaming', 'Souris de précision pour gamer', 59.99, 50),
('Écran 4K', 'Écran haute résolution 4K', 399.99, 12),
('Chargeur Universel', 'Chargeur rapide pour plusieurs appareils', 29.99, 40),
('Disque Dur Externe', 'Disque dur de grande capacité', 129.99, 18),
('Caméra de Surveillance', 'Caméra avec vision nocturne', 249.99, 8);

-- Insertion des commandes
INSERT INTO orders (user_id, total_amount) VALUES
(1, 1499.97),  -- Commande pour "john_doe"
(2, 699.99),   -- Commande pour "jane_smith"
(3, 1099.97),  -- Commande pour "mark_taylor"
(4, 259.98),   -- Commande pour "emily_davis"
(5, 329.98),   -- Commande pour "michael_brown"
(6, 849.97),   -- Commande pour "linda_jones"
(7, 959.98),   -- Commande pour "robert_miller"
(8, 479.98),   -- Commande pour "susan_wilson"
(9, 869.97),   -- Commande pour "james_moore"
(10, 1289.96); -- Commande pour "nancy_white"

-- Insertion des articles dans les commandes
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 799.99),  -- Ordinateur Portable
(1, 2, 1, 699.99),  -- Smartphone
(2, 2, 1, 699.99),  -- Smartphone
(3, 3, 2, 999.98),  -- 2 Tablettes
(3, 4, 1, 199.99),  -- Casque Audio
(4, 5, 2, 179.98),  -- 2 Claviers Mécaniques
(4, 6, 1, 59.99),   -- Souris Gaming
(5, 7, 1, 399.99),  -- Écran 4K
(5, 6, 2, 119.98),  -- 2 Souris Gaming
(6, 1, 1, 799.99),  -- Ordinateur Portable
(6, 8, 1, 29.99),   -- Chargeur Universel
(6, 9, 1, 129.99),  -- Disque Dur Externe
(7, 2, 1, 699.99),  -- Smartphone
(7, 9, 2, 259.98),  -- 2 Disques Durs Externes
(8, 5, 1, 89.99),   -- Clavier Mécanique
(8, 6, 1, 59.99),   -- Souris Gaming
(8, 10, 1, 249.99), -- Caméra de Surveillance
(9, 3, 1, 499.99),  -- Tablette
(9, 4, 1, 199.99),  -- Casque Audio
(9, 8, 1, 29.99),   -- Chargeur Universel
(10, 1, 1, 799.99), -- Ordinateur Portable
(10, 7, 1, 399.99), -- Écran 4K
(10, 8, 2, 59.98),  -- 2 Chargeurs Universels
(10, 9, 1, 129.99); -- Disque Dur Externe

-- Requête pour voir les utilisateurs
SELECT * FROM users;

-- Requête pour voir les produits
SELECT * FROM products;

-- Requête pour voir les commandes
SELECT * FROM orders;

-- Requête pour voir les articles de commande
SELECT * FROM order_items;

-- Requête avancée 1 : Commandes avec détails des produits commandés
SELECT orders.id AS order_id, users.username, products.name AS product_name, order_items.quantity, order_items.price
FROM orders
JOIN users ON orders.user_id = users.id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id;

-- Requête avancée 2 : Commandes d'un utilisateur spécifique
SELECT orders.id AS order_id, orders.order_date, SUM(order_items.price * order_items.quantity) AS total_order
FROM orders
JOIN users ON orders.user_id = users.id
JOIN order_items ON orders.id = order_items.order_id
WHERE users.username = 'john_doe'
GROUP BY orders.id;

-- Requête avancée 3 : Total des ventes par produit
SELECT products.name, SUM(order_items.quantity) AS total_sold
FROM products
JOIN order_items ON products.id = order_items.product_id
GROUP BY products.name;

-- Requête avancée 4 : Montant total dépensé par utilisateur
SELECT users.username, SUM(order_items.price * order_items.quantity) AS total_spent
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
GROUP BY users.username;

-- Requête avancée 5 : Produit le plus vendu
SELECT products.name, SUM(order_items.quantity) AS total_sold
FROM products
JOIN order_items ON products.id = order_items.product_id
GROUP BY products.name
ORDER BY total_sold DESC
LIMIT 1;
