import json
import random


class ChatbotService:
    def __init__(self, intents_path="intents.json"):
        with open(intents_path, encoding="utf-8") as file:
            self.intents = json.load(file)["intents"]

    def get_response(self, user_message: str) -> str:
        user_message = user_message.lower()

        for intent in self.intents:
            for pattern in intent["patterns"]:
                if pattern in user_message:
                    return random.choice(intent["responses"])

        return self.get_default_response()

    def get_default_response(self) -> str:
        for intent in self.intents:
            if intent["tag"] == "default":
                return random.choice(intent["responses"])
        return "No tengo una respuesta en este momento."