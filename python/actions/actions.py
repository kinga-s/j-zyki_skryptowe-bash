import json
import os.path
from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

current_directory = os.path.dirname(os.path.realpath(__file__))


class ActionTellOpeningHours(Action):
    """Action: present working hours of the restaurant to the user."""
    def name(self) -> Text:
        return "action_tell_opening_hours"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        weekday = extract_entity(tracker, "weekday")
        open_close = extract_entity(tracker, "open")
        hour = extract_entity(tracker, "time")
        if hour:
            hour = int(hour)

        response = None
        file = os.path.join(current_directory, "opening_hours.json")
        opening_hours_data = open_file(file)
        if not opening_hours_data:
            return []

        if hour:
            print(hour)
            print(type(hour))
            if weekday in opening_hours_data['items']:
                open_hour = opening_hours_data['items'][weekday]['open']
                close_hour = opening_hours_data['items'][weekday]['close']
                if open_close and open_close[:5] == "close":
                    if open_hour > hour or hour >= close_hour:
                        response = f"The restaurant is closed at {hour}"
                    else:
                        response = f"The restaurant is open at {hour}"
                elif open_hour <= hour < close_hour:
                    response = f"The restaurant is open at {hour}"
                else:
                    response = f"The restaurant is closed at {hour}"
        elif weekday in opening_hours_data['items']:
            open_hour = opening_hours_data['items'][weekday]['open']
            close_hour = opening_hours_data['items'][weekday]['close']
            if open_hour == 0 and close_hour == 0:
                response = f"The restaurant is closed on {weekday}."
            elif open_close and open_close == "open":
                response = f"The restaurant is open from {open_hour}"
            elif open_close and open_close == "close":
                response = f"The restaurant is being closed at {close_hour}"
            else:
                response = f"The restaurant is open from {open_hour} to {close_hour} on {weekday}."
        else:
            response = "On which day would you like to know?"

        dispatcher.utter_message(text=response)
        return []


class ActionGiveMenu(Action):
    """Action: present menu to the user."""
    def name(self) -> Text:
        return "action_give_menu"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        menu = extract_entity(tracker, "menu")
        food = extract_entity(tracker, "food")
        price = extract_entity(tracker, "price")
        duration = extract_entity(tracker, "duration")
        response = None
        if food:
            food = food.capitalize()
            print(food)

        file = os.path.join(current_directory, "menu.json")
        menu_data = open_file(file)
        if not menu_data:
            return []

        if menu and not food:
            response = f"Here is the menu: {menu_data}"
        if food:
            for meal in menu_data["items"]:
                if food == meal["name"]:
                    response = f"{food} is in our menu. "
                    if price:
                        response += f"It costs {meal['price']}$ "
                    if duration:
                        response += f" The preparation time is {int(meal['preparation_time'] * 60)} minutes."
                    break
        elif not response:
            response = "Sorry, we don't have that on the menu."

        dispatcher.utter_message(text=response)
        return []


def open_file(file: str) -> json:
    """Open and load json file"""
    try:
        with open(file, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"File '{file}' not found")
        return []
    except Exception as e:
        print(f"Error while opening the file: {e}")
        return []


def extract_entity(tracker: Tracker, entity_name: str):
    """Extract the first entity in user's sentence."""
    entities = tracker.latest_message.get('entities', [])
    extracted_entity = None

    for entity in entities:
        if entity['entity'] == entity_name:
            extracted_entity = entity['value']
            break

    return extracted_entity
