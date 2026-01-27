from service import ChatbotService

def iniciar_chat():
    bot = ChatbotService()
    print("🤖 Chatbot iniciado (escribe 'salir' para terminar)\n")

    while True:
        user_input = input("Tú: ")

        if user_input.lower() == "salir":
            print("Bot: ¡Hasta luego! 👋")
            break

        respuesta = bot.get_response(user_input)
        print(f"Bot: {respuesta}")

if __name__ == "__main__":
    iniciar_chat()
