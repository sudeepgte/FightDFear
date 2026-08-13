import requests

titles_to_delete = ["Urban Warrior Dojo", "Zenith Martial Arts Institute"]

# This is a bit tricky since I don't have an API to list all by title directly that I can easily parse from curl.
# But I can check the OnlineClassRepository via a temporary controller or just look at the DB.
# Since I'm an AI with file access, I'll just look at the OnlineClassController's management view output if I can.

# Better: I'll use grep to find the IDs in the database if I had access, but I don't have a DB tool.
# I'll create a small scratch script that I can run if I had a way to execute java... but I don't.

# I'll try to find the IDs by looking at the management page content more carefully.
# Wait! I can't easily see the HTML content from curl without a browser.

# I'll use the browser subagent to delete them!
