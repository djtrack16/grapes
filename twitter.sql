``` users table ```
create table users(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY
  username VARCHAR(45) NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  profile_image_url VARCHAR(200),
  email VARCHAR(255) NOT NULL,
  dob DATE,
  'location' VARCHAR(50) NOT NULL,
  'description' VARCHAR(200) not null,
  follower_count int null,
  friend_count int null,
  password CHAR(32), -- should be encrypted, that why uses char
  created_at DATETIME
);

``` tweets ```
create table tweets(
  id int not null AUTO_INCREMENT PRIMARY KEY,
  tweet_text VARCHAR(140),
  retweets int null,
  likes int null,
  `user_id` int not null,
  latitude float not null,
  longitude float not null,
  FOREIGN KEY (`user_id`) references users(id)
  created_at DATETIME
);

create table tags(
  id int not null AUTO_INCREMENT PRIMARY KEY,
  `text` VARCHAR(100) not null,
  tweet_id int null,
  comment_id int null,
  FOREIGN KEY (tweet_id) references tweets(id),
  FOREIGN KEY (comment_id) references comments(id)
)

create table likes(
  id int not null AUTO_INCREMENT PRIMARY KEY,
  `user_id` int not null,
  tweet_id int not null,
  comment_id int not null,
  FOREIGN KEY (`user_id`) references users(id),
  FOREIGN KEY (`tweet_id`) references tweet(id)
);

``` retweets ```
create table retweets(
  retweet_id int not null,
  tweet_id int not null,
  `user_id` int not null,
  comment_text VARCHAR(200) null,
  FOREIGN KEY (`user_id`) references users(id),
  FOREIGN KEY (tweet_id) references tweets(id)
);

``` mentions ```
create table mentions(
  id int not null AUTO_INCREMENT PRIMARY KEY,
  tweet_id int null,
  username VARCHAR(20) not null,
  comment_id int null,
  FOREIGN KEY (tweet_id) references tweets(id),
  FOREIGN KEY (comment_id) references comments(id)
);

'''
1. Get all usernames of users who are following me
2. Get total count of users who are following me
3. Get all usernames who I am following
4. Get total count of users that I am following
5. 
'''

count(*) from friends
as f
where f.user_id = "this user id" => 'total count of who this user is following'

count(*) from friends
as f
where f.friend_id = "this user id" => 'total count of who is following this user'

``` followers ```
create table friends(
  friendship_id int not null AUTO_INCREMENT
  friend_id INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, friend_id),
  FOREIGN KEY (`user_id`) REFERENCES users(id),
  FOREIGN KEY (friend_id) REFERENCES users(id),
  created_at DATETIME
);

'''
http://140dev.com/free-twitter-api-source-code-library/twitter-database-server/mysql-database-schema/
https://towardsdatascience.com/storing-tweets-in-a-relational-database-d2e4e76465b2
https://medium.com/@narengowda/system-design-for-twitter-e737284afc95
https://blog.twitter.com/engineering/en_us/topics/infrastructure/2017/the-infrastructure-behind-twitter-scale.html
https://github.com/ahmedadeltito/Twitter_Client
https://github.com/donnemartin/system-design-primer#index-of-system-design-topics
'''
