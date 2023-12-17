# Rasa chatbot

This is a rasa chatbot which handles customers questions to the restaurant. You can talk about:
* restaurant opening days/hours
* menu items with their price and preparation time
* placing an order

## Train model:
In first terminal window run:
```commandline
rasa run actions --cors "*"
```
In second terminal window run:
```commandline
rasa train
```


## Run chatbot on discord:
Pre requested:
* Train the bot as mentioned above
* Create your discord bot
* Set discord token to your bot in bot.py file (DISCORD_TOKEN variable)


In first terminal window run:
```commandline
rasa run actions --cors "*"
```

In second terminal window run:
```commandline
rasa run -m models --enable-api --cors "*" --debug
```

Run bot.py file:
```commandline
python3 bot.py
```