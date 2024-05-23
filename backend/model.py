import torch
from transformers import LlamaTokenizer, LlamaForCausalLM, Trainer, TrainingArguments
from datasets import load_dataset

# Load tokenizer and model
model_name_or_path = "NousResearch/Llama-2-7b-hf" 
tokenizer = LlamaTokenizer.from_pretrained(model_name_or_path)
model = LlamaForCausalLM.from_pretrained(model_name_or_path)

# Load your dataset
train_dataset = load_dataset('json', file_path='C:/Users/Dell/Desktop/Progess3/backend/satirical_dataset.json', split='train')


# Tokenize the dataset
def tokenize_function(examples):
    return tokenizer(examples["text"], padding="max_length", truncation=True)

train_dataset = train_dataset.map(tokenize_function, batched=True)


# Set format for PyTorch
train_dataset.set_format(type='torch', columns=['input_ids', 'attention_mask', 'labels'])


# Define training arguments
training_args = TrainingArguments(
    output_dir="./results",
    evaluation_strategy="epoch",
    learning_rate=2e-5,
    per_device_train_batch_size=1,  # Smaller batch size for CPU
    per_device_eval_batch_size=1,  # Smaller batch size for CPU
    num_train_epochs=3,
    weight_decay=0.01,
)

# Initialize Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    
)

# Train the model
trainer.train()

# Save the fine-tuned model
trainer.save_model("finetuned_llama_model")
# tokenizer.save_pretrained("finetuned_llama_model")

from transformers import LlamaForCausalLM, LlamaTokenizer
import bitsandbytes as bnb

# Load the fine-tuned model
model_name_or_path = "finetuned_llama_model"
tokenizer = LlamaTokenizer.from_pretrained(model_name_or_path)
model = LlamaForCausalLM.from_pretrained(model_name_or_path, load_in_8bit=True, device_map='cpu')

# Save the quantized model
model.save_pretrained("quantized_llama_model")
# tokenizer.save_pretrained("quantized_llama_model")

