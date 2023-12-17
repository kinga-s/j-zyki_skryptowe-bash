import discord
from discord.ext import commands
import requests

bot = commands.Bot(command_prefix="?", intents=discord.Intents().all())
DISCORD_TOKEN = "PLACE_YOUR_TOKEN_HERE"


@bot.event
async def on_ready() -> None:
    """Let know that the bot is on."""
    print(f'Logged in as {bot.user.name}')


@bot.event
async def on_message(message) -> None:
    """Answer the question when the user wrote the message."""
    if message.author.bot:
        return
    user_message = message.content
    rasa_response = send_message_to_rasa(user_message)
    await message.channel.send(rasa_response)


def send_message_to_rasa(message: str) -> str:
    """Send message to rasa and get the response."""
    rasa_url = r"http://localhost:5005/webhooks/rest/webhook"
    payload = {"sender": "user", "message": message}
    response = requests.post(rasa_url, json=payload)
    if response.status_code == 200:
        return response.json()[0]['text']
    return "Sorry, something went wrong :("


bot.run(DISCORD_TOKEN)
