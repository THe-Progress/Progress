from flask import Flask, request, jsonify
import torch
from transformers import LlamaForCausalLM, LlamaTokenizer
# import bitsandbytes as bnb

app = Flask(__name__)

# Load the quantized models
satirical_model_name_or_path = "quantized_llama_model"
# encouraging_model_name_or_path = "quantized_llama_model"

satirical_tokenizer = LlamaTokenizer.from_pretrained(satirical_model_name_or_path)
# satirical_model = LlamaForCausalLM.from_pretrained(satirical_model_name_or_path, load_in_8bit=True, device_map='cpu')

# encouraging_tokenizer = LlamaTokenizer.from_pretrained(encouraging_model_name_or_path)
# encouraging_model = LlamaForCausalLM.from_pretrained(encouraging_model_name_or_path, load_in_8bit=True, device_map='cpu')

@app.route('/satirical_notification', methods=['POST'])
def satirical_notification():
    data = request.json
    task = data['task']
    app_used = data['app']
    severity = data['severity']

    prompt = f"Generate a satirical message for not completing the task '{task}' while using {app_used} with severity {severity}."
    inputs = satirical_tokenizer(prompt, return_tensors="pt").to('cpu')
    outputs = satirical_model.generate(**inputs)
    message = satirical_tokenizer.decode(outputs[0], skip_special_tokens=True)
    
    return jsonify({'message': message})

# @app.route('/encouraging_message', methods=['POST'])
# def encouraging_message():
#     data = request.json
#     task = data['task']

#     prompt = f"Generate an encouraging message for completing the task '{task}'."
#     inputs = encouraging_tokenizer(prompt, return_tensors="pt").to('cpu')
#     outputs = encouraging_model.generate(**inputs)
#     message = encouraging_tokenizer.decode(outputs[0], skip_special_tokens=True)
    
#     return jsonify({'message': message})

if __name__ == '__main__':
    app.run()
