import tkinter as tk
from transformers import pipeline

# Load the text generation model
# This step may take a few seconds because the model needs to load into memory
print("Loading the model, please wait...")
generator = pipeline("text-generation", model="distilgpt2")
print("Model loaded and ready!")

# Function to send a question to the model and display its response
def ask_llm(question):
    try:
        # Generate a response based on the question
        # max_length limits how long the response will be
        responses = generator(question, max_length=50, num_return_sequences=1)
        answer = responses[0]["generated_text"]
        response_label.config(text="Response: " + answer)
    except Exception as e:
        # If something goes wrong, show the error in the response label
        response_label.config(text="Error: " + str(e))

# Function to handle when the "Send" button is clicked
def send_message():
    # Get the text that the user typed in the entry box
    question = entry.get()
    if question:  # Check if the user actually typed something
        # Clear the entry box after grabbing the text
        entry.delete(0, tk.END)
        # Show a "Thinking..." message while the model is working
        response_label.config(text="Thinking...")
        # Call the function to ask the model the user's question
        ask_llm(question)

# Set up the main application window
root = tk.Tk()
root.title("Wireshark LLM Chatbox")
root.geometry("400x300")  # Set the window size

# Label at the top with instructions for the user
label = tk.Label(root, text="Ask a question about the packets below:", font=("Arial", 12))
label.pack(pady=10)  # Add padding around the label for spacing

# Entry box where the user can type their question
entry = tk.Entry(root, width=40)
entry.pack(pady=5)  # Add some space around the entry box

# Button that the user clicks to send their question
send_button = tk.Button(root, text="Send", command=send_message)
send_button.pack(pady=10)  # Space around the button

# Label where the response from the model will be shown
response_label = tk.Label(root, text="", font=("Arial", 10), wraplength=350)
response_label.pack(pady=10)  # Space around the response label

# Start the application loop to keep the window open
root.mainloop()
