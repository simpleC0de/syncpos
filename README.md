# syncpos
Simple script that saves players location in a MySQL Database.
You can modify things in the server.lua
The script caches the positions locally, and only saves the positions of the players each 60 seconds by default. (You can easily go higher)
It only uses one query to save all positions, so it saves you a bit of performance.


# Dependencies
MySQL Async (https://github.com/brouznouf/fivem-mysql-async)

# Usage
This script is standalone, if you do not use it for RP, you might need to change the MySQL queries.

Other than that, it is just drag and drop.
You can change the default spawn location in the db.sql

Import the db.sql 
Start the Script
Should work.
